import 'package:flutter/material.dart';
import '../../domain/models/post.dart';

class PostActions extends StatelessWidget {
  final Post post;
  final VoidCallback onLike;
  final VoidCallback onUnlike;
  final VoidCallback onShare;

  const PostActions({
    super.key,
    required this.post,
    required this.onLike,
    required this.onUnlike,
    required this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    const currentUserId = 'currentUserId'; // TODO: Get from auth
    final hasLiked = post.likes.contains(currentUserId);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          IconButton(
            icon: Icon(
              hasLiked ? Icons.favorite : Icons.favorite_border,
              color: hasLiked ? Colors.red : null,
            ),
            onPressed: hasLiked ? onUnlike : onLike,
          ),
          Text(
            '${post.likes.length}',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(width: 16),
          IconButton(
            icon: const Icon(Icons.comment_outlined),
            onPressed: () {
              // TODO: Implement comment focus
            },
          ),
          Text(
            '${post.comments.length}',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(width: 16),
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: onShare,
          ),
          Text(
            '${post.shareCount}',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
