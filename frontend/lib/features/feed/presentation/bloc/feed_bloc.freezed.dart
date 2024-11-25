// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'feed_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$FeedEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loadPosts,
    required TResult Function() refreshPosts,
    required TResult Function(
            String content, List<String>? images, RunData? runData)
        createPost,
    required TResult Function(String postId, String userId) likePost,
    required TResult Function(String postId, String userId) unlikePost,
    required TResult Function(String postId, String content) addComment,
    required TResult Function(String postId, String commentId) deleteComment,
    required TResult Function(String postId) sharePost,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loadPosts,
    TResult? Function()? refreshPosts,
    TResult? Function(String content, List<String>? images, RunData? runData)?
        createPost,
    TResult? Function(String postId, String userId)? likePost,
    TResult? Function(String postId, String userId)? unlikePost,
    TResult? Function(String postId, String content)? addComment,
    TResult? Function(String postId, String commentId)? deleteComment,
    TResult? Function(String postId)? sharePost,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loadPosts,
    TResult Function()? refreshPosts,
    TResult Function(String content, List<String>? images, RunData? runData)?
        createPost,
    TResult Function(String postId, String userId)? likePost,
    TResult Function(String postId, String userId)? unlikePost,
    TResult Function(String postId, String content)? addComment,
    TResult Function(String postId, String commentId)? deleteComment,
    TResult Function(String postId)? sharePost,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_LoadPosts value) loadPosts,
    required TResult Function(_RefreshPosts value) refreshPosts,
    required TResult Function(_CreatePost value) createPost,
    required TResult Function(_LikePost value) likePost,
    required TResult Function(_UnlikePost value) unlikePost,
    required TResult Function(_AddComment value) addComment,
    required TResult Function(_DeleteComment value) deleteComment,
    required TResult Function(_SharePost value) sharePost,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_LoadPosts value)? loadPosts,
    TResult? Function(_RefreshPosts value)? refreshPosts,
    TResult? Function(_CreatePost value)? createPost,
    TResult? Function(_LikePost value)? likePost,
    TResult? Function(_UnlikePost value)? unlikePost,
    TResult? Function(_AddComment value)? addComment,
    TResult? Function(_DeleteComment value)? deleteComment,
    TResult? Function(_SharePost value)? sharePost,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_LoadPosts value)? loadPosts,
    TResult Function(_RefreshPosts value)? refreshPosts,
    TResult Function(_CreatePost value)? createPost,
    TResult Function(_LikePost value)? likePost,
    TResult Function(_UnlikePost value)? unlikePost,
    TResult Function(_AddComment value)? addComment,
    TResult Function(_DeleteComment value)? deleteComment,
    TResult Function(_SharePost value)? sharePost,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FeedEventCopyWith<$Res> {
  factory $FeedEventCopyWith(FeedEvent value, $Res Function(FeedEvent) then) =
      _$FeedEventCopyWithImpl<$Res, FeedEvent>;
}

/// @nodoc
class _$FeedEventCopyWithImpl<$Res, $Val extends FeedEvent>
    implements $FeedEventCopyWith<$Res> {
  _$FeedEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FeedEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$LoadPostsImplCopyWith<$Res> {
  factory _$$LoadPostsImplCopyWith(
          _$LoadPostsImpl value, $Res Function(_$LoadPostsImpl) then) =
      __$$LoadPostsImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$LoadPostsImplCopyWithImpl<$Res>
    extends _$FeedEventCopyWithImpl<$Res, _$LoadPostsImpl>
    implements _$$LoadPostsImplCopyWith<$Res> {
  __$$LoadPostsImplCopyWithImpl(
      _$LoadPostsImpl _value, $Res Function(_$LoadPostsImpl) _then)
      : super(_value, _then);

  /// Create a copy of FeedEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$LoadPostsImpl implements _LoadPosts {
  const _$LoadPostsImpl();

  @override
  String toString() {
    return 'FeedEvent.loadPosts()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$LoadPostsImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loadPosts,
    required TResult Function() refreshPosts,
    required TResult Function(
            String content, List<String>? images, RunData? runData)
        createPost,
    required TResult Function(String postId, String userId) likePost,
    required TResult Function(String postId, String userId) unlikePost,
    required TResult Function(String postId, String content) addComment,
    required TResult Function(String postId, String commentId) deleteComment,
    required TResult Function(String postId) sharePost,
  }) {
    return loadPosts();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loadPosts,
    TResult? Function()? refreshPosts,
    TResult? Function(String content, List<String>? images, RunData? runData)?
        createPost,
    TResult? Function(String postId, String userId)? likePost,
    TResult? Function(String postId, String userId)? unlikePost,
    TResult? Function(String postId, String content)? addComment,
    TResult? Function(String postId, String commentId)? deleteComment,
    TResult? Function(String postId)? sharePost,
  }) {
    return loadPosts?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loadPosts,
    TResult Function()? refreshPosts,
    TResult Function(String content, List<String>? images, RunData? runData)?
        createPost,
    TResult Function(String postId, String userId)? likePost,
    TResult Function(String postId, String userId)? unlikePost,
    TResult Function(String postId, String content)? addComment,
    TResult Function(String postId, String commentId)? deleteComment,
    TResult Function(String postId)? sharePost,
    required TResult orElse(),
  }) {
    if (loadPosts != null) {
      return loadPosts();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_LoadPosts value) loadPosts,
    required TResult Function(_RefreshPosts value) refreshPosts,
    required TResult Function(_CreatePost value) createPost,
    required TResult Function(_LikePost value) likePost,
    required TResult Function(_UnlikePost value) unlikePost,
    required TResult Function(_AddComment value) addComment,
    required TResult Function(_DeleteComment value) deleteComment,
    required TResult Function(_SharePost value) sharePost,
  }) {
    return loadPosts(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_LoadPosts value)? loadPosts,
    TResult? Function(_RefreshPosts value)? refreshPosts,
    TResult? Function(_CreatePost value)? createPost,
    TResult? Function(_LikePost value)? likePost,
    TResult? Function(_UnlikePost value)? unlikePost,
    TResult? Function(_AddComment value)? addComment,
    TResult? Function(_DeleteComment value)? deleteComment,
    TResult? Function(_SharePost value)? sharePost,
  }) {
    return loadPosts?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_LoadPosts value)? loadPosts,
    TResult Function(_RefreshPosts value)? refreshPosts,
    TResult Function(_CreatePost value)? createPost,
    TResult Function(_LikePost value)? likePost,
    TResult Function(_UnlikePost value)? unlikePost,
    TResult Function(_AddComment value)? addComment,
    TResult Function(_DeleteComment value)? deleteComment,
    TResult Function(_SharePost value)? sharePost,
    required TResult orElse(),
  }) {
    if (loadPosts != null) {
      return loadPosts(this);
    }
    return orElse();
  }
}

abstract class _LoadPosts implements FeedEvent {
  const factory _LoadPosts() = _$LoadPostsImpl;
}

/// @nodoc
abstract class _$$RefreshPostsImplCopyWith<$Res> {
  factory _$$RefreshPostsImplCopyWith(
          _$RefreshPostsImpl value, $Res Function(_$RefreshPostsImpl) then) =
      __$$RefreshPostsImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$RefreshPostsImplCopyWithImpl<$Res>
    extends _$FeedEventCopyWithImpl<$Res, _$RefreshPostsImpl>
    implements _$$RefreshPostsImplCopyWith<$Res> {
  __$$RefreshPostsImplCopyWithImpl(
      _$RefreshPostsImpl _value, $Res Function(_$RefreshPostsImpl) _then)
      : super(_value, _then);

  /// Create a copy of FeedEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$RefreshPostsImpl implements _RefreshPosts {
  const _$RefreshPostsImpl();

  @override
  String toString() {
    return 'FeedEvent.refreshPosts()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$RefreshPostsImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loadPosts,
    required TResult Function() refreshPosts,
    required TResult Function(
            String content, List<String>? images, RunData? runData)
        createPost,
    required TResult Function(String postId, String userId) likePost,
    required TResult Function(String postId, String userId) unlikePost,
    required TResult Function(String postId, String content) addComment,
    required TResult Function(String postId, String commentId) deleteComment,
    required TResult Function(String postId) sharePost,
  }) {
    return refreshPosts();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loadPosts,
    TResult? Function()? refreshPosts,
    TResult? Function(String content, List<String>? images, RunData? runData)?
        createPost,
    TResult? Function(String postId, String userId)? likePost,
    TResult? Function(String postId, String userId)? unlikePost,
    TResult? Function(String postId, String content)? addComment,
    TResult? Function(String postId, String commentId)? deleteComment,
    TResult? Function(String postId)? sharePost,
  }) {
    return refreshPosts?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loadPosts,
    TResult Function()? refreshPosts,
    TResult Function(String content, List<String>? images, RunData? runData)?
        createPost,
    TResult Function(String postId, String userId)? likePost,
    TResult Function(String postId, String userId)? unlikePost,
    TResult Function(String postId, String content)? addComment,
    TResult Function(String postId, String commentId)? deleteComment,
    TResult Function(String postId)? sharePost,
    required TResult orElse(),
  }) {
    if (refreshPosts != null) {
      return refreshPosts();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_LoadPosts value) loadPosts,
    required TResult Function(_RefreshPosts value) refreshPosts,
    required TResult Function(_CreatePost value) createPost,
    required TResult Function(_LikePost value) likePost,
    required TResult Function(_UnlikePost value) unlikePost,
    required TResult Function(_AddComment value) addComment,
    required TResult Function(_DeleteComment value) deleteComment,
    required TResult Function(_SharePost value) sharePost,
  }) {
    return refreshPosts(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_LoadPosts value)? loadPosts,
    TResult? Function(_RefreshPosts value)? refreshPosts,
    TResult? Function(_CreatePost value)? createPost,
    TResult? Function(_LikePost value)? likePost,
    TResult? Function(_UnlikePost value)? unlikePost,
    TResult? Function(_AddComment value)? addComment,
    TResult? Function(_DeleteComment value)? deleteComment,
    TResult? Function(_SharePost value)? sharePost,
  }) {
    return refreshPosts?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_LoadPosts value)? loadPosts,
    TResult Function(_RefreshPosts value)? refreshPosts,
    TResult Function(_CreatePost value)? createPost,
    TResult Function(_LikePost value)? likePost,
    TResult Function(_UnlikePost value)? unlikePost,
    TResult Function(_AddComment value)? addComment,
    TResult Function(_DeleteComment value)? deleteComment,
    TResult Function(_SharePost value)? sharePost,
    required TResult orElse(),
  }) {
    if (refreshPosts != null) {
      return refreshPosts(this);
    }
    return orElse();
  }
}

abstract class _RefreshPosts implements FeedEvent {
  const factory _RefreshPosts() = _$RefreshPostsImpl;
}

/// @nodoc
abstract class _$$CreatePostImplCopyWith<$Res> {
  factory _$$CreatePostImplCopyWith(
          _$CreatePostImpl value, $Res Function(_$CreatePostImpl) then) =
      __$$CreatePostImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String content, List<String>? images, RunData? runData});

  $RunDataCopyWith<$Res>? get runData;
}

/// @nodoc
class __$$CreatePostImplCopyWithImpl<$Res>
    extends _$FeedEventCopyWithImpl<$Res, _$CreatePostImpl>
    implements _$$CreatePostImplCopyWith<$Res> {
  __$$CreatePostImplCopyWithImpl(
      _$CreatePostImpl _value, $Res Function(_$CreatePostImpl) _then)
      : super(_value, _then);

  /// Create a copy of FeedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? content = null,
    Object? images = freezed,
    Object? runData = freezed,
  }) {
    return _then(_$CreatePostImpl(
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      images: freezed == images
          ? _value._images
          : images // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      runData: freezed == runData
          ? _value.runData
          : runData // ignore: cast_nullable_to_non_nullable
              as RunData?,
    ));
  }

  /// Create a copy of FeedEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $RunDataCopyWith<$Res>? get runData {
    if (_value.runData == null) {
      return null;
    }

    return $RunDataCopyWith<$Res>(_value.runData!, (value) {
      return _then(_value.copyWith(runData: value));
    });
  }
}

/// @nodoc

class _$CreatePostImpl implements _CreatePost {
  const _$CreatePostImpl(
      {required this.content, final List<String>? images, this.runData})
      : _images = images;

  @override
  final String content;
  final List<String>? _images;
  @override
  List<String>? get images {
    final value = _images;
    if (value == null) return null;
    if (_images is EqualUnmodifiableListView) return _images;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final RunData? runData;

  @override
  String toString() {
    return 'FeedEvent.createPost(content: $content, images: $images, runData: $runData)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreatePostImpl &&
            (identical(other.content, content) || other.content == content) &&
            const DeepCollectionEquality().equals(other._images, _images) &&
            (identical(other.runData, runData) || other.runData == runData));
  }

  @override
  int get hashCode => Object.hash(runtimeType, content,
      const DeepCollectionEquality().hash(_images), runData);

  /// Create a copy of FeedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CreatePostImplCopyWith<_$CreatePostImpl> get copyWith =>
      __$$CreatePostImplCopyWithImpl<_$CreatePostImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loadPosts,
    required TResult Function() refreshPosts,
    required TResult Function(
            String content, List<String>? images, RunData? runData)
        createPost,
    required TResult Function(String postId, String userId) likePost,
    required TResult Function(String postId, String userId) unlikePost,
    required TResult Function(String postId, String content) addComment,
    required TResult Function(String postId, String commentId) deleteComment,
    required TResult Function(String postId) sharePost,
  }) {
    return createPost(content, images, runData);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loadPosts,
    TResult? Function()? refreshPosts,
    TResult? Function(String content, List<String>? images, RunData? runData)?
        createPost,
    TResult? Function(String postId, String userId)? likePost,
    TResult? Function(String postId, String userId)? unlikePost,
    TResult? Function(String postId, String content)? addComment,
    TResult? Function(String postId, String commentId)? deleteComment,
    TResult? Function(String postId)? sharePost,
  }) {
    return createPost?.call(content, images, runData);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loadPosts,
    TResult Function()? refreshPosts,
    TResult Function(String content, List<String>? images, RunData? runData)?
        createPost,
    TResult Function(String postId, String userId)? likePost,
    TResult Function(String postId, String userId)? unlikePost,
    TResult Function(String postId, String content)? addComment,
    TResult Function(String postId, String commentId)? deleteComment,
    TResult Function(String postId)? sharePost,
    required TResult orElse(),
  }) {
    if (createPost != null) {
      return createPost(content, images, runData);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_LoadPosts value) loadPosts,
    required TResult Function(_RefreshPosts value) refreshPosts,
    required TResult Function(_CreatePost value) createPost,
    required TResult Function(_LikePost value) likePost,
    required TResult Function(_UnlikePost value) unlikePost,
    required TResult Function(_AddComment value) addComment,
    required TResult Function(_DeleteComment value) deleteComment,
    required TResult Function(_SharePost value) sharePost,
  }) {
    return createPost(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_LoadPosts value)? loadPosts,
    TResult? Function(_RefreshPosts value)? refreshPosts,
    TResult? Function(_CreatePost value)? createPost,
    TResult? Function(_LikePost value)? likePost,
    TResult? Function(_UnlikePost value)? unlikePost,
    TResult? Function(_AddComment value)? addComment,
    TResult? Function(_DeleteComment value)? deleteComment,
    TResult? Function(_SharePost value)? sharePost,
  }) {
    return createPost?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_LoadPosts value)? loadPosts,
    TResult Function(_RefreshPosts value)? refreshPosts,
    TResult Function(_CreatePost value)? createPost,
    TResult Function(_LikePost value)? likePost,
    TResult Function(_UnlikePost value)? unlikePost,
    TResult Function(_AddComment value)? addComment,
    TResult Function(_DeleteComment value)? deleteComment,
    TResult Function(_SharePost value)? sharePost,
    required TResult orElse(),
  }) {
    if (createPost != null) {
      return createPost(this);
    }
    return orElse();
  }
}

abstract class _CreatePost implements FeedEvent {
  const factory _CreatePost(
      {required final String content,
      final List<String>? images,
      final RunData? runData}) = _$CreatePostImpl;

  String get content;
  List<String>? get images;
  RunData? get runData;

  /// Create a copy of FeedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CreatePostImplCopyWith<_$CreatePostImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$LikePostImplCopyWith<$Res> {
  factory _$$LikePostImplCopyWith(
          _$LikePostImpl value, $Res Function(_$LikePostImpl) then) =
      __$$LikePostImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String postId, String userId});
}

/// @nodoc
class __$$LikePostImplCopyWithImpl<$Res>
    extends _$FeedEventCopyWithImpl<$Res, _$LikePostImpl>
    implements _$$LikePostImplCopyWith<$Res> {
  __$$LikePostImplCopyWithImpl(
      _$LikePostImpl _value, $Res Function(_$LikePostImpl) _then)
      : super(_value, _then);

  /// Create a copy of FeedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? postId = null,
    Object? userId = null,
  }) {
    return _then(_$LikePostImpl(
      postId: null == postId
          ? _value.postId
          : postId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$LikePostImpl implements _LikePost {
  const _$LikePostImpl({required this.postId, required this.userId});

  @override
  final String postId;
  @override
  final String userId;

  @override
  String toString() {
    return 'FeedEvent.likePost(postId: $postId, userId: $userId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LikePostImpl &&
            (identical(other.postId, postId) || other.postId == postId) &&
            (identical(other.userId, userId) || other.userId == userId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, postId, userId);

  /// Create a copy of FeedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LikePostImplCopyWith<_$LikePostImpl> get copyWith =>
      __$$LikePostImplCopyWithImpl<_$LikePostImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loadPosts,
    required TResult Function() refreshPosts,
    required TResult Function(
            String content, List<String>? images, RunData? runData)
        createPost,
    required TResult Function(String postId, String userId) likePost,
    required TResult Function(String postId, String userId) unlikePost,
    required TResult Function(String postId, String content) addComment,
    required TResult Function(String postId, String commentId) deleteComment,
    required TResult Function(String postId) sharePost,
  }) {
    return likePost(postId, userId);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loadPosts,
    TResult? Function()? refreshPosts,
    TResult? Function(String content, List<String>? images, RunData? runData)?
        createPost,
    TResult? Function(String postId, String userId)? likePost,
    TResult? Function(String postId, String userId)? unlikePost,
    TResult? Function(String postId, String content)? addComment,
    TResult? Function(String postId, String commentId)? deleteComment,
    TResult? Function(String postId)? sharePost,
  }) {
    return likePost?.call(postId, userId);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loadPosts,
    TResult Function()? refreshPosts,
    TResult Function(String content, List<String>? images, RunData? runData)?
        createPost,
    TResult Function(String postId, String userId)? likePost,
    TResult Function(String postId, String userId)? unlikePost,
    TResult Function(String postId, String content)? addComment,
    TResult Function(String postId, String commentId)? deleteComment,
    TResult Function(String postId)? sharePost,
    required TResult orElse(),
  }) {
    if (likePost != null) {
      return likePost(postId, userId);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_LoadPosts value) loadPosts,
    required TResult Function(_RefreshPosts value) refreshPosts,
    required TResult Function(_CreatePost value) createPost,
    required TResult Function(_LikePost value) likePost,
    required TResult Function(_UnlikePost value) unlikePost,
    required TResult Function(_AddComment value) addComment,
    required TResult Function(_DeleteComment value) deleteComment,
    required TResult Function(_SharePost value) sharePost,
  }) {
    return likePost(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_LoadPosts value)? loadPosts,
    TResult? Function(_RefreshPosts value)? refreshPosts,
    TResult? Function(_CreatePost value)? createPost,
    TResult? Function(_LikePost value)? likePost,
    TResult? Function(_UnlikePost value)? unlikePost,
    TResult? Function(_AddComment value)? addComment,
    TResult? Function(_DeleteComment value)? deleteComment,
    TResult? Function(_SharePost value)? sharePost,
  }) {
    return likePost?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_LoadPosts value)? loadPosts,
    TResult Function(_RefreshPosts value)? refreshPosts,
    TResult Function(_CreatePost value)? createPost,
    TResult Function(_LikePost value)? likePost,
    TResult Function(_UnlikePost value)? unlikePost,
    TResult Function(_AddComment value)? addComment,
    TResult Function(_DeleteComment value)? deleteComment,
    TResult Function(_SharePost value)? sharePost,
    required TResult orElse(),
  }) {
    if (likePost != null) {
      return likePost(this);
    }
    return orElse();
  }
}

abstract class _LikePost implements FeedEvent {
  const factory _LikePost(
      {required final String postId,
      required final String userId}) = _$LikePostImpl;

  String get postId;
  String get userId;

  /// Create a copy of FeedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LikePostImplCopyWith<_$LikePostImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$UnlikePostImplCopyWith<$Res> {
  factory _$$UnlikePostImplCopyWith(
          _$UnlikePostImpl value, $Res Function(_$UnlikePostImpl) then) =
      __$$UnlikePostImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String postId, String userId});
}

/// @nodoc
class __$$UnlikePostImplCopyWithImpl<$Res>
    extends _$FeedEventCopyWithImpl<$Res, _$UnlikePostImpl>
    implements _$$UnlikePostImplCopyWith<$Res> {
  __$$UnlikePostImplCopyWithImpl(
      _$UnlikePostImpl _value, $Res Function(_$UnlikePostImpl) _then)
      : super(_value, _then);

  /// Create a copy of FeedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? postId = null,
    Object? userId = null,
  }) {
    return _then(_$UnlikePostImpl(
      postId: null == postId
          ? _value.postId
          : postId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$UnlikePostImpl implements _UnlikePost {
  const _$UnlikePostImpl({required this.postId, required this.userId});

  @override
  final String postId;
  @override
  final String userId;

  @override
  String toString() {
    return 'FeedEvent.unlikePost(postId: $postId, userId: $userId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UnlikePostImpl &&
            (identical(other.postId, postId) || other.postId == postId) &&
            (identical(other.userId, userId) || other.userId == userId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, postId, userId);

  /// Create a copy of FeedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UnlikePostImplCopyWith<_$UnlikePostImpl> get copyWith =>
      __$$UnlikePostImplCopyWithImpl<_$UnlikePostImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loadPosts,
    required TResult Function() refreshPosts,
    required TResult Function(
            String content, List<String>? images, RunData? runData)
        createPost,
    required TResult Function(String postId, String userId) likePost,
    required TResult Function(String postId, String userId) unlikePost,
    required TResult Function(String postId, String content) addComment,
    required TResult Function(String postId, String commentId) deleteComment,
    required TResult Function(String postId) sharePost,
  }) {
    return unlikePost(postId, userId);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loadPosts,
    TResult? Function()? refreshPosts,
    TResult? Function(String content, List<String>? images, RunData? runData)?
        createPost,
    TResult? Function(String postId, String userId)? likePost,
    TResult? Function(String postId, String userId)? unlikePost,
    TResult? Function(String postId, String content)? addComment,
    TResult? Function(String postId, String commentId)? deleteComment,
    TResult? Function(String postId)? sharePost,
  }) {
    return unlikePost?.call(postId, userId);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loadPosts,
    TResult Function()? refreshPosts,
    TResult Function(String content, List<String>? images, RunData? runData)?
        createPost,
    TResult Function(String postId, String userId)? likePost,
    TResult Function(String postId, String userId)? unlikePost,
    TResult Function(String postId, String content)? addComment,
    TResult Function(String postId, String commentId)? deleteComment,
    TResult Function(String postId)? sharePost,
    required TResult orElse(),
  }) {
    if (unlikePost != null) {
      return unlikePost(postId, userId);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_LoadPosts value) loadPosts,
    required TResult Function(_RefreshPosts value) refreshPosts,
    required TResult Function(_CreatePost value) createPost,
    required TResult Function(_LikePost value) likePost,
    required TResult Function(_UnlikePost value) unlikePost,
    required TResult Function(_AddComment value) addComment,
    required TResult Function(_DeleteComment value) deleteComment,
    required TResult Function(_SharePost value) sharePost,
  }) {
    return unlikePost(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_LoadPosts value)? loadPosts,
    TResult? Function(_RefreshPosts value)? refreshPosts,
    TResult? Function(_CreatePost value)? createPost,
    TResult? Function(_LikePost value)? likePost,
    TResult? Function(_UnlikePost value)? unlikePost,
    TResult? Function(_AddComment value)? addComment,
    TResult? Function(_DeleteComment value)? deleteComment,
    TResult? Function(_SharePost value)? sharePost,
  }) {
    return unlikePost?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_LoadPosts value)? loadPosts,
    TResult Function(_RefreshPosts value)? refreshPosts,
    TResult Function(_CreatePost value)? createPost,
    TResult Function(_LikePost value)? likePost,
    TResult Function(_UnlikePost value)? unlikePost,
    TResult Function(_AddComment value)? addComment,
    TResult Function(_DeleteComment value)? deleteComment,
    TResult Function(_SharePost value)? sharePost,
    required TResult orElse(),
  }) {
    if (unlikePost != null) {
      return unlikePost(this);
    }
    return orElse();
  }
}

abstract class _UnlikePost implements FeedEvent {
  const factory _UnlikePost(
      {required final String postId,
      required final String userId}) = _$UnlikePostImpl;

  String get postId;
  String get userId;

  /// Create a copy of FeedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UnlikePostImplCopyWith<_$UnlikePostImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$AddCommentImplCopyWith<$Res> {
  factory _$$AddCommentImplCopyWith(
          _$AddCommentImpl value, $Res Function(_$AddCommentImpl) then) =
      __$$AddCommentImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String postId, String content});
}

/// @nodoc
class __$$AddCommentImplCopyWithImpl<$Res>
    extends _$FeedEventCopyWithImpl<$Res, _$AddCommentImpl>
    implements _$$AddCommentImplCopyWith<$Res> {
  __$$AddCommentImplCopyWithImpl(
      _$AddCommentImpl _value, $Res Function(_$AddCommentImpl) _then)
      : super(_value, _then);

  /// Create a copy of FeedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? postId = null,
    Object? content = null,
  }) {
    return _then(_$AddCommentImpl(
      postId: null == postId
          ? _value.postId
          : postId // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$AddCommentImpl implements _AddComment {
  const _$AddCommentImpl({required this.postId, required this.content});

  @override
  final String postId;
  @override
  final String content;

  @override
  String toString() {
    return 'FeedEvent.addComment(postId: $postId, content: $content)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AddCommentImpl &&
            (identical(other.postId, postId) || other.postId == postId) &&
            (identical(other.content, content) || other.content == content));
  }

  @override
  int get hashCode => Object.hash(runtimeType, postId, content);

  /// Create a copy of FeedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AddCommentImplCopyWith<_$AddCommentImpl> get copyWith =>
      __$$AddCommentImplCopyWithImpl<_$AddCommentImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loadPosts,
    required TResult Function() refreshPosts,
    required TResult Function(
            String content, List<String>? images, RunData? runData)
        createPost,
    required TResult Function(String postId, String userId) likePost,
    required TResult Function(String postId, String userId) unlikePost,
    required TResult Function(String postId, String content) addComment,
    required TResult Function(String postId, String commentId) deleteComment,
    required TResult Function(String postId) sharePost,
  }) {
    return addComment(postId, content);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loadPosts,
    TResult? Function()? refreshPosts,
    TResult? Function(String content, List<String>? images, RunData? runData)?
        createPost,
    TResult? Function(String postId, String userId)? likePost,
    TResult? Function(String postId, String userId)? unlikePost,
    TResult? Function(String postId, String content)? addComment,
    TResult? Function(String postId, String commentId)? deleteComment,
    TResult? Function(String postId)? sharePost,
  }) {
    return addComment?.call(postId, content);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loadPosts,
    TResult Function()? refreshPosts,
    TResult Function(String content, List<String>? images, RunData? runData)?
        createPost,
    TResult Function(String postId, String userId)? likePost,
    TResult Function(String postId, String userId)? unlikePost,
    TResult Function(String postId, String content)? addComment,
    TResult Function(String postId, String commentId)? deleteComment,
    TResult Function(String postId)? sharePost,
    required TResult orElse(),
  }) {
    if (addComment != null) {
      return addComment(postId, content);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_LoadPosts value) loadPosts,
    required TResult Function(_RefreshPosts value) refreshPosts,
    required TResult Function(_CreatePost value) createPost,
    required TResult Function(_LikePost value) likePost,
    required TResult Function(_UnlikePost value) unlikePost,
    required TResult Function(_AddComment value) addComment,
    required TResult Function(_DeleteComment value) deleteComment,
    required TResult Function(_SharePost value) sharePost,
  }) {
    return addComment(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_LoadPosts value)? loadPosts,
    TResult? Function(_RefreshPosts value)? refreshPosts,
    TResult? Function(_CreatePost value)? createPost,
    TResult? Function(_LikePost value)? likePost,
    TResult? Function(_UnlikePost value)? unlikePost,
    TResult? Function(_AddComment value)? addComment,
    TResult? Function(_DeleteComment value)? deleteComment,
    TResult? Function(_SharePost value)? sharePost,
  }) {
    return addComment?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_LoadPosts value)? loadPosts,
    TResult Function(_RefreshPosts value)? refreshPosts,
    TResult Function(_CreatePost value)? createPost,
    TResult Function(_LikePost value)? likePost,
    TResult Function(_UnlikePost value)? unlikePost,
    TResult Function(_AddComment value)? addComment,
    TResult Function(_DeleteComment value)? deleteComment,
    TResult Function(_SharePost value)? sharePost,
    required TResult orElse(),
  }) {
    if (addComment != null) {
      return addComment(this);
    }
    return orElse();
  }
}

abstract class _AddComment implements FeedEvent {
  const factory _AddComment(
      {required final String postId,
      required final String content}) = _$AddCommentImpl;

  String get postId;
  String get content;

  /// Create a copy of FeedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AddCommentImplCopyWith<_$AddCommentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$DeleteCommentImplCopyWith<$Res> {
  factory _$$DeleteCommentImplCopyWith(
          _$DeleteCommentImpl value, $Res Function(_$DeleteCommentImpl) then) =
      __$$DeleteCommentImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String postId, String commentId});
}

/// @nodoc
class __$$DeleteCommentImplCopyWithImpl<$Res>
    extends _$FeedEventCopyWithImpl<$Res, _$DeleteCommentImpl>
    implements _$$DeleteCommentImplCopyWith<$Res> {
  __$$DeleteCommentImplCopyWithImpl(
      _$DeleteCommentImpl _value, $Res Function(_$DeleteCommentImpl) _then)
      : super(_value, _then);

  /// Create a copy of FeedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? postId = null,
    Object? commentId = null,
  }) {
    return _then(_$DeleteCommentImpl(
      postId: null == postId
          ? _value.postId
          : postId // ignore: cast_nullable_to_non_nullable
              as String,
      commentId: null == commentId
          ? _value.commentId
          : commentId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$DeleteCommentImpl implements _DeleteComment {
  const _$DeleteCommentImpl({required this.postId, required this.commentId});

  @override
  final String postId;
  @override
  final String commentId;

  @override
  String toString() {
    return 'FeedEvent.deleteComment(postId: $postId, commentId: $commentId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DeleteCommentImpl &&
            (identical(other.postId, postId) || other.postId == postId) &&
            (identical(other.commentId, commentId) ||
                other.commentId == commentId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, postId, commentId);

  /// Create a copy of FeedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DeleteCommentImplCopyWith<_$DeleteCommentImpl> get copyWith =>
      __$$DeleteCommentImplCopyWithImpl<_$DeleteCommentImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loadPosts,
    required TResult Function() refreshPosts,
    required TResult Function(
            String content, List<String>? images, RunData? runData)
        createPost,
    required TResult Function(String postId, String userId) likePost,
    required TResult Function(String postId, String userId) unlikePost,
    required TResult Function(String postId, String content) addComment,
    required TResult Function(String postId, String commentId) deleteComment,
    required TResult Function(String postId) sharePost,
  }) {
    return deleteComment(postId, commentId);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loadPosts,
    TResult? Function()? refreshPosts,
    TResult? Function(String content, List<String>? images, RunData? runData)?
        createPost,
    TResult? Function(String postId, String userId)? likePost,
    TResult? Function(String postId, String userId)? unlikePost,
    TResult? Function(String postId, String content)? addComment,
    TResult? Function(String postId, String commentId)? deleteComment,
    TResult? Function(String postId)? sharePost,
  }) {
    return deleteComment?.call(postId, commentId);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loadPosts,
    TResult Function()? refreshPosts,
    TResult Function(String content, List<String>? images, RunData? runData)?
        createPost,
    TResult Function(String postId, String userId)? likePost,
    TResult Function(String postId, String userId)? unlikePost,
    TResult Function(String postId, String content)? addComment,
    TResult Function(String postId, String commentId)? deleteComment,
    TResult Function(String postId)? sharePost,
    required TResult orElse(),
  }) {
    if (deleteComment != null) {
      return deleteComment(postId, commentId);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_LoadPosts value) loadPosts,
    required TResult Function(_RefreshPosts value) refreshPosts,
    required TResult Function(_CreatePost value) createPost,
    required TResult Function(_LikePost value) likePost,
    required TResult Function(_UnlikePost value) unlikePost,
    required TResult Function(_AddComment value) addComment,
    required TResult Function(_DeleteComment value) deleteComment,
    required TResult Function(_SharePost value) sharePost,
  }) {
    return deleteComment(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_LoadPosts value)? loadPosts,
    TResult? Function(_RefreshPosts value)? refreshPosts,
    TResult? Function(_CreatePost value)? createPost,
    TResult? Function(_LikePost value)? likePost,
    TResult? Function(_UnlikePost value)? unlikePost,
    TResult? Function(_AddComment value)? addComment,
    TResult? Function(_DeleteComment value)? deleteComment,
    TResult? Function(_SharePost value)? sharePost,
  }) {
    return deleteComment?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_LoadPosts value)? loadPosts,
    TResult Function(_RefreshPosts value)? refreshPosts,
    TResult Function(_CreatePost value)? createPost,
    TResult Function(_LikePost value)? likePost,
    TResult Function(_UnlikePost value)? unlikePost,
    TResult Function(_AddComment value)? addComment,
    TResult Function(_DeleteComment value)? deleteComment,
    TResult Function(_SharePost value)? sharePost,
    required TResult orElse(),
  }) {
    if (deleteComment != null) {
      return deleteComment(this);
    }
    return orElse();
  }
}

abstract class _DeleteComment implements FeedEvent {
  const factory _DeleteComment(
      {required final String postId,
      required final String commentId}) = _$DeleteCommentImpl;

  String get postId;
  String get commentId;

  /// Create a copy of FeedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DeleteCommentImplCopyWith<_$DeleteCommentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$SharePostImplCopyWith<$Res> {
  factory _$$SharePostImplCopyWith(
          _$SharePostImpl value, $Res Function(_$SharePostImpl) then) =
      __$$SharePostImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String postId});
}

/// @nodoc
class __$$SharePostImplCopyWithImpl<$Res>
    extends _$FeedEventCopyWithImpl<$Res, _$SharePostImpl>
    implements _$$SharePostImplCopyWith<$Res> {
  __$$SharePostImplCopyWithImpl(
      _$SharePostImpl _value, $Res Function(_$SharePostImpl) _then)
      : super(_value, _then);

  /// Create a copy of FeedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? postId = null,
  }) {
    return _then(_$SharePostImpl(
      postId: null == postId
          ? _value.postId
          : postId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$SharePostImpl implements _SharePost {
  const _$SharePostImpl({required this.postId});

  @override
  final String postId;

  @override
  String toString() {
    return 'FeedEvent.sharePost(postId: $postId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SharePostImpl &&
            (identical(other.postId, postId) || other.postId == postId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, postId);

  /// Create a copy of FeedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SharePostImplCopyWith<_$SharePostImpl> get copyWith =>
      __$$SharePostImplCopyWithImpl<_$SharePostImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loadPosts,
    required TResult Function() refreshPosts,
    required TResult Function(
            String content, List<String>? images, RunData? runData)
        createPost,
    required TResult Function(String postId, String userId) likePost,
    required TResult Function(String postId, String userId) unlikePost,
    required TResult Function(String postId, String content) addComment,
    required TResult Function(String postId, String commentId) deleteComment,
    required TResult Function(String postId) sharePost,
  }) {
    return sharePost(postId);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loadPosts,
    TResult? Function()? refreshPosts,
    TResult? Function(String content, List<String>? images, RunData? runData)?
        createPost,
    TResult? Function(String postId, String userId)? likePost,
    TResult? Function(String postId, String userId)? unlikePost,
    TResult? Function(String postId, String content)? addComment,
    TResult? Function(String postId, String commentId)? deleteComment,
    TResult? Function(String postId)? sharePost,
  }) {
    return sharePost?.call(postId);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loadPosts,
    TResult Function()? refreshPosts,
    TResult Function(String content, List<String>? images, RunData? runData)?
        createPost,
    TResult Function(String postId, String userId)? likePost,
    TResult Function(String postId, String userId)? unlikePost,
    TResult Function(String postId, String content)? addComment,
    TResult Function(String postId, String commentId)? deleteComment,
    TResult Function(String postId)? sharePost,
    required TResult orElse(),
  }) {
    if (sharePost != null) {
      return sharePost(postId);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_LoadPosts value) loadPosts,
    required TResult Function(_RefreshPosts value) refreshPosts,
    required TResult Function(_CreatePost value) createPost,
    required TResult Function(_LikePost value) likePost,
    required TResult Function(_UnlikePost value) unlikePost,
    required TResult Function(_AddComment value) addComment,
    required TResult Function(_DeleteComment value) deleteComment,
    required TResult Function(_SharePost value) sharePost,
  }) {
    return sharePost(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_LoadPosts value)? loadPosts,
    TResult? Function(_RefreshPosts value)? refreshPosts,
    TResult? Function(_CreatePost value)? createPost,
    TResult? Function(_LikePost value)? likePost,
    TResult? Function(_UnlikePost value)? unlikePost,
    TResult? Function(_AddComment value)? addComment,
    TResult? Function(_DeleteComment value)? deleteComment,
    TResult? Function(_SharePost value)? sharePost,
  }) {
    return sharePost?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_LoadPosts value)? loadPosts,
    TResult Function(_RefreshPosts value)? refreshPosts,
    TResult Function(_CreatePost value)? createPost,
    TResult Function(_LikePost value)? likePost,
    TResult Function(_UnlikePost value)? unlikePost,
    TResult Function(_AddComment value)? addComment,
    TResult Function(_DeleteComment value)? deleteComment,
    TResult Function(_SharePost value)? sharePost,
    required TResult orElse(),
  }) {
    if (sharePost != null) {
      return sharePost(this);
    }
    return orElse();
  }
}

abstract class _SharePost implements FeedEvent {
  const factory _SharePost({required final String postId}) = _$SharePostImpl;

  String get postId;

  /// Create a copy of FeedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SharePostImplCopyWith<_$SharePostImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$FeedState {
  List<Post> get posts => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  bool get isSubmitting => throw _privateConstructorUsedError;
  bool get hasMore => throw _privateConstructorUsedError;
  int get currentPage => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;

  /// Create a copy of FeedState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FeedStateCopyWith<FeedState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FeedStateCopyWith<$Res> {
  factory $FeedStateCopyWith(FeedState value, $Res Function(FeedState) then) =
      _$FeedStateCopyWithImpl<$Res, FeedState>;
  @useResult
  $Res call(
      {List<Post> posts,
      bool isLoading,
      bool isSubmitting,
      bool hasMore,
      int currentPage,
      String? error});
}

/// @nodoc
class _$FeedStateCopyWithImpl<$Res, $Val extends FeedState>
    implements $FeedStateCopyWith<$Res> {
  _$FeedStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FeedState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? posts = null,
    Object? isLoading = null,
    Object? isSubmitting = null,
    Object? hasMore = null,
    Object? currentPage = null,
    Object? error = freezed,
  }) {
    return _then(_value.copyWith(
      posts: null == posts
          ? _value.posts
          : posts // ignore: cast_nullable_to_non_nullable
              as List<Post>,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isSubmitting: null == isSubmitting
          ? _value.isSubmitting
          : isSubmitting // ignore: cast_nullable_to_non_nullable
              as bool,
      hasMore: null == hasMore
          ? _value.hasMore
          : hasMore // ignore: cast_nullable_to_non_nullable
              as bool,
      currentPage: null == currentPage
          ? _value.currentPage
          : currentPage // ignore: cast_nullable_to_non_nullable
              as int,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FeedStateImplCopyWith<$Res>
    implements $FeedStateCopyWith<$Res> {
  factory _$$FeedStateImplCopyWith(
          _$FeedStateImpl value, $Res Function(_$FeedStateImpl) then) =
      __$$FeedStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<Post> posts,
      bool isLoading,
      bool isSubmitting,
      bool hasMore,
      int currentPage,
      String? error});
}

/// @nodoc
class __$$FeedStateImplCopyWithImpl<$Res>
    extends _$FeedStateCopyWithImpl<$Res, _$FeedStateImpl>
    implements _$$FeedStateImplCopyWith<$Res> {
  __$$FeedStateImplCopyWithImpl(
      _$FeedStateImpl _value, $Res Function(_$FeedStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of FeedState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? posts = null,
    Object? isLoading = null,
    Object? isSubmitting = null,
    Object? hasMore = null,
    Object? currentPage = null,
    Object? error = freezed,
  }) {
    return _then(_$FeedStateImpl(
      posts: null == posts
          ? _value._posts
          : posts // ignore: cast_nullable_to_non_nullable
              as List<Post>,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isSubmitting: null == isSubmitting
          ? _value.isSubmitting
          : isSubmitting // ignore: cast_nullable_to_non_nullable
              as bool,
      hasMore: null == hasMore
          ? _value.hasMore
          : hasMore // ignore: cast_nullable_to_non_nullable
              as bool,
      currentPage: null == currentPage
          ? _value.currentPage
          : currentPage // ignore: cast_nullable_to_non_nullable
              as int,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$FeedStateImpl implements _FeedState {
  const _$FeedStateImpl(
      {final List<Post> posts = const [],
      this.isLoading = false,
      this.isSubmitting = false,
      this.hasMore = true,
      this.currentPage = 0,
      this.error})
      : _posts = posts;

  final List<Post> _posts;
  @override
  @JsonKey()
  List<Post> get posts {
    if (_posts is EqualUnmodifiableListView) return _posts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_posts);
  }

  @override
  @JsonKey()
  final bool isLoading;
  @override
  @JsonKey()
  final bool isSubmitting;
  @override
  @JsonKey()
  final bool hasMore;
  @override
  @JsonKey()
  final int currentPage;
  @override
  final String? error;

  @override
  String toString() {
    return 'FeedState(posts: $posts, isLoading: $isLoading, isSubmitting: $isSubmitting, hasMore: $hasMore, currentPage: $currentPage, error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FeedStateImpl &&
            const DeepCollectionEquality().equals(other._posts, _posts) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.isSubmitting, isSubmitting) ||
                other.isSubmitting == isSubmitting) &&
            (identical(other.hasMore, hasMore) || other.hasMore == hasMore) &&
            (identical(other.currentPage, currentPage) ||
                other.currentPage == currentPage) &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_posts),
      isLoading,
      isSubmitting,
      hasMore,
      currentPage,
      error);

  /// Create a copy of FeedState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FeedStateImplCopyWith<_$FeedStateImpl> get copyWith =>
      __$$FeedStateImplCopyWithImpl<_$FeedStateImpl>(this, _$identity);
}

abstract class _FeedState implements FeedState {
  const factory _FeedState(
      {final List<Post> posts,
      final bool isLoading,
      final bool isSubmitting,
      final bool hasMore,
      final int currentPage,
      final String? error}) = _$FeedStateImpl;

  @override
  List<Post> get posts;
  @override
  bool get isLoading;
  @override
  bool get isSubmitting;
  @override
  bool get hasMore;
  @override
  int get currentPage;
  @override
  String? get error;

  /// Create a copy of FeedState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FeedStateImplCopyWith<_$FeedStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
