import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String name;
  final String email;
  final String avatarUrl;
  final String? bio;
  final List<String> followers;
  final List<String> following;
  final int totalRuns;
  final double totalDistance;
  final Duration totalDuration;

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.avatarUrl,
    this.bio,
    this.followers = const [],
    this.following = const [],
    this.totalRuns = 0,
    this.totalDistance = 0,
    this.totalDuration = const Duration(),
  });

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? avatarUrl,
    String? bio,
    List<String>? followers,
    List<String>? following,
    int? totalRuns,
    double? totalDistance,
    Duration? totalDuration,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      bio: bio ?? this.bio,
      followers: followers ?? this.followers,
      following: following ?? this.following,
      totalRuns: totalRuns ?? this.totalRuns,
      totalDistance: totalDistance ?? this.totalDistance,
      totalDuration: totalDuration ?? this.totalDuration,
    );
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      avatarUrl: json['avatarUrl'] as String,
      bio: json['bio'] as String?,
      followers: (json['followers'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
      following: (json['following'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
      totalRuns: json['totalRuns'] as int? ?? 0,
      totalDistance: (json['totalDistance'] as num?)?.toDouble() ?? 0,
      totalDuration: Duration(seconds: json['totalDuration'] as int? ?? 0),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'avatarUrl': avatarUrl,
      'bio': bio,
      'followers': followers,
      'following': following,
      'totalRuns': totalRuns,
      'totalDistance': totalDistance,
      'totalDuration': totalDuration.inSeconds,
    };
  }

  @override
  List<Object?> get props => [
    id,
    name,
    email,
    avatarUrl,
    bio,
    followers,
    following,
    totalRuns,
    totalDistance,
    totalDuration,
  ];

  String get formattedTotalDistance {
    return '${totalDistance.toStringAsFixed(1)} km';
  }

  String get formattedTotalDuration {
    final hours = totalDuration.inHours;
    final minutes = totalDuration.inMinutes.remainder(60);
    
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }
}
