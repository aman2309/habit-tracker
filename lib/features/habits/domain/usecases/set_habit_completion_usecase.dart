import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/app_date.dart';
import '../entities/habit_day_status.dart';
import '../repositories/habit_repository.dart';

/// Parameters for (un)marking a habit on a given day.
class SetHabitCompletionParams {
  const SetHabitCompletionParams({
    required this.habitId,
    required this.date,
    required this.completed,
  });

  final String habitId;
  final DateTime date;
  final bool completed;
}

/// Marks a habit as done or not done for a calendar day.
class SetHabitCompletionUseCase
    implements UseCase<HabitDayStatus, SetHabitCompletionParams> {
  const SetHabitCompletionUseCase(this._repository);

  final HabitRepository _repository;

  @override
  Future<Either<Failure, HabitDayStatus>> call(
    SetHabitCompletionParams params,
  ) {
    if (params.habitId.trim().isEmpty) {
      return Future.value(
        const Left(ValidationFailure('A habit is required.')),
      );
    }

    return _repository.setCompletion(
      habitId: params.habitId,
      date: dateOnly(params.date),
      completed: params.completed,
    );
  }
}
