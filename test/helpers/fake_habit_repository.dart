import 'package:dartz/dartz.dart';
import 'package:hiicampus_habit_tracker/core/error/failure.dart';
import 'package:hiicampus_habit_tracker/core/utils/app_date.dart';
import 'package:hiicampus_habit_tracker/features/habits/domain/entities/habit.dart';
import 'package:hiicampus_habit_tracker/features/habits/domain/entities/habit_day_status.dart';
import 'package:hiicampus_habit_tracker/features/habits/domain/repositories/habit_repository.dart';

/// In-memory [HabitRepository] used by tests only.
///
/// The app itself never uses fake storage: this double exists so domain and
/// presentation behaviour can be verified without Firestore.
class FakeHabitRepository implements HabitRepository {
  FakeHabitRepository({
    List<Habit>? habits,
    Map<String, Set<DateTime>>? completedDays,
    this.failure,
  }) : habits = habits ?? <Habit>[],
       completedDays = completedDays ?? <String, Set<DateTime>>{};

  final List<Habit> habits;

  /// habit id -> completed calendar days.
  final Map<String, Set<DateTime>> completedDays;

  /// When set, every call returns this failure.
  Failure? failure;

  int createCalls = 0;
  int updateCalls = 0;
  int deleteCalls = 0;
  int setCompletionCalls = 0;
  int statusCalls = 0;

  @override
  Future<Either<Failure, Habit>> createHabit({
    required String name,
    required String description,
    required int points,
  }) async {
    createCalls += 1;
    final currentFailure = failure;
    if (currentFailure != null) return Left(currentFailure);

    final habit = Habit(
      id: 'habit-${habits.length + 1}',
      name: name,
      description: description,
      points: points,
      createdAt: DateTime.now(),
    );
    habits.add(habit);
    return Right(habit);
  }

  @override
  Future<Either<Failure, Habit>> updateHabit({
    required String id,
    required String name,
    required String description,
    required int points,
  }) async {
    updateCalls += 1;
    final currentFailure = failure;
    if (currentFailure != null) return Left(currentFailure);

    final index = habits.indexWhere((habit) => habit.id == id);
    if (index == -1) return const Left(NotFoundFailure('Habit not found.'));

    final updated = habits[index].copyWith(
      name: name,
      description: description,
      points: points,
    );
    habits[index] = updated;
    return Right(updated);
  }

  @override
  Future<Either<Failure, Unit>> deleteHabit(String id) async {
    deleteCalls += 1;
    final currentFailure = failure;
    if (currentFailure != null) return Left(currentFailure);

    final index = habits.indexWhere((habit) => habit.id == id);
    if (index == -1) return const Left(NotFoundFailure('Habit not found.'));

    habits.removeAt(index);
    completedDays.remove(id);
    return const Right(unit);
  }

  @override
  Future<Either<Failure, Habit>> getHabitById(String id) async {
    final currentFailure = failure;
    if (currentFailure != null) return Left(currentFailure);

    for (final habit in habits) {
      if (habit.id == id) return Right(habit);
    }
    return const Left(NotFoundFailure('Habit not found.'));
  }

  @override
  Future<Either<Failure, List<HabitDayStatus>>> getStatusesInRange({
    required DateTime from,
    required DateTime to,
    String? habitId,
  }) async {
    statusCalls += 1;
    final currentFailure = failure;
    if (currentFailure != null) return Left(currentFailure);

    final selected = habitId == null
        ? habits
        : habits.where((habit) => habit.id == habitId).toList();

    final days = <DateTime>[];
    var cursor = dateOnly(from);
    final end = dateOnly(to);
    while (!cursor.isAfter(end)) {
      days.add(cursor);
      cursor = addDays(cursor, 1);
    }

    return Right([
      for (final habit in selected)
        for (final day in days)
          HabitDayStatus(
            habit: habit,
            date: day,
            completed: completedDays[habit.id]?.contains(day) ?? false,
          ),
    ]);
  }

  @override
  Future<Either<Failure, HabitDayStatus>> setCompletion({
    required String habitId,
    required DateTime date,
    required bool completed,
  }) async {
    setCompletionCalls += 1;
    final currentFailure = failure;
    if (currentFailure != null) return Left(currentFailure);

    final habit = habits.firstWhere(
      (item) => item.id == habitId,
      orElse: () => habits.first,
    );

    final days = completedDays.putIfAbsent(habitId, () => <DateTime>{});
    final day = dateOnly(date);
    if (completed) {
      days.add(day);
    } else {
      days.remove(day);
    }

    return Right(HabitDayStatus(habit: habit, date: day, completed: completed));
  }
}

/// Convenience factory for a habit with sensible defaults.
Habit buildHabit({
  String id = 'habit-1',
  String name = 'Drink water',
  String description = 'Two litres',
  int points = 10,
}) => Habit(
  id: id,
  name: name,
  description: description,
  points: points,
  createdAt: DateTime(2026, 1, 1),
);
