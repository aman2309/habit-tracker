import 'package:flutter_test/flutter_test.dart';
import 'package:hiicampus_habit_tracker/core/error/failure.dart';
import 'package:hiicampus_habit_tracker/features/habits/domain/usecases/update_habit_usecase.dart';

import '../../../../helpers/fake_habit_repository.dart';

void main() {
  group('UpdateHabitUseCase', () {
    test('updates the habit and trims user input', () async {
      final repository = FakeHabitRepository(
        habits: [
          buildHabit(id: 'a', name: 'Old', description: 'old', points: 5),
        ],
      );

      final result = await UpdateHabitUseCase(repository)(
        const UpdateHabitParams(
          id: 'a',
          name: '  Read more  ',
          description: '  Every night  ',
          points: 20,
        ),
      );

      final habit = result.fold(
        (_) => fail('expected a habit'),
        (habit) => habit,
      );

      expect(habit.name, 'Read more');
      expect(habit.description, 'Every night');
      expect(habit.points, 20);
      expect(repository.updateCalls, 1);
      expect(repository.habits.single.name, 'Read more');
    });

    test('rejects an empty name without touching the repository', () async {
      final repository = FakeHabitRepository(habits: [buildHabit(id: 'a')]);

      final result = await UpdateHabitUseCase(repository)(
        const UpdateHabitParams(
          id: 'a',
          name: '   ',
          description: '',
          points: 5,
        ),
      );

      expect(
        result.fold((failure) => failure, (_) => null),
        isA<ValidationFailure>(),
      );
      expect(repository.updateCalls, 0);
    });

    test('rejects a missing id', () async {
      final repository = FakeHabitRepository(habits: [buildHabit(id: 'a')]);

      final result = await UpdateHabitUseCase(repository)(
        const UpdateHabitParams(
          id: '  ',
          name: 'Read',
          description: '',
          points: 5,
        ),
      );

      expect(result.isLeft(), isTrue);
      expect(repository.updateCalls, 0);
    });

    test('rejects non positive points', () async {
      final repository = FakeHabitRepository(habits: [buildHabit(id: 'a')]);

      final result = await UpdateHabitUseCase(repository)(
        const UpdateHabitParams(
          id: 'a',
          name: 'Read',
          description: '',
          points: 0,
        ),
      );

      expect(result.isLeft(), isTrue);
      expect(repository.updateCalls, 0);
    });
  });
}
