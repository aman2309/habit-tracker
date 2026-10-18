import 'package:freezed_annotation/freezed_annotation.dart';

import 'habit_day_status.dart';

part 'daily_summary.freezed.dart';

/// Everything the "Today" screen needs for one calendar day.
@freezed
abstract class DailySummary with _$DailySummary {
  const DailySummary._();

  const factory DailySummary({
    required DateTime date,
    required List<HabitDayStatus> habits,
  }) = _DailySummary;

  int get totalCount => habits.length;

  int get completedCount => habits.where((status) => status.completed).length;

  bool get isEmpty => habits.isEmpty;

  /// Points earned from habits completed on this day.
  int get pointsEarned => habits
      .where((status) => status.completed)
      .fold(0, (total, status) => total + status.habit.points);

  /// Points available from every habit scheduled for this day.
  int get totalPoints =>
      habits.fold(0, (total, status) => total + status.habit.points);

  /// `0.0` .. `1.0` completion ratio.
  double get progress => totalCount == 0 ? 0 : completedCount / totalCount;

  /// Status of a single habit, used for optimistic UI updates.
  DailySummary withCompletion({
    required String habitId,
    required bool completed,
  }) {
    final updated = habits
        .map(
          (status) => status.habit.id == habitId
              ? status.copyWith(completed: completed)
              : status,
        )
        .toList(growable: false);
    return copyWith(habits: updated);
  }
}
