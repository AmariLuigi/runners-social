const User = require('../models/user');
const { generateToken } = require('../middleware/auth');

// Get user profile
const getProfile = async (req, res) => {
  try {
    const user = await User.findById(req.user.userId).select('-password');
    
    if (!user) {
      return res.status(404).json({
        error: 'User not found',
        details: 'User profile could not be found'
      });
    }

    res.json({
      message: 'Profile retrieved successfully',
      user: {
        id: user._id,
        username: user.username,
        email: user.email,
        profile: user.profile
      }
    });
  } catch (error) {
    console.error('Get profile error:', error);
    res.status(500).json({ 
      error: 'Failed to get profile',
      details: error.message 
    });
  }
};

// Update user profile
const updateProfile = async (req, res) => {
  try {
    const updates = Object.keys(req.body);
    const allowedUpdates = [
      'username',
      'profile.firstName',
      'profile.lastName',
      'profile.bio',
      'profile.location',
      'profile.preferences.distanceUnit',
      'profile.preferences.privacyLevel'
    ];

    const invalidUpdates = updates.filter(update => !allowedUpdates.includes(update));
    if (invalidUpdates.length > 0) {
      return res.status(400).json({ 
        error: 'Invalid updates',
        details: `The following fields cannot be updated: ${invalidUpdates.join(', ')}`
      });
    }

    const user = await User.findById(req.user.userId);
    if (!user) {
      return res.status(404).json({
        error: 'User not found',
        details: 'User profile could not be found'
      });
    }

    // Check if username is being updated and is unique
    if (updates.includes('username') && req.body.username !== user.username) {
      const existingUser = await User.findOne({ username: req.body.username });
      if (existingUser) {
        return res.status(400).json({
          error: 'Username already taken',
          details: 'Please choose a different username'
        });
      }
    }

    updates.forEach(update => {
      if (update.includes('.')) {
        const [key, subKey, subSubKey] = update.split('.');
        if (subSubKey) {
          user[key][subKey][subSubKey] = req.body[update];
        } else {
          user[key][subKey] = req.body[update];
        }
      } else {
        user[update] = req.body[update];
      }
    });

    await user.save();

    res.json({
      message: 'Profile updated successfully',
      user: {
        id: user._id,
        username: user.username,
        email: user.email,
        profile: user.profile
      }
    });
  } catch (error) {
    console.error('Update profile error:', error);
    res.status(500).json({ 
      error: 'Failed to update profile',
      details: error.message 
    });
  }
};

module.exports = {
  getProfile,
  updateProfile
};
