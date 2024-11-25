const Friendship = require('../models/friend');
const User = require('../models/user');
const RunSession = require('../models/runSession');
const Notification = require('../models/notification');

// Helper function to create notifications
const createNotification = async (type, sender, recipient, relatedModel, relatedId, message) => {
  const notification = new Notification({
    type,
    sender,
    recipient,
    relatedModel,
    relatedId,
    message
  });
  await notification.save();
  return notification;
};

// Send friend request
const sendFriendRequest = async (req, res) => {
  try {
    const { recipientId } = req.body;
    
    // Check if recipient exists
    const recipient = await User.findById(recipientId);
    if (!recipient) {
      return res.status(404).json({ error: 'User not found' });
    }

    // Check if friendship already exists
    const existingFriendship = await Friendship.findOne({
      $or: [
        { requester: req.user._id, recipient: recipientId },
        { requester: recipientId, recipient: req.user._id }
      ]
    });

    if (existingFriendship) {
      if (existingFriendship.status === 'blocked') {
        return res.status(403).json({ error: 'Unable to send friend request' });
      }
      return res.status(400).json({ 
        error: 'Friendship already exists',
        status: existingFriendship.status 
      });
    }

    const friendship = new Friendship({
      requester: req.user._id,
      recipient: recipientId
    });

    await friendship.save();

    // Create notification for friend request
    await createNotification(
      'friend_request',
      req.user._id,
      recipientId,
      'Friendship',
      friendship._id,
      `${req.user.username} sent you a friend request`
    );

    // Populate user info for response
    await friendship.populate('requester', 'username profile.firstName profile.lastName');
    await friendship.populate('recipient', 'username profile.firstName profile.lastName');

    res.status(201).json(friendship);
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
};

// Handle friend request (accept/decline)
const handleFriendRequest = async (req, res) => {
  try {
    const { requestId, action } = req.body;
    
    const friendship = await Friendship.findById(requestId);
    if (!friendship) {
      return res.status(404).json({ error: 'Friend request not found' });
    }

    // Verify recipient is current user
    if (!friendship.recipient.equals(req.user._id)) {
      return res.status(403).json({ error: 'Not authorized to handle this request' });
    }

    if (action === 'accept') {
      friendship.status = 'accepted';
    } else if (action === 'decline') {
      friendship.status = 'declined';
    } else {
      return res.status(400).json({ error: 'Invalid action' });
    }

    await friendship.save();

    // Create notification for friend request acceptance
    if (action === 'accept') {
      await createNotification(
        'friend_accept',
        req.user._id,
        friendship.requester,
        'Friendship',
        friendship._id,
        `${req.user.username} accepted your friend request`
      );
    }

    // Populate user info for response
    await friendship.populate('requester', 'username profile.firstName profile.lastName');
    await friendship.populate('recipient', 'username profile.firstName profile.lastName');

    res.json(friendship);
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
};

// Get friend list
const getFriends = async (req, res) => {
  try {
    const friendships = await Friendship.find({
      $or: [
        { requester: req.user._id },
        { recipient: req.user._id }
      ],
      status: 'accepted'
    })
    .populate('requester', 'username profile.firstName profile.lastName')
    .populate('recipient', 'username profile.firstName profile.lastName')
    .sort('-lastInteraction');

    // Format response to show friend info
    const friends = friendships.map(friendship => {
      const friend = friendship.requester._id.equals(req.user._id) 
        ? friendship.recipient 
        : friendship.requester;
      return {
        friendship: friendship._id,
        user: friend,
        sharedStats: friendship.sharedStats,
        lastInteraction: friendship.lastInteraction
      };
    });

    res.json(friends);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Get pending friend requests
const getPendingRequests = async (req, res) => {
  try {
    const pendingRequests = await Friendship.find({
      recipient: req.user._id,
      status: 'pending'
    })
    .populate('requester', 'username profile.firstName profile.lastName')
    .sort('-createdAt');

    res.json(pendingRequests);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Block/Unblock user
const toggleBlockUser = async (req, res) => {
  try {
    const { userId } = req.body;
    
    let friendship = await Friendship.findOne({
      $or: [
        { requester: req.user._id, recipient: userId },
        { requester: userId, recipient: req.user._id }
      ]
    });

    if (!friendship) {
      friendship = new Friendship({
        requester: req.user._id,
        recipient: userId,
        status: 'blocked',
        blockedBy: req.user._id
      });
    } else {
      if (friendship.status === 'blocked' && friendship.blockedBy.equals(req.user._id)) {
        friendship.status = 'declined';
        friendship.blockedBy = null;
      } else {
        friendship.status = 'blocked';
        friendship.blockedBy = req.user._id;
      }
    }

    await friendship.save();
    res.json({ status: friendship.status });
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
};

// Get friend activity feed
const getFriendActivity = async (req, res) => {
  try {
    // Get all accepted friendships
    const friendships = await Friendship.find({
      $or: [
        { requester: req.user._id },
        { recipient: req.user._id }
      ],
      status: 'accepted'
    });

    const friendIds = friendships.map(friendship => 
      friendship.requester.equals(req.user._id) 
        ? friendship.recipient 
        : friendship.requester
    );

    // Get recent run sessions from friends
    const recentActivity = await RunSession.find({
      'participants.user': { $in: friendIds },
      status: { $in: ['active', 'completed'] }
    })
    .populate('participants.user', 'username profile.firstName profile.lastName')
    .populate('group', 'name')
    .sort('-updatedAt')
    .limit(20);

    res.json(recentActivity);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Update shared stats after run session
const updateSharedStats = async (req, res) => {
  try {
    const { sessionId } = req.body;
    
    const session = await RunSession.findById(sessionId);
    if (!session) {
      return res.status(404).json({ error: 'Session not found' });
    }

    // Get participating friends
    const participantIds = session.participants.map(p => p.user);
    const friendships = await Friendship.find({
      $or: [
        { 
          requester: req.user._id,
          recipient: { $in: participantIds },
          status: 'accepted'
        },
        {
          recipient: req.user._id,
          requester: { $in: participantIds },
          status: 'accepted'
        }
      ]
    });

    // Update stats for each friendship
    await Promise.all(
      friendships.map(friendship => friendship.updateSharedStats(session))
    );

    res.json({ message: 'Shared stats updated successfully' });
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
};

// Get blocked users list
const getBlockedUsers = async (req, res) => {
  try {
    const blockedFriendships = await Friendship.find({
      $or: [
        { requester: req.user._id, status: 'blocked' },
        { recipient: req.user._id, status: 'blocked' }
      ]
    }).populate('requester recipient', 'username profile.firstName profile.lastName');

    const blockedUsers = blockedFriendships.map(friendship => {
      const blockedUser = friendship.requester._id.equals(req.user._id) 
        ? friendship.recipient 
        : friendship.requester;
      return {
        _id: blockedUser._id,
        username: blockedUser.username,
        profile: blockedUser.profile,
        blockedAt: friendship.updatedAt
      };
    });

    res.json(blockedUsers);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Unblock user
const unblockUser = async (req, res) => {
  try {
    const { userId } = req.body;
    
    const friendship = await Friendship.findOne({
      $or: [
        { requester: req.user._id, recipient: userId },
        { requester: userId, recipient: req.user._id }
      ],
      status: 'blocked'
    });

    if (!friendship) {
      return res.status(404).json({ error: 'Blocked relationship not found' });
    }

    // Delete the blocked relationship
    await friendship.deleteOne();
    
    res.json({ message: 'User unblocked successfully' });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Get friend notifications
const getFriendNotifications = async (req, res) => {
  try {
    const notifications = await Notification.find({
      recipient: req.user._id,
      $or: [
        { type: 'friend_request' },
        { type: 'friend_accept' },
        { type: 'run_invite' },
        { type: 'run_start' },
        { type: 'run_complete' }
      ]
    })
    .sort({ createdAt: -1 })
    .populate('sender', 'username profile.firstName profile.lastName')
    .limit(50);

    res.json(notifications);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Get friend statistics
const getFriendStats = async (req, res) => {
  try {
    const { friendId } = req.params;

    // Verify friendship exists and is accepted
    const friendship = await Friendship.findOne({
      $or: [
        { requester: req.user._id, recipient: friendId },
        { requester: friendId, recipient: req.user._id }
      ],
      status: 'accepted'
    });

    if (!friendship) {
      return res.status(404).json({ error: 'Friendship not found or not accepted' });
    }

    // Get all completed run sessions where both users participated
    const sharedSessions = await RunSession.find({
      status: 'completed',
      'participants.user': { 
        $all: [req.user._id, friendId] 
      }
    });

    // Calculate shared statistics
    let totalDistance = 0;
    let totalDuration = 0;
    let totalRuns = sharedSessions.length;
    let lastRunDate = null;

    sharedSessions.forEach(session => {
      totalDistance += session.stats.actualDistance || 0;
      totalDuration += session.stats.duration || 0;
      
      if (!lastRunDate || session.updatedAt > lastRunDate) {
        lastRunDate = session.updatedAt;
      }
    });

    const stats = {
      totalRuns,
      totalDistance,
      totalDuration,
      lastRunDate,
      averagePace: totalDuration > 0 ? totalDistance / totalDuration : 0,
      ...friendship.sharedStats
    };

    res.json(stats);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Get shared run history with a friend
const getSharedRunHistory = async (req, res) => {
  try {
    const { friendId } = req.params;
    const { page = 1, limit = 10 } = req.query;

    // Verify friendship exists and is accepted
    const friendship = await Friendship.findOne({
      $or: [
        { requester: req.user._id, recipient: friendId },
        { requester: friendId, recipient: req.user._id }
      ],
      status: 'accepted'
    });

    if (!friendship) {
      return res.status(404).json({ error: 'Friendship not found or not accepted' });
    }

    // Get shared run sessions with pagination
    const skip = (page - 1) * limit;
    const sharedSessions = await RunSession.find({
      status: 'completed',
      'participants.user': { 
        $all: [req.user._id, friendId] 
      }
    })
    .sort({ startTime: -1 })
    .skip(skip)
    .limit(parseInt(limit))
    .populate('participants.user', 'username profile.firstName profile.lastName');

    // Get total count for pagination
    const totalSessions = await RunSession.countDocuments({
      status: 'completed',
      'participants.user': { 
        $all: [req.user._id, friendId] 
      }
    });

    const totalPages = Math.ceil(totalSessions / limit);

    res.json({
      sessions: sharedSessions,
      pagination: {
        currentPage: parseInt(page),
        totalPages,
        totalSessions,
        hasNextPage: page < totalPages,
        hasPrevPage: page > 1
      }
    });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

module.exports = {
  sendFriendRequest,
  handleFriendRequest,
  getFriends,
  getPendingRequests,
  toggleBlockUser,
  getFriendActivity,
  updateSharedStats,
  getBlockedUsers,
  unblockUser,
  getFriendNotifications,
  getFriendStats,
  getSharedRunHistory
};
