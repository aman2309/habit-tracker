import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/utils/app_date.dart';
import 'habit.dart';
import 'habit_day_status.dart';

part 'habit_detail.freezed.dart';

/// Aggregated data for the "Habit Detail" screen.
@freezed
abstract class HabitDetail with _$HabitDetail {
  const HabitDetail._();

  const factory HabitDetail({
    required Habit habit,
    required List<HabitDayStatus> week,
    required int currentStreak,
    required bool completedToday,
  }) = _HabitDetail;

  /// The seven days shown in the history strip, oldest first.
  List<HabitDayStatus> get weekHistory => List.unmodifiable(week);

  bool isCompletedOn(DateTime date) =>
      week.any((status) => isSameDay(status.day, date) && status.completed);

  bool get hasAnyCompletion => week.any((status) => status.completed);
}
