import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/feed_bloc.dart';
import 'create_post_dialog.dart';

class CreatePostButton extends StatelessWidget {
  const CreatePostButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        child: InkWell(
          onTap: () => _showCreatePostDialog(context),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: const AssetImage('assets/images/default_avatar.png'),
                ),
                const SizedBox(width: 16),
                Text(
                  'Share your run...',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).textTheme.bodySmall?.color,
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showCreatePostDialog(BuildContext context) async {
    final result = await showDialog<CreatePostResult>(
      context: context,
      builder: (context) => const CreatePostDialog(),
    );

    if (result != null) {
      if (context.mounted) {
        context.read<FeedBloc>().add(
              FeedEvent.createPost(
                content: result.content,
                images: result.images,
                runData: result.runData,
              ),
            );
      }
    }
  }
}
