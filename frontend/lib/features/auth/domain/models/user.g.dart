// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserImpl _$$UserImplFromJson(Map<String, dynamic> json) => _$UserImpl(
      id: json['id'] as String,
      email: json['email'] as String,
      username: json['username'] as String,
      profilePicture: json['profilePicture'] as String?,
      bio: json['bio'] as String?,
      isOnline: json['isOnline'] as bool? ?? false,
      lastActive: json['lastActive'] == null
          ? null
          : DateTime.parse(json['lastActive'] as String),
      friends: (json['friends'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      pendingFriends: (json['pendingFriends'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      preferences: json['preferences'] as Map<String, dynamic>? ?? const {},
    );

Map<String, dynamic> _$$UserImplToJson(_$UserImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'username': instance.username,
      'profilePicture': instance.profilePicture,
      'bio': instance.bio,
      'isOnline': instance.isOnline,
      'lastActive': instance.lastActive?.toIso8601String(),
      'friends': instance.friends,
      'pendingFriends': instance.pendingFriends,
      'preferences': instance.preferences,
    };

_$UserPreferencesImpl _$$UserPreferencesImplFromJson(
        Map<String, dynamic> json) =>
    _$UserPreferencesImpl(
      preferredDistance: (json['preferredDistance'] as num?)?.toDouble() ?? 5,
      distanceUnit: json['distanceUnit'] as String? ?? 'km',
      preferredPace: (json['preferredPace'] as num?)?.toDouble() ?? 6,
      paceUnit: json['paceUnit'] as String? ?? 'min/km',
      shareLocation: json['shareLocation'] as bool? ?? true,
      notificationsEnabled: json['notificationsEnabled'] as bool? ?? true,
      favoriteRoutes: (json['favoriteRoutes'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      additionalSettings:
          json['additionalSettings'] as Map<String, dynamic>? ?? const {},
    );

Map<String, dynamic> _$$UserPreferencesImplToJson(
        _$UserPreferencesImpl instance) =>
    <String, dynamic>{
      'preferredDistance': instance.preferredDistance,
      'distanceUnit': instance.distanceUnit,
      'preferredPace': instance.preferredPace,
      'paceUnit': instance.paceUnit,
      'shareLocation': instance.shareLocation,
      'notificationsEnabled': instance.notificationsEnabled,
      'favoriteRoutes': instance.favoriteRoutes,
      'additionalSettings': instance.additionalSettings,
    };
