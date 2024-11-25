const express = require('express');
const { auth } = require('../middleware/auth');
const {
  createGroup,
  getGroups,
  getGroup,
  updateGroup,
  joinGroup,
  leaveGroup,
  inviteToGroup,
  handleJoinRequest,
  updateMemberRole
} = require('../controllers/groupController');

const router = express.Router();

// All routes require authentication
router.use(auth);

// Group management
router.post('/', createGroup);
router.get('/', getGroups);
router.get('/:id', getGroup);
router.patch('/:id', updateGroup);

// Membership management
router.post('/:id/join', joinGroup);
router.post('/:id/leave', leaveGroup);
router.post('/:id/invite', inviteToGroup);
router.post('/:id/handle-request', handleJoinRequest);
router.patch('/:id/member-role', updateMemberRole);

module.exports = router;
