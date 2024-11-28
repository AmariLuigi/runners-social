import 'package:json_annotation/json_annotation.dart';

enum RunType {
  solo,
  group
}

enum RunStatus {
  planned,
  active,
  completed,
  cancelled
}

extension RunStatusExtension on RunStatus {
  String toJson() => toString().split('.').last;
  
  static RunStatus fromJson(String json) {
    return RunStatus.values.firstWhere(
      (e) => e.toString().split('.').last == json,
      orElse: () => RunStatus.planned,
    );
  }
}

extension RunTypeExtension on RunType {
  String toJson() => toString().split('.').last;
  
  static RunType fromJson(String json) {
    return RunType.values.firstWhere(
      (e) => e.toString().split('.').last == json,
      orElse: () => RunType.solo,
    );
  }
}

class Participant {
  final String id;
  final String username;
  final String role;
  final bool isActive;

  Participant({
    required this.id,
    required this.username,
    required this.role,
    required this.isActive,
  });

  factory Participant.fromJson(Map<String, dynamic> json) {
    return Participant(
      id: json['user']['_id'].toString(),
      username: json['user']['username'].toString(),
      role: json['role'].toString(),
      isActive: json['isActive'] as bool? ?? true,
    );
  }
}

class Run {
  final String id;
  final String name;
  final String description;
  final DateTime startTime;
  final String status;
  final String type;
  final String privacy;
  final String style;
  final List<Participant> participants;
  final double? plannedDistance;
  final List<RoutePoint>? routePoints;
  final String? meetingPoint;

  Run({
    required this.id,
    required this.name,
    required this.description,
    required this.startTime,
    required this.status,
    required this.type,
    required this.privacy,
    required this.style,
    required this.participants,
    this.plannedDistance,
    this.routePoints,
    this.meetingPoint,
  });

  factory Run.fromJson(Map<String, dynamic> json) {
    return Run(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      startTime: DateTime.parse(json['startTime'] ?? DateTime.now().toIso8601String()),
      status: json['status'] ?? 'pending',
      type: json['type'] ?? 'solo',
      privacy: json['privacy'] ?? 'public',
      style: json['style'] ?? 'free',
      participants: (json['participants'] as List<dynamic>? ?? [])
          .map((p) => Participant.fromJson(p))
          .toList(),
      plannedDistance: json['plannedDistance']?.toDouble(),
      routePoints: (json['routePoints'] as List<dynamic>?)
          ?.map((p) => RoutePoint.fromJson(p))
          .toList(),
      meetingPoint: json['meetingPoint'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'description': description,
      'startTime': startTime.toIso8601String(),
      'status': status,
      'type': type,
      'privacy': privacy,
      'style': style,
      'participants': participants.map((p) => {
        'user': {
          '_id': p.id,
          'username': p.username,
        },
        'role': p.role,
        'isActive': p.isActive,
      }).toList(),
      if (plannedDistance != null) 'plannedDistance': plannedDistance,
      if (routePoints != null) 'routePoints': routePoints!.map((p) => p.toJson()).toList(),
      if (meetingPoint != null) 'meetingPoint': meetingPoint,
    };
  }

  bool get canJoin => !participants.any((p) => p.id == 'currentUserId') && 
      status == 'planned' && 
      (type == 'solo' || 
       participants.length < 1);

  bool get isParticipant => 
    participants.any((p) => p.id == 'currentUserId');

  Run copyWith({
    String? id,
    String? name,
    String? description,
    DateTime? startTime,
    String? status,
    String? type,
    String? privacy,
    String? style,
    List<Participant>? participants,
    double? plannedDistance,
    List<RoutePoint>? routePoints,
    String? meetingPoint,
  }) {
    return Run(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      startTime: startTime ?? this.startTime,
      status: status ?? this.status,
      type: type ?? this.type,
      privacy: privacy ?? this.privacy,
      style: style ?? this.style,
      participants: participants ?? this.participants,
      plannedDistance: plannedDistance ?? this.plannedDistance,
      routePoints: routePoints ?? this.routePoints,
      meetingPoint: meetingPoint ?? this.meetingPoint,
    );
  }
}

class RoutePoint {
  final double latitude;
  final double longitude;
  final int order;

  RoutePoint({
    required this.latitude,
    required this.longitude,
    required this.order,
  });

  factory RoutePoint.fromJson(Map<String, dynamic> json) {
    return RoutePoint(
      latitude: json['latitude']?.toDouble() ?? 0.0,
      longitude: json['longitude']?.toDouble() ?? 0.0,
      order: json['order'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'order': order,
    };
  }
}

extension RunX on Run {
  bool get canJoin => !participants.any((p) => p.id == 'currentUserId') && 
      status == 'planned' && 
      (type == 'solo' || 
       participants.length < 1);
}
