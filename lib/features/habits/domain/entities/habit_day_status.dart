import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/utils/app_date.dart';
import 'habit.dart';

part 'habit_day_status.freezed.dart';

/// A habit together with its completion state on a single calendar day.
@freezed
abstract class HabitDayStatus with _$HabitDayStatus {
  const HabitDayStatus._();

  const factory HabitDayStatus({
    required Habit habit,
    required DateTime date,
    required bool completed,
  }) = _HabitDayStatus;

  /// Calendar day this status refers to, with the time removed.
  DateTime get day => dateOnly(date);
}
