// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'add_habit_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AddHabitState {

 LoadStatus get status; Failure? get failure;
/// Create a copy of AddHabitState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AddHabitStateCopyWith<AddHabitState> get copyWith => _$AddHabitStateCopyWithImpl<AddHabitState>(this as AddHabitState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AddHabitState&&(identical(other.status, status) || other.status == status)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,status,failure);

@override
String toString() {
  return 'AddHabitState(status: $status, failure: $failure)';
}


}

/// @nodoc
abstract mixin class $AddHabitStateCopyWith<$Res>  {
  factory $AddHabitStateCopyWith(AddHabitState value, $Res Function(AddHabitState) _then) = _$AddHabitStateCopyWithImpl;
@useResult
$Res call({
 LoadStatus status, Failure? failure
});




}
/// @nodoc
class _$AddHabitStateCopyWithImpl<$Res>
    implements $AddHabitStateCopyWith<$Res> {
  _$AddHabitStateCopyWithImpl(this._self, this._then);

  final AddHabitState _self;
  final $Res Function(AddHabitState) _then;

/// Create a copy of AddHabitState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? failure = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LoadStatus,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}

}


/// Adds pattern-matching-related methods to [AddHabitState].
extension AddHabitStatePatterns on AddHabitState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AddHabitState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AddHabitState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AddHabitState value)  $default,){
final _that = this;
switch (_that) {
case _AddHabitState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AddHabitState value)?  $default,){
final _that = this;
switch (_that) {
case _AddHabitState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( LoadStatus status,  Failure? failure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AddHabitState() when $default != null:
return $default(_that.status,_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( LoadStatus status,  Failure? failure)  $default,) {final _that = this;
switch (_that) {
case _AddHabitState():
return $default(_that.status,_that.failure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( LoadStatus status,  Failure? failure)?  $default,) {final _that = this;
switch (_that) {
case _AddHabitState() when $default != null:
return $default(_that.status,_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class _AddHabitState extends AddHabitState {
  const _AddHabitState({this.status = LoadStatus.initial, this.failure}): super._();
  

@override@JsonKey() final  LoadStatus status;
@override final  Failure? failure;

/// Create a copy of AddHabitState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AddHabitStateCopyWith<_AddHabitState> get copyWith => __$AddHabitStateCopyWithImpl<_AddHabitState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AddHabitState&&(identical(other.status, status) || other.status == status)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,status,failure);

@override
String toString() {
  return 'AddHabitState(status: $status, failure: $failure)';
}


}

/// @nodoc
abstract mixin class _$AddHabitStateCopyWith<$Res> implements $AddHabitStateCopyWith<$Res> {
  factory _$AddHabitStateCopyWith(_AddHabitState value, $Res Function(_AddHabitState) _then) = __$AddHabitStateCopyWithImpl;
@override @useResult
$Res call({
 LoadStatus status, Failure? failure
});




}
/// @nodoc
class __$AddHabitStateCopyWithImpl<$Res>
    implements _$AddHabitStateCopyWith<$Res> {
  __$AddHabitStateCopyWithImpl(this._self, this._then);

  final _AddHabitState _self;
  final $Res Function(_AddHabitState) _then;

/// Create a copy of AddHabitState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? failure = freezed,}) {
  return _then(_AddHabitState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LoadStatus,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}


}

// dart format on
