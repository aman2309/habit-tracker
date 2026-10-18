import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/habit.dart';
import '../repositories/habit_repository.dart';

/// Parameters and validation rules for creating a habit.
class CreateHabitParams {
  const CreateHabitParams({
    required this.name,
    required this.description,
    required this.points,
  });

  final String name;
  final String description;
  final int points;

  static const int maxNameLength = 60;
  static const int maxDescriptionLength = 280;
  static const int maxPoints = 10000;

  /// Returns the first problem found, or `null` when the input is valid.
  String? validate() {
    if (name.trim().isEmpty) {
      return 'Habit name is required.';
    }
    if (name.trim().length > maxNameLength) {
      return 'Habit name must be $maxNameLength characters or fewer.';
    }
    if (description.trim().length > maxDescriptionLength) {
      return 'Description must be $maxDescriptionLength characters or fewer.';
    }
    if (points <= 0) {
      return 'Points must be a whole number greater than 0.';
    }
    if (points > maxPoints) {
      return 'Points must be $maxPoints or less.';
    }
    return null;
  }
}

/// Validates and creates a new habit.
class CreateHabitUseCase implements UseCase<Habit, CreateHabitParams> {
  const CreateHabitUseCase(this._repository);

  final HabitRepository _repository;

  @override
  Future<Either<Failure, Habit>> call(CreateHabitParams params) async {
    final validationError = params.validate();
    if (validationError != null) {
      return Left(ValidationFailure(validationError));
    }

    return _repository.createHabit(
      name: params.name.trim(),
      description: params.description.trim(),
      points: params.points,
    );
  }
}
