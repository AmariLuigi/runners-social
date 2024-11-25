const express = require('express');
const router = express.Router();
const { authenticateToken } = require('../middleware/auth');

// Get all available achievements
router.get('/', authenticateToken, async (req, res) => {
  try {
    // TODO: Implement get achievements logic
    const achievements = [
      {
        id: 'first-run',
        title: 'First Run',
        description: 'Complete your first run',
        icon: '/icons/first-run.png'
      },
      {
        id: 'distance-warrior',
        title: 'Distance Warrior',
        description: 'Run 100km in total',
        icon: '/icons/distance-warrior.png'
      }
    ];

    res.json({
      message: 'Successfully retrieved achievements',
      achievements
    });
  } catch (error) {
    console.error('Error fetching achievements:', error);
    res.status(500).json({ 
      error: 'Failed to fetch achievements',
      details: error.message 
    });
  }
});

// Get user's achievements
router.get('/user/:userId', authenticateToken, async (req, res) => {
  try {
    const { userId } = req.params;
    // TODO: Implement get user achievements logic
    const userAchievements = [
      {
        id: 'first-run',
        title: 'First Run',
        description: 'Complete your first run',
        icon: '/icons/first-run.png',
        unlockedAt: new Date(),
        progress: 100
      }
    ];

    res.json({
      message: 'Successfully retrieved user achievements',
      achievements: userAchievements
    });
  } catch (error) {
    console.error('Error fetching user achievements:', error);
    res.status(500).json({ 
      error: 'Failed to fetch user achievements',
      details: error.message 
    });
  }
});

module.exports = router;
