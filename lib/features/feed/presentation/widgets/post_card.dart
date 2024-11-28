import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/post.dart';
import '../bloc/feed_bloc.dart';
import '../bloc/feed_event.dart';

class PostCard extends StatelessWidget {
  final Post post;

  const PostCard({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(post.user.avatarUrl),
            ),
            title: Text(post.user.name),
            subtitle: Text(post.formattedDate),
          ),
          if (post.content.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(post.content),
            ),
          if (post.images.isNotEmpty)
            SizedBox(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: post.images.length,
                itemBuilder: (context, index) {
                  return Image.network(
                    post.images[index],
                    fit: BoxFit.cover,
                  );
                },
              ),
            ),
          ButtonBar(
            alignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton.icon(
                onPressed: () {
                  if (post.isLiked) {
                    context.read<FeedBloc>().add(
                          UnlikePostEvent(
                            postId: post.id,
                            userId: post.user.id,
                          ),
                        );
                  } else {
                    context.read<FeedBloc>().add(
                          LikePostEvent(
                            postId: post.id,
                            userId: post.user.id,
                          ),
                        );
                  }
                },
                icon: Icon(
                  post.isLiked ? Icons.favorite : Icons.favorite_border,
                  color: post.isLiked ? Colors.red : null,
                ),
                label: Text('${post.likes} Likes'),
              ),
              TextButton.icon(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AddCommentDialog(
                      onSubmit: (content) {
                        context.read<FeedBloc>().add(
                              AddCommentEvent(
                                postId: post.id,
                                content: content,
                              ),
                            );
                      },
                    ),
                  );
                },
                icon: const Icon(Icons.comment),
                label: Text('${post.comments.length} Comments'),
              ),
              TextButton.icon(
                onPressed: () {
                  context.read<FeedBloc>().add(SharePostEvent(postId: post.id));
                },
                icon: const Icon(Icons.share),
                label: Text('${post.shares} Shares'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class AddCommentDialog extends StatefulWidget {
  final Function(String) onSubmit;

  const AddCommentDialog({Key? key, required this.onSubmit}) : super(key: key);

  @override
  _AddCommentDialogState createState() => _AddCommentDialogState();
}

class _AddCommentDialogState extends State<AddCommentDialog> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Comment'),
      content: TextField(
        controller: _controller,
        decoration: const InputDecoration(
          hintText: 'Write your comment...',
        ),
        maxLines: 3,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            if (_controller.text.isNotEmpty) {
              widget.onSubmit(_controller.text);
              Navigator.pop(context);
            }
          },
          child: const Text('Submit'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
