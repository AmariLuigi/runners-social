import 'package:equatable/equatable.dart';
import '../../data/models/run_data.dart';

abstract class FeedEvent extends Equatable {
  const FeedEvent();

  @override
  List<Object?> get props => [];
}

class LoadPostsEvent extends FeedEvent {
  const LoadPostsEvent();
}

class RefreshPostsEvent extends FeedEvent {
  const RefreshPostsEvent();
}

class CreatePostEvent extends FeedEvent {
  final String content;
  final List<String> images;
  final RunData? runData;

  const CreatePostEvent({
    required this.content,
    this.images = const [],
    this.runData,
  });

  @override
  List<Object?> get props => [content, images, runData];
}

class LikePostEvent extends FeedEvent {
  final String postId;
  final String userId;

  const LikePostEvent({
    required this.postId,
    required this.userId,
  });

  @override
  List<Object> get props => [postId, userId];
}

class UnlikePostEvent extends FeedEvent {
  final String postId;
  final String userId;

  const UnlikePostEvent({
    required this.postId,
    required this.userId,
  });

  @override
  List<Object> get props => [postId, userId];
}

class AddCommentEvent extends FeedEvent {
  final String postId;
  final String content;

  const AddCommentEvent({
    required this.postId,
    required this.content,
  });

  @override
  List<Object> get props => [postId, content];
}

class DeleteCommentEvent extends FeedEvent {
  final String postId;
  final String commentId;

  const DeleteCommentEvent({
    required this.postId,
    required this.commentId,
  });

  @override
  List<Object> get props => [postId, commentId];
}

class SharePostEvent extends FeedEvent {
  final String postId;

  const SharePostEvent({required this.postId});

  @override
  List<Object> get props => [postId];
}
