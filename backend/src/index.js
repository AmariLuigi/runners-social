const express = require('express');
const http = require('http');
const socketIO = require('socket.io');
const mongoose = require('mongoose');
const cors = require('cors');
const dotenv = require('dotenv');
const SocketEventHandlers = require('./socket/eventHandlers');
const authRoutes = require('./routes/authRoutes');
const userRoutes = require('./routes/userRoutes');
const runRoutes = require('./routes/runRoutes');
const analyticsRoutes = require('./routes/analyticsRoutes');
const achievementRoutes = require('./routes/achievementRoutes');
const feedRoutes = require('./routes/feedRoutes');

dotenv.config();

const app = express();
const server = http.createServer(app);
const io = socketIO(server, {
  cors: {
    origin: process.env.FRONTEND_URL || 'http://localhost:51595',
    methods: ['GET', 'POST'],
    credentials: true,
    allowedHeaders: ['Content-Type', 'Authorization']
  }
});

// Middleware
app.use(cors({
  origin: process.env.FRONTEND_URL || 'http://localhost:51595',
  credentials: true,
  methods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'],
  allowedHeaders: ['Content-Type', 'Authorization']
}));

// Body parsing middleware
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Request logging middleware
app.use((req, res, next) => {
  console.log(`${req.method} ${req.url}`);
  console.log('Headers:', req.headers);
  if (req.body && Object.keys(req.body).length > 0) {
    console.log('Body:', req.body);
  }
  next();
});

// Database connection
mongoose.connect(process.env.MONGODB_URI || 'mongodb://localhost:27017/runners_social', {
  useNewUrlParser: true,
  useUnifiedTopology: true
})
.then(() => console.log('Connected to MongoDB'))
.catch(err => console.error('MongoDB connection error:', err));

// Socket.io setup
const socketHandlers = new SocketEventHandlers(io);
io.on('connection', (socket) => {
  socketHandlers.handleConnection(socket);
});

// Routes
app.use('/api/auth', authRoutes);
app.use('/api/users', userRoutes);
app.use('/api/runs', runRoutes);
app.use('/api/analytics', analyticsRoutes);
app.use('/api/achievements', achievementRoutes);
app.use('/api/feed', feedRoutes);

// Serve static files
app.use('/static', express.static('public'));

// Error handling middleware
app.use((err, req, res, next) => {
  console.error('Error:', err.stack);
  res.status(500).json({ message: 'Something went wrong!', error: err.message });
});

const PORT = process.env.PORT || 3000;
server.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
