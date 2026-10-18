// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'today_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TodayState {

 LoadStatus get status; DailySummary? get summary; Failure? get failure; bool get isToggling; String? get feedbackMessage;
/// Create a copy of TodayState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TodayStateCopyWith<TodayState> get copyWith => _$TodayStateCopyWithImpl<TodayState>(this as TodayState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TodayState&&(identical(other.status, status) || other.status == status)&&(identical(other.summary, summary) || other.summary == summary)&&(identical(other.failure, failure) || other.failure == failure)&&(identical(other.isToggling, isToggling) || other.isToggling == isToggling)&&(identical(other.feedbackMessage, feedbackMessage) || other.feedbackMessage == feedbackMessage));
}


@override
int get hashCode => Object.hash(runtimeType,status,summary,failure,isToggling,feedbackMessage);

@override
String toString() {
  return 'TodayState(status: $status, summary: $summary, failure: $failure, isToggling: $isToggling, feedbackMessage: $feedbackMessage)';
}


}

/// @nodoc
abstract mixin class $TodayStateCopyWith<$Res>  {
  factory $TodayStateCopyWith(TodayState value, $Res Function(TodayState) _then) = _$TodayStateCopyWithImpl;
@useResult
$Res call({
 LoadStatus status, DailySummary? summary, Failure? failure, bool isToggling, String? feedbackMessage
});


$DailySummaryCopyWith<$Res>? get summary;

}
/// @nodoc
class _$TodayStateCopyWithImpl<$Res>
    implements $TodayStateCopyWith<$Res> {
  _$TodayStateCopyWithImpl(this._self, this._then);

  final TodayState _self;
  final $Res Function(TodayState) _then;

/// Create a copy of TodayState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? summary = freezed,Object? failure = freezed,Object? isToggling = null,Object? feedbackMessage = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LoadStatus,summary: freezed == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as DailySummary?,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,isToggling: null == isToggling ? _self.isToggling : isToggling // ignore: cast_nullable_to_non_nullable
as bool,feedbackMessage: freezed == feedbackMessage ? _self.feedbackMessage : feedbackMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of TodayState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DailySummaryCopyWith<$Res>? get summary {
    if (_self.summary == null) {
    return null;
  }

  return $DailySummaryCopyWith<$Res>(_self.summary!, (value) {
    return _then(_self.copyWith(summary: value));
  });
}
}


/// Adds pattern-matching-related methods to [TodayState].
extension TodayStatePatterns on TodayState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TodayState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TodayState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TodayState value)  $default,){
final _that = this;
switch (_that) {
case _TodayState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TodayState value)?  $default,){
final _that = this;
switch (_that) {
case _TodayState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( LoadStatus status,  DailySummary? summary,  Failure? failure,  bool isToggling,  String? feedbackMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TodayState() when $default != null:
return $default(_that.status,_that.summary,_that.failure,_that.isToggling,_that.feedbackMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( LoadStatus status,  DailySummary? summary,  Failure? failure,  bool isToggling,  String? feedbackMessage)  $default,) {final _that = this;
switch (_that) {
case _TodayState():
return $default(_that.status,_that.summary,_that.failure,_that.isToggling,_that.feedbackMessage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( LoadStatus status,  DailySummary? summary,  Failure? failure,  bool isToggling,  String? feedbackMessage)?  $default,) {final _that = this;
switch (_that) {
case _TodayState() when $default != null:
return $default(_that.status,_that.summary,_that.failure,_that.isToggling,_that.feedbackMessage);case _:
  return null;

}
}

}

/// @nodoc


class _TodayState extends TodayState {
  const _TodayState({this.status = LoadStatus.loading, this.summary, this.failure, this.isToggling = false, this.feedbackMessage}): super._();
  

@override@JsonKey() final  LoadStatus status;
@override final  DailySummary? summary;
@override final  Failure? failure;
@override@JsonKey() final  bool isToggling;
@override final  String? feedbackMessage;

/// Create a copy of TodayState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TodayStateCopyWith<_TodayState> get copyWith => __$TodayStateCopyWithImpl<_TodayState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TodayState&&(identical(other.status, status) || other.status == status)&&(identical(other.summary, summary) || other.summary == summary)&&(identical(other.failure, failure) || other.failure == failure)&&(identical(other.isToggling, isToggling) || other.isToggling == isToggling)&&(identical(other.feedbackMessage, feedbackMessage) || other.feedbackMessage == feedbackMessage));
}


@override
int get hashCode => Object.hash(runtimeType,status,summary,failure,isToggling,feedbackMessage);

@override
String toString() {
  return 'TodayState(status: $status, summary: $summary, failure: $failure, isToggling: $isToggling, feedbackMessage: $feedbackMessage)';
}


}

/// @nodoc
abstract mixin class _$TodayStateCopyWith<$Res> implements $TodayStateCopyWith<$Res> {
  factory _$TodayStateCopyWith(_TodayState value, $Res Function(_TodayState) _then) = __$TodayStateCopyWithImpl;
@override @useResult
$Res call({
 LoadStatus status, DailySummary? summary, Failure? failure, bool isToggling, String? feedbackMessage
});


@override $DailySummaryCopyWith<$Res>? get summary;

}
/// @nodoc
class __$TodayStateCopyWithImpl<$Res>
    implements _$TodayStateCopyWith<$Res> {
  __$TodayStateCopyWithImpl(this._self, this._then);

  final _TodayState _self;
  final $Res Function(_TodayState) _then;

/// Create a copy of TodayState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? summary = freezed,Object? failure = freezed,Object? isToggling = null,Object? feedbackMessage = freezed,}) {
  return _then(_TodayState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LoadStatus,summary: freezed == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as DailySummary?,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,isToggling: null == isToggling ? _self.isToggling : isToggling // ignore: cast_nullable_to_non_nullable
as bool,feedbackMessage: freezed == feedbackMessage ? _self.feedbackMessage : feedbackMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of TodayState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DailySummaryCopyWith<$Res>? get summary {
    if (_self.summary == null) {
    return null;
  }

  return $DailySummaryCopyWith<$Res>(_self.summary!, (value) {
    return _then(_self.copyWith(summary: value));
  });
}
}

// dart format on
