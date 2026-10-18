import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hiicampus_habit_tracker/core/common/load_status.dart';
import 'package:hiicampus_habit_tracker/core/error/failure.dart';
import 'package:hiicampus_habit_tracker/core/utils/app_date.dart';
import 'package:hiicampus_habit_tracker/features/habits/domain/entities/habit_detail.dart';
import 'package:hiicampus_habit_tracker/features/habits/domain/entities/habit_day_status.dart';
import 'package:hiicampus_habit_tracker/features/habits/domain/usecases/delete_habit_usecase.dart';
import 'package:hiicampus_habit_tracker/features/habits/domain/usecases/get_habit_detail_usecase.dart';
import 'package:hiicampus_habit_tracker/features/habits/domain/usecases/set_habit_completion_usecase.dart';
import 'package:hiicampus_habit_tracker/features/habits/presentation/cubit/habit_detail_cubit.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/fake_habit_repository.dart';

class _MockGetHabitDetail extends Mock implements GetHabitDetailUseCase {}

class _MockSetHabitCompletion extends Mock
    implements SetHabitCompletionUseCase {}

class _MockDeleteHabit extends Mock implements DeleteHabitUseCase {}

void main() {
  late _MockGetHabitDetail getHabitDetail;
  late _MockSetHabitCompletion setHabitCompletion;
  late _MockDeleteHabit deleteHabit;

  final habit = buildHabit(id: 'a');
  final day = today();
  final detail = HabitDetail(
    habit: habit,
    week: [HabitDayStatus(habit: habit, date: day, completed: false)],
    currentStreak: 0,
    completedToday: false,
  );

  setUpAll(() {
    registerFallbackValue(const GetHabitDetailParams(habitId: 'fallback'));
    registerFallbackValue(
      SetHabitCompletionParams(
        habitId: 'fallback',
        date: DateTime(2026, 1, 1),
        completed: false,
      ),
    );
    registerFallbackValue(const DeleteHabitParams(habitId: 'fallback'));
  });

  setUp(() {
    getHabitDetail = _MockGetHabitDetail();
    setHabitCompletion = _MockSetHabitCompletion();
    deleteHabit = _MockDeleteHabit();
  });

  HabitDetailCubit buildCubit() => HabitDetailCubit(
    getHabitDetail: getHabitDetail,
    setHabitCompletion: setHabitCompletion,
    deleteHabit: deleteHabit,
  );

  test('load exposes the habit detail', () async {
    when(() => getHabitDetail(any())).thenAnswer((_) async => Right(detail));
    final cubit = buildCubit();

    await cubit.load('a');

    expect(cubit.state.status, LoadStatus.success);
    expect(cubit.state.detail, detail);
    expect(cubit.state.habitId, 'a');
  });

  test('load surfaces failures', () async {
    when(
      () => getHabitDetail(any()),
    ).thenAnswer((_) async => const Left(NotFoundFailure('missing')));
    final cubit = buildCubit();

    await cubit.load('a');

    expect(cubit.state.status, LoadStatus.failure);
    expect(cubit.state.detail, isNull);
    expect(cubit.state.failure, isA<NotFoundFailure>());
  });

  test('toggleToday writes the completion and reloads the detail', () async {
    when(() => getHabitDetail(any())).thenAnswer((_) async => Right(detail));
    when(() => setHabitCompletion(any())).thenAnswer(
      (_) async =>
          Right(HabitDayStatus(habit: habit, date: day, completed: true)),
    );
    final cubit = buildCubit();
    await cubit.load('a');

    await cubit.toggleToday();

    final params = verify(
      () => setHabitCompletion(captureAny()),
    ).captured.single;
    expect((params as SetHabitCompletionParams).completed, isTrue);
    verify(() => getHabitDetail(any())).called(2);
    expect(cubit.state.isToggling, isFalse);
  });

  test(
    'toggleToday reports failures without losing the loaded detail',
    () async {
      when(() => getHabitDetail(any())).thenAnswer((_) async => Right(detail));
      when(() => setHabitCompletion(any())).thenAnswer(
        (_) async => const Left(NotConfiguredFailure('nothing saved')),
      );
      final cubit = buildCubit();
      await cubit.load('a');

      await cubit.toggleToday();

      expect(cubit.state.detail, detail);
      expect(cubit.state.feedbackMessage, 'nothing saved');
      expect(cubit.state.isToggling, isFalse);
    },
  );

  test('delete marks the habit as deleted on success', () async {
    when(() => getHabitDetail(any())).thenAnswer((_) async => Right(detail));
    when(() => deleteHabit(any())).thenAnswer((_) async => const Right(unit));
    final cubit = buildCubit();
    await cubit.load('a');

    await cubit.delete();

    verify(() => deleteHabit(any())).called(1);
    expect(cubit.state.isDeleted, isTrue);
    expect(cubit.state.isDeleting, isFalse);
  });

  test('delete reports failures without marking the habit deleted', () async {
    when(() => getHabitDetail(any())).thenAnswer((_) async => Right(detail));
    when(
      () => deleteHabit(any()),
    ).thenAnswer((_) async => const Left(NotConfiguredFailure('nope')));
    final cubit = buildCubit();
    await cubit.load('a');

    await cubit.delete();

    expect(cubit.state.isDeleted, isFalse);
    expect(cubit.state.isDeleting, isFalse);
    expect(cubit.state.feedbackMessage, 'nope');
  });
}
