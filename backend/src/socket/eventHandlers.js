const RunSession = require('../models/runSession');
const User = require('../models/user');
const Friend = require('../models/friend');
const { updateAchievements } = require('../services/achievementService');
const { updateAnalytics } = require('../services/analyticsService');

class SocketEventHandlers {
  constructor(io) {
    this.io = io;
    this.activeRuns = new Map(); // Store active run sessions
    this.userSockets = new Map(); // Map user IDs to socket IDs
  }

  // Handle new socket connections
  handleConnection(socket) {
    console.log('New client connected:', socket.id);

    // Associate user with socket
    socket.on('authenticate', async (userId) => {
      this.userSockets.set(userId, socket.id);
      await this.broadcastUserStatus(userId, true);
    });

    // Handle live run updates
    socket.on('startRun', async (data) => {
      const { userId, runSessionId } = data;
      await this.handleStartRun(socket, userId, runSessionId);
    });

    socket.on('updateLocation', async (data) => {
      const { runSessionId, location, pace, distance } = data;
      await this.handleLocationUpdate(socket, runSessionId, location, pace, distance);
    });

    socket.on('endRun', async (data) => {
      const { runSessionId, finalStats } = data;
      await this.handleEndRun(socket, runSessionId, finalStats);
    });

    // Handle friend activity
    socket.on('joinFriendFeed', async (userId) => {
      const friends = await Friend.find({ 
        $or: [{ user1: userId }, { user2: userId }],
        status: 'accepted'
      });
      
      friends.forEach(friend => {
        const friendId = friend.user1.toString() === userId ? 
          friend.user2.toString() : friend.user1.toString();
        socket.join(`user:${friendId}:activity`);
      });
    });

    // Handle joining a run session room
    socket.on('join_run', async (runId) => {
      socket.join(`run_${runId}`);
      console.log(`User ${socket.id} joined run ${runId}`);
    });

    // Handle real-time location updates
    socket.on('location_update', async (data) => {
      const { runId, location, timestamp, metrics } = data;
      
      try {
        // Update run session with new location and metrics
        await RunSession.findByIdAndUpdate(runId, {
          $push: {
            locationHistory: {
              coordinates: [location.longitude, location.latitude],
              timestamp
            },
            metrics: {
              ...metrics,
              timestamp
            }
          }
        });

        // Broadcast location update to all users in the run session
        this.io.to(`run_${runId}`).emit('runner_location', {
          runnerId: socket.id,
          location,
          metrics
        });

        // Update achievements and analytics
        await updateAchievements(data);
        await updateAnalytics(data);
      } catch (error) {
        console.error('Error handling location update:', error);
        socket.emit('error', { message: 'Failed to update location' });
      }
    });

    // Handle run session completion
    socket.on('complete_run', async (data) => {
      const { runId, finalMetrics } = data;
      
      try {
        const session = await RunSession.findByIdAndUpdate(runId, {
          status: 'completed',
          endTime: new Date(),
          finalMetrics
        }, { new: true });

        // Notify all participants that the run is complete
        this.io.to(`run_${runId}`).emit('run_completed', {
          runId,
          finalMetrics
        });

        // Leave the run session room
        socket.leave(`run_${runId}`);
      } catch (error) {
        console.error('Error completing run:', error);
        socket.emit('error', { message: 'Failed to complete run' });
      }
    });

    // Handle pause/resume run
    socket.on('toggle_run_status', async (data) => {
      const { runId, status } = data; // status can be 'paused' or 'active'
      
      try {
        await RunSession.findByIdAndUpdate(runId, { status });
        this.io.to(`run_${runId}`).emit('run_status_changed', { runId, status });
      } catch (error) {
        console.error('Error toggling run status:', error);
        socket.emit('error', { message: 'Failed to update run status' });
      }
    });

    // Handle chat messages in run session
    socket.on('send_message', async (data) => {
      const { runId, message, sender } = data;
      
      try {
        await RunSession.findByIdAndUpdate(runId, {
          $push: {
            chat: {
              sender,
              message,
              timestamp: new Date()
            }
          }
        });

        this.io.to(`run_${runId}`).emit('new_message', {
          sender,
          message,
          timestamp: new Date()
        });
      } catch (error) {
        console.error('Error sending message:', error);
        socket.emit('error', { message: 'Failed to send message' });
      }
    });

    // Cleanup on disconnect
    socket.on('disconnect', async () => {
      const userId = this.getUserIdBySocket(socket.id);
      if (userId) {
        await this.broadcastUserStatus(userId, false);
        this.userSockets.delete(userId);
      }
    });
  }

  // Helper methods
  async handleStartRun(socket, userId, runSessionId) {
    try {
      const runSession = await RunSession.findById(runSessionId)
        .populate('participants', 'username');
      
      if (!runSession) {
        socket.emit('error', { message: 'Run session not found' });
        return;
      }

      this.activeRuns.set(runSessionId, {
        startTime: new Date(),
        participants: runSession.participants.map(p => p._id.toString())
      });

      // Notify friends about run start
      this.broadcastToFriends(userId, 'friendStartedRun', {
        username: runSession.participants.find(p => p._id.toString() === userId).username,
        runSessionId
      });

      socket.join(`run:${runSessionId}`);
      this.io.to(`run:${runSessionId}`).emit('runStarted', {
        runSessionId,
        startTime: new Date()
      });
    } catch (error) {
      socket.emit('error', { message: 'Failed to start run session' });
    }
  }

  async handleLocationUpdate(socket, runSessionId, location, pace, distance) {
    if (!this.activeRuns.has(runSessionId)) return;

    const runData = {
      location,
      pace,
      distance,
      timestamp: new Date()
    };

    this.io.to(`run:${runSessionId}`).emit('locationUpdate', runData);
    
    // Update run session in database
    await RunSession.findByIdAndUpdate(runSessionId, {
      $push: { 
        locationHistory: location,
        paceHistory: pace
      },
      currentDistance: distance
    });
  }

  async handleEndRun(socket, runSessionId, finalStats) {
    if (!this.activeRuns.has(runSessionId)) return;

    const runSession = await RunSession.findByIdAndUpdate(runSessionId, {
      isActive: false,
      endTime: new Date(),
      finalDistance: finalStats.distance,
      averagePace: finalStats.averagePace,
      totalTime: finalStats.totalTime
    }, { new: true });

    this.io.to(`run:${runSessionId}`).emit('runEnded', {
      runSessionId,
      finalStats
    });

    // Notify friends about run completion
    const userId = runSession.participants[0].toString();
    this.broadcastToFriends(userId, 'friendCompletedRun', {
      runSessionId,
      stats: finalStats
    });

    this.activeRuns.delete(runSessionId);
    socket.leave(`run:${runSessionId}`);
  }

  async broadcastUserStatus(userId, isOnline) {
    const user = await User.findById(userId);
    if (!user) return;

    const friends = await Friend.find({
      $or: [{ user1: userId }, { user2: userId }],
      status: 'accepted'
    });

    friends.forEach(friend => {
      const friendId = friend.user1.toString() === userId ? 
        friend.user2.toString() : friend.user1.toString();
      
      const friendSocketId = this.userSockets.get(friendId);
      if (friendSocketId) {
        this.io.to(friendSocketId).emit('friendStatus', {
          friendId: userId,
          username: user.username,
          isOnline
        });
      }
    });
  }

  async broadcastToFriends(userId, event, data) {
    this.io.to(`user:${userId}:activity`).emit(event, data);
  }

  getUserIdBySocket(socketId) {
    for (const [userId, sid] of this.userSockets.entries()) {
      if (sid === socketId) return userId;
    }
    return null;
  }
}

module.exports = SocketEventHandlers;
