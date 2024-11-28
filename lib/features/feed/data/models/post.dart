import 'package:equatable/equatable.dart';
import 'user.dart';
import 'run_data.dart';
import 'comment.dart';

class Post extends Equatable {
  final String id;
  final User user;
  final String content;
  final List<String> images;
  final RunData? runData;
  final List<Comment> comments;
  final int likes;
  final int shares;
  final int shareCount;
  final List<String> likedByUserIds;
  final DateTime createdAt;
  final bool isLiked;

  const Post({
    required this.id,
    required this.user,
    required this.content,
    this.images = const [],
    this.runData,
    this.comments = const [],
    this.likes = 0,
    this.shares = 0,
    this.shareCount = 0,
    this.likedByUserIds = const [],
    required this.createdAt,
    this.isLiked = false,
  });

  Post copyWith({
    String? id,
    User? user,
    String? content,
    List<String>? images,
    RunData? runData,
    List<Comment>? comments,
    int? likes,
    int? shares,
    int? shareCount,
    List<String>? likedByUserIds,
    DateTime? createdAt,
    bool? isLiked,
  }) {
    return Post(
      id: id ?? this.id,
      user: user ?? this.user,
      content: content ?? this.content,
      images: images ?? this.images,
      runData: runData ?? this.runData,
      comments: comments ?? this.comments,
      likes: likes ?? this.likes,
      shares: shares ?? this.shares,
      shareCount: shareCount ?? this.shareCount,
      likedByUserIds: likedByUserIds ?? this.likedByUserIds,
      createdAt: createdAt ?? this.createdAt,
      isLiked: isLiked ?? this.isLiked,
    );
  }

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'] as String,
      user: User.fromJson(json['user'] as Map<String, dynamic>),
      content: json['content'] as String,
      images: (json['images'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
      runData: json['runData'] != null ? RunData.fromJson(json['runData'] as Map<String, dynamic>) : null,
      comments: (json['comments'] as List<dynamic>?)?.map((e) => Comment.fromJson(e as Map<String, dynamic>)).toList() ?? [],
      likes: json['likes'] as int? ?? 0,
      shares: json['shares'] as int? ?? 0,
      shareCount: json['shareCount'] as int? ?? 0,
      likedByUserIds: (json['likedByUserIds'] as List<dynamic>?)?.cast<String>() ?? const [],
      createdAt: DateTime.parse(json['createdAt'] as String),
      isLiked: json['isLiked'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user': user.toJson(),
      'content': content,
      'images': images,
      'runData': runData?.toJson(),
      'comments': comments.map((e) => e.toJson()).toList(),
      'likes': likes,
      'shares': shares,
      'shareCount': shareCount,
      'likedByUserIds': likedByUserIds,
      'createdAt': createdAt.toIso8601String(),
      'isLiked': isLiked,
    };
  }

  @override
  List<Object?> get props => [id, user, content, images, runData, comments, likes, shares, shareCount, likedByUserIds, createdAt, isLiked];

  String get formattedDate {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inDays > 7) {
      return '${createdAt.day}/${createdAt.month}/${createdAt.year}';
    } else if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  bool isLikedByUser(String userId) => likedByUserIds.contains(userId);
}
