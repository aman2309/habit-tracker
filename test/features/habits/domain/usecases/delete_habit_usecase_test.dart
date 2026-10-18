import 'package:flutter_test/flutter_test.dart';
import 'package:hiicampus_habit_tracker/core/error/failure.dart';
import 'package:hiicampus_habit_tracker/features/habits/domain/usecases/delete_habit_usecase.dart';

import '../../../../helpers/fake_habit_repository.dart';

void main() {
  group('DeleteHabitUseCase', () {
    test('removes the habit through the repository', () async {
      final repository = FakeHabitRepository(habits: [buildHabit(id: 'a')]);

      final result = await DeleteHabitUseCase(repository)(
        const DeleteHabitParams(habitId: 'a'),
      );

      expect(result.isRight(), isTrue);
      expect(repository.deleteCalls, 1);
      expect(repository.habits, isEmpty);
    });

    test('rejects an empty id without touching the repository', () async {
      final repository = FakeHabitRepository(habits: [buildHabit(id: 'a')]);

      final result = await DeleteHabitUseCase(repository)(
        const DeleteHabitParams(habitId: '   '),
      );

      expect(
        result.fold((failure) => failure, (_) => null),
        isA<ValidationFailure>(),
      );
      expect(repository.deleteCalls, 0);
    });

    test('surfaces repository failures', () async {
      final repository = FakeHabitRepository(habits: [buildHabit(id: 'a')])
        ..failure = const NotFoundFailure('gone');

      final result = await DeleteHabitUseCase(repository)(
        const DeleteHabitParams(habitId: 'a'),
      );

      expect(
        result.fold((failure) => failure, (_) => null),
        isA<NotFoundFailure>(),
      );
    });
  });
}
