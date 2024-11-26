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
      const userId = await this.getUserIdBySocket(socket.id);
      await this.handleStartRun(socket, userId, data.runSessionId);
    });

    socket.on('updateLocation', async (data) => {
      await this.handleLocationUpdate(socket, data.runSessionId, data.location, data.pace, data.distance);
    });

    socket.on('endRun', async (data) => {
      await this.handleEndRun(socket, data.runSessionId, data.finalStats);
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
    socket.on('sendMessage', async (data) => {
      await this.handleChatMessage(socket, data.runSessionId, data.message);
    });

    socket.on('checkpointReached', async (data) => {
      await this.handleCheckpointReached(socket, data.runSessionId, data.checkpointId, data.location);
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
        .populate('participants.user', 'username');

      if (!runSession) {
        throw new Error('Run session not found');
      }

      if (!runSession.participants.some(p => p.user._id.toString() === userId)) {
        throw new Error('User not authorized for this run session');
      }

      // Update run session status
      runSession.status = 'active';
      runSession.startTime = new Date();
      await runSession.save();

      this.activeRuns.set(runSessionId, {
        startTime: new Date(),
        participants: runSession.participants.map(p => ({
          userId: p.user._id.toString(),
          username: p.user.username,
          role: p.role,
          lastLocation: null,
          distance: 0,
          pace: 0
        }))
      });

      // Notify all participants about run start
      const roomName = `run:${runSessionId}`;
      runSession.participants.forEach(participant => {
        const participantSocket = this.userSockets.get(participant.user._id.toString());
        if (participantSocket) {
          this.io.sockets.sockets.get(participantSocket).join(roomName);
        }
      });

      this.io.to(roomName).emit('runStarted', {
        runSessionId,
        startTime: new Date(),
        participants: this.activeRuns.get(runSessionId).participants
      });

      // Notify friends about run start
      runSession.participants.forEach(participant => {
        this.broadcastToFriends(participant.user._id.toString(), 'friendStartedRun', {
          username: participant.user.username,
          runSessionId,
          isGroupRun: runSession.type === 'group'
        });
      });
    } catch (error) {
      console.error('Error starting run:', error);
      socket.emit('error', { message: error.message || 'Failed to start run session' });
    }
  }

  async handleLocationUpdate(socket, runSessionId, location, pace, distance) {
    try {
      const activeRun = this.activeRuns.get(runSessionId);
      if (!activeRun) return;

      const userId = await this.getUserIdBySocket(socket.id);
      const participant = activeRun.participants.find(p => p.userId === userId);
      
      if (!participant) return;

      // Update participant's stats
      participant.lastLocation = location;
      participant.distance = distance;
      participant.pace = pace;

      // Broadcast to all participants in the run
      this.io.to(`run:${runSessionId}`).emit('locationUpdate', {
        runSessionId,
        participant: {
          userId,
          username: participant.username,
          location,
          pace,
          distance
        }
      });

      // Update run session in database
      await RunSession.findByIdAndUpdate(runSessionId, {
        $push: {
          [`locationHistory.${userId}`]: {
            coordinates: location,
            timestamp: new Date()
          },
          [`paceHistory.${userId}`]: {
            pace,
            timestamp: new Date()
          }
        },
        [`currentDistance.${userId}`]: distance
      });
    } catch (error) {
      console.error('Error updating location:', error);
      socket.emit('error', { message: 'Failed to update location' });
    }
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

  async handleChatMessage(socket, runSessionId, message) {
    try {
      const userId = await this.getUserIdBySocket(socket.id);
      const runSession = await RunSession.findById(runSessionId)
        .populate('participants.user', 'username profileImage');

      if (!runSession || !runSession.participants.some(p => p.user._id.toString() === userId)) {
        throw new Error('Not authorized to send messages in this run');
      }

      const sender = runSession.participants.find(p => p.user._id.toString() === userId).user;
      const chatMessage = {
        sender: sender._id,
        content: message,
        timestamp: new Date(),
        type: 'text'
      };

      // Save message to database
      runSession.chat.push(chatMessage);
      await runSession.save();

      // Broadcast message to all participants
      this.io.to(`run:${runSessionId}`).emit('chatMessage', {
        ...chatMessage,
        sender: {
          _id: sender._id,
          username: sender.username,
          profileImage: sender.profileImage
        }
      });
    } catch (error) {
      console.error('Error sending message:', error);
      socket.emit('error', { message: 'Failed to send message' });
    }
  }

  async handleCheckpointReached(socket, runSessionId, checkpointId, userLocation) {
    try {
      const userId = await this.getUserIdBySocket(socket.id);
      const runSession = await RunSession.findById(runSessionId);

      if (!runSession || !runSession.participants.some(p => p.user.toString() === userId)) {
        throw new Error('Not authorized for this run');
      }

      const checkpoint = runSession.checkpoints.id(checkpointId);
      if (!checkpoint) {
        throw new Error('Checkpoint not found');
      }

      // Calculate distance between user and checkpoint
      const distance = this.calculateDistance(
        userLocation,
        checkpoint.location.coordinates
      );

      // Check if user is within checkpoint radius
      if (distance <= checkpoint.radius) {
        // Update checkpoint progress
        if (!checkpoint.participantProgress.some(p => p.user.toString() === userId)) {
          checkpoint.participantProgress.push({
            user: userId,
            reachedAt: new Date()
          });

          await runSession.save();

          // Notify all participants
          const message = {
            sender: userId,
            content: `Checkpoint ${checkpoint.name} reached!`,
            timestamp: new Date(),
            type: 'system'
          };

          runSession.chat.push(message);
          await runSession.save();

          this.io.to(`run:${runSessionId}`).emit('checkpointUpdate', {
            checkpointId,
            userId,
            checkpoint: checkpoint.toObject()
          });

          this.io.to(`run:${runSessionId}`).emit('chatMessage', {
            ...message,
            sender: {
              _id: userId,
              username: runSession.participants.find(p => p.user.toString() === userId).user.username
            }
          });
        }
      }
    } catch (error) {
      console.error('Error handling checkpoint:', error);
      socket.emit('error', { message: 'Failed to process checkpoint' });
    }
  }

  calculateDistance(point1, point2) {
    const R = 6371e3; // Earth's radius in meters
    const φ1 = point1[1] * Math.PI / 180;
    const φ2 = point2[1] * Math.PI / 180;
    const Δφ = (point2[1] - point1[1]) * Math.PI / 180;
    const Δλ = (point2[0] - point1[0]) * Math.PI / 180;

    const a = Math.sin(Δφ/2) * Math.sin(Δφ/2) +
              Math.cos(φ1) * Math.cos(φ2) *
              Math.sin(Δλ/2) * Math.sin(Δλ/2);
    const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a));

    return R * c; // Distance in meters
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
