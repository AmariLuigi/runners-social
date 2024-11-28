import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
class User with _$User {
  const factory User({
    required String id,
    required String email,
    required String username,
    @Default('') String firstName,
    @Default('') String lastName,
    @Default('') String bio,
    @Default('/default-profile.png') String profileImage,
    @Default(false) bool isOnline,
    DateTime? lastActive,
    @Default([]) List<String> friends,
    @Default([]) List<String> pendingFriends,
    @Default({}) Map<String, dynamic> preferences,
  }) = _User;

  const User._();

  String get name => '$firstName $lastName'.trim().isEmpty ? username : '$firstName $lastName'.trim();

  static User fromJson(Map<String, dynamic> json) {
    final profile = json['profile'] as Map<String, dynamic>?;
    return User(
      id: json['id']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      username: json['username']?.toString() ?? '',
      firstName: profile?['firstName']?.toString() ?? '',
      lastName: profile?['lastName']?.toString() ?? '',
      bio: profile?['bio']?.toString() ?? '',
      profileImage: profile?['profileImage']?.toString() ?? '/default-profile.png',
      isOnline: json['isOnline'] as bool? ?? false,
      lastActive: json['lastActive'] == null 
          ? null 
          : DateTime.tryParse(json['lastActive'].toString()),
      friends: (json['friends'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ?? [],
      pendingFriends: (json['pendingFriends'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ?? [],
      preferences: profile?['preferences'] as Map<String, dynamic>? ?? {},
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'email': email,
    'username': username,
    'firstName': firstName,
    'lastName': lastName,
    'bio': bio,
    'profileImage': profileImage,
    'isOnline': isOnline,
    'lastActive': lastActive?.toIso8601String(),
    'friends': friends,
    'pendingFriends': pendingFriends,
    'preferences': preferences,
  };
}

@freezed
class UserPreferences with _$UserPreferences {
  const factory UserPreferences({
    @Default(5) double preferredDistance,
    @Default('km') String distanceUnit,
    @Default(6) double preferredPace,
    @Default('min/km') String paceUnit,
    @Default(true) bool shareLocation,
    @Default(true) bool notificationsEnabled,
    @Default([]) List<String> favoriteRoutes,
    @Default({}) Map<String, dynamic> additionalSettings,
  }) = _UserPreferences;

  factory UserPreferences.fromJson(Map<String, dynamic> json) =>
      _$UserPreferencesFromJson(json);
}
