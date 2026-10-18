import 'package:flutter_test/flutter_test.dart';
import 'package:hiicampus_habit_tracker/core/error/failure.dart';
import 'package:hiicampus_habit_tracker/features/habits/domain/usecases/create_habit_usecase.dart';

import '../../../../helpers/fake_habit_repository.dart';

void main() {
  group('CreateHabitUseCase', () {
    test('creates a habit and trims user input', () async {
      final repository = FakeHabitRepository();
      final useCase = CreateHabitUseCase(repository);

      final result = await useCase(
        const CreateHabitParams(
          name: '  Read 20 pages  ',
          description: '  Every evening  ',
          points: 15,
        ),
      );

      final habit = result.fold(
        (_) => fail('expected a habit'),
        (habit) => habit,
      );

      expect(habit.name, 'Read 20 pages');
      expect(habit.description, 'Every evening');
      expect(habit.points, 15);
      expect(repository.createCalls, 1);
      expect(repository.habits, hasLength(1));
    });

    test('rejects an empty name without touching the repository', () async {
      final repository = FakeHabitRepository();

      final result = await CreateHabitUseCase(repository)(
        const CreateHabitParams(name: '   ', description: '', points: 5),
      );

      final failure = result.fold(
        (failure) => failure,
        (_) => fail('expected a failure'),
      );

      expect(failure, isA<ValidationFailure>());
      expect(repository.createCalls, 0);
    });

    test('rejects non positive points', () async {
      final repository = FakeHabitRepository();

      final result = await CreateHabitUseCase(repository)(
        const CreateHabitParams(name: 'Stretch', description: '', points: 0),
      );

      final failure = result.fold(
        (failure) => failure,
        (_) => fail('expected a failure'),
      );

      expect(failure, isA<ValidationFailure>());
      expect(failure.message, contains('greater than 0'));
      expect(repository.createCalls, 0);
    });

    test('rejects a name that is too long', () async {
      final repository = FakeHabitRepository();

      final result = await CreateHabitUseCase(repository)(
        CreateHabitParams(
          name: 'a' * (CreateHabitParams.maxNameLength + 1),
          description: '',
          points: 5,
        ),
      );

      expect(result.isLeft(), isTrue);
      expect(repository.createCalls, 0);
    });
  });
}
