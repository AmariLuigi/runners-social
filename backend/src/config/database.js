const mongoose = require('mongoose');

const connectDB = async () => {
  try {
    // Development local database
    const uri = 'mongodb://localhost:27017/runners_social';
    await mongoose.connect(uri, {
      useNewUrlParser: true,
      useUnifiedTopology: true,
    });
    console.log('Connected to local MongoDB');
    
    // List all collections
    const collections = await mongoose.connection.db.listCollections().toArray();
    console.log('Available collections:', collections.map(c => c.name));
    
    // Count users
    const userCount = await mongoose.connection.db.collection('users').countDocuments();
    console.log('Number of users in database:', userCount);
  } catch (error) {
    console.error('MongoDB connection error:', error);
    process.exit(1);
  }
};

const disconnectDB = async () => {
  try {
    await mongoose.disconnect();
  } catch (error) {
    console.error('MongoDB disconnection error:', error);
  }
};

module.exports = { connectDB, disconnectDB };
