const express = require('express');
const mongoose = require('mongoose');
const { authenticateToken } = require('../middleware/auth');
const RunSession = require('../models/runSession');
const User = require('../models/user');
const router = express.Router();

// Get all runs for the authenticated user
router.get('/', authenticateToken, async (req, res) => {
  try {
    const runs = await RunSession.find({
      $or: [
        { 'participants.user': req.user.userId },
        { user: req.user.userId }
      ]
    })
    .populate('user', 'username profileImage')
    .populate('participants.user', 'username profileImage')
    .sort({ startTime: -1 });

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
      scheduledStart,
      checkpoints 
    } = req.body;

    // Process checkpoints to ensure proper ObjectId format
    const processedCheckpoints = checkpoints?.map((checkpoint, index) => ({
      ...checkpoint,
      _id: new mongoose.Types.ObjectId(),  // Generate new ObjectId for each checkpoint
      order: index + 1  // Ensure proper ordering
    })) || [];

    const runSession = new RunSession({
      user: req.user.userId,
      title,
      description,
      type: type || 'solo',
      status: 'planned',
      maxParticipants: type === 'group' ? (maxParticipants || 10) : 1,
      scheduledStart: scheduledStart || new Date(),
      checkpoints: processedCheckpoints,
      participants: [{
        user: req.user.userId,
        role: 'host',
        joinedAt: new Date(),
        status: 'ready'
      }],
      runStyle: processedCheckpoints.length > 0 ? 'checkpoint' : 'free'
    });

    await runSession.save();
    await runSession.populate('user', 'username profileImage');
    await runSession.populate('participants.user', 'username profileImage');
    
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

// Leave a group run
router.post('/:runId/leave', authenticateToken, async (req, res) => {
  try {
    const runSession = await RunSession.findById(req.params.runId);
    
    if (!runSession) {
      return res.status(404).json({ error: 'Run session not found' });
    }

    const participantIndex = runSession.participants.findIndex(
      p => p.user.toString() === req.user.userId
    );

    if (participantIndex === -1) {
      return res.status(400).json({ error: 'You are not in this run' });
    }

    if (runSession.participants[participantIndex].role === 'host') {
      runSession.status = 'cancelled';
    } else {
      runSession.participants.splice(participantIndex, 1);
    }

    await runSession.save();
    res.json({ message: 'Successfully left run session' });
  } catch (error) {
    console.error('Error leaving run:', error);
    res.status(500).json({ error: 'Failed to leave run session' });
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
