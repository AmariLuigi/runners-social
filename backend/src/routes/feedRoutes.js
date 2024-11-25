const express = require('express');
const router = express.Router();
const { authenticateToken } = require('../middleware/auth');
const postController = require('../controllers/postController');

// Get feed posts
router.get('/', authenticateToken, postController.getFeedPosts);

// Create a new post
router.post('/posts', authenticateToken, postController.createPost);

// Like a post
router.post('/posts/:postId/like', authenticateToken, postController.likePost);

// Unlike a post
router.delete('/posts/:postId/like', authenticateToken, postController.unlikePost);

// Add a comment to a post
router.post('/posts/:postId/comments', authenticateToken, postController.addComment);

// Delete a comment from a post
router.delete('/posts/:postId/comments/:commentId', authenticateToken, postController.deleteComment);

module.exports = router;
