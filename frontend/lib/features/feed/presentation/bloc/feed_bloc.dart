import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/models/post.dart';
import '../../domain/repositories/feed_repository.dart';

part 'feed_bloc.freezed.dart';
part 'feed_event.dart';
part 'feed_state.dart';

class FeedBloc extends Bloc<FeedEvent, FeedState> {
  final FeedRepository _feedRepository;
  static const int _postsPerPage = 10;

  FeedBloc({required FeedRepository feedRepository})
      : _feedRepository = feedRepository,
        super(const FeedState()) {
    on<FeedEvent>((event, emit) async {
      await event.map(
        loadPosts: (e) => _onLoadPosts(e, emit),
        refreshPosts: (e) => _onRefreshPosts(e, emit),
        createPost: (e) => _onCreatePost(e, emit),
        likePost: (e) => _onLikePost(e, emit),
        unlikePost: (e) => _onUnlikePost(e, emit),
        addComment: (e) => _onAddComment(e, emit),
        deleteComment: (e) => _onDeleteComment(e, emit),
        sharePost: (e) => _onSharePost(e, emit),
      );
    });
  }

  Future<void> _onLoadPosts(_LoadPosts event, Emitter<FeedState> emit) async {
    if (state.isLoading || !state.hasMore) return;

    emit(state.copyWith(isLoading: true));

    final result = await _feedRepository.getFeedPosts(
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

  Future<void> _onRefreshPosts(_RefreshPosts event, Emitter<FeedState> emit) async {
    emit(state.copyWith(isLoading: true, posts: [], currentPage: 0));

    final result = await _feedRepository.getFeedPosts(
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

  Future<void> _onCreatePost(_CreatePost event, Emitter<FeedState> emit) async {
    emit(state.copyWith(isSubmitting: true));

    final result = await _feedRepository.createPost(
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

  Future<void> _onLikePost(_LikePost event, Emitter<FeedState> emit) async {
    final result = await _feedRepository.likePost(event.postId);

    result.fold(
      (failure) => emit(state.copyWith(error: failure.message)),
      (_) {
        final updatedPosts = state.posts.map((post) {
          if (post.id == event.postId) {
            return post.copyWith(
              likes: [...post.likes, event.userId],
            );
          }
          return post;
        }).toList();

        emit(state.copyWith(posts: updatedPosts, error: null));
      },
    );
  }

  Future<void> _onUnlikePost(_UnlikePost event, Emitter<FeedState> emit) async {
    final result = await _feedRepository.unlikePost(event.postId);

    result.fold(
      (failure) => emit(state.copyWith(error: failure.message)),
      (_) {
        final updatedPosts = state.posts.map((post) {
          if (post.id == event.postId) {
            return post.copyWith(
              likes: post.likes.where((id) => id != event.userId).toList(),
            );
          }
          return post;
        }).toList();

        emit(state.copyWith(posts: updatedPosts, error: null));
      },
    );
  }

  Future<void> _onAddComment(_AddComment event, Emitter<FeedState> emit) async {
    final result = await _feedRepository.addComment(
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

  Future<void> _onDeleteComment(_DeleteComment event, Emitter<FeedState> emit) async {
    final result = await _feedRepository.deleteComment(
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

  Future<void> _onSharePost(_SharePost event, Emitter<FeedState> emit) async {
    final result = await _feedRepository.sharePost(event.postId);

    result.fold(
      (failure) => emit(state.copyWith(error: failure.message)),
      (_) {
        final updatedPosts = state.posts.map((post) {
          if (post.id == event.postId) {
            return post.copyWith(
              shareCount: post.shareCount + 1,
            );
          }
          return post;
        }).toList();

        emit(state.copyWith(posts: updatedPosts, error: null));
      },
    );
  }
}
