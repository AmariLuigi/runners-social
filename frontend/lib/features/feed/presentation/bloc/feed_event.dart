part of 'feed_bloc.dart';

@freezed
class FeedEvent with _$FeedEvent {
  const factory FeedEvent.loadPosts() = _LoadPosts;
  const factory FeedEvent.refreshPosts() = _RefreshPosts;
  const factory FeedEvent.createPost({
    required String content,
    List<String>? images,
    RunData? runData,
  }) = _CreatePost;
  const factory FeedEvent.likePost({
    required String postId,
    required String userId,
  }) = _LikePost;
  const factory FeedEvent.unlikePost({
    required String postId,
    required String userId,
  }) = _UnlikePost;
  const factory FeedEvent.addComment({
    required String postId,
    required String content,
  }) = _AddComment;
  const factory FeedEvent.deleteComment({
    required String postId,
    required String commentId,
  }) = _DeleteComment;
  const factory FeedEvent.sharePost({
    required String postId,
  }) = _SharePost;
}
