import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/habit.dart';
import '../repositories/habit_repository.dart';
import 'create_habit_usecase.dart';

/// Parameters and validation rules for editing a habit.
///
/// Limits are shared with [CreateHabitParams] so the two forms cannot drift.
class UpdateHabitParams {
  const UpdateHabitParams({
    required this.id,
    required this.name,
    required this.description,
    required this.points,
  });

  final String id;
  final String name;
  final String description;
  final int points;

  /// Returns the first problem found, or `null` when the input is valid.
  String? validate() {
    if (id.trim().isEmpty) {
      return 'A habit is required.';
    }
    if (name.trim().isEmpty) {
      return 'Habit name is required.';
    }
    if (name.trim().length > CreateHabitParams.maxNameLength) {
      return 'Habit name must be ${CreateHabitParams.maxNameLength} '
          'characters or fewer.';
    }
    if (description.trim().length > CreateHabitParams.maxDescriptionLength) {
      return 'Description must be ${CreateHabitParams.maxDescriptionLength} '
          'characters or fewer.';
    }
    if (points <= 0) {
      return 'Points must be a whole number greater than 0.';
    }
    if (points > CreateHabitParams.maxPoints) {
      return 'Points must be ${CreateHabitParams.maxPoints} or less.';
    }
    return null;
  }
}

/// Validates and saves edits to an existing habit.
class UpdateHabitUseCase implements UseCase<Habit, UpdateHabitParams> {
  const UpdateHabitUseCase(this._repository);

  final HabitRepository _repository;

  @override
  Future<Either<Failure, Habit>> call(UpdateHabitParams params) async {
    final validationError = params.validate();
    if (validationError != null) {
      return Left(ValidationFailure(validationError));
    }

    return _repository.updateHabit(
      id: params.id,
      name: params.name.trim(),
      description: params.description.trim(),
      points: params.points,
    );
  }
}
