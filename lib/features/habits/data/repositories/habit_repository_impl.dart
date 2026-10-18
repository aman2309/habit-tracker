import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/utils/app_date.dart';
import '../../domain/entities/habit.dart';
import '../../domain/entities/habit_day_status.dart';
import '../../domain/repositories/habit_repository.dart';
import '../datasources/habit_remote_data_source.dart';
import '../models/habit_completion_model.dart';

/// Implements the domain storage contract on top of [HabitRemoteDataSource].
///
/// This is the only place where data-layer exceptions are translated into
/// domain [Failure] values, and where models are mapped to entities.
class HabitRepositoryImpl implements HabitRepository {
  const HabitRepositoryImpl(this._remote);

  final HabitRemoteDataSource _remote;

  @override
  Future<Either<Failure, Habit>> createHabit({
    required String name,
    required String description,
    required int points,
  }) => _guard(() async {
    final model = await _remote.createHabit(
      name: name,
      description: description,
      points: points,
    );
    return model.toEntity();
  });

  @override
  Future<Either<Failure, Habit>> getHabitById(String id) => _guard(() async {
    final model = await _remote.fetchHabitById(id);
    return model.toEntity();
  });

  @override
  Future<Either<Failure, Habit>> updateHabit({
    required String id,
    required String name,
    required String description,
    required int points,
  }) => _guard(() async {
    final model = await _remote.updateHabit(
      id: id,
      name: name,
      description: description,
      points: points,
    );
    return model.toEntity();
  });

  @override
  Future<Either<Failure, Unit>> deleteHabit(String id) => _guard(() async {
    await _remote.deleteHabit(id);
    return unit;
  });

  @override
  Future<Either<Failure, List<HabitDayStatus>>> getStatusesInRange({
    required DateTime from,
    required DateTime to,
    String? habitId,
  }) => _guard(() async {
    final habits = habitId == null
        ? await _remote.fetchHabits()
        : [await _remote.fetchHabitById(habitId)];

    final completions = await _remote.fetchCompletions(
      fromKey: dateKey(from),
      toKey: dateKey(to),
      habitId: habitId,
    );

    final completedKeys = {
      for (final completion in completions)
        if (completion.completed)
          '${completion.habitId}|${dateKey(completion.day)}',
    };

    final days = _daysInRange(from, to);

    return [
      for (final model in habits)
        for (final day in days)
          HabitDayStatus(
            habit: model.toEntity(),
            date: day,
            completed: completedKeys.contains('${model.id}|${dateKey(day)}'),
          ),
    ];
  });

  @override
  Future<Either<Failure, HabitDayStatus>> setCompletion({
    required String habitId,
    required DateTime date,
    required bool completed,
  }) => _guard(() async {
    final habit = await _remote.fetchHabitById(habitId);
    await _remote.saveCompletion(
      habitId: habitId,
      dateKey: dateKey(date),
      completed: completed,
    );
    return HabitCompletionModel.fromDay(
      habitId: habitId,
      day: date,
      completed: completed,
    ).toStatus(habit: habit.toEntity());
  });

  Future<Either<Failure, T>> _guard<T>(Future<T> Function() action) async {
    try {
      return Right(await action());
    } on DataSourceNotConfiguredException catch (exception) {
      return Left(NotConfiguredFailure(exception.message));
    } on PermissionDeniedException catch (exception) {
      return Left(PermissionFailure(exception.message));
    } on UnavailableException catch (exception) {
      return Left(NetworkFailure(exception.message));
    } on RecordNotFoundException catch (exception) {
      return Left(NotFoundFailure(exception.message));
    } on SerializationException catch (exception) {
      return Left(RemoteFailure(exception.message));
    } on RemoteDataException catch (exception) {
      return Left(RemoteFailure(exception.message));
    } on AppException catch (exception) {
      return Left(RemoteFailure(exception.message));
    } catch (_) {
      return const Left(UnexpectedFailure());
    }
  }

  List<DateTime> _daysInRange(DateTime from, DateTime to) {
    final start = dateOnly(from);
    final end = dateOnly(to);
    final count = daysBetween(start, end) + 1;
    if (count <= 0) {
      return const [];
    }
    return List.generate(count, (index) => addDays(start, index));
  }
}
