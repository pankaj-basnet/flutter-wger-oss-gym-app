// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pull_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PullRequest {

 int get id; int get number; String get title; String get body; String get state; String get htmlUrl; DateTime get createdAt; DateTime get updatedAt; DateTime? get mergedAt; DateTime? get closedAt; GithubUser get user; List<PrLabel> get labels; int get commentsCount; bool get draft;
/// Create a copy of PullRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PullRequestCopyWith<PullRequest> get copyWith => _$PullRequestCopyWithImpl<PullRequest>(this as PullRequest, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PullRequest&&(identical(other.id, id) || other.id == id)&&(identical(other.number, number) || other.number == number)&&(identical(other.title, title) || other.title == title)&&(identical(other.body, body) || other.body == body)&&(identical(other.state, state) || other.state == state)&&(identical(other.htmlUrl, htmlUrl) || other.htmlUrl == htmlUrl)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.mergedAt, mergedAt) || other.mergedAt == mergedAt)&&(identical(other.closedAt, closedAt) || other.closedAt == closedAt)&&(identical(other.user, user) || other.user == user)&&const DeepCollectionEquality().equals(other.labels, labels)&&(identical(other.commentsCount, commentsCount) || other.commentsCount == commentsCount)&&(identical(other.draft, draft) || other.draft == draft));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,number,title,body,state,htmlUrl,createdAt,updatedAt,mergedAt,closedAt,user,const DeepCollectionEquality().hash(labels),commentsCount,draft);

@override
String toString() {
  return 'PullRequest(id: $id, number: $number, title: $title, body: $body, state: $state, htmlUrl: $htmlUrl, createdAt: $createdAt, updatedAt: $updatedAt, mergedAt: $mergedAt, closedAt: $closedAt, user: $user, labels: $labels, commentsCount: $commentsCount, draft: $draft)';
}


}

/// @nodoc
abstract mixin class $PullRequestCopyWith<$Res>  {
  factory $PullRequestCopyWith(PullRequest value, $Res Function(PullRequest) _then) = _$PullRequestCopyWithImpl;
@useResult
$Res call({
 int id, int number, String title, String body, String state, String htmlUrl, DateTime createdAt, DateTime updatedAt, DateTime? mergedAt, DateTime? closedAt, GithubUser user, List<PrLabel> labels, int commentsCount, bool draft
});




}
/// @nodoc
class _$PullRequestCopyWithImpl<$Res>
    implements $PullRequestCopyWith<$Res> {
  _$PullRequestCopyWithImpl(this._self, this._then);

  final PullRequest _self;
  final $Res Function(PullRequest) _then;

/// Create a copy of PullRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? number = null,Object? title = null,Object? body = null,Object? state = null,Object? htmlUrl = null,Object? createdAt = null,Object? updatedAt = null,Object? mergedAt = freezed,Object? closedAt = freezed,Object? user = null,Object? labels = null,Object? commentsCount = null,Object? draft = null,}) {
  return _then(PullRequest(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,number: null == number ? _self.number : number // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,state: null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as String,htmlUrl: null == htmlUrl ? _self.htmlUrl : htmlUrl // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,mergedAt: freezed == mergedAt ? _self.mergedAt : mergedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,closedAt: freezed == closedAt ? _self.closedAt : closedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,user: null == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as GithubUser,labels: null == labels ? _self.labels : labels // ignore: cast_nullable_to_non_nullable
as List<PrLabel>,commentsCount: null == commentsCount ? _self.commentsCount : commentsCount // ignore: cast_nullable_to_non_nullable
as int,draft: null == draft ? _self.draft : draft // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [PullRequest].
extension PullRequestPatterns on PullRequest {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({required TResult orElse(),}){
final _that = this;
switch (_that) {
case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(){
final _that = this;
switch (_that) {
case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(){
final _that = this;
switch (_that) {
case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({required TResult orElse(),}) {final _that = this;
switch (_that) {
case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>() {final _that = this;
switch (_that) {
case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>() {final _that = this;
switch (_that) {
case _:
  return null;

}
}

}

// dart format on
