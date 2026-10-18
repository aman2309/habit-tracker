// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'habit_completion_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$HabitCompletionModel {

 String get habitId;@JsonKey(name: 'date') String get date;@JsonKey(name: 'completed') bool get completed;
/// Create a copy of HabitCompletionModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HabitCompletionModelCopyWith<HabitCompletionModel> get copyWith => _$HabitCompletionModelCopyWithImpl<HabitCompletionModel>(this as HabitCompletionModel, _$identity);

  /// Serializes this HabitCompletionModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HabitCompletionModel&&(identical(other.habitId, habitId) || other.habitId == habitId)&&(identical(other.date, date) || other.date == date)&&(identical(other.completed, completed) || other.completed == completed));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,habitId,date,completed);

@override
String toString() {
  return 'HabitCompletionModel(habitId: $habitId, date: $date, completed: $completed)';
}


}

/// @nodoc
abstract mixin class $HabitCompletionModelCopyWith<$Res>  {
  factory $HabitCompletionModelCopyWith(HabitCompletionModel value, $Res Function(HabitCompletionModel) _then) = _$HabitCompletionModelCopyWithImpl;
@useResult
$Res call({
 String habitId,@JsonKey(name: 'date') String date,@JsonKey(name: 'completed') bool completed
});




}
/// @nodoc
class _$HabitCompletionModelCopyWithImpl<$Res>
    implements $HabitCompletionModelCopyWith<$Res> {
  _$HabitCompletionModelCopyWithImpl(this._self, this._then);

  final HabitCompletionModel _self;
  final $Res Function(HabitCompletionModel) _then;

/// Create a copy of HabitCompletionModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? habitId = null,Object? date = null,Object? completed = null,}) {
  return _then(_self.copyWith(
habitId: null == habitId ? _self.habitId : habitId // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,completed: null == completed ? _self.completed : completed // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [HabitCompletionModel].
extension HabitCompletionModelPatterns on HabitCompletionModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HabitCompletionModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HabitCompletionModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HabitCompletionModel value)  $default,){
final _that = this;
switch (_that) {
case _HabitCompletionModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HabitCompletionModel value)?  $default,){
final _that = this;
switch (_that) {
case _HabitCompletionModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String habitId, @JsonKey(name: 'date')  String date, @JsonKey(name: 'completed')  bool completed)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HabitCompletionModel() when $default != null:
return $default(_that.habitId,_that.date,_that.completed);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String habitId, @JsonKey(name: 'date')  String date, @JsonKey(name: 'completed')  bool completed)  $default,) {final _that = this;
switch (_that) {
case _HabitCompletionModel():
return $default(_that.habitId,_that.date,_that.completed);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String habitId, @JsonKey(name: 'date')  String date, @JsonKey(name: 'completed')  bool completed)?  $default,) {final _that = this;
switch (_that) {
case _HabitCompletionModel() when $default != null:
return $default(_that.habitId,_that.date,_that.completed);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HabitCompletionModel extends HabitCompletionModel {
  const _HabitCompletionModel({required this.habitId, @JsonKey(name: 'date') required this.date, @JsonKey(name: 'completed') this.completed = true}): super._();
  factory _HabitCompletionModel.fromJson(Map<String, dynamic> json) => _$HabitCompletionModelFromJson(json);

@override final  String habitId;
@override@JsonKey(name: 'date') final  String date;
@override@JsonKey(name: 'completed') final  bool completed;

/// Create a copy of HabitCompletionModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HabitCompletionModelCopyWith<_HabitCompletionModel> get copyWith => __$HabitCompletionModelCopyWithImpl<_HabitCompletionModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HabitCompletionModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HabitCompletionModel&&(identical(other.habitId, habitId) || other.habitId == habitId)&&(identical(other.date, date) || other.date == date)&&(identical(other.completed, completed) || other.completed == completed));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,habitId,date,completed);

@override
String toString() {
  return 'HabitCompletionModel(habitId: $habitId, date: $date, completed: $completed)';
}


}

/// @nodoc
abstract mixin class _$HabitCompletionModelCopyWith<$Res> implements $HabitCompletionModelCopyWith<$Res> {
  factory _$HabitCompletionModelCopyWith(_HabitCompletionModel value, $Res Function(_HabitCompletionModel) _then) = __$HabitCompletionModelCopyWithImpl;
@override @useResult
$Res call({
 String habitId,@JsonKey(name: 'date') String date,@JsonKey(name: 'completed') bool completed
});




}
/// @nodoc
class __$HabitCompletionModelCopyWithImpl<$Res>
    implements _$HabitCompletionModelCopyWith<$Res> {
  __$HabitCompletionModelCopyWithImpl(this._self, this._then);

  final _HabitCompletionModel _self;
  final $Res Function(_HabitCompletionModel) _then;

/// Create a copy of HabitCompletionModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? habitId = null,Object? date = null,Object? completed = null,}) {
  return _then(_HabitCompletionModel(
habitId: null == habitId ? _self.habitId : habitId // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,completed: null == completed ? _self.completed : completed // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
