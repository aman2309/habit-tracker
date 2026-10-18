// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'habit_day_status.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$HabitDayStatus {

 Habit get habit; DateTime get date; bool get completed;
/// Create a copy of HabitDayStatus
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HabitDayStatusCopyWith<HabitDayStatus> get copyWith => _$HabitDayStatusCopyWithImpl<HabitDayStatus>(this as HabitDayStatus, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HabitDayStatus&&(identical(other.habit, habit) || other.habit == habit)&&(identical(other.date, date) || other.date == date)&&(identical(other.completed, completed) || other.completed == completed));
}


@override
int get hashCode => Object.hash(runtimeType,habit,date,completed);

@override
String toString() {
  return 'HabitDayStatus(habit: $habit, date: $date, completed: $completed)';
}


}

/// @nodoc
abstract mixin class $HabitDayStatusCopyWith<$Res>  {
  factory $HabitDayStatusCopyWith(HabitDayStatus value, $Res Function(HabitDayStatus) _then) = _$HabitDayStatusCopyWithImpl;
@useResult
$Res call({
 Habit habit, DateTime date, bool completed
});


$HabitCopyWith<$Res> get habit;

}
/// @nodoc
class _$HabitDayStatusCopyWithImpl<$Res>
    implements $HabitDayStatusCopyWith<$Res> {
  _$HabitDayStatusCopyWithImpl(this._self, this._then);

  final HabitDayStatus _self;
  final $Res Function(HabitDayStatus) _then;

/// Create a copy of HabitDayStatus
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? habit = null,Object? date = null,Object? completed = null,}) {
  return _then(_self.copyWith(
habit: null == habit ? _self.habit : habit // ignore: cast_nullable_to_non_nullable
as Habit,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,completed: null == completed ? _self.completed : completed // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of HabitDayStatus
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$HabitCopyWith<$Res> get habit {
  
  return $HabitCopyWith<$Res>(_self.habit, (value) {
    return _then(_self.copyWith(habit: value));
  });
}
}


/// Adds pattern-matching-related methods to [HabitDayStatus].
extension HabitDayStatusPatterns on HabitDayStatus {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HabitDayStatus value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HabitDayStatus() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HabitDayStatus value)  $default,){
final _that = this;
switch (_that) {
case _HabitDayStatus():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HabitDayStatus value)?  $default,){
final _that = this;
switch (_that) {
case _HabitDayStatus() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Habit habit,  DateTime date,  bool completed)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HabitDayStatus() when $default != null:
return $default(_that.habit,_that.date,_that.completed);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Habit habit,  DateTime date,  bool completed)  $default,) {final _that = this;
switch (_that) {
case _HabitDayStatus():
return $default(_that.habit,_that.date,_that.completed);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Habit habit,  DateTime date,  bool completed)?  $default,) {final _that = this;
switch (_that) {
case _HabitDayStatus() when $default != null:
return $default(_that.habit,_that.date,_that.completed);case _:
  return null;

}
}

}

/// @nodoc


class _HabitDayStatus extends HabitDayStatus {
  const _HabitDayStatus({required this.habit, required this.date, required this.completed}): super._();
  

@override final  Habit habit;
@override final  DateTime date;
@override final  bool completed;

/// Create a copy of HabitDayStatus
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HabitDayStatusCopyWith<_HabitDayStatus> get copyWith => __$HabitDayStatusCopyWithImpl<_HabitDayStatus>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HabitDayStatus&&(identical(other.habit, habit) || other.habit == habit)&&(identical(other.date, date) || other.date == date)&&(identical(other.completed, completed) || other.completed == completed));
}


@override
int get hashCode => Object.hash(runtimeType,habit,date,completed);

@override
String toString() {
  return 'HabitDayStatus(habit: $habit, date: $date, completed: $completed)';
}


}

/// @nodoc
abstract mixin class _$HabitDayStatusCopyWith<$Res> implements $HabitDayStatusCopyWith<$Res> {
  factory _$HabitDayStatusCopyWith(_HabitDayStatus value, $Res Function(_HabitDayStatus) _then) = __$HabitDayStatusCopyWithImpl;
@override @useResult
$Res call({
 Habit habit, DateTime date, bool completed
});


@override $HabitCopyWith<$Res> get habit;

}
/// @nodoc
class __$HabitDayStatusCopyWithImpl<$Res>
    implements _$HabitDayStatusCopyWith<$Res> {
  __$HabitDayStatusCopyWithImpl(this._self, this._then);

  final _HabitDayStatus _self;
  final $Res Function(_HabitDayStatus) _then;

/// Create a copy of HabitDayStatus
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? habit = null,Object? date = null,Object? completed = null,}) {
  return _then(_HabitDayStatus(
habit: null == habit ? _self.habit : habit // ignore: cast_nullable_to_non_nullable
as Habit,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,completed: null == completed ? _self.completed : completed // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of HabitDayStatus
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$HabitCopyWith<$Res> get habit {
  
  return $HabitCopyWith<$Res>(_self.habit, (value) {
    return _then(_self.copyWith(habit: value));
  });
}
}

// dart format on
