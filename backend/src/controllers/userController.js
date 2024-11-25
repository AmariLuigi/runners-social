const User = require('../models/user');
const { generateToken } = require('../middleware/auth');

// Register new user
const register = async (req, res) => {
  try {
    const { email, password, username } = req.body;

    // Check if user already exists
    const existingUser = await User.findOne({
      $or: [{ email }, { username }]
    });

    if (existingUser) {
      return res.status(400).json({
        error: 'User already exists with this email or username'
      });
    }

    const user = new User({
      email,
      password,
      username,
      profile: {
        firstName: req.body.firstName,
        lastName: req.body.lastName
      }
    });

    await user.save();
    const token = generateToken(user._id);

    res.status(201).json({ user, token });
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
};

// Login user
const login = async (req, res) => {
  try {
    const { email, password } = req.body;
    const user = await User.findOne({ email });

    if (!user || !(await user.comparePassword(password))) {
      return res.status(401).json({ error: 'Invalid credentials' });
    }

    const token = generateToken(user._id);
    res.json({ user, token });
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
};

// Get user profile
const getProfile = async (req, res) => {
  try {
    res.json(req.user);
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
};

// Update user profile
const updateProfile = async (req, res) => {
  const updates = Object.keys(req.body);
  const allowedUpdates = [
    'username',
    'profile.firstName',
    'profile.lastName',
    'profile.bio',
    'profile.location',
    'profile.preferences.distanceUnit',
    'profile.preferences.privacyLevel'
  ];

  const isValidOperation = updates.every(update => 
    allowedUpdates.includes(update)
  );

  if (!isValidOperation) {
    return res.status(400).json({ error: 'Invalid updates' });
  }

  try {
    updates.forEach(update => {
      if (update.includes('.')) {
        const [key, subKey, subSubKey] = update.split('.');
        if (subSubKey) {
          req.user[key][subKey][subSubKey] = req.body[update];
        } else {
          req.user[key][subKey] = req.body[update];
        }
      } else {
        req.user[update] = req.body[update];
      }
    });

    await req.user.save();
    res.json(req.user);
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
};

module.exports = {
  register,
  login,
  getProfile,
  updateProfile
};
