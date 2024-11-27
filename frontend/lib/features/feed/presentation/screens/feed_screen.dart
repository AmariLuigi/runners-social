import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../bloc/feed_bloc.dart';
import '../bloc/feed_event.dart';
import '../bloc/feed_state.dart';
import '../../data/repositories/feed_repository_impl.dart';
import '../widgets/post_card.dart';
import '../widgets/create_post_dialog.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FeedBloc(
        feedRepository: FeedRepositoryImpl(
          client: http.Client(),
          storage: const FlutterSecureStorage(),
          baseUrl: 'http://localhost:8080', // TODO: Get from config
        ),
      )..add(const LoadPostsEvent()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Feed'),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () => context.read<FeedBloc>().add(
                    const RefreshPostsEvent(),
                  ),
            ),
          ],
        ),
        body: BlocConsumer<FeedBloc, FeedState>(
          listener: (context, state) {
            if (state.error != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.error!),
                  backgroundColor: Theme.of(context).colorScheme.error,
                ),
              );
            }
          },
          builder: (context, state) {
            if (state.isLoading && state.posts.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            return RefreshIndicator(
              onRefresh: () async {
                context.read<FeedBloc>().add(const RefreshPostsEvent());
              },
              child: ListView.builder(
                itemCount: state.posts.length + (state.hasMore ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == state.posts.length) {
                    if (!state.isLoading) {
                      context.read<FeedBloc>().add(const LoadPostsEvent());
                    }
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  return PostCard(post: state.posts[index]);
                },
              ),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final result = await showDialog<CreatePostResult>(
              context: context,
              builder: (context) => const CreatePostDialog(),
            );

            if (result != null) {
              if (!context.mounted) return;
              context.read<FeedBloc>().add(
                    CreatePostEvent(
                      content: result.content,
                      images: result.images,
                      runData: result.runData,
                    ),
                  );
            }
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
