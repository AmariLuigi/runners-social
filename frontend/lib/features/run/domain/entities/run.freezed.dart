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

/// @nodoc
mixin _$Run {
  @JsonKey(name: '_id')
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'title')
  String get name => throw _privateConstructorUsedError;
  RunType get type => throw _privateConstructorUsedError;
  RunStatus get status => throw _privateConstructorUsedError;
  DateTime get startTime => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'runStyle')
  String? get runStyle => throw _privateConstructorUsedError;
  int? get maxParticipants => throw _privateConstructorUsedError;
  String get privacy => throw _privateConstructorUsedError;
  List<String> get participants => throw _privateConstructorUsedError;
  List<dynamic> get chat => throw _privateConstructorUsedError;
  List<dynamic> get checkpoints => throw _privateConstructorUsedError;
  List<dynamic> get metrics => throw _privateConstructorUsedError;
  List<dynamic> get photos => throw _privateConstructorUsedError;
  List<dynamic> get comments => throw _privateConstructorUsedError;
  List<dynamic> get likes => throw _privateConstructorUsedError;
  bool get isParticipant => throw _privateConstructorUsedError;

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
      {@JsonKey(name: '_id') String id,
      @JsonKey(name: 'title') String name,
      RunType type,
      RunStatus status,
      DateTime startTime,
      String? description,
      @JsonKey(name: 'runStyle') String? runStyle,
      int? maxParticipants,
      String privacy,
      List<String> participants,
      List<dynamic> chat,
      List<dynamic> checkpoints,
      List<dynamic> metrics,
      List<dynamic> photos,
      List<dynamic> comments,
      List<dynamic> likes,
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
    Object? description = freezed,
    Object? runStyle = freezed,
    Object? maxParticipants = freezed,
    Object? privacy = null,
    Object? participants = null,
    Object? chat = null,
    Object? checkpoints = null,
    Object? metrics = null,
    Object? photos = null,
    Object? comments = null,
    Object? likes = null,
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
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      runStyle: freezed == runStyle
          ? _value.runStyle
          : runStyle // ignore: cast_nullable_to_non_nullable
              as String?,
      maxParticipants: freezed == maxParticipants
          ? _value.maxParticipants
          : maxParticipants // ignore: cast_nullable_to_non_nullable
              as int?,
      privacy: null == privacy
          ? _value.privacy
          : privacy // ignore: cast_nullable_to_non_nullable
              as String,
      participants: null == participants
          ? _value.participants
          : participants // ignore: cast_nullable_to_non_nullable
              as List<String>,
      chat: null == chat
          ? _value.chat
          : chat // ignore: cast_nullable_to_non_nullable
              as List<dynamic>,
      checkpoints: null == checkpoints
          ? _value.checkpoints
          : checkpoints // ignore: cast_nullable_to_non_nullable
              as List<dynamic>,
      metrics: null == metrics
          ? _value.metrics
          : metrics // ignore: cast_nullable_to_non_nullable
              as List<dynamic>,
      photos: null == photos
          ? _value.photos
          : photos // ignore: cast_nullable_to_non_nullable
              as List<dynamic>,
      comments: null == comments
          ? _value.comments
          : comments // ignore: cast_nullable_to_non_nullable
              as List<dynamic>,
      likes: null == likes
          ? _value.likes
          : likes // ignore: cast_nullable_to_non_nullable
              as List<dynamic>,
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
      {@JsonKey(name: '_id') String id,
      @JsonKey(name: 'title') String name,
      RunType type,
      RunStatus status,
      DateTime startTime,
      String? description,
      @JsonKey(name: 'runStyle') String? runStyle,
      int? maxParticipants,
      String privacy,
      List<String> participants,
      List<dynamic> chat,
      List<dynamic> checkpoints,
      List<dynamic> metrics,
      List<dynamic> photos,
      List<dynamic> comments,
      List<dynamic> likes,
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
    Object? description = freezed,
    Object? runStyle = freezed,
    Object? maxParticipants = freezed,
    Object? privacy = null,
    Object? participants = null,
    Object? chat = null,
    Object? checkpoints = null,
    Object? metrics = null,
    Object? photos = null,
    Object? comments = null,
    Object? likes = null,
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
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      runStyle: freezed == runStyle
          ? _value.runStyle
          : runStyle // ignore: cast_nullable_to_non_nullable
              as String?,
      maxParticipants: freezed == maxParticipants
          ? _value.maxParticipants
          : maxParticipants // ignore: cast_nullable_to_non_nullable
              as int?,
      privacy: null == privacy
          ? _value.privacy
          : privacy // ignore: cast_nullable_to_non_nullable
              as String,
      participants: null == participants
          ? _value._participants
          : participants // ignore: cast_nullable_to_non_nullable
              as List<String>,
      chat: null == chat
          ? _value._chat
          : chat // ignore: cast_nullable_to_non_nullable
              as List<dynamic>,
      checkpoints: null == checkpoints
          ? _value._checkpoints
          : checkpoints // ignore: cast_nullable_to_non_nullable
              as List<dynamic>,
      metrics: null == metrics
          ? _value._metrics
          : metrics // ignore: cast_nullable_to_non_nullable
              as List<dynamic>,
      photos: null == photos
          ? _value._photos
          : photos // ignore: cast_nullable_to_non_nullable
              as List<dynamic>,
      comments: null == comments
          ? _value._comments
          : comments // ignore: cast_nullable_to_non_nullable
              as List<dynamic>,
      likes: null == likes
          ? _value._likes
          : likes // ignore: cast_nullable_to_non_nullable
              as List<dynamic>,
      isParticipant: null == isParticipant
          ? _value.isParticipant
          : isParticipant // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$RunImpl implements _Run {
  const _$RunImpl(
      {@JsonKey(name: '_id') required this.id,
      @JsonKey(name: 'title') required this.name,
      required this.type,
      required this.status,
      required this.startTime,
      this.description,
      @JsonKey(name: 'runStyle') this.runStyle,
      this.maxParticipants,
      this.privacy = 'public',
      final List<String> participants = const [],
      final List<dynamic> chat = const [],
      final List<dynamic> checkpoints = const [],
      final List<dynamic> metrics = const [],
      final List<dynamic> photos = const [],
      final List<dynamic> comments = const [],
      final List<dynamic> likes = const [],
      this.isParticipant = false})
      : _participants = participants,
        _chat = chat,
        _checkpoints = checkpoints,
        _metrics = metrics,
        _photos = photos,
        _comments = comments,
        _likes = likes;

  @override
  @JsonKey(name: '_id')
  final String id;
  @override
  @JsonKey(name: 'title')
  final String name;
  @override
  final RunType type;
  @override
  final RunStatus status;
  @override
  final DateTime startTime;
  @override
  final String? description;
  @override
  @JsonKey(name: 'runStyle')
  final String? runStyle;
  @override
  final int? maxParticipants;
  @override
  @JsonKey()
  final String privacy;
  final List<String> _participants;
  @override
  @JsonKey()
  List<String> get participants {
    if (_participants is EqualUnmodifiableListView) return _participants;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_participants);
  }

  final List<dynamic> _chat;
  @override
  @JsonKey()
  List<dynamic> get chat {
    if (_chat is EqualUnmodifiableListView) return _chat;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_chat);
  }

  final List<dynamic> _checkpoints;
  @override
  @JsonKey()
  List<dynamic> get checkpoints {
    if (_checkpoints is EqualUnmodifiableListView) return _checkpoints;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_checkpoints);
  }

  final List<dynamic> _metrics;
  @override
  @JsonKey()
  List<dynamic> get metrics {
    if (_metrics is EqualUnmodifiableListView) return _metrics;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_metrics);
  }

  final List<dynamic> _photos;
  @override
  @JsonKey()
  List<dynamic> get photos {
    if (_photos is EqualUnmodifiableListView) return _photos;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_photos);
  }

  final List<dynamic> _comments;
  @override
  @JsonKey()
  List<dynamic> get comments {
    if (_comments is EqualUnmodifiableListView) return _comments;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_comments);
  }

  final List<dynamic> _likes;
  @override
  @JsonKey()
  List<dynamic> get likes {
    if (_likes is EqualUnmodifiableListView) return _likes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_likes);
  }

  @override
  @JsonKey()
  final bool isParticipant;

  @override
  String toString() {
    return 'Run(id: $id, name: $name, type: $type, status: $status, startTime: $startTime, description: $description, runStyle: $runStyle, maxParticipants: $maxParticipants, privacy: $privacy, participants: $participants, chat: $chat, checkpoints: $checkpoints, metrics: $metrics, photos: $photos, comments: $comments, likes: $likes, isParticipant: $isParticipant)';
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
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.runStyle, runStyle) ||
                other.runStyle == runStyle) &&
            (identical(other.maxParticipants, maxParticipants) ||
                other.maxParticipants == maxParticipants) &&
            (identical(other.privacy, privacy) || other.privacy == privacy) &&
            const DeepCollectionEquality()
                .equals(other._participants, _participants) &&
            const DeepCollectionEquality().equals(other._chat, _chat) &&
            const DeepCollectionEquality()
                .equals(other._checkpoints, _checkpoints) &&
            const DeepCollectionEquality().equals(other._metrics, _metrics) &&
            const DeepCollectionEquality().equals(other._photos, _photos) &&
            const DeepCollectionEquality().equals(other._comments, _comments) &&
            const DeepCollectionEquality().equals(other._likes, _likes) &&
            (identical(other.isParticipant, isParticipant) ||
                other.isParticipant == isParticipant));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      type,
      status,
      startTime,
      description,
      runStyle,
      maxParticipants,
      privacy,
      const DeepCollectionEquality().hash(_participants),
      const DeepCollectionEquality().hash(_chat),
      const DeepCollectionEquality().hash(_checkpoints),
      const DeepCollectionEquality().hash(_metrics),
      const DeepCollectionEquality().hash(_photos),
      const DeepCollectionEquality().hash(_comments),
      const DeepCollectionEquality().hash(_likes),
      isParticipant);

  /// Create a copy of Run
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RunImplCopyWith<_$RunImpl> get copyWith =>
      __$$RunImplCopyWithImpl<_$RunImpl>(this, _$identity);
}

abstract class _Run implements Run {
  const factory _Run(
      {@JsonKey(name: '_id') required final String id,
      @JsonKey(name: 'title') required final String name,
      required final RunType type,
      required final RunStatus status,
      required final DateTime startTime,
      final String? description,
      @JsonKey(name: 'runStyle') final String? runStyle,
      final int? maxParticipants,
      final String privacy,
      final List<String> participants,
      final List<dynamic> chat,
      final List<dynamic> checkpoints,
      final List<dynamic> metrics,
      final List<dynamic> photos,
      final List<dynamic> comments,
      final List<dynamic> likes,
      final bool isParticipant}) = _$RunImpl;

  @override
  @JsonKey(name: '_id')
  String get id;
  @override
  @JsonKey(name: 'title')
  String get name;
  @override
  RunType get type;
  @override
  RunStatus get status;
  @override
  DateTime get startTime;
  @override
  String? get description;
  @override
  @JsonKey(name: 'runStyle')
  String? get runStyle;
  @override
  int? get maxParticipants;
  @override
  String get privacy;
  @override
  List<String> get participants;
  @override
  List<dynamic> get chat;
  @override
  List<dynamic> get checkpoints;
  @override
  List<dynamic> get metrics;
  @override
  List<dynamic> get photos;
  @override
  List<dynamic> get comments;
  @override
  List<dynamic> get likes;
  @override
  bool get isParticipant;

  /// Create a copy of Run
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RunImplCopyWith<_$RunImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
