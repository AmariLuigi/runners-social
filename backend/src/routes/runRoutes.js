const express = require('express');
const mongoose = require('mongoose');
const { authenticateToken } = require('../middleware/auth');
const RunSession = require('../models/runSession');
const User = require('../models/user');
const router = express.Router();

// Get all runs for the authenticated user
router.get('/', authenticateToken, async (req, res) => {
  try {
    const runs = await RunSession.find()
      .populate('user', 'username profileImage')
      .populate('participants.user', 'username profileImage')
      .sort({ createdAt: -1 }); // Sort by creation date, newest first

    console.log(`Found ${runs.length} runs`);
    res.json({ runs });
  } catch (error) {
    console.error('Error fetching runs:', error);
    res.status(500).json({ error: 'Failed to fetch runs' });
  }
});

// Get active runs (available to join)
router.get('/active', authenticateToken, async (req, res) => {
  try {
    const activeRuns = await RunSession.find({
      status: { $in: ['planned', 'active'] },
      type: 'group',
      'participants.user': { $ne: req.user.userId }
    })
    .populate('user', 'username profileImage')
    .populate('participants.user', 'username profileImage')
    .sort({ startTime: -1 });

    res.json({ runs: activeRuns });
  } catch (error) {
    console.error('Error fetching active runs:', error);
    res.status(500).json({ error: 'Failed to fetch active runs' });
  }
});

// Create a new run session (solo or group)
router.post('/', authenticateToken, async (req, res) => {
  try {
    const { 
      title, 
      description, 
      type, 
      maxParticipants, 
      startTime,
      checkpoints,
      runStyle,
      privacy,
      status = 'planned',
      routePoints,
      plannedDistance
    } = req.body;

    console.log('Creating run with user:', req.user.userId);
    console.log('Route points:', routePoints);

    const runSession = new RunSession({
      user: req.user.userId,
      title,
      description,
      type: type || 'solo',
      status,
      maxParticipants: type === 'group' ? (maxParticipants || 10) : 1,
      startTime: startTime || new Date(),
      runStyle: runStyle || 'free', 
      privacy: privacy || 'public',
      routePoints: routePoints || [],
      plannedDistance,
      participants: [{
        user: req.user.userId,
        role: 'host',
        joinedAt: new Date(),
        status: 'ready'
      }]
    });

    console.log('Run session before save:', runSession);
    await runSession.save();
    await runSession.populate('user', 'username profileImage');
    await runSession.populate('participants.user', 'username profileImage');
    console.log('Run session after save:', runSession);
    
    res.status(201).json({ 
      message: 'Run session created successfully',
      runSession 
    });
  } catch (error) {
    console.error('Error creating run:', error);
    res.status(500).json({ error: 'Failed to create run session' });
  }
});

// Join a group run
router.post('/:runId/join', authenticateToken, async (req, res) => {
  try {
    const runSession = await RunSession.findById(req.params.runId);
    
    if (!runSession) {
      return res.status(404).json({ error: 'Run session not found' });
    }

    if (runSession.type !== 'group') {
      return res.status(400).json({ error: 'This is not a group run' });
    }

    if (runSession.status !== 'active') {
      return res.status(400).json({ error: 'This run is not active' });
    }

    if (runSession.participants.some(p => p.user.toString() === req.user.userId)) {
      return res.status(400).json({ error: 'You are already in this run' });
    }

    if (runSession.participants.length >= runSession.maxParticipants) {
      return res.status(400).json({ error: 'Run session is full' });
    }

    runSession.participants.push({
      user: req.user.userId,
      role: 'participant',
      joinedAt: new Date()
    });

    await runSession.save();
    await runSession.populate('participants.user', 'username profileImage');

    res.json({ 
      message: 'Successfully joined run session',
      runSession 
    });
  } catch (error) {
    console.error('Error joining run:', error);
    res.status(500).json({ error: 'Failed to join run session' });
  }
});

// Leave a run
router.post('/:runId/leave', authenticateToken, async (req, res) => {
  try {
    console.log('Attempting to leave run:', req.params.runId);
    const userId = req.user.userId.toString();
    console.log('User ID (string):', userId);

    let runSession = await RunSession.findById(req.params.runId)
      .populate('user', 'username profileImage')
      .populate('participants.user', 'username profileImage');
    
    if (!runSession) {
      console.log('Run session not found');
      return res.status(404).json({ error: 'Run session not found' });
    }

    console.log('Found run session:', {
      id: runSession._id.toString(),
      title: runSession.title,
      participants: runSession.participants.map(p => ({
        id: p.user.toString(),
        role: p.role
      }))
    });

    const participantIndex = runSession.participants.findIndex(
      p => p.user._id.toString() === userId || p.user.toString() === userId
    );

    console.log('Participant index:', participantIndex);

    if (participantIndex === -1) {
      console.log('User not found in participants. User ID:', userId);
      console.log('Available participant IDs:', runSession.participants.map(p => p.user.toString()));
      // Instead of error, return success if user is already not in the run
      return res.json({ message: 'User is not in this run' });
    }

    console.log('Found participant with role:', runSession.participants[participantIndex].role);

    if (runSession.participants[participantIndex].role === 'host') {
      console.log('Host is leaving, cancelling run');
      runSession.status = 'cancelled';
      await runSession.save();
      return res.json({ message: 'Run cancelled successfully' });
    } else {
      console.log('Participant is leaving, removing from participants array');
      runSession.participants.splice(participantIndex, 1);
      await runSession.save();
      
      // Fetch the updated run session
      runSession = await RunSession.findById(req.params.runId)
        .populate('user', 'username profileImage')
        .populate('participants.user', 'username profileImage');
        
      return res.json(runSession);
    }
  } catch (error) {
    console.error('Error leaving run:', error);
    res.status(500).json({ error: 'Failed to leave run session' });
  }
});

// Delete a run
router.delete('/:runId', authenticateToken, async (req, res) => {
  try {
    console.log('Delete request for run:', req.params.runId);
    console.log('Current user ID:', req.user.userId);

    const runSession = await RunSession.findById(req.params.runId)
      .populate('user', 'username');
    
    if (!runSession) {
      return res.status(404).json({ error: 'Run session not found' });
    }

    // Convert both IDs to strings for comparison
    const creatorId = runSession.user._id.toString();
    const currentUserId = typeof req.user.userId === 'string' ? 
      req.user.userId : 
      req.user.userId.toString();

    console.log('Run creator ID (string):', creatorId);
    console.log('Current user ID (string):', currentUserId);
    console.log('Current user matches creator?', creatorId === currentUserId);

    // Check if the user is the creator of the run
    if (creatorId !== currentUserId) {
      return res.status(403).json({ error: 'Not authorized to delete this run' });
    }

    await RunSession.findByIdAndDelete(req.params.runId);
    
    res.json({ message: 'Run deleted successfully' });
  } catch (error) {
    console.error('Error deleting run:', error);
    res.status(500).json({ error: 'Failed to delete run' });
  }
});

// Get specific run details
router.get('/:runId', authenticateToken, async (req, res) => {
  try {
    const runSession = await RunSession.findById(req.params.runId)
      .populate('user', 'username profileImage')
      .populate('participants.user', 'username profileImage');
    
    if (!runSession) {
      return res.status(404).json({ error: 'Run session not found' });
    }

    res.json({ runSession });
  } catch (error) {
    console.error('Error fetching run details:', error);
    res.status(500).json({ error: 'Failed to fetch run details' });
  }
});

module.exports = router;
