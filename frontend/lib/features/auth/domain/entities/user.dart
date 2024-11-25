import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String email;
  final String username;
  final String? profileImageUrl;
  final String? bio;
  final DateTime createdAt;
  final List<String> following;
  final List<String> followers;
  final Map<String, dynamic> preferences;
  final Map<String, dynamic> stats;

  const User({
    required this.id,
    required this.email,
    required this.username,
    this.profileImageUrl,
    this.bio,
    required this.createdAt,
    required this.following,
    required this.followers,
    required this.preferences,
    required this.stats,
  });

  User copyWith({
    String? id,
    String? email,
    String? username,
    String? profileImageUrl,
    String? bio,
    DateTime? createdAt,
    List<String>? following,
    List<String>? followers,
    Map<String, dynamic>? preferences,
    Map<String, dynamic>? stats,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      username: username ?? this.username,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      bio: bio ?? this.bio,
      createdAt: createdAt ?? this.createdAt,
      following: following ?? this.following,
      followers: followers ?? this.followers,
      preferences: preferences ?? this.preferences,
      stats: stats ?? this.stats,
    );
  }

  @override
  List<Object?> get props => [
        id,
        email,
        username,
        profileImageUrl,
        bio,
        createdAt,
        following,
        followers,
        preferences,
        stats,
      ];
}
