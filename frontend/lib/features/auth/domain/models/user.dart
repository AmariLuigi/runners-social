import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
class User with _$User {
  const factory User({
    required String id,
    required String email,
    required String username,
    String? profilePicture,
    String? bio,
    @Default(false) bool isOnline,
    DateTime? lastActive,
    @Default([]) List<String> friends,
    @Default([]) List<String> pendingFriends,
    @Default({}) Map<String, dynamic> preferences,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
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
