const RunSession = require('../models/runSession');
const User = require('../models/user');

const ACHIEVEMENT_TYPES = {
  DISTANCE: {
    BEGINNER: { name: '5K Runner', distance: 5000 },
    INTERMEDIATE: { name: '10K Runner', distance: 10000 },
    ADVANCED: { name: 'Half Marathon', distance: 21097 },
    EXPERT: { name: 'Marathon', distance: 42195 }
  },
  SPEED: {
    FAST: { name: 'Speed Demon', pace: 4.5 }, // minutes per km
    LIGHTNING: { name: 'Lightning Fast', pace: 4.0 }
  },
  CONSISTENCY: {
    REGULAR: { name: 'Regular Runner', runs: 10 },
    DEDICATED: { name: 'Dedicated Runner', runs: 50 },
    ELITE: { name: 'Elite Runner', runs: 100 }
  },
  ELEVATION: {
    HILL_CLIMBER: { name: 'Hill Climber', elevation: 100 },
    MOUNTAIN_GOAT: { name: 'Mountain Goat', elevation: 500 }
  },
  SPECIAL: {
    EARLY_BIRD: { name: 'Early Bird', condition: 'Run before 6 AM' },
    NIGHT_OWL: { name: 'Night Owl', condition: 'Run after 10 PM' },
    SOCIAL_BUTTERFLY: { name: 'Social Butterfly', condition: '5 group runs' }
  }
};

const checkDistanceAchievements = async (userId, totalDistance) => {
  const achievements = [];
  
  Object.values(ACHIEVEMENT_TYPES.DISTANCE).forEach(achievement => {
    if (totalDistance >= achievement.distance) {
      achievements.push(achievement.name);
    }
  });

  return achievements;
};

const checkSpeedAchievements = async (userId, averagePace) => {
  const achievements = [];

  Object.values(ACHIEVEMENT_TYPES.SPEED).forEach(achievement => {
    if (averagePace <= achievement.pace) {
      achievements.push(achievement.name);
    }
  });

  return achievements;
};

const checkConsistencyAchievements = async (userId) => {
  const achievements = [];
  const totalRuns = await RunSession.countDocuments({
    user: userId,
    status: 'completed'
  });

  Object.values(ACHIEVEMENT_TYPES.CONSISTENCY).forEach(achievement => {
    if (totalRuns >= achievement.runs) {
      achievements.push(achievement.name);
    }
  });

  return achievements;
};

const checkElevationAchievements = async (userId, elevationGain) => {
  const achievements = [];

  Object.values(ACHIEVEMENT_TYPES.ELEVATION).forEach(achievement => {
    if (elevationGain >= achievement.elevation) {
      achievements.push(achievement.name);
    }
  });

  return achievements;
};

const checkSpecialAchievements = async (userId, runData) => {
  const achievements = [];
  const runHour = new Date(runData.timestamp).getHours();

  // Early Bird Achievement
  if (runHour < 6) {
    achievements.push(ACHIEVEMENT_TYPES.SPECIAL.EARLY_BIRD.name);
  }

  // Night Owl Achievement
  if (runHour >= 22) {
    achievements.push(ACHIEVEMENT_TYPES.SPECIAL.NIGHT_OWL.name);
  }

  // Social Butterfly Achievement
  const groupRuns = await RunSession.countDocuments({
    user: userId,
    type: 'group',
    status: 'completed'
  });

  if (groupRuns >= 5) {
    achievements.push(ACHIEVEMENT_TYPES.SPECIAL.SOCIAL_BUTTERFLY.name);
  }

  return achievements;
};

const updateAchievements = async (runData) => {
  try {
    const { runId, metrics } = runData;
    const runSession = await RunSession.findById(runId);
    if (!runSession) return;

    const userId = runSession.user;
    const stats = runSession.calculateStatistics();
    if (!stats) return;

    const newAchievements = [
      ...(await checkDistanceAchievements(userId, stats.totalDistance)),
      ...(await checkSpeedAchievements(userId, stats.averagePace)),
      ...(await checkConsistencyAchievements(userId)),
      ...(await checkElevationAchievements(userId, stats.elevationGain)),
      ...(await checkSpecialAchievements(userId, runData))
    ];

    if (newAchievements.length > 0) {
      // Update user's achievements
      await User.findByIdAndUpdate(userId, {
        $addToSet: {
          achievements: {
            $each: newAchievements.map(achievement => ({
              name: achievement,
              earnedAt: new Date(),
              runSession: runId
            }))
          }
        }
      });

      // Emit achievement notifications through Socket.IO if needed
      // This would be implemented in the socket handlers
    }

    return newAchievements;
  } catch (error) {
    console.error('Error updating achievements:', error);
    return [];
  }
};

module.exports = {
  ACHIEVEMENT_TYPES,
  updateAchievements
};
