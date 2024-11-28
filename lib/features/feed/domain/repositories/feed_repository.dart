import 'package:dartz/dartz.dart';
import '../../data/models/post.dart';
import '../../data/models/comment.dart';
import '../../data/models/run_data.dart';
import '../../../../core/error/failures.dart';

abstract class FeedRepository {
  Future<Either<Failure, List<Post>>> getFeedPosts({
    required int page,
    required int limit,
  });

  Future<Either<Failure, Post>> createPost({
    required String content,
    required List<String> images,
    RunData? runData,
  });

  Future<Either<Failure, void>> likePost(String postId);
  Future<Either<Failure, void>> unlikePost(String postId);

  Future<Either<Failure, Comment>> addComment({
    required String postId,
    required String content,
  });

  Future<Either<Failure, void>> deleteComment({
    required String postId,
    required String commentId,
  });

  Future<Either<Failure, void>> sharePost(String postId);
}
