const mongoose = require('mongoose');

const runSessionSchema = new mongoose.Schema({
  user: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true
  },
  title: {
    type: String,
    required: true
  },
  description: String,
  startTime: {
    type: Date,
    default: Date.now
  },
  endTime: Date,
  status: {
    type: String,
    enum: ['active', 'paused', 'completed', 'cancelled'],
    default: 'active'
  },
  type: {
    type: String,
    enum: ['solo', 'group', 'challenge'],
    default: 'solo'
  },
  participants: [{
    user: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User'
    },
    role: {
      type: String,
      enum: ['host', 'participant'],
      default: 'participant'
    },
    joinedAt: {
      type: Date,
      default: Date.now
    }
  }],
  locationHistory: [{
    coordinates: {
      type: [Number], // [longitude, latitude]
      required: true
    },
    timestamp: {
      type: Date,
      default: Date.now
    }
  }],
  metrics: [{
    distance: Number, // in meters
    duration: Number, // in seconds
    pace: Number, // in minutes per kilometer
    speed: Number, // in kilometers per hour
    calories: Number,
    elevation: Number, // in meters
    heartRate: Number, // beats per minute
    timestamp: {
      type: Date,
      default: Date.now
    }
  }],
  finalMetrics: {
    totalDistance: Number,
    totalDuration: Number,
    averagePace: Number,
    averageSpeed: Number,
    totalCalories: Number,
    elevationGain: Number,
    averageHeartRate: Number
  },
  weather: {
    temperature: Number,
    condition: String,
    humidity: Number,
    windSpeed: Number
  },
  route: {
    name: String,
    difficulty: {
      type: String,
      enum: ['easy', 'moderate', 'hard', 'extreme']
    },
    terrain: {
      type: String,
      enum: ['road', 'trail', 'track', 'mixed']
    }
  },
  chat: [{
    sender: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User',
      required: true
    },
    message: {
      type: String,
      required: true
    },
    timestamp: {
      type: Date,
      default: Date.now
    }
  }],
  privacy: {
    type: String,
    enum: ['public', 'friends', 'private'],
    default: 'public'
  },
  tags: [String],
  photos: [{
    url: String,
    caption: String,
    location: {
      type: [Number], // [longitude, latitude]
    },
    timestamp: {
      type: Date,
      default: Date.now
    }
  }],
  comments: [{
    user: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User'
    },
    text: String,
    timestamp: {
      type: Date,
      default: Date.now
    }
  }],
  likes: [{
    user: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User'
    },
    timestamp: {
      type: Date,
      default: Date.now
    }
  }]
}, {
  timestamps: true
});

// Indexes for better query performance
runSessionSchema.index({ user: 1, startTime: -1 });
runSessionSchema.index({ status: 1 });
runSessionSchema.index({ 'participants.user': 1 });
runSessionSchema.index({ privacy: 1 });
runSessionSchema.index({ tags: 1 });

// Virtual for calculating current pace
runSessionSchema.virtual('currentPace').get(function() {
  if (this.metrics && this.metrics.length > 0) {
    return this.metrics[this.metrics.length - 1].pace;
  }
  return 0;
});

// Method to calculate session statistics
runSessionSchema.methods.calculateStatistics = function() {
  if (!this.metrics || this.metrics.length === 0) return null;

  const stats = {
    totalDistance: 0,
    totalDuration: 0,
    averagePace: 0,
    averageSpeed: 0,
    totalCalories: 0,
    elevationGain: 0,
    averageHeartRate: 0
  };

  let heartRateReadings = 0;

  this.metrics.forEach(metric => {
    stats.totalDistance += metric.distance || 0;
    stats.totalDuration += metric.duration || 0;
    stats.totalCalories += metric.calories || 0;
    if (metric.elevation > 0) stats.elevationGain += metric.elevation;
    if (metric.heartRate) {
      stats.averageHeartRate += metric.heartRate;
      heartRateReadings++;
    }
  });

  if (stats.totalDuration > 0) {
    stats.averageSpeed = (stats.totalDistance / 1000) / (stats.totalDuration / 3600);
    stats.averagePace = stats.totalDuration / (stats.totalDistance / 1000) / 60;
  }

  if (heartRateReadings > 0) {
    stats.averageHeartRate = stats.averageHeartRate / heartRateReadings;
  }

  return stats;
};

const RunSession = mongoose.model('RunSession', runSessionSchema);

module.exports = RunSession;
