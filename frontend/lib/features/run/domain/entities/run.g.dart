// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'run.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RunImpl _$$RunImplFromJson(Map<String, dynamic> json) => _$RunImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      type: $enumDecode(_$RunTypeEnumMap, json['type']),
      status: $enumDecode(_$RunStatusEnumMap, json['status']),
      startTime: DateTime.parse(json['startTime'] as String),
      location: LatLng.fromJson(json['location'] as Map<String, dynamic>),
      locationName: json['locationName'] as String?,
      distanceGoal: (json['distanceGoal'] as num?)?.toDouble(),
      isPublic: json['isPublic'] as bool?,
      participants: (json['participants'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      hasChatEnabled: json['hasChatEnabled'] as bool?,
    );

Map<String, dynamic> _$$RunImplToJson(_$RunImpl instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'type': _$RunTypeEnumMap[instance.type]!,
      'status': _$RunStatusEnumMap[instance.status]!,
      'startTime': instance.startTime.toIso8601String(),
      'location': instance.location,
      'locationName': instance.locationName,
      'distanceGoal': instance.distanceGoal,
      'isPublic': instance.isPublic,
      'participants': instance.participants,
      'hasChatEnabled': instance.hasChatEnabled,
    };

const _$RunTypeEnumMap = {
  RunType.solo: 'solo',
  RunType.group: 'group',
};

const _$RunStatusEnumMap = {
  RunStatus.upcoming: 'upcoming',
  RunStatus.ongoing: 'ongoing',
  RunStatus.completed: 'completed',
};
