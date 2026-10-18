// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'edit_habit_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$EditHabitState {

 LoadStatus get status; Habit? get habit; Failure? get failure; bool get isSaving; bool get isSaved;
/// Create a copy of EditHabitState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EditHabitStateCopyWith<EditHabitState> get copyWith => _$EditHabitStateCopyWithImpl<EditHabitState>(this as EditHabitState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EditHabitState&&(identical(other.status, status) || other.status == status)&&(identical(other.habit, habit) || other.habit == habit)&&(identical(other.failure, failure) || other.failure == failure)&&(identical(other.isSaving, isSaving) || other.isSaving == isSaving)&&(identical(other.isSaved, isSaved) || other.isSaved == isSaved));
}


@override
int get hashCode => Object.hash(runtimeType,status,habit,failure,isSaving,isSaved);

@override
String toString() {
  return 'EditHabitState(status: $status, habit: $habit, failure: $failure, isSaving: $isSaving, isSaved: $isSaved)';
}


}

/// @nodoc
abstract mixin class $EditHabitStateCopyWith<$Res>  {
  factory $EditHabitStateCopyWith(EditHabitState value, $Res Function(EditHabitState) _then) = _$EditHabitStateCopyWithImpl;
@useResult
$Res call({
 LoadStatus status, Habit? habit, Failure? failure, bool isSaving, bool isSaved
});


$HabitCopyWith<$Res>? get habit;

}
/// @nodoc
class _$EditHabitStateCopyWithImpl<$Res>
    implements $EditHabitStateCopyWith<$Res> {
  _$EditHabitStateCopyWithImpl(this._self, this._then);

  final EditHabitState _self;
  final $Res Function(EditHabitState) _then;

/// Create a copy of EditHabitState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? habit = freezed,Object? failure = freezed,Object? isSaving = null,Object? isSaved = null,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LoadStatus,habit: freezed == habit ? _self.habit : habit // ignore: cast_nullable_to_non_nullable
as Habit?,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,isSaving: null == isSaving ? _self.isSaving : isSaving // ignore: cast_nullable_to_non_nullable
as bool,isSaved: null == isSaved ? _self.isSaved : isSaved // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of EditHabitState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$HabitCopyWith<$Res>? get habit {
    if (_self.habit == null) {
    return null;
  }

  return $HabitCopyWith<$Res>(_self.habit!, (value) {
    return _then(_self.copyWith(habit: value));
  });
}
}


/// Adds pattern-matching-related methods to [EditHabitState].
extension EditHabitStatePatterns on EditHabitState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EditHabitState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EditHabitState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EditHabitState value)  $default,){
final _that = this;
switch (_that) {
case _EditHabitState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EditHabitState value)?  $default,){
final _that = this;
switch (_that) {
case _EditHabitState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( LoadStatus status,  Habit? habit,  Failure? failure,  bool isSaving,  bool isSaved)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EditHabitState() when $default != null:
return $default(_that.status,_that.habit,_that.failure,_that.isSaving,_that.isSaved);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( LoadStatus status,  Habit? habit,  Failure? failure,  bool isSaving,  bool isSaved)  $default,) {final _that = this;
switch (_that) {
case _EditHabitState():
return $default(_that.status,_that.habit,_that.failure,_that.isSaving,_that.isSaved);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( LoadStatus status,  Habit? habit,  Failure? failure,  bool isSaving,  bool isSaved)?  $default,) {final _that = this;
switch (_that) {
case _EditHabitState() when $default != null:
return $default(_that.status,_that.habit,_that.failure,_that.isSaving,_that.isSaved);case _:
  return null;

}
}

}

/// @nodoc


class _EditHabitState extends EditHabitState {
  const _EditHabitState({this.status = LoadStatus.initial, this.habit, this.failure, this.isSaving = false, this.isSaved = false}): super._();
  

@override@JsonKey() final  LoadStatus status;
@override final  Habit? habit;
@override final  Failure? failure;
@override@JsonKey() final  bool isSaving;
@override@JsonKey() final  bool isSaved;

/// Create a copy of EditHabitState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EditHabitStateCopyWith<_EditHabitState> get copyWith => __$EditHabitStateCopyWithImpl<_EditHabitState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EditHabitState&&(identical(other.status, status) || other.status == status)&&(identical(other.habit, habit) || other.habit == habit)&&(identical(other.failure, failure) || other.failure == failure)&&(identical(other.isSaving, isSaving) || other.isSaving == isSaving)&&(identical(other.isSaved, isSaved) || other.isSaved == isSaved));
}


@override
int get hashCode => Object.hash(runtimeType,status,habit,failure,isSaving,isSaved);

@override
String toString() {
  return 'EditHabitState(status: $status, habit: $habit, failure: $failure, isSaving: $isSaving, isSaved: $isSaved)';
}


}

/// @nodoc
abstract mixin class _$EditHabitStateCopyWith<$Res> implements $EditHabitStateCopyWith<$Res> {
  factory _$EditHabitStateCopyWith(_EditHabitState value, $Res Function(_EditHabitState) _then) = __$EditHabitStateCopyWithImpl;
@override @useResult
$Res call({
 LoadStatus status, Habit? habit, Failure? failure, bool isSaving, bool isSaved
});


@override $HabitCopyWith<$Res>? get habit;

}
/// @nodoc
class __$EditHabitStateCopyWithImpl<$Res>
    implements _$EditHabitStateCopyWith<$Res> {
  __$EditHabitStateCopyWithImpl(this._self, this._then);

  final _EditHabitState _self;
  final $Res Function(_EditHabitState) _then;

/// Create a copy of EditHabitState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? habit = freezed,Object? failure = freezed,Object? isSaving = null,Object? isSaved = null,}) {
  return _then(_EditHabitState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LoadStatus,habit: freezed == habit ? _self.habit : habit // ignore: cast_nullable_to_non_nullable
as Habit?,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,isSaving: null == isSaving ? _self.isSaving : isSaving // ignore: cast_nullable_to_non_nullable
as bool,isSaved: null == isSaved ? _self.isSaved : isSaved // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of EditHabitState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$HabitCopyWith<$Res>? get habit {
    if (_self.habit == null) {
    return null;
  }

  return $HabitCopyWith<$Res>(_self.habit!, (value) {
    return _then(_self.copyWith(habit: value));
  });
}
}

// dart format on
