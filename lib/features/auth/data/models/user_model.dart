import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/user.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel extends User {
  const UserModel({
    required String id,
    required String email,
    required String username,
    String? profileImageUrl,
    String? bio,
    required DateTime createdAt,
    required List<String> following,
    required List<String> followers,
    required Map<String, dynamic> preferences,
    required Map<String, dynamic> stats,
  }) : super(
          id: id,
          email: email,
          username: username,
          profileImageUrl: profileImageUrl,
          bio: bio,
          createdAt: createdAt,
          following: following,
          followers: followers,
          preferences: preferences,
          stats: stats,
        );

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  factory UserModel.fromEntity(User user) {
    return UserModel(
      id: user.id,
      email: user.email,
      username: user.username,
      profileImageUrl: user.profileImageUrl,
      bio: user.bio,
      createdAt: user.createdAt,
      following: user.following,
      followers: user.followers,
      preferences: user.preferences,
      stats: user.stats,
    );
  }

  User toEntity() {
    return User(
      id: id,
      email: email,
      username: username,
      profileImageUrl: profileImageUrl,
      bio: bio,
      createdAt: createdAt,
      following: following,
      followers: followers,
      preferences: preferences,
      stats: stats,
    );
  }
}
