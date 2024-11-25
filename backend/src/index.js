require('dotenv').config();
const express = require('express');
const http = require('http');
const socketIO = require('socket.io');
const cors = require('cors');
const { connectDB } = require('./config/database');
const userRoutes = require('./routes/userRoutes');
const groupRoutes = require('./routes/groupRoutes');
const runSessionRoutes = require('./routes/runSessionRoutes');
const friendRoutes = require('./routes/friendRoutes');
const authRoutes = require('./routes/authRoutes');

const app = express();
const server = http.createServer(app);
const io = socketIO(server, {
  cors: {
    origin: "*",
    methods: ["GET", "POST"]
  }
});

// Middleware
app.use(cors());
app.use(express.json());

// Connect to database
connectDB();

// Routes
app.use('/api/auth', authRoutes);
app.use('/api/users', userRoutes);
app.use('/api/groups', groupRoutes);
app.use('/api/sessions', runSessionRoutes);
app.use('/api/friends', friendRoutes);

// Basic route
app.get('/', (req, res) => {
  res.json({ message: 'Welcome to Runners Social API' });
});

// Socket.IO connection handling
io.on('connection', (socket) => {
  console.log('New client connected');

  socket.on('joinGroup', (groupId) => {
    socket.join(groupId);
    console.log(`User joined group: ${groupId}`);
  });

  socket.on('leaveGroup', (groupId) => {
    socket.leave(groupId);
    console.log(`User left group: ${groupId}`);
  });

  // Join run session room
  socket.on('joinSession', (sessionId) => {
    socket.join(`session:${sessionId}`);
  });

  // Leave run session room
  socket.on('leaveSession', (sessionId) => {
    socket.leave(`session:${sessionId}`);
  });

  // Broadcast location update to session participants
  socket.on('locationUpdate', (data) => {
    const { sessionId, location, userId } = data;
    socket.to(`session:${sessionId}`).emit('participantLocation', {
      userId,
      location
    });
  });

  // Broadcast session status changes
  socket.on('sessionStatus', (data) => {
    const { sessionId, status } = data;
    socket.to(`session:${sessionId}`).emit('sessionStatusUpdate', {
      status
    });
  });

  // Broadcast participant status changes
  socket.on('participantStatus', (data) => {
    const { sessionId, userId, status } = data;
    socket.to(`session:${sessionId}`).emit('participantStatusUpdate', {
      userId,
      status
    });
  });

  // Join friend activity room
  socket.on('joinFriendActivity', (userId) => {
    socket.join(`friend:${userId}`);
  });

  // Leave friend activity room
  socket.on('leaveFriendActivity', (userId) => {
    socket.leave(`friend:${userId}`);
  });

  // Broadcast friend request
  socket.on('friendRequest', (data) => {
    const { recipientId, request } = data;
    socket.to(`friend:${recipientId}`).emit('newFriendRequest', request);
  });

  // Broadcast friend request response
  socket.on('friendRequestResponse', (data) => {
    const { requesterId, response } = data;
    socket.to(`friend:${requesterId}`).emit('friendRequestUpdated', response);
  });

  // Broadcast friend activity update
  socket.on('friendActivity', (data) => {
    const { friendIds, activity } = data;
    friendIds.forEach(friendId => {
      socket.to(`friend:${friendId}`).emit('friendActivityUpdate', activity);
    });
  });

  socket.on('disconnect', () => {
    console.log('Client disconnected');
  });
});

// Error handling middleware
app.use((err, req, res, next) => {
  console.error(err.stack);
  res.status(500).json({ error: 'Something went wrong!' });
});

// Start server
const PORT = process.env.PORT || 3000;
server.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
