import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hiicampus_habit_tracker/core/common/load_status.dart';
import 'package:hiicampus_habit_tracker/core/error/failure.dart';
import 'package:hiicampus_habit_tracker/core/usecases/usecase.dart';
import 'package:hiicampus_habit_tracker/core/utils/app_date.dart';
import 'package:hiicampus_habit_tracker/features/habits/domain/entities/daily_summary.dart';
import 'package:hiicampus_habit_tracker/features/habits/domain/entities/habit_day_status.dart';
import 'package:hiicampus_habit_tracker/features/habits/domain/usecases/get_today_summary_usecase.dart';
import 'package:hiicampus_habit_tracker/features/habits/domain/usecases/set_habit_completion_usecase.dart';
import 'package:hiicampus_habit_tracker/features/habits/presentation/cubit/today_cubit.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/fake_habit_repository.dart';

class _MockGetTodaySummary extends Mock implements GetTodaySummaryUseCase {}

class _MockSetHabitCompletion extends Mock
    implements SetHabitCompletionUseCase {}

void main() {
  late _MockGetTodaySummary getTodaySummary;
  late _MockSetHabitCompletion setHabitCompletion;

  final habit = buildHabit(id: 'a', points: 10);
  final day = today();
  final summary = DailySummary(
    date: day,
    habits: [HabitDayStatus(habit: habit, date: day, completed: false)],
  );

  setUpAll(() {
    registerFallbackValue(const NoParams());
    registerFallbackValue(
      SetHabitCompletionParams(
        habitId: 'fallback',
        date: DateTime(2026, 1, 1),
        completed: false,
      ),
    );
  });

  setUp(() {
    getTodaySummary = _MockGetTodaySummary();
    setHabitCompletion = _MockSetHabitCompletion();
  });

  TodayCubit buildCubit() => TodayCubit(
    getTodaySummary: getTodaySummary,
    setHabitCompletion: setHabitCompletion,
  );

  group('loadToday', () {
    test('emits the summary on success', () async {
      when(
        () => getTodaySummary(any()),
      ).thenAnswer((_) async => Right(summary));
      final cubit = buildCubit();

      await cubit.loadToday();

      expect(cubit.state.status, LoadStatus.success);
      expect(cubit.state.summary, summary);
      expect(cubit.state.failure, isNull);
    });

    test('emits the failure when loading fails', () async {
      when(() => getTodaySummary(any())).thenAnswer(
        (_) async => const Left(NotConfiguredFailure('not connected')),
      );
      final cubit = buildCubit();

      await cubit.loadToday();

      expect(cubit.state.status, LoadStatus.failure);
      expect(cubit.state.failure, isA<NotConfiguredFailure>());
      expect(cubit.state.summary, isNull);
    });
  });

  group('toggleCompletion', () {
    test('applies the change optimistically and confirms it', () async {
      when(
        () => getTodaySummary(any()),
      ).thenAnswer((_) async => Right(summary));
      when(() => setHabitCompletion(any())).thenAnswer(
        (_) async =>
            Right(HabitDayStatus(habit: habit, date: day, completed: true)),
      );
      final cubit = buildCubit();
      await cubit.loadToday();

      final pending = cubit.toggleCompletion(habitId: 'a', completed: true);

      expect(cubit.state.summary!.habits.single.completed, isTrue);
      expect(cubit.state.isToggling, isTrue);

      await pending;

      expect(cubit.state.isToggling, isFalse);
      expect(cubit.state.summary!.habits.single.completed, isTrue);
      expect(cubit.state.failure, isNull);
    });

    test('rolls back and reports when storage rejects the change', () async {
      when(
        () => getTodaySummary(any()),
      ).thenAnswer((_) async => Right(summary));
      when(() => setHabitCompletion(any())).thenAnswer(
        (_) async => const Left(NotConfiguredFailure('nothing saved')),
      );
      final cubit = buildCubit();
      await cubit.loadToday();

      final pending = cubit.toggleCompletion(habitId: 'a', completed: true);
      expect(cubit.state.summary!.habits.single.completed, isTrue);

      await pending;

      expect(cubit.state.summary!.habits.single.completed, isFalse);
      expect(cubit.state.feedbackMessage, 'nothing saved');
      expect(cubit.state.isToggling, isFalse);
    });

    test('does nothing without a loaded summary', () async {
      final cubit = buildCubit();

      await cubit.toggleCompletion(habitId: 'a', completed: true);

      verifyNever(() => setHabitCompletion(any()));
    });
  });

  test('clearFeedback removes the snackbar message', () async {
    when(() => getTodaySummary(any())).thenAnswer(
      (_) async => const Left(NotConfiguredFailure('not connected')),
    );
    final cubit = buildCubit();
    await cubit.loadToday();
    expect(cubit.state.failure, isNotNull);

    cubit.clearFeedback();

    expect(cubit.state.feedbackMessage, isNull);
  });
}
