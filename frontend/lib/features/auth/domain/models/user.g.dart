// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

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
