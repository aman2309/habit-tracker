import 'package:flutter_test/flutter_test.dart';
import 'package:hiicampus_habit_tracker/core/utils/app_date.dart';
import 'package:hiicampus_habit_tracker/features/habits/domain/usecases/get_habit_detail_usecase.dart';

import '../../../../helpers/fake_habit_repository.dart';

void main() {
  group('GetHabitDetailUseCase', () {
    test('builds a seven day history and counts the current streak', () async {
      final habit = buildHabit(id: 'a', points: 7);
      final day = today();
      final repository = FakeHabitRepository(
        habits: [habit],
        completedDays: {
          'a': {day, addDays(day, -1), addDays(day, -2), addDays(day, -5)},
        },
      );

      final result = await GetHabitDetailUseCase(repository)(
        const GetHabitDetailParams(habitId: 'a'),
      );

      final detail = result.fold(
        (_) => fail('expected habit detail'),
        (detail) => detail,
      );

      expect(detail.habit.id, 'a');
      expect(detail.week, hasLength(7));
      expect(detail.week.first.day, addDays(day, -6));
      expect(detail.week.last.day, day);
      expect(detail.completedToday, isTrue);
      expect(detail.currentStreak, 3);
      expect(detail.hasAnyCompletion, isTrue);
    });

    test('reports missing history as not completed', () async {
      final repository = FakeHabitRepository(habits: [buildHabit(id: 'a')]);

      final result = await GetHabitDetailUseCase(repository)(
        const GetHabitDetailParams(habitId: 'a'),
      );

      final detail = result.fold(
        (_) => fail('expected habit detail'),
        (detail) => detail,
      );

      expect(detail.week.every((status) => !status.completed), isTrue);
      expect(detail.completedToday, isFalse);
      expect(detail.currentStreak, 0);
      expect(detail.hasAnyCompletion, isFalse);
    });

    test('returns a not found failure for an unknown habit', () async {
      final repository = FakeHabitRepository(habits: [buildHabit(id: 'a')]);

      final result = await GetHabitDetailUseCase(repository)(
        const GetHabitDetailParams(habitId: 'missing'),
      );

      expect(result.isLeft(), isTrue);
    });

    test('requires an id', () async {
      final repository = FakeHabitRepository();

      final result = await GetHabitDetailUseCase(repository)(
        const GetHabitDetailParams(habitId: ''),
      );

      expect(result.isLeft(), isTrue);
      expect(repository.statusCalls, 0);
    });
  });
}
