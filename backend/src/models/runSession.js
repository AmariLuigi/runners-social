const mongoose = require('mongoose');

const locationPointSchema = new mongoose.Schema({
  type: {
    type: String,
    enum: ['Point'],
    default: 'Point'
  },
  coordinates: {
    type: [Number], // [longitude, latitude]
    required: true
  },
  timestamp: {
    type: Date,
    default: Date.now
  },
  elevation: Number,
  speed: Number // in meters per second
}, { _id: false });

const participantSchema = new mongoose.Schema({
  user: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true
  },
  role: {
    type: String,
    enum: ['leader', 'participant'],
    default: 'participant'
  },
  joinedAt: {
    type: Date,
    default: Date.now
  },
  status: {
    type: String,
    enum: ['active', 'paused', 'finished', 'dropped'],
    default: 'active'
  },
  currentLocation: locationPointSchema,
  route: [locationPointSchema],
  stats: {
    distance: {
      type: Number,
      default: 0 // in meters
    },
    duration: {
      type: Number,
      default: 0 // in seconds
    },
    averageSpeed: {
      type: Number,
      default: 0 // in meters per second
    },
    currentSpeed: {
      type: Number,
      default: 0 // in meters per second
    },
    elevationGain: {
      type: Number,
      default: 0 // in meters
    }
  }
}, { _id: false });

const runSessionSchema = new mongoose.Schema({
  title: {
    type: String,
    required: true
  },
  description: String,
  group: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Group'
  },
  status: {
    type: String,
    enum: ['scheduled', 'active', 'paused', 'completed', 'cancelled'],
    default: 'scheduled'
  },
  type: {
    type: String,
    enum: ['casual', 'training', 'race', 'social'],
    default: 'casual'
  },
  startTime: {
    type: Date,
    required: true
  },
  plannedDistance: {
    type: Number, // in kilometers
    required: true
  },
  participants: [participantSchema],
  stats: {
    actualDistance: {
      type: Number,
      default: 0 // in kilometers
    },
    duration: {
      type: Number,
      default: 0 // in minutes
    },
    averagePace: {
      type: Number,
      default: 0 // in minutes per kilometer
    }
  }
}, {
  timestamps: true
});

// Indexes for efficient queries
runSessionSchema.index({ group: 1, status: 1 });
runSessionSchema.index({ 'startTime': 1 });
runSessionSchema.index({ 'participants.user': 1 });

// Update stats when participant joins/leaves
runSessionSchema.pre('save', function(next) {
  if (this.isModified('participants')) {
    this.stats.participantCount = this.participants.filter(
      p => p.status === 'active'
    ).length;
  }
  next();
});

// Virtual for checking if session is active
runSessionSchema.virtual('isActive').get(function() {
  return this.status === 'active';
});

// Method to calculate session statistics
runSessionSchema.methods.calculateStats = function() {
  const activeParticipants = this.participants.filter(p => p.status === 'active');
  
  if (activeParticipants.length === 0) return;

  // Calculate averages across all active participants
  const totals = activeParticipants.reduce((acc, p) => {
    return {
      distance: acc.distance + p.stats.distance,
      speed: acc.speed + p.stats.averageSpeed,
      elevation: acc.elevation + p.stats.elevationGain
    };
  }, { distance: 0, speed: 0, elevation: 0 });

  const count = activeParticipants.length;
  
  this.stats.actualDistance = totals.distance / count / 1000; // Convert meters to kilometers
  this.stats.averageSpeed = totals.speed / count;
  this.stats.totalElevationGain = totals.elevation / count;
  
  if (this.stats.averageSpeed > 0) {
    this.stats.averagePace = 16.6667 / this.stats.averageSpeed; // Convert m/s to min/km
  }
};

const RunSession = mongoose.model('RunSession', runSessionSchema);

module.exports = RunSession;
