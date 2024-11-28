import 'package:json_annotation/json_annotation.dart';

enum RunType {
  @JsonValue('solo')
  solo,
  @JsonValue('group')
  group
}

enum RunStatus {
  @JsonValue('planned')
  planned,
  @JsonValue('active')
  active,
  @JsonValue('paused')
  paused,
  @JsonValue('completed')
  completed,
  @JsonValue('cancelled')
  cancelled
}

class Run {
  final String id;
  final String name;
  final RunType type;
  final RunStatus status;
  final DateTime startTime;
  final String? description;
  final String? runStyle;
  final int? maxParticipants;
  final String privacy;
  final List<String> participants;
  final List<dynamic> chat;
  final List<dynamic> checkpoints;
  final List<dynamic> metrics;
  final List<dynamic> photos;
  final List<dynamic> comments;
  final List<dynamic> likes;
  final bool isParticipant;

  Run({
    required this.id,
    required this.name,
    required this.type,
    required this.status,
    required this.startTime,
    this.description,
    this.runStyle,
    this.maxParticipants,
    this.privacy = 'public',
    this.participants = const [],
    this.chat = const [],
    this.checkpoints = const [],
    this.metrics = const [],
    this.photos = const [],
    this.comments = const [],
    this.likes = const [],
    this.isParticipant = false,
  });

  factory Run.fromJson(Map<String, dynamic> json) {
    try {
      // Handle nested participants data with different structures
      final participantsList = (json['participants'] as List<dynamic>?)?.map((p) {
        if (p['user'] is Map<String, dynamic>) {
          return p['user']['_id'].toString();
        } else if (p['user'] is String) {
          return p['user'].toString();
        }
        return '';
      }).where((id) => id.isNotEmpty).toList() ?? [];

      return Run(
        id: json['_id']?.toString() ?? '',
        name: json['title']?.toString() ?? '',
        type: RunType.values.firstWhere(
          (e) => e.toString().split('.').last.toLowerCase() == (json['type'] as String?)?.toLowerCase(),
          orElse: () => RunType.solo,
        ),
        status: RunStatus.values.firstWhere(
          (e) => e.toString().split('.').last.toLowerCase() == (json['status'] as String?)?.toLowerCase(),
          orElse: () => RunStatus.planned,
        ),
        startTime: json['startTime'] != null 
          ? DateTime.parse(json['startTime'] as String)
          : DateTime.now(),
        description: json['description'] as String? ?? '',
        runStyle: json['runStyle'] as String? ?? 'free',
        maxParticipants: json['maxParticipants'] as int? ?? 1,
        privacy: json['privacy'] as String? ?? 'public',
        participants: participantsList,
        chat: json['chat'] as List<dynamic>? ?? [],
        checkpoints: json['checkpoints'] as List<dynamic>? ?? [],
        metrics: json['metrics'] as List<dynamic>? ?? [],
        photos: json['photos'] as List<dynamic>? ?? [],
        comments: json['comments'] as List<dynamic>? ?? [],
        likes: json['likes'] as List<dynamic>? ?? [],
        isParticipant: participantsList.contains(json['currentUserId']),
      );
    } catch (e) {
      print('Error parsing run JSON: $e');
      print('Problematic JSON: $json');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': name,
      'type': type.toString().split('.').last,
      'status': status.toString().split('.').last,
      'startTime': startTime.toIso8601String(),
      'description': description,
      'runStyle': runStyle,
      'maxParticipants': maxParticipants,
      'privacy': privacy,
      'participants': participants,
      'chat': chat,
      'checkpoints': checkpoints,
      'metrics': metrics,
      'photos': photos,
      'comments': comments,
      'likes': likes,
    };
  }

  bool get canJoin => !isParticipant && 
      status == RunStatus.planned && 
      (type == RunType.solo || 
       maxParticipants == null || 
       participants.length < maxParticipants!);

  Run copyWith({
    String? id,
    String? name,
    RunType? type,
    RunStatus? status,
    DateTime? startTime,
    String? description,
    String? runStyle,
    int? maxParticipants,
    String? privacy,
    List<String>? participants,
    List<dynamic>? chat,
    List<dynamic>? checkpoints,
    List<dynamic>? metrics,
    List<dynamic>? photos,
    List<dynamic>? comments,
    List<dynamic>? likes,
    bool? isParticipant,
  }) {
    return Run(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      status: status ?? this.status,
      startTime: startTime ?? this.startTime,
      description: description ?? this.description,
      runStyle: runStyle ?? this.runStyle,
      maxParticipants: maxParticipants ?? this.maxParticipants,
      privacy: privacy ?? this.privacy,
      participants: participants ?? this.participants,
      chat: chat ?? this.chat,
      checkpoints: checkpoints ?? this.checkpoints,
      metrics: metrics ?? this.metrics,
      photos: photos ?? this.photos,
      comments: comments ?? this.comments,
      likes: likes ?? this.likes,
      isParticipant: isParticipant ?? this.isParticipant,
    );
  }
}

extension RunX on Run {
  bool get canJoin => !isParticipant && 
      status == RunStatus.planned && 
      (type == RunType.solo || 
       maxParticipants == null || 
       participants.length < maxParticipants!);
}
