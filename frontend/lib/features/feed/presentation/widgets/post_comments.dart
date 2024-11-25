import 'package:flutter/material.dart';
import '../../domain/models/post.dart';

class PostComments extends StatelessWidget {
  final Post post;
  final Function(String) onAddComment;
  final Function(String) onDeleteComment;

  const PostComments({
    super.key,
    required this.post,
    required this.onAddComment,
    required this.onDeleteComment,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (post.comments.isNotEmpty) ...[
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              'Comments',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: post.comments.length,
            itemBuilder: (context, index) {
              final comment = post.comments[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(comment.author.profileImage),
                ),
                title: Row(
                  children: [
                    Text(
                      comment.author.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      comment.content,
                      style: const TextStyle(fontWeight: FontWeight.normal),
                    ),
                  ],
                ),
                subtitle: Text(
                  _formatTimestamp(comment.createdAt),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                trailing: comment.author.id == 'currentUserId' // TODO: Get from auth
                    ? IconButton(
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () => onDeleteComment(comment.id),
                      )
                    : null,
              );
            },
          ),
        ],
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: 'Add a comment...',
                    border: OutlineInputBorder(),
                  ),
                  onSubmitted: (value) {
                    if (value.isNotEmpty) {
                      onAddComment(value);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ],
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
