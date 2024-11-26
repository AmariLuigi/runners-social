const jwt = require('jsonwebtoken');
const User = require('../models/user');

const JWT_SECRET = process.env.JWT_SECRET || 'your-development-secret';

const authenticateToken = async (req, res, next) => {
  try {
    console.log('Auth headers:', req.headers);
    const token = req.header('Authorization')?.replace('Bearer ', '');
    console.log('Extracted token:', token);
    
    if (!token) {
      throw new Error('No token provided');
    }

    console.log('JWT_SECRET:', JWT_SECRET);
    const decoded = jwt.verify(token, JWT_SECRET);
    console.log('Decoded token:', decoded);
    
    const user = await User.findOne({ _id: decoded.userId });
    console.log('Found user:', user);

    if (!user) {
      throw new Error('User not found');
    }

    req.token = token;
    req.user = { userId: user._id, email: user.email };
    next();
  } catch (error) {
    console.error('Auth error:', error);
    res.status(401).json({ 
      error: 'Authentication failed',
      details: error.message
    });
  }
};

const generateToken = (userId) => {
  return jwt.sign({ userId }, JWT_SECRET, { expiresIn: '7d' });
};

module.exports = {
  authenticateToken,
  generateToken,
  JWT_SECRET
};
