// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PostImpl _$$PostImplFromJson(Map<String, dynamic> json) => _$PostImpl(
      id: json['id'] as String,
      author: User.fromJson(json['author'] as Map<String, dynamic>),
      content: json['content'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      images:
          (json['images'] as List<dynamic>).map((e) => e as String).toList(),
      runData: json['runData'] == null
          ? null
          : RunData.fromJson(json['runData'] as Map<String, dynamic>),
      comments: (json['comments'] as List<dynamic>?)
              ?.map((e) => Comment.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      likes:
          (json['likes'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
      shareCount: (json['shareCount'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$PostImplToJson(_$PostImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'author': _userToJson(instance.author),
      'content': instance.content,
      'createdAt': instance.createdAt.toIso8601String(),
      'images': instance.images,
      'runData': instance.runData,
      'comments': instance.comments,
      'likes': instance.likes,
      'shareCount': instance.shareCount,
    };

_$RunDataImpl _$$RunDataImplFromJson(Map<String, dynamic> json) =>
    _$RunDataImpl(
      distance: (json['distance'] as num).toDouble(),
      duration: Duration(microseconds: (json['duration'] as num).toInt()),
      averagePace: (json['averagePace'] as num).toDouble(),
      route: (json['route'] as List<dynamic>)
          .map((e) => LatLng.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$RunDataImplToJson(_$RunDataImpl instance) =>
    <String, dynamic>{
      'distance': instance.distance,
      'duration': instance.duration.inMicroseconds,
      'averagePace': instance.averagePace,
      'route': instance.route,
    };

_$CommentImpl _$$CommentImplFromJson(Map<String, dynamic> json) =>
    _$CommentImpl(
      id: json['id'] as String,
      author: User.fromJson(json['author'] as Map<String, dynamic>),
      content: json['content'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$CommentImplToJson(_$CommentImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'author': _userToJson(instance.author),
      'content': instance.content,
      'createdAt': instance.createdAt.toIso8601String(),
    };

_$LatLngImpl _$$LatLngImplFromJson(Map<String, dynamic> json) => _$LatLngImpl(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );

Map<String, dynamic> _$$LatLngImplToJson(_$LatLngImpl instance) =>
    <String, dynamic>{
      'latitude': instance.latitude,
      'longitude': instance.longitude,
    };
