const RunSession = require('../models/runSession');
const User = require('../models/user');
const Friend = require('../models/friend');
const { updateAchievements } = require('../services/achievementService');
const { updateAnalytics } = require('../services/analyticsService');
const jwt = require('jsonwebtoken');
const { JWT_SECRET } = require('../middleware/auth');

class SocketEventHandlers {
  constructor(io) {
    this.io = io;
    this.activeRuns = new Map(); // Store active run sessions
    this.userSockets = new Map(); // Map user IDs to socket IDs

    // Add middleware for socket authentication
    io.use(async (socket, next) => {
      try {
        console.log('Socket auth middleware - auth:', socket.handshake.auth);
        console.log('Socket auth middleware - headers:', socket.handshake.headers);

        const token = socket.handshake.auth.token || socket.handshake.headers.authorization;
        if (!token) {
          console.log('No token provided in socket connection');
          return next(new Error('Authentication token required'));
        }

        console.log('Received token:', token.substring(0, 20) + '...');
        console.log('Using JWT_SECRET:', JWT_SECRET);

        try {
          const decoded = jwt.verify(token, JWT_SECRET);
          if (!decoded || !decoded.userId) {
            console.log('Invalid token payload:', decoded);
            return next(new Error('Invalid token'));
          }

          socket.userId = decoded.userId;
          this.userSockets.set(decoded.userId, socket.id);
          console.log('Socket authenticated successfully:', {
            socketId: socket.id,
            userId: decoded.userId
          });
          next();
        } catch (jwtError) {
          console.error('JWT verification failed:', jwtError);
          return next(new Error('Invalid token'));
        }
      } catch (error) {
        console.error('Socket authentication error:', error);
        next(new Error('Authentication failed'));
      }
    });
  }

  // Handle new socket connections
  handleConnection(socket) {
    console.log('New client connected:', {
      socketId: socket.id,
      userId: socket.userId
    });

    // Associate user with socket
    // socket.on('authenticate', async (userId) => {
    //   console.log('Socket authentication received for userId:', userId);
    //   if (!userId) {
    //     socket.emit('error', { message: 'Authentication failed: userId is required' });
    //     return;
    //   }
      
    //   // Store both ways for redundancy
    //   this.userSockets.set(userId, socket.id);
    //   socket.userId = userId; // Store userId in socket for direct access
      
    //   console.log('Socket authenticated:', {
    //     socketId: socket.id,
    //     userId: userId,
    //     mappedSocketId: this.userSockets.get(userId)
    //   });
      
    //   await this.broadcastUserStatus(userId, true);
    //   socket.emit('authenticated', { userId });
    // });

    // Handle live run updates
    socket.on('startRun', async (data) => {
      try {
        console.log('StartRun event received:', {
          socketId: socket.id,
          userId: socket.userId,
          data: data
        });

        if (!socket.userId) {
          console.log('Unauthenticated startRun attempt');
          socket.emit('error', { message: 'Authentication required before starting a run' });
          return;
        }

        await this.handleStartRun(socket, socket.userId, data.runSessionId);
      } catch (error) {
        console.error('Error in startRun event:', error);
        socket.emit('error', { message: error.message || 'Failed to start run' });
      }
    });

    socket.on('updateLocation', async (data) => {
      await this.handleLocationUpdate(socket, data.runSessionId, data.location, data.isActive, data.userId);
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

    socket.on('disconnect', async () => {
      console.log('Client disconnected:', {
        socketId: socket.id,
        userId: socket.userId
      });
      
      if (socket.userId) {
        await this.broadcastUserStatus(socket.userId, false);
        this.userSockets.delete(socket.userId);
      }
    });
  }

  // Helper methods
  async handleStartRun(socket, userId, runSessionId) {
    try {
      console.log('Starting run with userId:', userId, 'runSessionId:', runSessionId);
      
      if (!userId || !runSessionId) {
        throw new Error('Missing required parameters: userId and runSessionId are required');
      }

      const runSession = await RunSession.findById(runSessionId)
        .populate('user', 'username profileImage')
        .populate('participants.user', 'username profileImage');

      if (!runSession) {
        throw new Error('Run session not found');
      }

      console.log('Run session found:', {
        id: runSession._id,
        status: runSession.status,
        participantCount: runSession.participants.length
      });

      // Safely check if user is a participant
      let isParticipant = false;
      if (runSession.participants && Array.isArray(runSession.participants)) {
        for (const participant of runSession.participants) {
          if (!participant) continue;
          
          // Get the user ID, handling both populated and unpopulated cases
          let participantUserId = null;
          if (participant.user) {
            if (participant.user._id) {
              participantUserId = participant.user._id.toString();
            } else if (typeof participant.user === 'string' || participant.user instanceof mongoose.Types.ObjectId) {
              participantUserId = participant.user.toString();
            }
          }

          console.log('Comparing participant:', {
            participantUserId,
            userId: userId.toString()
          });

          if (participantUserId === userId.toString()) {
            isParticipant = true;
            break;
          }
        }
      }

      if (!isParticipant) {
        throw new Error('User not authorized for this run session');
      }

      // Update run session status
      runSession.status = 'active';
      runSession.startTime = new Date();
      await runSession.save();

      // Safely map participants
      const mappedParticipants = [];
      if (runSession.participants && Array.isArray(runSession.participants)) {
        for (const participant of runSession.participants) {
          if (!participant) continue;

          let participantData = {
            userId: null,
            username: 'Unknown',
            role: participant.role || 'participant',
            lastLocation: null,
            distance: 0,
            pace: 0
          };

          if (participant.user) {
            if (participant.user._id) {
              participantData.userId = participant.user._id.toString();
              participantData.username = participant.user.username || 'Unknown';
            } else if (typeof participant.user === 'string' || participant.user instanceof mongoose.Types.ObjectId) {
              participantData.userId = participant.user.toString();
            }
          }

          if (participantData.userId) {
            mappedParticipants.push(participantData);
          }
        }
      }

      this.activeRuns.set(runSessionId, {
        startTime: new Date(),
        participants: mappedParticipants
      });

      // Notify all participants about run start
      const roomName = `run:${runSessionId}`;
      for (const participant of runSession.participants) {
        const participantSocket = this.userSockets.get(participant.user._id.toString());
        if (participantSocket) {
          this.io.sockets.sockets.get(participantSocket).join(roomName);
        }
      }

      this.io.to(roomName).emit('runStarted', {
        runSessionId,
        startTime: new Date(),
        participants: this.activeRuns.get(runSessionId).participants
      });

      // Notify friends about run start
      for (const participant of runSession.participants) {
        this.broadcastToFriends(participant.user._id.toString(), 'friendStartedRun', {
          username: participant.user.username,
          runSessionId,
          isGroupRun: runSession.type === 'group'
        });
      }
    } catch (error) {
      console.error('Error starting run:', error);
      socket.emit('error', { message: error.message || 'Failed to start run session' });
    }
  }

  async handleLocationUpdate(socket, runSessionId, location, isActive, userId) {
    try {
      console.log('Handling location update:', { runSessionId, location, isActive, userId });
      
      if (!userId) {
        userId = socket.userId; // Fallback to socket's userId if not provided
      }

      if (!userId) {
        throw new Error('No userId provided or found in socket');
      }

      const runSession = await RunSession.findById(runSessionId);
      if (!runSession) {
        throw new Error('Run session not found');
      }

      console.log('Found run session:', {
        id: runSession._id,
        status: runSession.status,
        participantCount: runSession.participants.length
      });

      // Verify participant
      const participant = runSession.participants.find(p => {
        const participantUserId = p.user.toString();
        console.log('Comparing participant:', {
          participantUserId,
          userId
        });
        return participantUserId === userId;
      });
      
      if (!participant) {
        throw new Error('User not authorized for this run session');
      }

      // Create location entry
      const locationEntry = {
        type: 'Point',
        coordinates: [location.longitude, location.latitude],  // GeoJSON format: [longitude, latitude]
        altitude: location.altitude || 0,
        speed: location.speed || 0,
        timestamp: new Date(location.timestamp) || new Date()
      };

      console.log('Updating run session with location:', locationEntry);

      // Update run session with new location
      const updatedSession = await RunSession.findByIdAndUpdate(
        runSessionId,
        {
          $push: {
            locationHistory: locationEntry
          },
          $set: {
            'participants.$[elem].lastLocation': locationEntry,
            'participants.$[elem].isActive': isActive
          }
        },
        {
          arrayFilters: [{ 'elem.user': userId }],
          new: true
        }
      );

      if (!updatedSession) {
        throw new Error('Failed to update run session');
      }

      console.log('Successfully updated run session with location');

      // Broadcast to all participants in the run
      this.io.to(`run:${runSessionId}`).emit('locationUpdated', {
        participantId: userId,
        location: locationEntry,
        isActive
      });

    } catch (error) {
      console.error('Error updating location:', error);
      socket.emit('error', { message: error.message || 'Failed to update location' });
    }
  }

  async handleEndRun(socket, runSessionId, finalStats) {
    try {
      console.log('Handling end run:', { runSessionId, finalStats });

      // Check if run exists and is active
      const runSession = await RunSession.findById(runSessionId);
      if (!runSession) {
        console.log('Run session not found:', runSessionId);
        socket.emit('error', { message: 'Run session not found' });
        return;
      }

      if (!runSession.isActive) {
        console.log('Run session already ended:', runSessionId);
        socket.emit('error', { message: 'Run already ended' });
        return;
      }

      // Ensure finalStats has default values if undefined
      const stats = {
        distance: finalStats?.distance || 0,
        averagePace: finalStats?.averagePace || 0,
        totalTime: finalStats?.totalTime || 0
      };

      console.log('Updating run session with stats:', stats);

      // Update run session
      const updatedSession = await RunSession.findByIdAndUpdate(
        runSessionId,
        {
          isActive: false,
          endTime: new Date(),
          finalDistance: stats.distance,
          averagePace: stats.averagePace,
          totalTime: stats.totalTime
        },
        { new: true }
      );

      if (!updatedSession) {
        console.log('Failed to update run session:', runSessionId);
        socket.emit('error', { message: 'Failed to update run session' });
        return;
      }

      // Get the host user's ID (first participant)
      const participant = updatedSession.participants[0];
      const userId = participant?.user?.toString() || participant?.toString();

      console.log('Extracted userId:', userId);

      if (userId) {
        try {
          // Notify friends about run completion
          await this.broadcastToFriends(userId, 'friendCompletedRun', {
            runSessionId,
            userId,
            stats
          });

          console.log('Updating user stats for:', userId);

          // Update user stats
          await User.findByIdAndUpdate(
            userId,
            {
              $inc: {
                'stats.totalRuns': 1,
                'stats.totalDistance': stats.distance,
                'stats.totalDuration': stats.totalTime
              }
            },
            { new: true }
          );

          // Update achievements
          await updateAchievements(userId, {
            distance: stats.distance,
            duration: stats.totalTime
          });

          // Update analytics
          await updateAnalytics('runCompleted', {
            userId,
            distance: stats.distance,
            duration: stats.totalTime,
            pace: stats.averagePace
          });
        } catch (innerError) {
          console.error('Error updating user data:', innerError);
          // Continue with cleanup even if user updates fail
        }
      } else {
        console.log('No valid userId found in run session');
      }

      // Emit success event
      this.io.to(`run:${runSessionId}`).emit('runEnded', {
        runSessionId,
        finalStats: stats,
        success: true
      });

      // Clean up
      this.activeRuns.delete(runSessionId);
      socket.leave(`run:${runSessionId}`);
      console.log('Run ended successfully:', runSessionId);

    } catch (error) {
      console.error('Error ending run:', error);
      socket.emit('error', { message: 'Failed to end run' });
    }
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
        let participantProgressUpdated = false;
        for (const participantProgress of checkpoint.participantProgress) {
          if (participantProgress.user.toString() === userId) {
            participantProgress.reachedAt = new Date();
            participantProgressUpdated = true;
            break;
          }
        }

        if (!participantProgressUpdated) {
          checkpoint.participantProgress.push({
            user: userId,
            reachedAt: new Date()
          });
        }

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

    for (const friend of friends) {
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
    }
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
