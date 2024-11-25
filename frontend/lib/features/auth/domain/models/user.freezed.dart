// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

User _$UserFromJson(Map<String, dynamic> json) {
  return _User.fromJson(json);
}

/// @nodoc
mixin _$User {
  String get id => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  String get username => throw _privateConstructorUsedError;
  String? get profilePicture => throw _privateConstructorUsedError;
  String? get bio => throw _privateConstructorUsedError;
  bool get isOnline => throw _privateConstructorUsedError;
  DateTime? get lastActive => throw _privateConstructorUsedError;
  List<String> get friends => throw _privateConstructorUsedError;
  List<String> get pendingFriends => throw _privateConstructorUsedError;
  Map<String, dynamic> get preferences => throw _privateConstructorUsedError;

  /// Serializes this User to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of User
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserCopyWith<User> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserCopyWith<$Res> {
  factory $UserCopyWith(User value, $Res Function(User) then) =
      _$UserCopyWithImpl<$Res, User>;
  @useResult
  $Res call(
      {String id,
      String email,
      String username,
      String? profilePicture,
      String? bio,
      bool isOnline,
      DateTime? lastActive,
      List<String> friends,
      List<String> pendingFriends,
      Map<String, dynamic> preferences});
}

/// @nodoc
class _$UserCopyWithImpl<$Res, $Val extends User>
    implements $UserCopyWith<$Res> {
  _$UserCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of User
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? email = null,
    Object? username = null,
    Object? profilePicture = freezed,
    Object? bio = freezed,
    Object? isOnline = null,
    Object? lastActive = freezed,
    Object? friends = null,
    Object? pendingFriends = null,
    Object? preferences = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      username: null == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String,
      profilePicture: freezed == profilePicture
          ? _value.profilePicture
          : profilePicture // ignore: cast_nullable_to_non_nullable
              as String?,
      bio: freezed == bio
          ? _value.bio
          : bio // ignore: cast_nullable_to_non_nullable
              as String?,
      isOnline: null == isOnline
          ? _value.isOnline
          : isOnline // ignore: cast_nullable_to_non_nullable
              as bool,
      lastActive: freezed == lastActive
          ? _value.lastActive
          : lastActive // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      friends: null == friends
          ? _value.friends
          : friends // ignore: cast_nullable_to_non_nullable
              as List<String>,
      pendingFriends: null == pendingFriends
          ? _value.pendingFriends
          : pendingFriends // ignore: cast_nullable_to_non_nullable
              as List<String>,
      preferences: null == preferences
          ? _value.preferences
          : preferences // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserImplCopyWith<$Res> implements $UserCopyWith<$Res> {
  factory _$$UserImplCopyWith(
          _$UserImpl value, $Res Function(_$UserImpl) then) =
      __$$UserImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String email,
      String username,
      String? profilePicture,
      String? bio,
      bool isOnline,
      DateTime? lastActive,
      List<String> friends,
      List<String> pendingFriends,
      Map<String, dynamic> preferences});
}

/// @nodoc
class __$$UserImplCopyWithImpl<$Res>
    extends _$UserCopyWithImpl<$Res, _$UserImpl>
    implements _$$UserImplCopyWith<$Res> {
  __$$UserImplCopyWithImpl(_$UserImpl _value, $Res Function(_$UserImpl) _then)
      : super(_value, _then);

  /// Create a copy of User
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? email = null,
    Object? username = null,
    Object? profilePicture = freezed,
    Object? bio = freezed,
    Object? isOnline = null,
    Object? lastActive = freezed,
    Object? friends = null,
    Object? pendingFriends = null,
    Object? preferences = null,
  }) {
    return _then(_$UserImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      username: null == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String,
      profilePicture: freezed == profilePicture
          ? _value.profilePicture
          : profilePicture // ignore: cast_nullable_to_non_nullable
              as String?,
      bio: freezed == bio
          ? _value.bio
          : bio // ignore: cast_nullable_to_non_nullable
              as String?,
      isOnline: null == isOnline
          ? _value.isOnline
          : isOnline // ignore: cast_nullable_to_non_nullable
              as bool,
      lastActive: freezed == lastActive
          ? _value.lastActive
          : lastActive // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      friends: null == friends
          ? _value._friends
          : friends // ignore: cast_nullable_to_non_nullable
              as List<String>,
      pendingFriends: null == pendingFriends
          ? _value._pendingFriends
          : pendingFriends // ignore: cast_nullable_to_non_nullable
              as List<String>,
      preferences: null == preferences
          ? _value._preferences
          : preferences // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserImpl implements _User {
  const _$UserImpl(
      {required this.id,
      required this.email,
      required this.username,
      this.profilePicture,
      this.bio,
      this.isOnline = false,
      this.lastActive,
      final List<String> friends = const [],
      final List<String> pendingFriends = const [],
      final Map<String, dynamic> preferences = const {}})
      : _friends = friends,
        _pendingFriends = pendingFriends,
        _preferences = preferences;

  factory _$UserImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserImplFromJson(json);

  @override
  final String id;
  @override
  final String email;
  @override
  final String username;
  @override
  final String? profilePicture;
  @override
  final String? bio;
  @override
  @JsonKey()
  final bool isOnline;
  @override
  final DateTime? lastActive;
  final List<String> _friends;
  @override
  @JsonKey()
  List<String> get friends {
    if (_friends is EqualUnmodifiableListView) return _friends;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_friends);
  }

  final List<String> _pendingFriends;
  @override
  @JsonKey()
  List<String> get pendingFriends {
    if (_pendingFriends is EqualUnmodifiableListView) return _pendingFriends;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_pendingFriends);
  }

  final Map<String, dynamic> _preferences;
  @override
  @JsonKey()
  Map<String, dynamic> get preferences {
    if (_preferences is EqualUnmodifiableMapView) return _preferences;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_preferences);
  }

  @override
  String toString() {
    return 'User(id: $id, email: $email, username: $username, profilePicture: $profilePicture, bio: $bio, isOnline: $isOnline, lastActive: $lastActive, friends: $friends, pendingFriends: $pendingFriends, preferences: $preferences)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.username, username) ||
                other.username == username) &&
            (identical(other.profilePicture, profilePicture) ||
                other.profilePicture == profilePicture) &&
            (identical(other.bio, bio) || other.bio == bio) &&
            (identical(other.isOnline, isOnline) ||
                other.isOnline == isOnline) &&
            (identical(other.lastActive, lastActive) ||
                other.lastActive == lastActive) &&
            const DeepCollectionEquality().equals(other._friends, _friends) &&
            const DeepCollectionEquality()
                .equals(other._pendingFriends, _pendingFriends) &&
            const DeepCollectionEquality()
                .equals(other._preferences, _preferences));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      email,
      username,
      profilePicture,
      bio,
      isOnline,
      lastActive,
      const DeepCollectionEquality().hash(_friends),
      const DeepCollectionEquality().hash(_pendingFriends),
      const DeepCollectionEquality().hash(_preferences));

  /// Create a copy of User
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserImplCopyWith<_$UserImpl> get copyWith =>
      __$$UserImplCopyWithImpl<_$UserImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserImplToJson(
      this,
    );
  }
}

abstract class _User implements User {
  const factory _User(
      {required final String id,
      required final String email,
      required final String username,
      final String? profilePicture,
      final String? bio,
      final bool isOnline,
      final DateTime? lastActive,
      final List<String> friends,
      final List<String> pendingFriends,
      final Map<String, dynamic> preferences}) = _$UserImpl;

  factory _User.fromJson(Map<String, dynamic> json) = _$UserImpl.fromJson;

  @override
  String get id;
  @override
  String get email;
  @override
  String get username;
  @override
  String? get profilePicture;
  @override
  String? get bio;
  @override
  bool get isOnline;
  @override
  DateTime? get lastActive;
  @override
  List<String> get friends;
  @override
  List<String> get pendingFriends;
  @override
  Map<String, dynamic> get preferences;

  /// Create a copy of User
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserImplCopyWith<_$UserImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

UserPreferences _$UserPreferencesFromJson(Map<String, dynamic> json) {
  return _UserPreferences.fromJson(json);
}

/// @nodoc
mixin _$UserPreferences {
  double get preferredDistance => throw _privateConstructorUsedError;
  String get distanceUnit => throw _privateConstructorUsedError;
  double get preferredPace => throw _privateConstructorUsedError;
  String get paceUnit => throw _privateConstructorUsedError;
  bool get shareLocation => throw _privateConstructorUsedError;
  bool get notificationsEnabled => throw _privateConstructorUsedError;
  List<String> get favoriteRoutes => throw _privateConstructorUsedError;
  Map<String, dynamic> get additionalSettings =>
      throw _privateConstructorUsedError;

  /// Serializes this UserPreferences to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserPreferences
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserPreferencesCopyWith<UserPreferences> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserPreferencesCopyWith<$Res> {
  factory $UserPreferencesCopyWith(
          UserPreferences value, $Res Function(UserPreferences) then) =
      _$UserPreferencesCopyWithImpl<$Res, UserPreferences>;
  @useResult
  $Res call(
      {double preferredDistance,
      String distanceUnit,
      double preferredPace,
      String paceUnit,
      bool shareLocation,
      bool notificationsEnabled,
      List<String> favoriteRoutes,
      Map<String, dynamic> additionalSettings});
}

/// @nodoc
class _$UserPreferencesCopyWithImpl<$Res, $Val extends UserPreferences>
    implements $UserPreferencesCopyWith<$Res> {
  _$UserPreferencesCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserPreferences
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? preferredDistance = null,
    Object? distanceUnit = null,
    Object? preferredPace = null,
    Object? paceUnit = null,
    Object? shareLocation = null,
    Object? notificationsEnabled = null,
    Object? favoriteRoutes = null,
    Object? additionalSettings = null,
  }) {
    return _then(_value.copyWith(
      preferredDistance: null == preferredDistance
          ? _value.preferredDistance
          : preferredDistance // ignore: cast_nullable_to_non_nullable
              as double,
      distanceUnit: null == distanceUnit
          ? _value.distanceUnit
          : distanceUnit // ignore: cast_nullable_to_non_nullable
              as String,
      preferredPace: null == preferredPace
          ? _value.preferredPace
          : preferredPace // ignore: cast_nullable_to_non_nullable
              as double,
      paceUnit: null == paceUnit
          ? _value.paceUnit
          : paceUnit // ignore: cast_nullable_to_non_nullable
              as String,
      shareLocation: null == shareLocation
          ? _value.shareLocation
          : shareLocation // ignore: cast_nullable_to_non_nullable
              as bool,
      notificationsEnabled: null == notificationsEnabled
          ? _value.notificationsEnabled
          : notificationsEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      favoriteRoutes: null == favoriteRoutes
          ? _value.favoriteRoutes
          : favoriteRoutes // ignore: cast_nullable_to_non_nullable
              as List<String>,
      additionalSettings: null == additionalSettings
          ? _value.additionalSettings
          : additionalSettings // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserPreferencesImplCopyWith<$Res>
    implements $UserPreferencesCopyWith<$Res> {
  factory _$$UserPreferencesImplCopyWith(_$UserPreferencesImpl value,
          $Res Function(_$UserPreferencesImpl) then) =
      __$$UserPreferencesImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {double preferredDistance,
      String distanceUnit,
      double preferredPace,
      String paceUnit,
      bool shareLocation,
      bool notificationsEnabled,
      List<String> favoriteRoutes,
      Map<String, dynamic> additionalSettings});
}

/// @nodoc
class __$$UserPreferencesImplCopyWithImpl<$Res>
    extends _$UserPreferencesCopyWithImpl<$Res, _$UserPreferencesImpl>
    implements _$$UserPreferencesImplCopyWith<$Res> {
  __$$UserPreferencesImplCopyWithImpl(
      _$UserPreferencesImpl _value, $Res Function(_$UserPreferencesImpl) _then)
      : super(_value, _then);

  /// Create a copy of UserPreferences
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? preferredDistance = null,
    Object? distanceUnit = null,
    Object? preferredPace = null,
    Object? paceUnit = null,
    Object? shareLocation = null,
    Object? notificationsEnabled = null,
    Object? favoriteRoutes = null,
    Object? additionalSettings = null,
  }) {
    return _then(_$UserPreferencesImpl(
      preferredDistance: null == preferredDistance
          ? _value.preferredDistance
          : preferredDistance // ignore: cast_nullable_to_non_nullable
              as double,
      distanceUnit: null == distanceUnit
          ? _value.distanceUnit
          : distanceUnit // ignore: cast_nullable_to_non_nullable
              as String,
      preferredPace: null == preferredPace
          ? _value.preferredPace
          : preferredPace // ignore: cast_nullable_to_non_nullable
              as double,
      paceUnit: null == paceUnit
          ? _value.paceUnit
          : paceUnit // ignore: cast_nullable_to_non_nullable
              as String,
      shareLocation: null == shareLocation
          ? _value.shareLocation
          : shareLocation // ignore: cast_nullable_to_non_nullable
              as bool,
      notificationsEnabled: null == notificationsEnabled
          ? _value.notificationsEnabled
          : notificationsEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      favoriteRoutes: null == favoriteRoutes
          ? _value._favoriteRoutes
          : favoriteRoutes // ignore: cast_nullable_to_non_nullable
              as List<String>,
      additionalSettings: null == additionalSettings
          ? _value._additionalSettings
          : additionalSettings // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserPreferencesImpl implements _UserPreferences {
  const _$UserPreferencesImpl(
      {this.preferredDistance = 5,
      this.distanceUnit = 'km',
      this.preferredPace = 6,
      this.paceUnit = 'min/km',
      this.shareLocation = true,
      this.notificationsEnabled = true,
      final List<String> favoriteRoutes = const [],
      final Map<String, dynamic> additionalSettings = const {}})
      : _favoriteRoutes = favoriteRoutes,
        _additionalSettings = additionalSettings;

  factory _$UserPreferencesImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserPreferencesImplFromJson(json);

  @override
  @JsonKey()
  final double preferredDistance;
  @override
  @JsonKey()
  final String distanceUnit;
  @override
  @JsonKey()
  final double preferredPace;
  @override
  @JsonKey()
  final String paceUnit;
  @override
  @JsonKey()
  final bool shareLocation;
  @override
  @JsonKey()
  final bool notificationsEnabled;
  final List<String> _favoriteRoutes;
  @override
  @JsonKey()
  List<String> get favoriteRoutes {
    if (_favoriteRoutes is EqualUnmodifiableListView) return _favoriteRoutes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_favoriteRoutes);
  }

  final Map<String, dynamic> _additionalSettings;
  @override
  @JsonKey()
  Map<String, dynamic> get additionalSettings {
    if (_additionalSettings is EqualUnmodifiableMapView)
      return _additionalSettings;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_additionalSettings);
  }

  @override
  String toString() {
    return 'UserPreferences(preferredDistance: $preferredDistance, distanceUnit: $distanceUnit, preferredPace: $preferredPace, paceUnit: $paceUnit, shareLocation: $shareLocation, notificationsEnabled: $notificationsEnabled, favoriteRoutes: $favoriteRoutes, additionalSettings: $additionalSettings)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserPreferencesImpl &&
            (identical(other.preferredDistance, preferredDistance) ||
                other.preferredDistance == preferredDistance) &&
            (identical(other.distanceUnit, distanceUnit) ||
                other.distanceUnit == distanceUnit) &&
            (identical(other.preferredPace, preferredPace) ||
                other.preferredPace == preferredPace) &&
            (identical(other.paceUnit, paceUnit) ||
                other.paceUnit == paceUnit) &&
            (identical(other.shareLocation, shareLocation) ||
                other.shareLocation == shareLocation) &&
            (identical(other.notificationsEnabled, notificationsEnabled) ||
                other.notificationsEnabled == notificationsEnabled) &&
            const DeepCollectionEquality()
                .equals(other._favoriteRoutes, _favoriteRoutes) &&
            const DeepCollectionEquality()
                .equals(other._additionalSettings, _additionalSettings));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      preferredDistance,
      distanceUnit,
      preferredPace,
      paceUnit,
      shareLocation,
      notificationsEnabled,
      const DeepCollectionEquality().hash(_favoriteRoutes),
      const DeepCollectionEquality().hash(_additionalSettings));

  /// Create a copy of UserPreferences
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserPreferencesImplCopyWith<_$UserPreferencesImpl> get copyWith =>
      __$$UserPreferencesImplCopyWithImpl<_$UserPreferencesImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserPreferencesImplToJson(
      this,
    );
  }
}

abstract class _UserPreferences implements UserPreferences {
  const factory _UserPreferences(
      {final double preferredDistance,
      final String distanceUnit,
      final double preferredPace,
      final String paceUnit,
      final bool shareLocation,
      final bool notificationsEnabled,
      final List<String> favoriteRoutes,
      final Map<String, dynamic> additionalSettings}) = _$UserPreferencesImpl;

  factory _UserPreferences.fromJson(Map<String, dynamic> json) =
      _$UserPreferencesImpl.fromJson;

  @override
  double get preferredDistance;
  @override
  String get distanceUnit;
  @override
  double get preferredPace;
  @override
  String get paceUnit;
  @override
  bool get shareLocation;
  @override
  bool get notificationsEnabled;
  @override
  List<String> get favoriteRoutes;
  @override
  Map<String, dynamic> get additionalSettings;

  /// Create a copy of UserPreferences
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserPreferencesImplCopyWith<_$UserPreferencesImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
