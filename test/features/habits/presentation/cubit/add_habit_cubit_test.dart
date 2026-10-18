import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hiicampus_habit_tracker/core/common/load_status.dart';
import 'package:hiicampus_habit_tracker/core/error/failure.dart';
import 'package:hiicampus_habit_tracker/features/habits/domain/entities/habit.dart';
import 'package:hiicampus_habit_tracker/features/habits/domain/usecases/create_habit_usecase.dart';
import 'package:hiicampus_habit_tracker/features/habits/presentation/cubit/add_habit_cubit.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/fake_habit_repository.dart';

class _MockCreateHabit extends Mock implements CreateHabitUseCase {}

void main() {
  late _MockCreateHabit createHabit;

  setUpAll(() {
    registerFallbackValue(
      const CreateHabitParams(name: 'fallback', description: '', points: 1),
    );
  });

  setUp(() {
    createHabit = _MockCreateHabit();
  });

  AddHabitCubit buildCubit() => AddHabitCubit(createHabit: createHabit);

  test('rejects points that are not a whole number', () async {
    final cubit = buildCubit();

    await cubit.submit(name: 'Read', description: '', points: 'abc');

    expect(cubit.state.status, LoadStatus.failure);
    expect(cubit.state.failure, isA<ValidationFailure>());
    verifyNever(() => createHabit(any()));
  });

  test('parses points and forwards the form values', () async {
    when(() => createHabit(any())).thenAnswer(
      (_) async => Right(buildHabit(id: 'new', name: 'Read', points: 12)),
    );
    final cubit = buildCubit();

    await cubit.submit(name: ' Read ', description: '  daily ', points: '12');

    expect(cubit.state.status, LoadStatus.success);
    final params =
        verify(() => createHabit(captureAny())).captured.single
            as CreateHabitParams;
    expect(params.name, ' Read ');
    expect(params.description, '  daily ');
    expect(params.points, 12);
  });

  test('reports validation failures coming from the use case', () async {
    when(() => createHabit(any())).thenAnswer(
      (_) async => const Left(ValidationFailure('Habit name is required.')),
    );
    final cubit = buildCubit();

    await cubit.submit(name: '', description: '', points: '5');

    expect(cubit.state.status, LoadStatus.failure);
    expect(cubit.state.errorMessage, 'Habit name is required.');
  });

  test('ignores a second submission while saving', () async {
    final completer = Completer<Either<Failure, Habit>>();
    when(() => createHabit(any())).thenAnswer((_) => completer.future);
    final cubit = buildCubit();

    final first = cubit.submit(name: 'Read', description: '', points: '5');
    expect(cubit.state.isSubmitting, isTrue);

    await cubit.submit(name: 'Read', description: '', points: '5');

    verify(() => createHabit(any())).called(1);

    completer.complete(Right(buildHabit()));
    await first;

    expect(cubit.state.status, LoadStatus.success);
  });
}
