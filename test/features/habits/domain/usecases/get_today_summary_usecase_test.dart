import 'package:flutter_test/flutter_test.dart';
import 'package:hiicampus_habit_tracker/core/error/failure.dart';
import 'package:hiicampus_habit_tracker/core/usecases/usecase.dart';
import 'package:hiicampus_habit_tracker/core/utils/app_date.dart';
import 'package:hiicampus_habit_tracker/features/habits/domain/usecases/get_today_summary_usecase.dart';

import '../../../../helpers/fake_habit_repository.dart';

void main() {
  group('GetTodaySummaryUseCase', () {
    test('summarises today using habits and completion records', () async {
      final habitA = buildHabit(id: 'a', points: 5);
      final habitB = buildHabit(id: 'b', points: 10);
      final repository = FakeHabitRepository(
        habits: [habitA, habitB],
        completedDays: {
          'a': {today()},
        },
      );

      final result = await GetTodaySummaryUseCase(
        repository,
      ).call(const NoParams());

      final summary = result.fold(
        (_) => fail('expected a summary'),
        (summary) => summary,
      );

      expect(summary.date, today());
      expect(summary.totalCount, 2);
      expect(summary.completedCount, 1);
      expect(summary.pointsEarned, 5);
      expect(summary.totalPoints, 15);
      expect(summary.progress, closeTo(0.5, 0.0001));
      expect(summary.isEmpty, isFalse);
    });

    test('returns an empty summary when there are no habits', () async {
      final repository = FakeHabitRepository();

      final result = await GetTodaySummaryUseCase(
        repository,
      ).call(const NoParams());

      final summary = result.fold(
        (_) => fail('expected a summary'),
        (summary) => summary,
      );

      expect(summary.isEmpty, isTrue);
      expect(summary.progress, 0);
    });

    test('passes repository failures through unchanged', () async {
      final repository = FakeHabitRepository(
        failure: const NotConfiguredFailure('not connected'),
      );

      final result = await GetTodaySummaryUseCase(
        repository,
      ).call(const NoParams());

      final failure = result.fold(
        (failure) => failure,
        (_) => fail('expected a failure'),
      );

      expect(failure, isA<NotConfiguredFailure>());
      expect(failure.message, 'not connected');
    });
  });
}
