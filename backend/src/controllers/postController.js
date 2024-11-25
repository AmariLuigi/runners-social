const Post = require('../models/post');
const User = require('../models/user');

exports.getFeedPosts = async (req, res) => {
  try {
    const page = parseInt(req.query.page) || 0;
    const limit = parseInt(req.query.limit) || 10;
    const skip = page * limit;

    const user = await User.findById(req.user.userId);
    if (!user) {
      return res.status(404).json({ error: 'User not found' });
    }

    // Get posts from user and their friends
    const feedPosts = await Post.find({
      $or: [
        { author: user._id },
        { author: { $in: user.friends } }
      ]
    })
      .sort({ createdAt: -1 })
      .skip(skip)
      .limit(limit + 1) // Get one extra to check if there are more
      .populate({
        path: 'author',
        select: 'username email profile.firstName profile.lastName profile.profileImage'
      })
      .populate({
        path: 'comments.author',
        select: 'username email profile.firstName profile.lastName profile.profileImage'
      });

    const hasMore = feedPosts.length > limit;
    const posts = hasMore ? feedPosts.slice(0, -1) : feedPosts;

    res.status(200).json({
      posts,
      page,
      limit,
      hasMore
    });
  } catch (error) {
    console.error('Feed error:', error);
    res.status(500).json({
      error: 'Failed to fetch feed',
      details: error.message
    });
  }
};

exports.createPost = async (req, res) => {
  try {
    const { content, images, runData } = req.body;
    const user = await User.findById(req.user.userId);
    
    if (!user) {
      return res.status(404).json({ error: 'User not found' });
    }

    const post = new Post({
      author: user._id,
      content,
      images: images || [],
      runData
    });

    await post.save();

    // Populate author details before sending response
    await post.populate({
      path: 'author',
      select: 'username email profile.firstName profile.lastName profile.profileImage'
    });

    res.status(201).json({
      post,
      message: 'Post created successfully'
    });
  } catch (error) {
    console.error('Create post error:', error);
    res.status(500).json({
      error: 'Failed to create post',
      details: error.message
    });
  }
};

exports.likePost = async (req, res) => {
  try {
    const { postId } = req.params;
    const userId = req.user.userId;

    const post = await Post.findById(postId);
    if (!post) {
      return res.status(404).json({ error: 'Post not found' });
    }

    if (post.likes.includes(userId)) {
      return res.status(400).json({ error: 'Post already liked' });
    }

    post.likes.push(userId);
    await post.save();

    res.status(200).json({
      message: 'Post liked successfully',
      likes: post.likes
    });
  } catch (error) {
    console.error('Like post error:', error);
    res.status(500).json({
      error: 'Failed to like post',
      details: error.message
    });
  }
};

exports.unlikePost = async (req, res) => {
  try {
    const { postId } = req.params;
    const userId = req.user.userId;

    const post = await Post.findById(postId);
    if (!post) {
      return res.status(404).json({ error: 'Post not found' });
    }

    const likeIndex = post.likes.indexOf(userId);
    if (likeIndex === -1) {
      return res.status(400).json({ error: 'Post not liked' });
    }

    post.likes.splice(likeIndex, 1);
    await post.save();

    res.status(200).json({
      message: 'Post unliked successfully',
      likes: post.likes
    });
  } catch (error) {
    console.error('Unlike post error:', error);
    res.status(500).json({
      error: 'Failed to unlike post',
      details: error.message
    });
  }
};

exports.addComment = async (req, res) => {
  try {
    const { postId } = req.params;
    const { content } = req.body;
    const userId = req.user.userId;

    const post = await Post.findById(postId);
    if (!post) {
      return res.status(404).json({ error: 'Post not found' });
    }

    post.comments.push({
      author: userId,
      content
    });

    await post.save();

    // Populate the new comment's author
    await post.populate({
      path: 'comments.author',
      select: 'username email profile.firstName profile.lastName profile.profileImage'
    });

    const newComment = post.comments[post.comments.length - 1];

    res.status(201).json({
      message: 'Comment added successfully',
      comment: newComment
    });
  } catch (error) {
    console.error('Add comment error:', error);
    res.status(500).json({
      error: 'Failed to add comment',
      details: error.message
    });
  }
};

exports.deleteComment = async (req, res) => {
  try {
    const { postId, commentId } = req.params;
    const userId = req.user.userId;

    const post = await Post.findById(postId);
    if (!post) {
      return res.status(404).json({ error: 'Post not found' });
    }

    const comment = post.comments.id(commentId);
    if (!comment) {
      return res.status(404).json({ error: 'Comment not found' });
    }

    if (comment.author.toString() !== userId && post.author.toString() !== userId) {
      return res.status(403).json({ error: 'Not authorized to delete this comment' });
    }

    comment.remove();
    await post.save();

    res.status(200).json({
      message: 'Comment deleted successfully'
    });
  } catch (error) {
    console.error('Delete comment error:', error);
    res.status(500).json({
      error: 'Failed to delete comment',
      details: error.message
    });
  }
};
