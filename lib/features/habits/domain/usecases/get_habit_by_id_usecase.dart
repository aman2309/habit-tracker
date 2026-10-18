import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/habit.dart';
import '../repositories/habit_repository.dart';

/// Parameters for loading a single habit.
class GetHabitByIdParams {
  const GetHabitByIdParams({required this.habitId});

  final String habitId;
}

/// Loads a single habit by id (used to prefill the edit form).
class GetHabitByIdUseCase implements UseCase<Habit, GetHabitByIdParams> {
  const GetHabitByIdUseCase(this._repository);

  final HabitRepository _repository;

  @override
  Future<Either<Failure, Habit>> call(GetHabitByIdParams params) async {
    if (params.habitId.trim().isEmpty) {
      return const Left(ValidationFailure('A habit is required.'));
    }
    return _repository.getHabitById(params.habitId);
  }
}
