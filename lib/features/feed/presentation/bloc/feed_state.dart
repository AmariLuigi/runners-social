import 'package:equatable/equatable.dart';
import '../../data/models/post.dart';

class FeedState extends Equatable {
  final List<Post> posts;
  final bool isLoading;
  final bool isSubmitting;
  final bool hasMore;
  final int currentPage;
  final String? error;

  const FeedState({
    this.posts = const [],
    this.isLoading = false,
    this.isSubmitting = false,
    this.hasMore = true,
    this.currentPage = 0,
    this.error,
  });

  FeedState copyWith({
    List<Post>? posts,
    bool? isLoading,
    bool? isSubmitting,
    bool? hasMore,
    int? currentPage,
    String? error,
  }) {
    return FeedState(
      posts: posts ?? this.posts,
      isLoading: isLoading ?? this.isLoading,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      hasMore: hasMore ?? this.hasMore,
      currentPage: currentPage ?? this.currentPage,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [
        posts,
        isLoading,
        isSubmitting,
        hasMore,
        currentPage,
        error,
      ];
}
