import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/post.dart';
import '../../data/models/comment.dart';
import '../../data/models/run_data.dart';
import '../../domain/repositories/feed_repository.dart';
import 'feed_event.dart';
import 'feed_state.dart';

class FeedBloc extends Bloc<FeedEvent, FeedState> {
  final FeedRepository feedRepository;
  static const int _postsPerPage = 10;

  FeedBloc({required this.feedRepository}) : super(const FeedState()) {
    on<LoadPostsEvent>(_onLoadPosts);
    on<RefreshPostsEvent>(_onRefreshPosts);
    on<CreatePostEvent>(_onCreatePost);
    on<LikePostEvent>(_onLikePost);
    on<UnlikePostEvent>(_onUnlikePost);
    on<AddCommentEvent>(_onAddComment);
    on<DeleteCommentEvent>(_onDeleteComment);
    on<SharePostEvent>(_onSharePost);
  }

  Future<void> _onLoadPosts(LoadPostsEvent event, Emitter<FeedState> emit) async {
    if (state.isLoading || !state.hasMore) return;

    emit(state.copyWith(isLoading: true));

    final result = await feedRepository.getFeedPosts(
      page: state.currentPage,
      limit: _postsPerPage,
    );

    result.fold(
      (failure) => emit(state.copyWith(
        isLoading: false,
        error: failure.message,
      )),
      (posts) => emit(state.copyWith(
        isLoading: false,
        posts: [...state.posts, ...posts],
        currentPage: state.currentPage + 1,
        hasMore: posts.length >= _postsPerPage,
        error: null,
      )),
    );
  }

  Future<void> _onRefreshPosts(RefreshPostsEvent event, Emitter<FeedState> emit) async {
    emit(state.copyWith(isLoading: true, posts: [], currentPage: 0));

    final result = await feedRepository.getFeedPosts(
      page: 0,
      limit: _postsPerPage,
    );

    result.fold(
      (failure) => emit(state.copyWith(
        isLoading: false,
        error: failure.message,
      )),
      (posts) => emit(state.copyWith(
        isLoading: false,
        posts: posts,
        currentPage: 1,
        hasMore: posts.length >= _postsPerPage,
        error: null,
      )),
    );
  }

  Future<void> _onCreatePost(CreatePostEvent event, Emitter<FeedState> emit) async {
    emit(state.copyWith(isSubmitting: true));

    final result = await feedRepository.createPost(
      content: event.content,
      images: event.images,
      runData: event.runData,
    );

    result.fold(
      (failure) => emit(state.copyWith(
        isSubmitting: false,
        error: failure.message,
      )),
      (post) => emit(state.copyWith(
        isSubmitting: false,
        posts: [post, ...state.posts],
        error: null,
      )),
    );
  }

  Future<void> _onLikePost(LikePostEvent event, Emitter<FeedState> emit) async {
    final result = await feedRepository.likePost(event.postId);

    result.fold(
      (failure) => emit(state.copyWith(error: failure.message)),
      (_) {
        final updatedPosts = state.posts.map((post) {
          if (post.id == event.postId) {
            return post.copyWith(
              likedByUserIds: [...post.likedByUserIds, event.userId],
              likes: post.likes + 1,
            );
          }
          return post;
        }).toList();

        emit(state.copyWith(posts: updatedPosts, error: null));
      },
    );
  }

  Future<void> _onUnlikePost(UnlikePostEvent event, Emitter<FeedState> emit) async {
    final result = await feedRepository.unlikePost(event.postId);

    result.fold(
      (failure) => emit(state.copyWith(error: failure.message)),
      (_) {
        final updatedPosts = state.posts.map((post) {
          if (post.id == event.postId) {
            return post.copyWith(
              likedByUserIds: post.likedByUserIds.where((id) => id != event.userId).toList(),
              likes: post.likes - 1,
            );
          }
          return post;
        }).toList();

        emit(state.copyWith(posts: updatedPosts, error: null));
      },
    );
  }

  Future<void> _onAddComment(AddCommentEvent event, Emitter<FeedState> emit) async {
    final result = await feedRepository.addComment(
      postId: event.postId,
      content: event.content,
    );

    result.fold(
      (failure) => emit(state.copyWith(error: failure.message)),
      (comment) {
        final updatedPosts = state.posts.map((post) {
          if (post.id == event.postId) {
            return post.copyWith(
              comments: [...post.comments, comment],
            );
          }
          return post;
        }).toList();

        emit(state.copyWith(posts: updatedPosts, error: null));
      },
    );
  }

  Future<void> _onDeleteComment(DeleteCommentEvent event, Emitter<FeedState> emit) async {
    final result = await feedRepository.deleteComment(
      postId: event.postId,
      commentId: event.commentId,
    );

    result.fold(
      (failure) => emit(state.copyWith(error: failure.message)),
      (_) {
        final updatedPosts = state.posts.map((post) {
          if (post.id == event.postId) {
            return post.copyWith(
              comments: post.comments
                  .where((comment) => comment.id != event.commentId)
                  .toList(),
            );
          }
          return post;
        }).toList();

        emit(state.copyWith(posts: updatedPosts, error: null));
      },
    );
  }

  Future<void> _onSharePost(SharePostEvent event, Emitter<FeedState> emit) async {
    final result = await feedRepository.sharePost(event.postId);

    result.fold(
      (failure) => emit(state.copyWith(error: failure.message)),
      (_) {
        final updatedPosts = state.posts.map((post) {
          if (post.id == event.postId) {
            return post.copyWith(
              shareCount: post.shareCount + 1,
              shares: post.shares + 1,
            );
          }
          return post;
        }).toList();

        emit(state.copyWith(posts: updatedPosts, error: null));
      },
    );
  }
}
