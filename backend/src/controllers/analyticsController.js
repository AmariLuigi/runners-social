const AnalyticsService = require('../services/analyticsService');
const AchievementService = require('../services/achievementService');
const RunSession = require('../models/runSession');

exports.getUserStats = async (req, res) => {
  try {
    const { timeframe } = req.query;
    const stats = await AnalyticsService.calculateUserStats(req.user.id, timeframe);
    res.json(stats);
  } catch (error) {
    console.error('Error getting user stats:', error);
    res.status(500).json({ message: 'Failed to retrieve user statistics' });
  }
};

exports.getRunAnalysis = async (req, res) => {
  try {
    const runSession = await RunSession.findById(req.params.runId);
    if (!runSession) {
      return res.status(404).json({ message: 'Run session not found' });
    }

    // Calculate achievements
    const achievements = await AchievementService.calculateAchievements(runSession, req.user.id);
    
    // Get run stats
    const stats = runSession.calculateStats();
    
    // Get performance insights
    const insights = await AnalyticsService.calculatePerformanceInsights([runSession]);

    res.json({
      runId: runSession._id,
      achievements,
      stats,
      insights
    });
  } catch (error) {
    console.error('Error analyzing run:', error);
    res.status(500).json({ message: 'Failed to analyze run session' });
  }
};

exports.getWeeklyProgress = async (req, res) => {
  try {
    const stats = await AnalyticsService.calculateUserStats(req.user.id, 'week');
    res.json(stats.weeklyProgress);
  } catch (error) {
    console.error('Error getting weekly progress:', error);
    res.status(500).json({ message: 'Failed to retrieve weekly progress' });
  }
};

exports.getPaceAnalysis = async (req, res) => {
  try {
    const stats = await AnalyticsService.calculateUserStats(req.user.id, 'month');
    res.json({
      paceProgress: stats.paceProgress,
      consistencyScore: stats.consistencyScore
    });
  } catch (error) {
    console.error('Error getting pace analysis:', error);
    res.status(500).json({ message: 'Failed to analyze pace' });
  }
};

exports.getIntensityDistribution = async (req, res) => {
  try {
    const stats = await AnalyticsService.calculateUserStats(req.user.id, 'month');
    res.json(stats.intensityDistribution);
  } catch (error) {
    console.error('Error getting intensity distribution:', error);
    res.status(500).json({ message: 'Failed to retrieve intensity distribution' });
  }
};
