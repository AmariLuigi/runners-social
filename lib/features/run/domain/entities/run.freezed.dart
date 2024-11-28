// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'run.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Run _$RunFromJson(Map<String, dynamic> json) {
  return _Run.fromJson(json);
}

/// @nodoc
mixin _$Run {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  RunType get type => throw _privateConstructorUsedError;
  RunStatus get status => throw _privateConstructorUsedError;
  DateTime get startTime => throw _privateConstructorUsedError;
  String? get locationName => throw _privateConstructorUsedError;
  double? get distanceGoal => throw _privateConstructorUsedError;
  bool? get isPublic => throw _privateConstructorUsedError;
  List<String>? get participants => throw _privateConstructorUsedError;
  bool? get hasChatEnabled => throw _privateConstructorUsedError;
  bool get isParticipant => throw _privateConstructorUsedError;

  /// Serializes this Run to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Run
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RunCopyWith<Run> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RunCopyWith<$Res> {
  factory $RunCopyWith(Run value, $Res Function(Run) then) =
      _$RunCopyWithImpl<$Res, Run>;
  @useResult
  $Res call(
      {String id,
      String name,
      RunType type,
      RunStatus status,
      DateTime startTime,
      String? locationName,
      double? distanceGoal,
      bool? isPublic,
      List<String>? participants,
      bool? hasChatEnabled,
      bool isParticipant});
}

/// @nodoc
class _$RunCopyWithImpl<$Res, $Val extends Run> implements $RunCopyWith<$Res> {
  _$RunCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Run
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? type = null,
    Object? status = null,
    Object? startTime = null,
    Object? locationName = freezed,
    Object? distanceGoal = freezed,
    Object? isPublic = freezed,
    Object? participants = freezed,
    Object? hasChatEnabled = freezed,
    Object? isParticipant = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as RunType,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as RunStatus,
      startTime: null == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      locationName: freezed == locationName
          ? _value.locationName
          : locationName // ignore: cast_nullable_to_non_nullable
              as String?,
      distanceGoal: freezed == distanceGoal
          ? _value.distanceGoal
          : distanceGoal // ignore: cast_nullable_to_non_nullable
              as double?,
      isPublic: freezed == isPublic
          ? _value.isPublic
          : isPublic // ignore: cast_nullable_to_non_nullable
              as bool?,
      participants: freezed == participants
          ? _value.participants
          : participants // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      hasChatEnabled: freezed == hasChatEnabled
          ? _value.hasChatEnabled
          : hasChatEnabled // ignore: cast_nullable_to_non_nullable
              as bool?,
      isParticipant: null == isParticipant
          ? _value.isParticipant
          : isParticipant // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RunImplCopyWith<$Res> implements $RunCopyWith<$Res> {
  factory _$$RunImplCopyWith(_$RunImpl value, $Res Function(_$RunImpl) then) =
      __$$RunImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      RunType type,
      RunStatus status,
      DateTime startTime,
      String? locationName,
      double? distanceGoal,
      bool? isPublic,
      List<String>? participants,
      bool? hasChatEnabled,
      bool isParticipant});
}

/// @nodoc
class __$$RunImplCopyWithImpl<$Res> extends _$RunCopyWithImpl<$Res, _$RunImpl>
    implements _$$RunImplCopyWith<$Res> {
  __$$RunImplCopyWithImpl(_$RunImpl _value, $Res Function(_$RunImpl) _then)
      : super(_value, _then);

  /// Create a copy of Run
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? type = null,
    Object? status = null,
    Object? startTime = null,
    Object? locationName = freezed,
    Object? distanceGoal = freezed,
    Object? isPublic = freezed,
    Object? participants = freezed,
    Object? hasChatEnabled = freezed,
    Object? isParticipant = null,
  }) {
    return _then(_$RunImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as RunType,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as RunStatus,
      startTime: null == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      locationName: freezed == locationName
          ? _value.locationName
          : locationName // ignore: cast_nullable_to_non_nullable
              as String?,
      distanceGoal: freezed == distanceGoal
          ? _value.distanceGoal
          : distanceGoal // ignore: cast_nullable_to_non_nullable
              as double?,
      isPublic: freezed == isPublic
          ? _value.isPublic
          : isPublic // ignore: cast_nullable_to_non_nullable
              as bool?,
      participants: freezed == participants
          ? _value._participants
          : participants // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      hasChatEnabled: freezed == hasChatEnabled
          ? _value.hasChatEnabled
          : hasChatEnabled // ignore: cast_nullable_to_non_nullable
              as bool?,
      isParticipant: null == isParticipant
          ? _value.isParticipant
          : isParticipant // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RunImpl implements _Run {
  const _$RunImpl(
      {required this.id,
      required this.name,
      required this.type,
      required this.status,
      required this.startTime,
      this.locationName,
      this.distanceGoal,
      this.isPublic,
      final List<String>? participants,
      this.hasChatEnabled,
      this.isParticipant = false})
      : _participants = participants;

  factory _$RunImpl.fromJson(Map<String, dynamic> json) =>
      _$$RunImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final RunType type;
  @override
  final RunStatus status;
  @override
  final DateTime startTime;
  @override
  final String? locationName;
  @override
  final double? distanceGoal;
  @override
  final bool? isPublic;
  final List<String>? _participants;
  @override
  List<String>? get participants {
    final value = _participants;
    if (value == null) return null;
    if (_participants is EqualUnmodifiableListView) return _participants;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final bool? hasChatEnabled;
  @override
  @JsonKey()
  final bool isParticipant;

  @override
  String toString() {
    return 'Run(id: $id, name: $name, type: $type, status: $status, startTime: $startTime, locationName: $locationName, distanceGoal: $distanceGoal, isPublic: $isPublic, participants: $participants, hasChatEnabled: $hasChatEnabled, isParticipant: $isParticipant)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RunImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.locationName, locationName) ||
                other.locationName == locationName) &&
            (identical(other.distanceGoal, distanceGoal) ||
                other.distanceGoal == distanceGoal) &&
            (identical(other.isPublic, isPublic) ||
                other.isPublic == isPublic) &&
            const DeepCollectionEquality()
                .equals(other._participants, _participants) &&
            (identical(other.hasChatEnabled, hasChatEnabled) ||
                other.hasChatEnabled == hasChatEnabled) &&
            (identical(other.isParticipant, isParticipant) ||
                other.isParticipant == isParticipant));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      type,
      status,
      startTime,
      locationName,
      distanceGoal,
      isPublic,
      const DeepCollectionEquality().hash(_participants),
      hasChatEnabled,
      isParticipant);

  /// Create a copy of Run
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RunImplCopyWith<_$RunImpl> get copyWith =>
      __$$RunImplCopyWithImpl<_$RunImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RunImplToJson(
      this,
    );
  }
}

abstract class _Run implements Run {
  const factory _Run(
      {required final String id,
      required final String name,
      required final RunType type,
      required final RunStatus status,
      required final DateTime startTime,
      final String? locationName,
      final double? distanceGoal,
      final bool? isPublic,
      final List<String>? participants,
      final bool? hasChatEnabled,
      final bool isParticipant}) = _$RunImpl;

  factory _Run.fromJson(Map<String, dynamic> json) = _$RunImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  RunType get type;
  @override
  RunStatus get status;
  @override
  DateTime get startTime;
  @override
  String? get locationName;
  @override
  double? get distanceGoal;
  @override
  bool? get isPublic;
  @override
  List<String>? get participants;
  @override
  bool? get hasChatEnabled;
  @override
  bool get isParticipant;

  /// Create a copy of Run
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RunImplCopyWith<_$RunImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
