import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/feed_bloc.dart';
import '../widgets/post_card.dart';
import '../widgets/create_post_button.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../../domain/repositories/feed_repository.dart';
import '../../../../main.dart';

@RoutePage()
class FeedPage extends StatelessWidget {
  const FeedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FeedBloc(
        feedRepository: getIt<FeedRepository>(),
      )..add(const FeedEvent.loadPosts()),
      child: const FeedView(),
    );
  }
}

class FeedView extends StatefulWidget {
  const FeedView({super.key});

  @override
  State<FeedView> createState() => _FeedViewState();
}

class _FeedViewState extends State<FeedView> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<FeedBloc>().add(const FeedEvent.loadPosts());
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<FeedBloc>().add(const FeedEvent.refreshPosts());
        },
        child: BlocBuilder<FeedBloc, FeedState>(
          builder: (context, state) {
            if (state.error != null) {
              return ErrorView(
                message: state.error!,
                onRetry: () => context.read<FeedBloc>().add(
                  const FeedEvent.refreshPosts(),
                ),
              );
            }

            if (state.posts.isEmpty && state.isLoading) {
              return const Center(child: LoadingIndicator());
            }

            return CustomScrollView(
              controller: _scrollController,
              slivers: [
                const SliverAppBar(
                  title: Text('Feed'),
                  floating: true,
                  centerTitle: true,
                ),
                const SliverToBoxAdapter(
                  child: CreatePostButton(),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      if (index >= state.posts.length) {
                        return state.hasMore
                            ? const Padding(
                                padding: EdgeInsets.symmetric(vertical: 16),
                                child: Center(child: LoadingIndicator()),
                              )
                            : const SizedBox();
                      }

                      final post = state.posts[index];
                      return PostCard(post: post);
                    },
                    childCount: state.posts.length + (state.hasMore ? 1 : 0),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
