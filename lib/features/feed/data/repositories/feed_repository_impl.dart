import 'dart:convert';
import 'dart:developer' as developer;
import 'package:dartz/dartz.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../../../../core/error/failures.dart';
import '../models/post.dart';
import '../models/comment.dart';
import '../models/run_data.dart';
import '../../domain/repositories/feed_repository.dart';

class FeedRepositoryImpl implements FeedRepository {
  final http.Client _client;
  final FlutterSecureStorage _storage;
  final String _baseUrl;

  FeedRepositoryImpl({
    required http.Client client,
    required FlutterSecureStorage storage,
    required String baseUrl,
  })  : _client = client,
        _storage = storage,
        _baseUrl = baseUrl;

  @override
  Future<Either<Failure, List<Post>>> getFeedPosts({
    required int page,
    required int limit,
  }) async {
    try {
      final token = await _storage.read(key: 'token');
      if (token == null) {
        return Left(AuthenticationFailure('No token found'));
      }

      final response = await _client.get(
        Uri.parse('$_baseUrl/api/feed?page=$page&limit=$limit'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      developer.log('Feed response: ${response.body}', name: 'Feed');

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final data = responseData['posts'] as List<dynamic>? ?? 
                    responseData as List<dynamic>? ?? 
                    [];
        
        final posts = data.map((post) {
          try {
            return Post.fromJson(post as Map<String, dynamic>);
          } catch (e, stackTrace) {
            developer.log(
              'Error parsing post: $e\nPost data: $post',
              name: 'Feed',
              error: e,
              stackTrace: stackTrace,
            );
            rethrow;
          }
        }).toList();
        
        return Right(posts);
      } else {
        final error = json.decode(response.body);
        return Left(ServerFailure(
          error['message'] ?? error['error'] ?? 'Failed to get feed posts',
        ));
      }
    } catch (e, stackTrace) {
      developer.log(
        'Feed error: $e',
        name: 'Feed',
        error: e,
        stackTrace: stackTrace,
      );
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Post>> createPost({
    required String content,
    List<String>? images,
    RunData? runData,
  }) async {
    try {
      final token = await _storage.read(key: 'token');
      if (token == null) {
        return Left(AuthenticationFailure('No token found'));
      }

      final response = await _client.post(
        Uri.parse('$_baseUrl/api/feed/posts'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'content': content,
          if (images != null) 'images': images,
          if (runData != null) 'runData': runData.toJson(),
        }),
      );

      developer.log('Create post response: ${response.body}', name: 'Feed');

      if (response.statusCode == 201) {
        final responseData = json.decode(response.body);
        final post = Post.fromJson(responseData['post'] as Map<String, dynamic>? ?? 
                                 responseData as Map<String, dynamic>);
        return Right(post);
      } else {
        final error = json.decode(response.body);
        return Left(ServerFailure(
          error['message'] ?? error['error'] ?? 'Failed to create post',
        ));
      }
    } catch (e, stackTrace) {
      developer.log(
        'Create post error: $e',
        name: 'Feed',
        error: e,
        stackTrace: stackTrace,
      );
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> likePost(String postId) async {
    try {
      final token = await _storage.read(key: 'token');
      if (token == null) {
        return Left(AuthenticationFailure('No token found'));
      }

      final response = await _client.post(
        Uri.parse('$_baseUrl/api/feed/posts/$postId/like'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return const Right(null);
      } else {
        final error = json.decode(response.body);
        return Left(ServerFailure(
          error['message'] ?? error['error'] ?? 'Failed to like post',
        ));
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> unlikePost(String postId) async {
    try {
      final token = await _storage.read(key: 'token');
      if (token == null) {
        return Left(AuthenticationFailure('No token found'));
      }

      final response = await _client.delete(
        Uri.parse('$_baseUrl/api/feed/posts/$postId/like'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return const Right(null);
      } else {
        final error = json.decode(response.body);
        return Left(ServerFailure(
          error['message'] ?? error['error'] ?? 'Failed to unlike post',
        ));
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deletePost(String postId) async {
    try {
      final token = await _storage.read(key: 'token');
      if (token == null) {
        return Left(AuthenticationFailure('No token found'));
      }

      final response = await _client.delete(
        Uri.parse('$_baseUrl/api/feed/posts/$postId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return const Right(null);
      } else {
        final error = json.decode(response.body);
        return Left(ServerFailure(
          error['message'] ?? error['error'] ?? 'Failed to delete post',
        ));
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Comment>> addComment({
    required String postId,
    required String content,
  }) async {
    try {
      final token = await _storage.read(key: 'token');
      if (token == null) {
        return Left(AuthenticationFailure('No token found'));
      }

      final response = await _client.post(
        Uri.parse('$_baseUrl/api/feed/posts/$postId/comments'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'content': content,
        }),
      );

      if (response.statusCode == 201) {
        final comment = Comment.fromJson(json.decode(response.body));
        return Right(comment);
      } else {
        final error = json.decode(response.body);
        return Left(ServerFailure(
          error['message'] ?? error['error'] ?? 'Failed to add comment',
        ));
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteComment({
    required String postId,
    required String commentId,
  }) async {
    try {
      final token = await _storage.read(key: 'token');
      if (token == null) {
        return Left(AuthenticationFailure('No token found'));
      }

      final response = await _client.delete(
        Uri.parse('$_baseUrl/api/feed/posts/$postId/comments/$commentId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return const Right(null);
      } else {
        final error = json.decode(response.body);
        return Left(ServerFailure(
          error['message'] ?? error['error'] ?? 'Failed to delete comment',
        ));
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> sharePost(String postId) async {
    try {
      final token = await _storage.read(key: 'token');
      if (token == null) {
        return Left(AuthenticationFailure('No token found'));
      }

      final response = await _client.post(
        Uri.parse('$_baseUrl/api/feed/posts/$postId/share'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return const Right(null);
      } else {
        final error = json.decode(response.body);
        return Left(ServerFailure(
          error['message'] ?? error['error'] ?? 'Failed to share post',
        ));
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
