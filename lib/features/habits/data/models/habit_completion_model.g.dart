// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'habit_completion_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_HabitCompletionModel _$HabitCompletionModelFromJson(
  Map<String, dynamic> json,
) => _HabitCompletionModel(
  habitId: json['habitId'] as String,
  date: json['date'] as String,
  completed: json['completed'] as bool? ?? true,
);

Map<String, dynamic> _$HabitCompletionModelToJson(
  _HabitCompletionModel instance,
) => <String, dynamic>{
  'habitId': instance.habitId,
  'date': instance.date,
  'completed': instance.completed,
};
