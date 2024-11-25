const mongoose = require('mongoose');

const groupSchema = new mongoose.Schema({
  name: {
    type: String,
    required: true,
    trim: true,
    minlength: 3
  },
  description: {
    type: String,
    trim: true,
    default: ''
  },
  creator: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true
  },
  members: [{
    user: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User'
    },
    role: {
      type: String,
      enum: ['admin', 'moderator', 'member'],
      default: 'member'
    },
    joinedAt: {
      type: Date,
      default: Date.now
    }
  }],
  settings: {
    privacy: {
      type: String,
      enum: ['public', 'private'],
      default: 'public'
    },
    maxMembers: {
      type: Number,
      default: 50
    },
    allowInvites: {
      type: Boolean,
      default: true
    },
    runningPreferences: {
      difficulty: {
        type: String,
        enum: ['beginner', 'intermediate', 'advanced'],
        default: 'intermediate'
      },
      preferredDistance: {
        type: Number, // in kilometers
        default: 5
      },
      preferredPace: {
        type: Number, // in minutes per kilometer
        default: 6
      }
    }
  },
  location: {
    type: {
      type: String,
      enum: ['Point'],
      default: 'Point'
    },
    coordinates: {
      type: [Number], // [longitude, latitude]
      default: [0, 0]
    },
    city: String,
    country: String
  },
  stats: {
    totalRuns: {
      type: Number,
      default: 0
    },
    totalDistance: {
      type: Number,
      default: 0
    },
    totalDuration: {
      type: Number,
      default: 0
    }
  },
  pendingInvites: [{
    user: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User'
    },
    invitedBy: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User'
    },
    invitedAt: {
      type: Date,
      default: Date.now
    }
  }],
  joinRequests: [{
    user: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User'
    },
    requestedAt: {
      type: Date,
      default: Date.now
    }
  }]
}, {
  timestamps: true
});

// Index for location-based queries
groupSchema.index({ location: '2dsphere' });

// Add creator as first admin member
groupSchema.pre('save', async function(next) {
  if (this.isNew) {
    this.members.push({
      user: this.creator,
      role: 'admin',
      joinedAt: new Date()
    });
  }
  next();
});

const Group = mongoose.model('Group', groupSchema);

module.exports = Group;
