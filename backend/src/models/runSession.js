const mongoose = require('mongoose');

const messageSchema = new mongoose.Schema({
  sender: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true
  },
  content: {
    type: String,
    required: true
  },
  timestamp: {
    type: Date,
    default: Date.now
  },
  type: {
    type: String,
    enum: ['text', 'system', 'achievement'],
    default: 'text'
  }
});

const checkpointSchema = new mongoose.Schema({
  name: {
    type: String,
    required: true
  },
  description: String,
  location: {
    type: {
      type: String,
      enum: ['Point'],
      default: 'Point'
    },
    coordinates: {
      type: [Number],
      required: true
    }
  },
  radius: {
    type: Number,
    default: 20 // meters
  },
  order: {
    type: Number,
    required: true
  },
  participantProgress: [{
    user: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User'
    },
    reachedAt: Date
  }]
});

const locationSchema = new mongoose.Schema({
  type: {
    type: String,
    enum: ['Point'],
    default: 'Point'
  },
  coordinates: {
    type: [Number],  // [longitude, latitude]
    required: true
  },
  altitude: {
    type: Number,
    default: 0
  },
  speed: {
    type: Number,
    default: 0
  },
  timestamp: {
    type: Date,
    default: Date.now
  }
});

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
    enum: ['planned', 'active', 'paused', 'completed', 'cancelled'],
    default: 'planned'
  },
  type: {
    type: String,
    enum: ['solo', 'group', 'challenge'],
    default: 'solo'
  },
  runStyle: {
    type: String,
    enum: ['free', 'checkpoint', 'race'],
    default: 'free'
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
    },
    lastLocation: locationSchema,
    isActive: {
      type: Boolean,
      default: true
    }
  }],
  maxParticipants: {
    type: Number,
    default: 1
  },
  chat: [messageSchema],
  checkpoints: [checkpointSchema],
  locationHistory: [locationSchema],
  paceHistory: {
    type: Map,
    of: [{
      pace: Number,
      timestamp: Date
    }]
  },
  currentDistance: {
    type: Map,
    of: Number
  },
  scheduledStart: {
    type: Date
  },
  weather: {
    temperature: Number,
    condition: String,
    windSpeed: Number,
    humidity: Number
  },
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
  }],
  privacy: {
    type: String,
    enum: ['public', 'friends', 'private'],
    default: 'public'
  },
  tags: [String]
}, {
  timestamps: true
});

// Index for geospatial queries on checkpoints
runSessionSchema.index({ 'checkpoints.location': '2dsphere' });

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
