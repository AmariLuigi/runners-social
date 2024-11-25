const express = require('express');
const router = express.Router();
const AnalyticsService = require('../services/analyticsService');
const auth = require('../middleware/auth');

// Get user's statistics
router.get('/stats/:userId', auth, async (req, res) => {
  try {
    const { userId } = req.params;
    const { timeRange } = req.query;

    const stats = await AnalyticsService.getUserStats(userId, timeRange);
    if (!stats) {
      return res.status(404).json({ message: 'Stats not found' });
    }

    res.json(stats);
  } catch (error) {
    console.error('Error fetching user stats:', error);
    res.status(500).json({ message: 'Error fetching user statistics' });
  }
});

// Get user's progress over time
router.get('/progress/:userId', auth, async (req, res) => {
  try {
    const { userId } = req.params;
    const { timeRange } = req.query;

    const progress = await AnalyticsService.getUserProgress(userId, timeRange);
    if (!progress) {
      return res.status(404).json({ message: 'Progress data not found' });
    }

    res.json(progress);
  } catch (error) {
    console.error('Error fetching user progress:', error);
    res.status(500).json({ message: 'Error fetching user progress' });
  }
});

// Get leaderboard
router.get('/leaderboard', auth, async (req, res) => {
  try {
    const { timeRange, category, limit } = req.query;

    const leaderboard = await AnalyticsService.getLeaderboard(
      timeRange,
      category,
      parseInt(limit) || 10
    );

    res.json(leaderboard);
  } catch (error) {
    console.error('Error fetching leaderboard:', error);
    res.status(500).json({ message: 'Error fetching leaderboard' });
  }
});

// Get personal bests
router.get('/personal-bests/:userId', auth, async (req, res) => {
  try {
    const { userId } = req.params;
    const user = await User.findById(userId);
    
    if (!user || !user.stats || !user.stats.personalBests) {
      return res.status(404).json({ message: 'Personal bests not found' });
    }

    res.json(user.stats.personalBests);
  } catch (error) {
    console.error('Error fetching personal bests:', error);
    res.status(500).json({ message: 'Error fetching personal bests' });
  }
});

module.exports = router;
