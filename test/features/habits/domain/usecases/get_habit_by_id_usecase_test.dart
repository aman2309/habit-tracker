import 'package:flutter_test/flutter_test.dart';
import 'package:hiicampus_habit_tracker/core/error/failure.dart';
import 'package:hiicampus_habit_tracker/features/habits/domain/usecases/get_habit_by_id_usecase.dart';

import '../../../../helpers/fake_habit_repository.dart';

void main() {
  group('GetHabitByIdUseCase', () {
    test('returns the habit', () async {
      final repository = FakeHabitRepository(
        habits: [buildHabit(id: 'a', name: 'Water')],
      );

      final result = await GetHabitByIdUseCase(repository)(
        const GetHabitByIdParams(habitId: 'a'),
      );

      final habit = result.fold(
        (_) => fail('expected a habit'),
        (habit) => habit,
      );
      expect(habit.name, 'Water');
    });

    test('rejects an empty id', () async {
      final repository = FakeHabitRepository();

      final result = await GetHabitByIdUseCase(repository)(
        const GetHabitByIdParams(habitId: ''),
      );

      expect(
        result.fold((failure) => failure, (_) => null),
        isA<ValidationFailure>(),
      );
    });

    test('surfaces a missing habit', () async {
      final repository = FakeHabitRepository();

      final result = await GetHabitByIdUseCase(repository)(
        const GetHabitByIdParams(habitId: 'missing'),
      );

      expect(
        result.fold((failure) => failure, (_) => null),
        isA<NotFoundFailure>(),
      );
    });
  });
}
