const User = require('../models/user');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const { JWT_SECRET } = require('../middleware/auth');

// Register new user
const register = async (req, res) => {
  try {
    console.log('Register request body:', req.body);
    const { username, email, password } = req.body;

    if (!username || !email || !password) {
      return res.status(400).json({ 
        error: 'Missing required fields',
        details: {
          username: username ? 'provided' : 'missing',
          email: email ? 'provided' : 'missing',
          password: password ? 'provided' : 'missing'
        }
      });
    }

    // Check if user already exists
    const existingEmail = await User.findOne({ email });
    const existingUsername = await User.findOne({ username });

    if (existingEmail || existingUsername) {
      return res.status(400).json({ 
        error: 'User already exists',
        details: existingEmail ? 'Email is already registered' : 'Username is already taken'
      });
    }

    // Create new user
    const user = new User({
      username,
      email,
      password,
      profile: {
        firstName: '',
        lastName: '',
        bio: '',
        location: '',
        profileImage: '/default-profile.png',
        preferences: {
          privacyLevel: 'public',
          notificationSettings: {
            friendRequests: true,
            runInvites: true,
            achievements: true
          }
        }
      }
    });

    await user.save();

    // Generate JWT token
    const token = jwt.sign(
      { userId: user._id },
      JWT_SECRET,
      { expiresIn: '7d' }
    );

    res.status(201).json({
      message: 'Registration successful',
      token,
      user: {
        id: user._id,
        username: user.username,
        email: user.email,
        profile: user.profile
      }
    });
  } catch (error) {
    console.error('Registration error:', error);
    res.status(500).json({ 
      error: 'Registration failed',
      details: error.message 
    });
  }
};

// Login user
const login = async (req, res) => {
  try {
    console.log('Login request body:', req.body);
    const { email, password } = req.body;

    if (!email || !password) {
      return res.status(400).json({ 
        error: 'Missing required fields',
        details: {
          email: email ? 'provided' : 'missing',
          password: password ? 'provided' : 'missing'
        }
      });
    }

    // Find user by email
    const user = await User.findOne({ email });
    console.log('Found user:', user ? 'User exists' : 'User not found');

    if (!user) {
      console.log('Login failed: User not found');
      return res.status(401).json({ 
        error: 'Authentication failed',
        details: 'Invalid email or password'
      });
    }

    // Check password using the model's method
    const isMatch = await user.comparePassword(password);
    console.log('Password match result:', isMatch);

    if (!isMatch) {
      console.log('Login failed: Password mismatch');
      return res.status(401).json({ 
        error: 'Authentication failed',
        details: 'Invalid email or password'
      });
    }

    // Generate JWT token
    const token = jwt.sign(
      { userId: user._id },
      JWT_SECRET,
      { expiresIn: '7d' }
    );

    console.log('Login successful');
    res.status(200).json({
      message: 'Login successful',
      token,
      user: {
        id: user._id,
        username: user.username,
        email: user.email,
        profile: user.profile
      }
    });
  } catch (error) {
    console.error('Login error:', error);
    res.status(500).json({ 
      error: 'Login failed',
      details: error.message 
    });
  }
};

// Get current user
const getCurrentUser = async (req, res) => {
  try {
    console.log('Get current user request');
    const user = await User.findById(req.user.userId);

    if (!user) {
      return res.status(404).json({
        error: 'User not found',
        details: 'User no longer exists'
      });
    }

    res.status(200).json({
      id: user._id,
      username: user.username,
      email: user.email,
      profile: user.profile
    });
  } catch (error) {
    console.error('Get current user error:', error);
    res.status(500).json({
      error: 'Failed to get user',
      details: error.message
    });
  }
};

module.exports = {
  register,
  login,
  getCurrentUser
};
