import 'package:hiicampus_habit_tracker/core/error/exceptions.dart';
import 'package:hiicampus_habit_tracker/features/habits/data/datasources/habit_remote_data_source.dart';
import 'package:hiicampus_habit_tracker/features/habits/data/models/habit_completion_model.dart';
import 'package:hiicampus_habit_tracker/features/habits/data/models/habit_model.dart';

/// In-memory [HabitRemoteDataSource] used by data-layer tests.
///
/// The app never uses this: it exists only so the repository and mapping logic
/// can be exercised without a live Firestore.
class FakeHabitRemoteDataSource implements HabitRemoteDataSource {
  FakeHabitRemoteDataSource({this.failure});

  final Map<String, HabitModel> habits = {};

  /// habitId -> dayKey -> completion.
  final Map<String, Map<String, HabitCompletionModel>> completions = {};

  /// When set, every call throws this exception.
  Object? failure;

  int createCalls = 0;
  int updateCalls = 0;
  int deleteCalls = 0;
  int saveCalls = 0;

  void _checkFailure() {
    final current = failure;
    if (current != null) throw current;
  }

  @override
  Future<HabitModel> createHabit({
    required String name,
    required String description,
    required int points,
  }) async {
    createCalls += 1;
    _checkFailure();
    final model = HabitModel(
      id: 'habit-${habits.length + 1}',
      name: name,
      description: description,
      points: points,
      createdAt: DateTime(2026, 1, 1),
    );
    habits[model.id] = model;
    return model;
  }

  @override
  Future<HabitModel> fetchHabitById(String id) async {
    _checkFailure();
    final habit = habits[id];
    if (habit == null) {
      throw const RecordNotFoundException('That habit no longer exists.');
    }
    return habit;
  }

  @override
  Future<List<HabitModel>> fetchHabits() async {
    _checkFailure();
    return habits.values.toList();
  }

  @override
  Future<HabitModel> updateHabit({
    required String id,
    required String name,
    required String description,
    required int points,
  }) async {
    updateCalls += 1;
    _checkFailure();
    final existing = habits[id];
    if (existing == null) {
      throw const RecordNotFoundException('That habit no longer exists.');
    }
    final updated = existing.copyWith(
      name: name,
      description: description,
      points: points,
    );
    habits[id] = updated;
    return updated;
  }

  @override
  Future<void> deleteHabit(String id) async {
    deleteCalls += 1;
    _checkFailure();
    habits.remove(id);
    completions.remove(id);
  }

  @override
  Future<List<HabitCompletionModel>> fetchCompletions({
    required String fromKey,
    required String toKey,
    String? habitId,
  }) async {
    _checkFailure();
    final result = <HabitCompletionModel>[];
    completions.forEach((id, byDay) {
      if (habitId != null && habitId != id) return;
      byDay.forEach((day, completion) {
        if (day.compareTo(fromKey) >= 0 && day.compareTo(toKey) <= 0) {
          result.add(completion);
        }
      });
    });
    return result;
  }

  @override
  Future<void> saveCompletion({
    required String habitId,
    required String dateKey,
    required bool completed,
  }) async {
    saveCalls += 1;
    _checkFailure();
    final byDay = completions.putIfAbsent(habitId, () => {});
    if (completed) {
      byDay[dateKey] = HabitCompletionModel(
        habitId: habitId,
        date: dateKey,
        completed: true,
      );
    } else {
      byDay.remove(dateKey);
    }
  }
}
