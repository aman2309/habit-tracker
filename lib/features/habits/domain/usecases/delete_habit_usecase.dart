import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/habit_repository.dart';

/// Parameters for deleting a habit.
class DeleteHabitParams {
  const DeleteHabitParams({required this.habitId});

  final String habitId;
}

/// Deletes a habit together with its completion history.
class DeleteHabitUseCase implements UseCase<Unit, DeleteHabitParams> {
  const DeleteHabitUseCase(this._repository);

  final HabitRepository _repository;

  @override
  Future<Either<Failure, Unit>> call(DeleteHabitParams params) async {
    if (params.habitId.trim().isEmpty) {
      return const Left(ValidationFailure('A habit is required.'));
    }
    return _repository.deleteHabit(params.habitId);
  }
}
