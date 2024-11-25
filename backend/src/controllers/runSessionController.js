const RunSession = require('../models/runSession');
const Group = require('../models/group');
const Friendship = require('../models/friend');

// Create a new run session
const createSession = async (req, res) => {
  try {
    const sessionData = { ...req.body };
    
    // Add creator as first participant if not already included
    if (!sessionData.participants) {
      sessionData.participants = [];
    }
    
    const creatorParticipant = sessionData.participants.find(p => 
      p.user.toString() === req.user._id.toString()
    );
    
    if (!creatorParticipant) {
      sessionData.participants.unshift({
        user: req.user._id,
        role: 'leader',
        status: 'active'
      });
    }

    // If group is specified, verify membership
    if (sessionData.group) {
      const group = await Group.findById(sessionData.group);
      if (!group) {
        return res.status(404).json({ error: 'Group not found' });
      }

      const isMember = group.members.some(member => 
        member.user.equals(req.user._id)
      );
      if (!isMember) {
        return res.status(403).json({ error: 'Must be group member to create session' });
      }
    } else {
      // For non-group sessions, verify friendship with all participants
      const participantIds = sessionData.participants
        .filter(p => p.user.toString() !== req.user._id.toString())
        .map(p => p.user);

      for (const participantId of participantIds) {
        const friendship = await Friendship.findOne({
          $or: [
            { requester: req.user._id, recipient: participantId },
            { requester: participantId, recipient: req.user._id }
          ],
          status: 'accepted'
        });

        if (!friendship) {
          return res.status(403).json({ 
            error: 'All participants must be friends with the session creator'
          });
        }
      }
    }

    const session = new RunSession(sessionData);
    await session.save();

    // If session is completed, update shared stats for all participants
    if (session.status === 'completed' && session.stats) {
      const participantPairs = [];
      for (let i = 0; i < session.participants.length; i++) {
        for (let j = i + 1; j < session.participants.length; j++) {
          participantPairs.push([
            session.participants[i].user,
            session.participants[j].user
          ]);
        }
      }

      for (const [user1, user2] of participantPairs) {
        const friendship = await Friendship.findOne({
          $or: [
            { requester: user1, recipient: user2 },
            { requester: user2, recipient: user1 }
          ],
          status: 'accepted'
        });

        if (friendship) {
          await friendship.updateSharedStats(session);
        }
      }
    }

    res.status(201).json(session);
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
};

// Get all sessions for a group
const getGroupSessions = async (req, res) => {
  try {
    const { groupId } = req.params;
    const sessions = await RunSession.find({ group: groupId })
      .populate('participants.user', 'username profile.firstName profile.lastName')
      .sort({ 'schedule.startTime': -1 });
    res.json(sessions);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Get specific session
const getSession = async (req, res) => {
  try {
    const session = await RunSession.findById(req.params.id)
      .populate('participants.user', 'username profile.firstName profile.lastName')
      .populate('group', 'name settings');

    if (!session) {
      return res.status(404).json({ error: 'Session not found' });
    }

    res.json(session);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Join a session
const joinSession = async (req, res) => {
  try {
    const session = await RunSession.findById(req.params.id);
    if (!session) {
      return res.status(404).json({ error: 'Session not found' });
    }

    // Check if user is already in session
    if (session.participants.some(p => p.user.equals(req.user._id))) {
      return res.status(400).json({ error: 'Already in session' });
    }

    // Check if session allows joining after start
    if (session.status === 'active' && !session.settings.allowJoinAfterStart) {
      return res.status(400).json({ error: 'Session does not allow joining after start' });
    }

    session.participants.push({
      user: req.user._id,
      role: 'participant',
      status: 'active'
    });

    await session.save();
    res.json(session);
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
};

// Update session status (start, pause, resume, end)
const updateSessionStatus = async (req, res) => {
  try {
    const { status } = req.body;
    const session = await RunSession.findById(req.params.id);
    
    if (!session) {
      return res.status(404).json({ error: 'Session not found' });
    }

    // Check if user is session leader
    const participant = session.participants.find(p => 
      p.user.equals(req.user._id)
    );
    if (!participant || participant.role !== 'leader') {
      return res.status(403).json({ error: 'Only session leader can update status' });
    }

    session.status = status;
    
    if (status === 'completed') {
      session.calculateStats();
    }

    await session.save();
    res.json(session);
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
};

// Update participant status (pause, resume, drop)
const updateParticipantStatus = async (req, res) => {
  try {
    const { status } = req.body;
    const session = await RunSession.findById(req.params.id);
    
    if (!session) {
      return res.status(404).json({ error: 'Session not found' });
    }

    const participant = session.participants.find(p => 
      p.user.equals(req.user._id)
    );
    if (!participant) {
      return res.status(404).json({ error: 'Not a participant in this session' });
    }

    participant.status = status;
    await session.save();
    res.json(session);
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
};

// Update participant location and stats
const updateParticipantLocation = async (req, res) => {
  try {
    const { location, stats } = req.body;
    const session = await RunSession.findById(req.params.id);
    
    if (!session) {
      return res.status(404).json({ error: 'Session not found' });
    }

    const participant = session.participants.find(p => 
      p.user.equals(req.user._id)
    );
    if (!participant) {
      return res.status(404).json({ error: 'Not a participant in this session' });
    }

    participant.currentLocation = location;
    participant.route.push(location);
    
    if (stats) {
      participant.stats = {
        ...participant.stats,
        ...stats
      };
    }

    session.calculateStats();
    await session.save();
    
    // Return minimal response for frequent updates
    res.json({
      sessionId: session._id,
      status: session.status,
      stats: session.stats
    });
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
};

module.exports = {
  createSession,
  getGroupSessions,
  getSession,
  joinSession,
  updateSessionStatus,
  updateParticipantStatus,
  updateParticipantLocation
};
