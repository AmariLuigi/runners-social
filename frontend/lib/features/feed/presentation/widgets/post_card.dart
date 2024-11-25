import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/models/post.dart';
import '../bloc/feed_bloc.dart';
import 'run_data_preview.dart';
import 'post_actions.dart';
import 'post_comments.dart';

class PostCard extends StatelessWidget {
  final Post post;

  const PostCard({
    super.key,
    required this.post,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(post.author.profileImage),
            ),
            title: Text(post.author.name),
            subtitle: Text(
              _formatTimestamp(post.createdAt),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(post.content),
          ),
          if (post.images.isNotEmpty)
            SizedBox(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: post.images.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        post.images[index],
                        fit: BoxFit.cover,
                        width: 200,
                      ),
                    ),
                  );
                },
              ),
            ),
          if (post.runData != null)
            Padding(
              padding: const EdgeInsets.all(16),
              child: RunDataPreview(runData: post.runData!),
            ),
          PostActions(
            post: post,
            onLike: () => context.read<FeedBloc>().add(
                  FeedEvent.likePost(
                    postId: post.id,
                    userId: 'currentUserId', // TODO: Get from auth
                  ),
                ),
            onUnlike: () => context.read<FeedBloc>().add(
                  FeedEvent.unlikePost(
                    postId: post.id,
                    userId: 'currentUserId', // TODO: Get from auth
                  ),
                ),
            onShare: () => context.read<FeedBloc>().add(
                  FeedEvent.sharePost(postId: post.id),
                ),
          ),
          PostComments(
            post: post,
            onAddComment: (content) => context.read<FeedBloc>().add(
                  FeedEvent.addComment(
                    postId: post.id,
                    content: content,
                  ),
                ),
            onDeleteComment: (commentId) => context.read<FeedBloc>().add(
                  FeedEvent.deleteComment(
                    postId: post.id,
                    commentId: commentId,
                  ),
                ),
          ),
        ],
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 7) {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    } else if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}
