import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../auth/domain/models/user.dart';

part 'post.freezed.dart';
part 'post.g.dart';

@freezed
class Post with _$Post {
  const factory Post({
    required String id,
    required User author,
    required String content,
    required DateTime createdAt,
    required List<String> images,
    required RunData? runData,
    @Default([]) List<Comment> comments,
    @Default([]) List<String> likes,
    @Default(0) int shareCount,
  }) = _Post;

  factory Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);
}

@freezed
class RunData with _$RunData {
  const factory RunData({
    required double distance,
    required Duration duration,
    required double averagePace,
    required List<LatLng> route,
  }) = _RunData;

  factory RunData.fromJson(Map<String, dynamic> json) => _$RunDataFromJson(json);
}

@freezed
class Comment with _$Comment {
  const factory Comment({
    required String id,
    required User author,
    required String content,
    required DateTime createdAt,
  }) = _Comment;

  factory Comment.fromJson(Map<String, dynamic> json) => _$CommentFromJson(json);
}

@freezed
class LatLng with _$LatLng {
  const factory LatLng({
    required double latitude,
    required double longitude,
  }) = _LatLng;

  factory LatLng.fromJson(Map<String, dynamic> json) => _$LatLngFromJson(json);
}
