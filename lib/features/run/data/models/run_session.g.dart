// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'run_session.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RunSession _$RunSessionFromJson(Map<String, dynamic> json) => RunSession(
      id: json['_id'] as String?,
      title: json['title'] as String,
      description: json['description'] as String,
      user: User.fromJson(json['user'] as Map<String, dynamic>),
      participants: (json['participants'] as List<dynamic>)
          .map((e) => Participant.fromJson(e as Map<String, dynamic>))
          .toList(),
      status: json['status'] as String,
      type: json['type'] as String,
      runStyle: json['runStyle'] as String,
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: json['endTime'] == null
          ? null
          : DateTime.parse(json['endTime'] as String),
      scheduledStart: DateTime.parse(json['scheduledStart'] as String),
      isActive: json['isActive'] as bool? ?? false,
      checkpoints: (json['checkpoints'] as List<dynamic>)
          .map((e) => Checkpoint.fromJson(e as Map<String, dynamic>))
          .toList(),
      chat: (json['chat'] as List<dynamic>)
          .map((e) => ChatMessage.fromJson(e as Map<String, dynamic>))
          .toList(),
      maxParticipants: (json['maxParticipants'] as num).toInt(),
      privacy: json['privacy'] as String,
      tags: (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
      metrics: (json['metrics'] as List<dynamic>)
          .map((e) => RunMetrics.fromJson(e as Map<String, dynamic>))
          .toList(),
      photos: json['photos'] as List<dynamic>,
      comments: json['comments'] as List<dynamic>,
      likes: json['likes'] as List<dynamic>,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$RunSessionToJson(RunSession instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'user': instance.user,
      'participants': instance.participants,
      'status': instance.status,
      'type': instance.type,
      'runStyle': instance.runStyle,
      'startTime': instance.startTime.toIso8601String(),
      'endTime': instance.endTime?.toIso8601String(),
      'scheduledStart': instance.scheduledStart.toIso8601String(),
      'isActive': instance.isActive,
      'checkpoints': instance.checkpoints,
      'chat': instance.chat,
      'maxParticipants': instance.maxParticipants,
      'privacy': instance.privacy,
      'tags': instance.tags,
      'metrics': instance.metrics,
      'photos': instance.photos,
      'comments': instance.comments,
      'likes': instance.likes,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

User _$UserFromJson(Map<String, dynamic> json) => User(
      id: json['_id'] as String,
      username: json['username'] as String,
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      '_id': instance.id,
      'username': instance.username,
    };

Participant _$ParticipantFromJson(Map<String, dynamic> json) => Participant(
      user: User.fromJson(json['user'] as Map<String, dynamic>),
      role: json['role'] as String,
      joinedAt: DateTime.parse(json['joinedAt'] as String),
      status: json['status'] as String,
      id: json['_id'] as String,
    );

Map<String, dynamic> _$ParticipantToJson(Participant instance) =>
    <String, dynamic>{
      'user': instance.user,
      'role': instance.role,
      'joinedAt': instance.joinedAt.toIso8601String(),
      'status': instance.status,
      '_id': instance.id,
    };

Checkpoint _$CheckpointFromJson(Map<String, dynamic> json) => Checkpoint(
      id: json['id'] as String?,
      name: json['name'] as String,
      description: json['description'] as String?,
      location: RunLocation.fromJson(json['location'] as Map<String, dynamic>),
      radius: (json['radius'] as num).toDouble(),
      order: (json['order'] as num).toInt(),
      participantProgress: (json['participantProgress'] as List<dynamic>)
          .map((e) => CheckpointProgress.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CheckpointToJson(Checkpoint instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'location': instance.location,
      'radius': instance.radius,
      'order': instance.order,
      'participantProgress': instance.participantProgress,
    };

RunLocation _$RunLocationFromJson(Map<String, dynamic> json) => RunLocation(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );

Map<String, dynamic> _$RunLocationToJson(RunLocation instance) =>
    <String, dynamic>{
      'latitude': instance.latitude,
      'longitude': instance.longitude,
    };

ChatMessage _$ChatMessageFromJson(Map<String, dynamic> json) => ChatMessage(
      id: json['id'] as String?,
      userId: json['userId'] as String,
      message: json['message'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );

Map<String, dynamic> _$ChatMessageToJson(ChatMessage instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'message': instance.message,
      'timestamp': instance.timestamp.toIso8601String(),
    };

CheckpointProgress _$CheckpointProgressFromJson(Map<String, dynamic> json) =>
    CheckpointProgress(
      userId: json['userId'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      reached: json['reached'] as bool,
    );

Map<String, dynamic> _$CheckpointProgressToJson(CheckpointProgress instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'timestamp': instance.timestamp.toIso8601String(),
      'reached': instance.reached,
    };

RunMetrics _$RunMetricsFromJson(Map<String, dynamic> json) => RunMetrics(
      userId: json['userId'] as String,
      location: json['location'] == null
          ? null
          : RunLocation.fromJson(json['location'] as Map<String, dynamic>),
      distance: (json['distance'] as num).toDouble(),
      averagePace: (json['averagePace'] as num?)?.toDouble(),
      totalTime: (json['totalTime'] as num?)?.toInt(),
    );

Map<String, dynamic> _$RunMetricsToJson(RunMetrics instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'location': instance.location,
      'distance': instance.distance,
      'averagePace': instance.averagePace,
      'totalTime': instance.totalTime,
    };
