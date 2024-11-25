const express = require('express');
const { authenticateToken } = require('../middleware/auth');
const { getProfile, updateProfile } = require('../controllers/userController');

const router = express.Router();

// Protected routes - require authentication
router.get('/profile', authenticateToken, getProfile);
router.patch('/profile', authenticateToken, updateProfile);

module.exports = router;
