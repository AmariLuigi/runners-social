const RunSession = require('../models/runSession');
const User = require('../models/user');

class AnalyticsService {
  static async updateAnalytics(runData) {
    try {
      const { runId } = runData;
      const runSession = await RunSession.findById(runId);
      if (!runSession) return null;

      const stats = runSession.calculateStatistics();
      if (!stats) return null;

      await this.updateUserStats(runSession.user, stats);
      return stats;
    } catch (error) {
      console.error('Error updating analytics:', error);
      return null;
    }
  }

  static async getUserStats(userId, timeRange = 'all') {
    try {
      const query = { user: userId, status: 'completed' };

      if (timeRange !== 'all') {
        const startDate = this.getStartDateForTimeRange(timeRange);
        query.endTime = { $gte: startDate };
      }

      const runs = await RunSession.find(query);
      
      return this.calculateAggregateStats(runs);
    } catch (error) {
      console.error('Error getting user stats:', error);
      return null;
    }
  }

  static async getLeaderboard(timeRange = 'weekly', category = 'distance', limit = 10) {
    try {
      const startDate = this.getStartDateForTimeRange(timeRange);
      
      const runs = await RunSession.find({
        status: 'completed',
        endTime: { $gte: startDate }
      }).populate('user', 'name profileImage');

      const userStats = {};

      // Aggregate stats by user
      runs.forEach(run => {
        const stats = run.calculateStatistics();
        if (!stats) return;

        if (!userStats[run.user._id]) {
          userStats[run.user._id] = {
            user: {
              _id: run.user._id,
              name: run.user.name,
              profileImage: run.user.profileImage
            },
            totalDistance: 0,
            totalDuration: 0,
            totalRuns: 0,
            averagePace: 0,
            totalCalories: 0,
            elevationGain: 0
          };
        }

        const userStat = userStats[run.user._id];
        userStat.totalDistance += stats.totalDistance;
        userStat.totalDuration += stats.totalDuration;
        userStat.totalRuns += 1;
        userStat.totalCalories += stats.totalCalories;
        userStat.elevationGain += stats.elevationGain;
      });

      // Calculate averages and sort by category
      const leaderboard = Object.values(userStats)
        .map(stat => ({
          ...stat,
          averagePace: stat.totalDistance > 0 ? 
            stat.totalDuration / (stat.totalDistance / 1000) / 60 : 0
        }))
        .sort((a, b) => {
          switch (category) {
            case 'distance':
              return b.totalDistance - a.totalDistance;
            case 'duration':
              return b.totalDuration - a.totalDuration;
            case 'runs':
              return b.totalRuns - a.totalRuns;
            case 'pace':
              return a.averagePace - b.averagePace;
            case 'calories':
              return b.totalCalories - a.totalCalories;
            case 'elevation':
              return b.elevationGain - a.elevationGain;
            default:
              return b.totalDistance - a.totalDistance;
          }
        })
        .slice(0, limit);

      return leaderboard;
    } catch (error) {
      console.error('Error getting leaderboard:', error);
      return [];
    }
  }

  static async getUserProgress(userId, timeRange = 'monthly') {
    try {
      const startDate = this.getStartDateForTimeRange(timeRange);
      const runs = await RunSession.find({
        user: userId,
        status: 'completed',
        endTime: { $gte: startDate }
      }).sort('endTime');

      return this.calculateProgressStats(runs, timeRange);
    } catch (error) {
      console.error('Error getting user progress:', error);
      return null;
    }
  }

  static async updateUserStats(userId, runStats) {
    try {
      const user = await User.findById(userId);
      if (!user) return;

      const stats = user.stats || {};
      
      // Update lifetime stats
      stats.totalDistance = (stats.totalDistance || 0) + runStats.totalDistance;
      stats.totalDuration = (stats.totalDuration || 0) + runStats.totalDuration;
      stats.totalRuns = (stats.totalRuns || 0) + 1;
      stats.totalCalories = (stats.totalCalories || 0) + runStats.totalCalories;
      stats.elevationGain = (stats.elevationGain || 0) + runStats.elevationGain;

      // Update average pace
      stats.averagePace = stats.totalDistance > 0 ? 
        stats.totalDuration / (stats.totalDistance / 1000) / 60 : 0;

      // Update personal bests
      if (!stats.personalBests) {
        stats.personalBests = {};
      }

      if (!stats.personalBests.fastestPace || runStats.averagePace < stats.personalBests.fastestPace) {
        stats.personalBests.fastestPace = runStats.averagePace;
      }

      if (!stats.personalBests.longestDistance || runStats.totalDistance > stats.personalBests.longestDistance) {
        stats.personalBests.longestDistance = runStats.totalDistance;
      }

      if (!stats.personalBests.longestDuration || runStats.totalDuration > stats.personalBests.longestDuration) {
        stats.personalBests.longestDuration = runStats.totalDuration;
      }

      await User.findByIdAndUpdate(userId, { stats });
    } catch (error) {
      console.error('Error updating user stats:', error);
    }
  }

  static getStartDateForTimeRange(timeRange) {
    const now = new Date();
    switch (timeRange) {
      case 'daily':
        return new Date(now.setHours(0, 0, 0, 0));
      case 'weekly':
        return new Date(now.setDate(now.getDate() - 7));
      case 'monthly':
        return new Date(now.setMonth(now.getMonth() - 1));
      case 'yearly':
        return new Date(now.setFullYear(now.getFullYear() - 1));
      default:
        return new Date(0);
    }
  }

  static calculateAggregateStats(runs) {
    const stats = {
      totalDistance: 0,
      totalDuration: 0,
      totalRuns: runs.length,
      averagePace: 0,
      totalCalories: 0,
      elevationGain: 0,
      averageHeartRate: 0,
      heartRateReadings: 0
    };

    runs.forEach(run => {
      const runStats = run.calculateStatistics();
      if (!runStats) return;

      stats.totalDistance += runStats.totalDistance;
      stats.totalDuration += runStats.totalDuration;
      stats.totalCalories += runStats.totalCalories;
      stats.elevationGain += runStats.elevationGain;
      
      if (runStats.averageHeartRate) {
        stats.averageHeartRate += runStats.averageHeartRate;
        stats.heartRateReadings++;
      }
    });

    if (stats.totalDistance > 0) {
      stats.averagePace = stats.totalDuration / (stats.totalDistance / 1000) / 60;
    }

    if (stats.heartRateReadings > 0) {
      stats.averageHeartRate = stats.averageHeartRate / stats.heartRateReadings;
    }

    return stats;
  }

  static calculateProgressStats(runs, timeRange) {
    const progressData = [];
    const intervalMap = {
      daily: { unit: 'hour', count: 24 },
      weekly: { unit: 'day', count: 7 },
      monthly: { unit: 'day', count: 30 },
      yearly: { unit: 'month', count: 12 }
    };

    const interval = intervalMap[timeRange] || intervalMap.monthly;
    const now = new Date();

    // Initialize intervals
    for (let i = 0; i < interval.count; i++) {
      const date = new Date(now);
      switch (interval.unit) {
        case 'hour':
          date.setHours(now.getHours() - i);
          break;
        case 'day':
          date.setDate(now.getDate() - i);
          break;
        case 'month':
          date.setMonth(now.getMonth() - i);
          break;
      }

      progressData.push({
        date,
        distance: 0,
        duration: 0,
        calories: 0
      });
    }

    // Aggregate run data into intervals
    runs.forEach(run => {
      const stats = run.calculateStatistics();
      if (!stats) return;

      const runDate = new Date(run.endTime);
      const intervalIndex = progressData.findIndex(interval => {
        switch (interval.unit) {
          case 'hour':
            return runDate.getHours() === interval.date.getHours();
          case 'day':
            return runDate.getDate() === interval.date.getDate();
          case 'month':
            return runDate.getMonth() === interval.date.getMonth();
        }
      });

      if (intervalIndex !== -1) {
        progressData[intervalIndex].distance += stats.totalDistance;
        progressData[intervalIndex].duration += stats.totalDuration;
        progressData[intervalIndex].calories += stats.totalCalories;
      }
    });

    return progressData;
  }
}

module.exports = AnalyticsService;
