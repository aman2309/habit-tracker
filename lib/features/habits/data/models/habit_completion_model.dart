import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/utils/app_date.dart';
import '../../domain/entities/habit.dart';
import '../../domain/entities/habit_day_status.dart';

part 'habit_completion_model.freezed.dart';
part 'habit_completion_model.g.dart';

/// A single completion record stored per habit and per calendar day.
@freezed
abstract class HabitCompletionModel with _$HabitCompletionModel {
  const HabitCompletionModel._();

  const factory HabitCompletionModel({
    required String habitId,
    @JsonKey(name: 'date') required String date,
    @Default(true) @JsonKey(name: 'completed') bool completed,
  }) = _HabitCompletionModel;

  factory HabitCompletionModel.fromJson(Map<String, dynamic> json) =>
      _$HabitCompletionModelFromJson(json);

  /// Builds a model from a Firestore completion document.
  ///
  /// The document id is the `yyyy-MM-dd` day key, so the date is not duplicated
  /// inside the document body. A missing `completed` field is treated as
  /// `false` so malformed documents never mark a day as done by accident.
  factory HabitCompletionModel.fromFirestore({
    required String habitId,
    required String dayKey,
    required Map<String, dynamic> data,
  }) => HabitCompletionModel(
    habitId: habitId,
    date: dayKey,
    completed: data['completed'] as bool? ?? false,
  );

  /// Fields written to Firestore. The day is the document id, not a field.
  Map<String, Object?> toFirestore() => {'completed': completed};

  /// Calendar day this record belongs to (`yyyy-MM-dd`).
  DateTime get day {
    final parts = date.split('-');
    if (parts.length == 3) {
      final year = int.tryParse(parts[0]);
      final month = int.tryParse(parts[1]);
      final dayOfMonth = int.tryParse(parts[2]);
      if (year != null && month != null && dayOfMonth != null) {
        return DateTime(year, month, dayOfMonth);
      }
    }
    return dateOnly(DateTime.tryParse(date) ?? DateTime.now());
  }

  factory HabitCompletionModel.fromDay({
    required String habitId,
    required DateTime day,
    required bool completed,
  }) => HabitCompletionModel(
    habitId: habitId,
    date: dateKey(day),
    completed: completed,
  );

  HabitDayStatus toStatus({required Habit habit}) =>
      HabitDayStatus(habit: habit, date: day, completed: completed);
}

/// Canonical `yyyy-MM-dd` key for a calendar day.
String dateKey(DateTime day) {
  final month = day.month.toString().padLeft(2, '0');
  final dayOfMonth = day.day.toString().padLeft(2, '0');
  return '${day.year}-$month-$dayOfMonth';
}
