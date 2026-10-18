import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/app_date.dart';
import '../../../../core/utils/habit_streak.dart';
import '../entities/habit.dart';
import '../entities/habit_detail.dart';
import '../entities/habit_day_status.dart';
import '../repositories/habit_repository.dart';

/// Parameters for loading a single habit with its history.
class GetHabitDetailParams {
  const GetHabitDetailParams({required this.habitId});

  final String habitId;

  /// Number of days included in the history strip.
  static const int historyDays = 7;
}

/// Loads a habit together with its seven day history and current streak.
class GetHabitDetailUseCase
    implements UseCase<HabitDetail, GetHabitDetailParams> {
  const GetHabitDetailUseCase(this._repository);

  final HabitRepository _repository;

  @override
  Future<Either<Failure, HabitDetail>> call(GetHabitDetailParams params) async {
    if (params.habitId.trim().isEmpty) {
      return const Left(ValidationFailure('A habit is required.'));
    }

    final day = today();
    final from = addDays(day, -(GetHabitDetailParams.historyDays - 1));

    final habitFuture = _repository.getHabitById(params.habitId);
    final historyFuture = _repository.getStatusesInRange(
      from: from,
      to: day,
      habitId: params.habitId,
    );

    final habitResult = await habitFuture;
    final historyResult = await historyFuture;

    return habitResult.fold(
      (failure) => Left<Failure, HabitDetail>(failure),
      (habit) => historyResult.map(
        (statuses) => _build(habit: habit, statuses: statuses, day: day),
      ),
    );
  }

  HabitDetail _build({
    required Habit habit,
    required List<HabitDayStatus> statuses,
    required DateTime day,
  }) {
    final byDay = <DateTime, HabitDayStatus>{
      for (final status in statuses) status.day: status,
    };

    final week = [
      for (final date in lastSevenDays(day))
        byDay[date] ??
            HabitDayStatus(habit: habit, date: date, completed: false),
    ];

    final completedDays = {
      for (final status in statuses)
        if (status.completed) status.day,
    };

    return HabitDetail(
      habit: habit,
      week: week,
      currentStreak: currentStreak(completedDays: completedDays, today: day),
      completedToday: byDay[day]?.completed ?? false,
    );
  }
}
