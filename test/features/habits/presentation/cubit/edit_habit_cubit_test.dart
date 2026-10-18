import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hiicampus_habit_tracker/core/common/load_status.dart';
import 'package:hiicampus_habit_tracker/core/error/failure.dart';
import 'package:hiicampus_habit_tracker/features/habits/domain/usecases/get_habit_by_id_usecase.dart';
import 'package:hiicampus_habit_tracker/features/habits/domain/usecases/update_habit_usecase.dart';
import 'package:hiicampus_habit_tracker/features/habits/presentation/cubit/edit_habit_cubit.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/fake_habit_repository.dart';

class _MockGetHabitById extends Mock implements GetHabitByIdUseCase {}

class _MockUpdateHabit extends Mock implements UpdateHabitUseCase {}

void main() {
  late _MockGetHabitById getHabitById;
  late _MockUpdateHabit updateHabit;

  final habit = buildHabit(id: 'a', name: 'Water');

  setUpAll(() {
    registerFallbackValue(const GetHabitByIdParams(habitId: 'fallback'));
    registerFallbackValue(
      const UpdateHabitParams(
        id: 'fallback',
        name: 'name',
        description: 'desc',
        points: 1,
      ),
    );
  });

  setUp(() {
    getHabitById = _MockGetHabitById();
    updateHabit = _MockUpdateHabit();
  });

  EditHabitCubit buildCubit() =>
      EditHabitCubit(getHabitById: getHabitById, updateHabit: updateHabit);

  test('load exposes the habit', () async {
    when(() => getHabitById(any())).thenAnswer((_) async => Right(habit));
    final cubit = buildCubit();

    await cubit.load('a');

    expect(cubit.state.status, LoadStatus.success);
    expect(cubit.state.habit, habit);
    expect(cubit.state.hasHabit, isTrue);
  });

  test('load surfaces failures', () async {
    when(
      () => getHabitById(any()),
    ).thenAnswer((_) async => const Left(NotFoundFailure('missing')));
    final cubit = buildCubit();

    await cubit.load('a');

    expect(cubit.state.isMissing, isTrue);
    expect(cubit.state.habit, isNull);
  });

  test('save updates the habit and flags success', () async {
    when(() => getHabitById(any())).thenAnswer((_) async => Right(habit));
    when(
      () => updateHabit(any()),
    ).thenAnswer((_) async => Right(habit.copyWith(name: 'Read')));
    final cubit = buildCubit();
    await cubit.load('a');

    await cubit.save(name: 'Read', description: 'd', points: '12');

    final params = verify(() => updateHabit(captureAny())).captured.single;
    expect((params as UpdateHabitParams).points, 12);
    expect(cubit.state.isSaved, isTrue);
    expect(cubit.state.isSaving, isFalse);
  });

  test(
    'save rejects non numeric points without calling the use case',
    () async {
      when(() => getHabitById(any())).thenAnswer((_) async => Right(habit));
      final cubit = buildCubit();
      await cubit.load('a');

      await cubit.save(name: 'Read', description: '', points: 'abc');

      expect(cubit.state.failure, isA<ValidationFailure>());
      verifyNever(() => updateHabit(any()));
    },
  );

  test('save surfaces failures', () async {
    when(() => getHabitById(any())).thenAnswer((_) async => Right(habit));
    when(
      () => updateHabit(any()),
    ).thenAnswer((_) async => const Left(NotConfiguredFailure('nope')));
    final cubit = buildCubit();
    await cubit.load('a');

    await cubit.save(name: 'Read', description: '', points: '5');

    expect(cubit.state.isSaved, isFalse);
    expect(cubit.state.errorMessage, 'nope');
  });
}
