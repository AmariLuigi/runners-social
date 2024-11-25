const mongoose = require('mongoose');

const friendshipSchema = new mongoose.Schema({
  requester: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true
  },
  recipient: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true
  },
  status: {
    type: String,
    enum: ['pending', 'accepted', 'declined', 'blocked'],
    default: 'pending'
  },
  blockedBy: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User'
  },
  lastInteraction: {
    type: Date,
    default: Date.now
  },
  sharedStats: {
    runsCompleted: {
      type: Number,
      default: 0
    },
    distanceCovered: {
      type: Number,
      default: 0
    },
    timeSpentTogether: {
      type: Number,
      default: 0 // in minutes
    },
    lastRunTogether: Date,
    averagePace: {
      type: Number,
      default: 0 // minutes per kilometer
    },
    longestRun: {
      distance: { type: Number, default: 0 },
      date: Date
    },
    fastestPace: {
      pace: { type: Number, default: 0 },
      date: Date,
      distance: Number
    },
    weeklyStats: {
      runs: { type: Number, default: 0 },
      distance: { type: Number, default: 0 },
      duration: { type: Number, default: 0 }
    },
    monthlyStats: {
      runs: { type: Number, default: 0 },
      distance: { type: Number, default: 0 },
      duration: { type: Number, default: 0 }
    }
  }
}, {
  timestamps: true
});

// Ensure unique friendships
friendshipSchema.index({ requester: 1, recipient: 1 }, { unique: true });
friendshipSchema.index({ status: 1 });

// Prevent self-friendship
friendshipSchema.pre('save', function(next) {
  if (this.requester.equals(this.recipient)) {
    next(new Error('Cannot befriend yourself'));
  }
  next();
});

// Method to check if users are friends
friendshipSchema.statics.areFriends = async function(user1Id, user2Id) {
  const friendship = await this.findOne({
    $or: [
      { requester: user1Id, recipient: user2Id },
      { requester: user2Id, recipient: user1Id }
    ],
    status: 'accepted'
  });
  return !!friendship;
};

// Method to get friendship status
friendshipSchema.statics.getFriendshipStatus = async function(user1Id, user2Id) {
  const friendship = await this.findOne({
    $or: [
      { requester: user1Id, recipient: user2Id },
      { requester: user2Id, recipient: user1Id }
    ]
  });
  return friendship ? friendship.status : null;
};

// Method to update shared stats
friendshipSchema.methods.updateSharedStats = async function(runSession) {
  if (!runSession || !runSession.stats) return;

  const { actualDistance, duration } = runSession.stats;
  const pace = duration > 0 ? duration / actualDistance : 0;

  // Update basic stats
  this.sharedStats.runsCompleted += 1;
  this.sharedStats.distanceCovered += actualDistance;
  this.sharedStats.timeSpentTogether += duration;
  this.sharedStats.lastRunTogether = new Date();
  
  // Update average pace
  this.sharedStats.averagePace = (
    (this.sharedStats.averagePace * (this.sharedStats.runsCompleted - 1) + pace) / 
    this.sharedStats.runsCompleted
  );

  // Update longest run
  if (actualDistance > this.sharedStats.longestRun.distance) {
    this.sharedStats.longestRun = {
      distance: actualDistance,
      date: new Date()
    };
  }

  // Update fastest pace
  if (pace > 0 && (!this.sharedStats.fastestPace.pace || pace < this.sharedStats.fastestPace.pace)) {
    this.sharedStats.fastestPace = {
      pace,
      date: new Date(),
      distance: actualDistance
    };
  }

  // Update weekly stats
  const now = new Date();
  const weekStart = new Date(now.getFullYear(), now.getMonth(), now.getDate() - now.getDay());
  if (runSession.startTime >= weekStart) {
    this.sharedStats.weeklyStats.runs += 1;
    this.sharedStats.weeklyStats.distance += actualDistance;
    this.sharedStats.weeklyStats.duration += duration;
  }

  // Update monthly stats
  const monthStart = new Date(now.getFullYear(), now.getMonth(), 1);
  if (runSession.startTime >= monthStart) {
    this.sharedStats.monthlyStats.runs += 1;
    this.sharedStats.monthlyStats.distance += actualDistance;
    this.sharedStats.monthlyStats.duration += duration;
  }

  await this.save();
};

const Friendship = mongoose.model('Friendship', friendshipSchema);

module.exports = Friendship;
