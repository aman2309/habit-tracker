import 'package:flutter_test/flutter_test.dart';
import 'package:hiicampus_habit_tracker/core/error/exceptions.dart';
import 'package:hiicampus_habit_tracker/core/error/failure.dart';
import 'package:hiicampus_habit_tracker/core/utils/app_date.dart';
import 'package:hiicampus_habit_tracker/features/habits/data/repositories/habit_repository_impl.dart';
import 'package:hiicampus_habit_tracker/features/habits/domain/repositories/habit_repository.dart';

import '../../../../helpers/fake_habit_remote_data_source.dart';

void main() {
  late FakeHabitRemoteDataSource remote;
  late HabitRepository repository;

  setUp(() {
    remote = FakeHabitRemoteDataSource();
    repository = HabitRepositoryImpl(remote);
  });

  test('createHabit returns the stored habit', () async {
    final result = await repository.createHabit(
      name: 'Read',
      description: 'Twenty pages',
      points: 5,
    );

    final habit = result.getOrElse(() => throw StateError('expected success'));
    expect(habit.name, 'Read');
    expect(habit.points, 5);
    expect(remote.createCalls, 1);
  });

  test('getHabitById maps a missing document to NotFoundFailure', () async {
    final result = await repository.getHabitById('missing');

    expect(result.isLeft(), isTrue);
    expect(result.fold((f) => f, (_) => null), isA<NotFoundFailure>());
  });

  test('getStatusesInRange reports every day, completed or not', () async {
    final created = await repository.createHabit(
      name: 'Water',
      description: '',
      points: 5,
    );
    final habit = created.getOrElse(() => throw StateError('expected habit'));
    await repository.setCompletion(
      habitId: habit.id,
      date: today(),
      completed: true,
    );

    final result = await repository.getStatusesInRange(
      from: addDays(today(), -1),
      to: today(),
    );

    final statuses = result.getOrElse(
      () => throw StateError('expected statuses'),
    );
    expect(statuses, hasLength(2));
    expect(statuses.where((s) => s.completed), hasLength(1));
    expect(
      statuses.firstWhere((s) => isSameDay(s.day, today())).completed,
      isTrue,
    );
  });

  test('setCompletion(false) clears the record', () async {
    final created = await repository.createHabit(
      name: 'Water',
      description: '',
      points: 5,
    );
    final habit = created.getOrElse(() => throw StateError('expected habit'));

    await repository.setCompletion(
      habitId: habit.id,
      date: today(),
      completed: true,
    );
    final cleared = await repository.setCompletion(
      habitId: habit.id,
      date: today(),
      completed: false,
    );

    final clearedStatus = cleared.getOrElse(
      () => throw StateError('expected a status'),
    );
    expect(clearedStatus.completed, isFalse);
    final result = await repository.getStatusesInRange(
      from: today(),
      to: today(),
    );
    expect(result.getOrElse(() => []).single.completed, isFalse);
  });

  test('updateHabit returns the updated habit', () async {
    final created = await repository.createHabit(
      name: 'Read',
      description: 'old',
      points: 5,
    );
    final habit = created.getOrElse(() => throw StateError('expected habit'));

    final result = await repository.updateHabit(
      id: habit.id,
      name: 'Read more',
      description: 'new',
      points: 7,
    );

    final updated = result.getOrElse(() => throw StateError('expected habit'));
    expect(updated.name, 'Read more');
    expect(updated.description, 'new');
    expect(updated.points, 7);
    expect(remote.updateCalls, 1);
  });

  test('updateHabit maps a missing habit to NotFoundFailure', () async {
    final result = await repository.updateHabit(
      id: 'missing',
      name: 'Read',
      description: '',
      points: 5,
    );

    expect(result.isLeft(), isTrue);
    expect(result.fold((f) => f, (_) => null), isA<NotFoundFailure>());
  });

  test('deleteHabit removes the habit and its completions', () async {
    final created = await repository.createHabit(
      name: 'Water',
      description: '',
      points: 5,
    );
    final habit = created.getOrElse(() => throw StateError('expected habit'));
    await repository.setCompletion(
      habitId: habit.id,
      date: today(),
      completed: true,
    );

    final result = await repository.deleteHabit(habit.id);

    expect(result.isRight(), isTrue);
    expect(remote.deleteCalls, 1);
    final lookup = await repository.getHabitById(habit.id);
    expect(lookup.fold((f) => f, (_) => null), isA<NotFoundFailure>());
  });

  group('error mapping', () {
    Future<Failure> failureFor(Object exception) async {
      remote.failure = exception;
      final result = await repository.getHabitById('anything');
      return result.fold(
        (f) => f,
        (_) => throw StateError('expected a failure'),
      );
    }

    test('permission denied becomes PermissionFailure', () async {
      expect(
        await failureFor(const PermissionDeniedException('nope')),
        isA<PermissionFailure>(),
      );
    });

    test('unavailable becomes NetworkFailure', () async {
      expect(
        await failureFor(const UnavailableException('offline')),
        isA<NetworkFailure>(),
      );
    });

    test('serialization problems become RemoteFailure', () async {
      expect(
        await failureFor(const SerializationException('bad data')),
        isA<RemoteFailure>(),
      );
    });

    test('missing records stay NotFoundFailure', () async {
      expect(
        await failureFor(const RecordNotFoundException('gone')),
        isA<NotFoundFailure>(),
      );
    });

    test('not configured stays NotConfiguredFailure', () async {
      expect(
        await failureFor(const DataSourceNotConfiguredException('none')),
        isA<NotConfiguredFailure>(),
      );
    });

    test('unknown exceptions become UnexpectedFailure', () async {
      expect(await failureFor(StateError('boom')), isA<UnexpectedFailure>());
    });
  });
}
