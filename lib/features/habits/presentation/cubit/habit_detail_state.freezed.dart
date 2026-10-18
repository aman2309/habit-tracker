// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'habit_detail_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$HabitDetailState {

 String get habitId; LoadStatus get status; HabitDetail? get detail; Failure? get failure; bool get isToggling; bool get isDeleting; bool get isDeleted; String? get feedbackMessage;
/// Create a copy of HabitDetailState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HabitDetailStateCopyWith<HabitDetailState> get copyWith => _$HabitDetailStateCopyWithImpl<HabitDetailState>(this as HabitDetailState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HabitDetailState&&(identical(other.habitId, habitId) || other.habitId == habitId)&&(identical(other.status, status) || other.status == status)&&(identical(other.detail, detail) || other.detail == detail)&&(identical(other.failure, failure) || other.failure == failure)&&(identical(other.isToggling, isToggling) || other.isToggling == isToggling)&&(identical(other.isDeleting, isDeleting) || other.isDeleting == isDeleting)&&(identical(other.isDeleted, isDeleted) || other.isDeleted == isDeleted)&&(identical(other.feedbackMessage, feedbackMessage) || other.feedbackMessage == feedbackMessage));
}


@override
int get hashCode => Object.hash(runtimeType,habitId,status,detail,failure,isToggling,isDeleting,isDeleted,feedbackMessage);

@override
String toString() {
  return 'HabitDetailState(habitId: $habitId, status: $status, detail: $detail, failure: $failure, isToggling: $isToggling, isDeleting: $isDeleting, isDeleted: $isDeleted, feedbackMessage: $feedbackMessage)';
}


}

/// @nodoc
abstract mixin class $HabitDetailStateCopyWith<$Res>  {
  factory $HabitDetailStateCopyWith(HabitDetailState value, $Res Function(HabitDetailState) _then) = _$HabitDetailStateCopyWithImpl;
@useResult
$Res call({
 String habitId, LoadStatus status, HabitDetail? detail, Failure? failure, bool isToggling, bool isDeleting, bool isDeleted, String? feedbackMessage
});


$HabitDetailCopyWith<$Res>? get detail;

}
/// @nodoc
class _$HabitDetailStateCopyWithImpl<$Res>
    implements $HabitDetailStateCopyWith<$Res> {
  _$HabitDetailStateCopyWithImpl(this._self, this._then);

  final HabitDetailState _self;
  final $Res Function(HabitDetailState) _then;

/// Create a copy of HabitDetailState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? habitId = null,Object? status = null,Object? detail = freezed,Object? failure = freezed,Object? isToggling = null,Object? isDeleting = null,Object? isDeleted = null,Object? feedbackMessage = freezed,}) {
  return _then(_self.copyWith(
habitId: null == habitId ? _self.habitId : habitId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LoadStatus,detail: freezed == detail ? _self.detail : detail // ignore: cast_nullable_to_non_nullable
as HabitDetail?,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,isToggling: null == isToggling ? _self.isToggling : isToggling // ignore: cast_nullable_to_non_nullable
as bool,isDeleting: null == isDeleting ? _self.isDeleting : isDeleting // ignore: cast_nullable_to_non_nullable
as bool,isDeleted: null == isDeleted ? _self.isDeleted : isDeleted // ignore: cast_nullable_to_non_nullable
as bool,feedbackMessage: freezed == feedbackMessage ? _self.feedbackMessage : feedbackMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of HabitDetailState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$HabitDetailCopyWith<$Res>? get detail {
    if (_self.detail == null) {
    return null;
  }

  return $HabitDetailCopyWith<$Res>(_self.detail!, (value) {
    return _then(_self.copyWith(detail: value));
  });
}
}


/// Adds pattern-matching-related methods to [HabitDetailState].
extension HabitDetailStatePatterns on HabitDetailState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HabitDetailState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HabitDetailState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HabitDetailState value)  $default,){
final _that = this;
switch (_that) {
case _HabitDetailState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HabitDetailState value)?  $default,){
final _that = this;
switch (_that) {
case _HabitDetailState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String habitId,  LoadStatus status,  HabitDetail? detail,  Failure? failure,  bool isToggling,  bool isDeleting,  bool isDeleted,  String? feedbackMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HabitDetailState() when $default != null:
return $default(_that.habitId,_that.status,_that.detail,_that.failure,_that.isToggling,_that.isDeleting,_that.isDeleted,_that.feedbackMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String habitId,  LoadStatus status,  HabitDetail? detail,  Failure? failure,  bool isToggling,  bool isDeleting,  bool isDeleted,  String? feedbackMessage)  $default,) {final _that = this;
switch (_that) {
case _HabitDetailState():
return $default(_that.habitId,_that.status,_that.detail,_that.failure,_that.isToggling,_that.isDeleting,_that.isDeleted,_that.feedbackMessage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String habitId,  LoadStatus status,  HabitDetail? detail,  Failure? failure,  bool isToggling,  bool isDeleting,  bool isDeleted,  String? feedbackMessage)?  $default,) {final _that = this;
switch (_that) {
case _HabitDetailState() when $default != null:
return $default(_that.habitId,_that.status,_that.detail,_that.failure,_that.isToggling,_that.isDeleting,_that.isDeleted,_that.feedbackMessage);case _:
  return null;

}
}

}

/// @nodoc


class _HabitDetailState extends HabitDetailState {
  const _HabitDetailState({this.habitId = '', this.status = LoadStatus.loading, this.detail, this.failure, this.isToggling = false, this.isDeleting = false, this.isDeleted = false, this.feedbackMessage}): super._();
  

@override@JsonKey() final  String habitId;
@override@JsonKey() final  LoadStatus status;
@override final  HabitDetail? detail;
@override final  Failure? failure;
@override@JsonKey() final  bool isToggling;
@override@JsonKey() final  bool isDeleting;
@override@JsonKey() final  bool isDeleted;
@override final  String? feedbackMessage;

/// Create a copy of HabitDetailState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HabitDetailStateCopyWith<_HabitDetailState> get copyWith => __$HabitDetailStateCopyWithImpl<_HabitDetailState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HabitDetailState&&(identical(other.habitId, habitId) || other.habitId == habitId)&&(identical(other.status, status) || other.status == status)&&(identical(other.detail, detail) || other.detail == detail)&&(identical(other.failure, failure) || other.failure == failure)&&(identical(other.isToggling, isToggling) || other.isToggling == isToggling)&&(identical(other.isDeleting, isDeleting) || other.isDeleting == isDeleting)&&(identical(other.isDeleted, isDeleted) || other.isDeleted == isDeleted)&&(identical(other.feedbackMessage, feedbackMessage) || other.feedbackMessage == feedbackMessage));
}


@override
int get hashCode => Object.hash(runtimeType,habitId,status,detail,failure,isToggling,isDeleting,isDeleted,feedbackMessage);

@override
String toString() {
  return 'HabitDetailState(habitId: $habitId, status: $status, detail: $detail, failure: $failure, isToggling: $isToggling, isDeleting: $isDeleting, isDeleted: $isDeleted, feedbackMessage: $feedbackMessage)';
}


}

/// @nodoc
abstract mixin class _$HabitDetailStateCopyWith<$Res> implements $HabitDetailStateCopyWith<$Res> {
  factory _$HabitDetailStateCopyWith(_HabitDetailState value, $Res Function(_HabitDetailState) _then) = __$HabitDetailStateCopyWithImpl;
@override @useResult
$Res call({
 String habitId, LoadStatus status, HabitDetail? detail, Failure? failure, bool isToggling, bool isDeleting, bool isDeleted, String? feedbackMessage
});


@override $HabitDetailCopyWith<$Res>? get detail;

}
/// @nodoc
class __$HabitDetailStateCopyWithImpl<$Res>
    implements _$HabitDetailStateCopyWith<$Res> {
  __$HabitDetailStateCopyWithImpl(this._self, this._then);

  final _HabitDetailState _self;
  final $Res Function(_HabitDetailState) _then;

/// Create a copy of HabitDetailState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? habitId = null,Object? status = null,Object? detail = freezed,Object? failure = freezed,Object? isToggling = null,Object? isDeleting = null,Object? isDeleted = null,Object? feedbackMessage = freezed,}) {
  return _then(_HabitDetailState(
habitId: null == habitId ? _self.habitId : habitId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LoadStatus,detail: freezed == detail ? _self.detail : detail // ignore: cast_nullable_to_non_nullable
as HabitDetail?,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,isToggling: null == isToggling ? _self.isToggling : isToggling // ignore: cast_nullable_to_non_nullable
as bool,isDeleting: null == isDeleting ? _self.isDeleting : isDeleting // ignore: cast_nullable_to_non_nullable
as bool,isDeleted: null == isDeleted ? _self.isDeleted : isDeleted // ignore: cast_nullable_to_non_nullable
as bool,feedbackMessage: freezed == feedbackMessage ? _self.feedbackMessage : feedbackMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of HabitDetailState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$HabitDetailCopyWith<$Res>? get detail {
    if (_self.detail == null) {
    return null;
  }

  return $HabitDetailCopyWith<$Res>(_self.detail!, (value) {
    return _then(_self.copyWith(detail: value));
  });
}
}

// dart format on
