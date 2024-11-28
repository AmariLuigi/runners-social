import 'package:json_annotation/json_annotation.dart';
import '../../../../core/services/user_service.dart';

part 'run_session.g.dart';

@JsonSerializable()
class RunSession {
  @JsonKey(name: '_id')
  final String? id;
  final String title;
  final String description;
  final User user;
  final List<Participant> participants;
  final String status;
  final String type;
  final String runStyle;
  final DateTime startTime;
  final DateTime? endTime;
  final DateTime scheduledStart;
  final bool isActive;
  final List<Checkpoint> checkpoints;
  final List<ChatMessage> chat;
  final int maxParticipants;
  final String privacy;
  final List<String> tags;
  final List<RunMetrics> metrics;
  final List<dynamic> photos;
  final List<dynamic> comments;
  final List<dynamic> likes;
  final DateTime createdAt;
  final DateTime updatedAt;

  bool get isParticipant => 
    user.id != null && 
    participants.any((p) => p.user.id == user.id);

  RunSession({
    this.id,
    required this.title,
    required this.description,
    required this.user,
    required this.participants,
    required this.status,
    required this.type,
    required this.runStyle,
    required this.startTime,
    this.endTime,
    required this.scheduledStart,
    this.isActive = false,
    required this.checkpoints,
    required this.chat,
    required this.maxParticipants,
    required this.privacy,
    required this.tags,
    required this.metrics,
    required this.photos,
    required this.comments,
    required this.likes,
    required this.createdAt,
    required this.updatedAt,
  });

  factory RunSession.fromJson(Map<String, dynamic> json) =>
      _$RunSessionFromJson(json);

  Map<String, dynamic> toJson() => _$RunSessionToJson(this);
}

@JsonSerializable()
class User {
  @JsonKey(name: '_id')
  final String id;
  final String username;

  User({
    required this.id,
    required this.username,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}

@JsonSerializable()
class Participant {
  final User user;
  final String role;
  final DateTime joinedAt;
  final String status;
  @JsonKey(name: '_id')
  final String id;

  Participant({
    required this.user,
    required this.role,
    required this.joinedAt,
    required this.status,
    required this.id,
  });

  factory Participant.fromJson(Map<String, dynamic> json) =>
      _$ParticipantFromJson(json);

  Map<String, dynamic> toJson() => _$ParticipantToJson(this);
}

@JsonSerializable()
class Checkpoint {
  final String? id;
  final String name;
  final String? description;
  final RunLocation location;
  final double radius;
  final int order;
  final List<CheckpointProgress> participantProgress;

  Checkpoint({
    this.id,
    required this.name,
    this.description,
    required this.location,
    required this.radius,
    required this.order,
    required this.participantProgress,
  });

  factory Checkpoint.fromJson(Map<String, dynamic> json) =>
      _$CheckpointFromJson(json);

  Map<String, dynamic> toJson() => _$CheckpointToJson(this);
}

@JsonSerializable()
class RunLocation {
  final double latitude;
  final double longitude;

  RunLocation({
    required this.latitude,
    required this.longitude,
  });

  factory RunLocation.fromJson(Map<String, dynamic> json) =>
      _$RunLocationFromJson(json);

  Map<String, dynamic> toJson() => _$RunLocationToJson(this);
}

@JsonSerializable()
class ChatMessage {
  final String? id;
  final String userId;
  final String message;
  final DateTime timestamp;

  ChatMessage({
    this.id,
    required this.userId,
    required this.message,
    required this.timestamp,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) =>
      _$ChatMessageFromJson(json);

  Map<String, dynamic> toJson() => _$ChatMessageToJson(this);
}

@JsonSerializable()
class CheckpointProgress {
  final String userId;
  final DateTime timestamp;
  final bool reached;

  CheckpointProgress({
    required this.userId,
    required this.timestamp,
    required this.reached,
  });

  factory CheckpointProgress.fromJson(Map<String, dynamic> json) =>
      _$CheckpointProgressFromJson(json);

  Map<String, dynamic> toJson() => _$CheckpointProgressToJson(this);
}

@JsonSerializable()
class RunMetrics {
  final String userId;
  final RunLocation? location;
  final double distance;
  final double? averagePace;
  final int? totalTime;

  RunMetrics({
    required this.userId,
    this.location,
    required this.distance,
    this.averagePace,
    this.totalTime,
  });

  factory RunMetrics.fromJson(Map<String, dynamic> json) =>
      _$RunMetricsFromJson(json);

  Map<String, dynamic> toJson() => _$RunMetricsToJson(this);
}
