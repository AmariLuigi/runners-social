const express = require('express');
const auth = require('../middleware/auth').auth;
const {
  createSession,
  getGroupSessions,
  getSession,
  joinSession,
  updateSessionStatus,
  updateParticipantStatus,
  updateParticipantLocation
} = require('../controllers/runSessionController');

const router = express.Router();

// All routes require authentication
router.use(auth);

// Session management
router.post('/', createSession);
router.get('/group/:groupId', getGroupSessions);
router.get('/:id', getSession);
router.post('/:id/join', joinSession);

// Session control
router.patch('/:id/status', updateSessionStatus);
router.patch('/:id/participant-status', updateParticipantStatus);
router.post('/:id/location', updateParticipantLocation);

module.exports = router;
