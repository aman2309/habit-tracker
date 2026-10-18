// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_name_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$UserNameState {

 LoadStatus get status; bool get isSaving; String get name; Failure? get failure;
/// Create a copy of UserNameState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserNameStateCopyWith<UserNameState> get copyWith => _$UserNameStateCopyWithImpl<UserNameState>(this as UserNameState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserNameState&&(identical(other.status, status) || other.status == status)&&(identical(other.isSaving, isSaving) || other.isSaving == isSaving)&&(identical(other.name, name) || other.name == name)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,status,isSaving,name,failure);

@override
String toString() {
  return 'UserNameState(status: $status, isSaving: $isSaving, name: $name, failure: $failure)';
}


}

/// @nodoc
abstract mixin class $UserNameStateCopyWith<$Res>  {
  factory $UserNameStateCopyWith(UserNameState value, $Res Function(UserNameState) _then) = _$UserNameStateCopyWithImpl;
@useResult
$Res call({
 LoadStatus status, bool isSaving, String name, Failure? failure
});




}
/// @nodoc
class _$UserNameStateCopyWithImpl<$Res>
    implements $UserNameStateCopyWith<$Res> {
  _$UserNameStateCopyWithImpl(this._self, this._then);

  final UserNameState _self;
  final $Res Function(UserNameState) _then;

/// Create a copy of UserNameState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? isSaving = null,Object? name = null,Object? failure = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LoadStatus,isSaving: null == isSaving ? _self.isSaving : isSaving // ignore: cast_nullable_to_non_nullable
as bool,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}

}


/// Adds pattern-matching-related methods to [UserNameState].
extension UserNameStatePatterns on UserNameState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserNameState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserNameState() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserNameState value)  $default,){
final _that = this;
switch (_that) {
case _UserNameState():
return $default(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserNameState value)?  $default,){
final _that = this;
switch (_that) {
case _UserNameState() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( LoadStatus status,  bool isSaving,  String name,  Failure? failure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserNameState() when $default != null:
return $default(_that.status,_that.isSaving,_that.name,_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( LoadStatus status,  bool isSaving,  String name,  Failure? failure)  $default,) {final _that = this;
switch (_that) {
case _UserNameState():
return $default(_that.status,_that.isSaving,_that.name,_that.failure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( LoadStatus status,  bool isSaving,  String name,  Failure? failure)?  $default,) {final _that = this;
switch (_that) {
case _UserNameState() when $default != null:
return $default(_that.status,_that.isSaving,_that.name,_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class _UserNameState extends UserNameState {
  const _UserNameState({this.status = LoadStatus.initial, this.isSaving = false, this.name = '', this.failure}): super._();
  

@override@JsonKey() final  LoadStatus status;
@override@JsonKey() final  bool isSaving;
@override@JsonKey() final  String name;
@override final  Failure? failure;

/// Create a copy of UserNameState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserNameStateCopyWith<_UserNameState> get copyWith => __$UserNameStateCopyWithImpl<_UserNameState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserNameState&&(identical(other.status, status) || other.status == status)&&(identical(other.isSaving, isSaving) || other.isSaving == isSaving)&&(identical(other.name, name) || other.name == name)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,status,isSaving,name,failure);

@override
String toString() {
  return 'UserNameState(status: $status, isSaving: $isSaving, name: $name, failure: $failure)';
}


}

/// @nodoc
abstract mixin class _$UserNameStateCopyWith<$Res> implements $UserNameStateCopyWith<$Res> {
  factory _$UserNameStateCopyWith(_UserNameState value, $Res Function(_UserNameState) _then) = __$UserNameStateCopyWithImpl;
@override @useResult
$Res call({
 LoadStatus status, bool isSaving, String name, Failure? failure
});




}
/// @nodoc
class __$UserNameStateCopyWithImpl<$Res>
    implements _$UserNameStateCopyWith<$Res> {
  __$UserNameStateCopyWithImpl(this._self, this._then);

  final _UserNameState _self;
  final $Res Function(_UserNameState) _then;

/// Create a copy of UserNameState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? isSaving = null,Object? name = null,Object? failure = freezed,}) {
  return _then(_UserNameState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LoadStatus,isSaving: null == isSaving ? _self.isSaving : isSaving // ignore: cast_nullable_to_non_nullable
as bool,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}


}

// dart format on
