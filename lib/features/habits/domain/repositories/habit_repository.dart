import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entities/habit.dart';
import '../entities/habit_day_status.dart';

/// Storage contract for habits.
///
/// Declared in the domain layer and implemented in the data layer, so the
/// presentation and domain code never depends on a concrete storage backend.
abstract interface class HabitRepository {
  /// Creates a habit and returns it with its generated id.
  Future<Either<Failure, Habit>> createHabit({
    required String name,
    required String description,
    required int points,
  });

  /// Looks up a single habit by id.
  Future<Either<Failure, Habit>> getHabitById(String id);

  /// Updates an existing habit's editable fields and returns the stored habit.
  Future<Either<Failure, Habit>> updateHabit({
    required String id,
    required String name,
    required String description,
    required int points,
  });

  /// Permanently removes a habit and its completion history.
  Future<Either<Failure, Unit>> deleteHabit(String id);

  /// Completion statuses for every habit (or only [habitId] when given)
  /// across the inclusive range `[from, to]`.
  ///
  /// Every habit is reported for every day in the range; days without a
  /// completion record are returned as not completed.
  Future<Either<Failure, List<HabitDayStatus>>> getStatusesInRange({
    required DateTime from,
    required DateTime to,
    String? habitId,
  });

  /// Sets or clears the completion of [habitId] on [date].
  Future<Either<Failure, HabitDayStatus>> setCompletion({
    required String habitId,
    required DateTime date,
    required bool completed,
  });
}
