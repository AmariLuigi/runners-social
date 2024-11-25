const mongoose = require('mongoose');
const bcrypt = require('bcryptjs');

const userSchema = new mongoose.Schema({
  email: {
    type: String,
    required: true,
    unique: true,
    trim: true,
    lowercase: true
  },
  password: {
    type: String,
    required: true,
    minlength: 6
  },
  username: {
    type: String,
    required: true,
    unique: true,
    trim: true,
    minlength: 3
  },
  profile: {
    firstName: String,
    lastName: String,
    bio: String,
    avatar: String,
    location: String,
    preferences: {
      distanceUnit: {
        type: String,
        enum: ['km', 'mi'],
        default: 'km'
      },
      privacyLevel: {
        type: String,
        enum: ['public', 'friends', 'private'],
        default: 'public'
      }
    }
  },
  stats: {
    totalRuns: { type: Number, default: 0 },
    totalDistance: { type: Number, default: 0 },
    totalDuration: { type: Number, default: 0 }
  }
}, {
  timestamps: true
});

// Hash password before saving
userSchema.pre('save', async function(next) {
  const user = this;
  if (user.isModified('password')) {
    user.password = await bcrypt.hash(user.password, 8);
  }
  next();
});

// Method to compare password for login
userSchema.methods.comparePassword = async function(password) {
  return bcrypt.compare(password, this.password);
};

// Remove sensitive information when converting to JSON
userSchema.methods.toJSON = function() {
  const user = this.toObject();
  delete user.password;
  return user;
};

const User = mongoose.model('User', userSchema);

module.exports = User;
