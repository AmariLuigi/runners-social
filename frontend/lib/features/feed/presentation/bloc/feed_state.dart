part of 'feed_bloc.dart';

@freezed
class FeedState with _$FeedState {
  const factory FeedState({
    @Default([]) List<Post> posts,
    @Default(false) bool isLoading,
    @Default(false) bool isSubmitting,
    @Default(true) bool hasMore,
    @Default(0) int currentPage,
    String? error,
  }) = _FeedState;
}
