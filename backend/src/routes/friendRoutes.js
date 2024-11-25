const express = require('express');
const auth = require('../middleware/auth').auth;
const {
  sendFriendRequest,
  handleFriendRequest,
  getFriends,
  getPendingRequests,
  toggleBlockUser,
  getFriendActivity,
  updateSharedStats,
  getBlockedUsers,
  unblockUser,
  getFriendNotifications,
  getFriendStats,
  getSharedRunHistory
} = require('../controllers/friendController');

const router = express.Router();

// All routes require authentication
router.use(auth);

// Friend management
router.post('/request', sendFriendRequest);
router.post('/handle-request', handleFriendRequest);
router.get('/list', getFriends);
router.get('/pending', getPendingRequests);
router.post('/block', toggleBlockUser);
router.get('/blocked', getBlockedUsers);
router.post('/unblock', unblockUser);

// Friend activity and stats
router.get('/activity', getFriendActivity);
router.post('/stats/update', updateSharedStats);
router.get('/stats/:friendId', getFriendStats);
router.get('/runs/:friendId', getSharedRunHistory);
router.get('/notifications', getFriendNotifications);

module.exports = router;
