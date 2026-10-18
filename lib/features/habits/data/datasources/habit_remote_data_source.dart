import '../models/habit_completion_model.dart';
import '../models/habit_model.dart';

/// Storage operations required by [HabitRepositoryImpl].
///
/// The Firestore implementation will be added in a later phase; until then the
/// unconfigured implementation reports that no storage is available instead of
/// inventing data.
abstract interface class HabitRemoteDataSource {
  Future<HabitModel> createHabit({
    required String name,
    required String description,
    required int points,
  });

  Future<HabitModel> fetchHabitById(String id);

  Future<List<HabitModel>> fetchHabits();

  /// Updates an existing habit's editable fields and returns the stored model.
  Future<HabitModel> updateHabit({
    required String id,
    required String name,
    required String description,
    required int points,
  });

  /// Permanently removes a habit and its completion records.
  Future<void> deleteHabit(String id);

  /// Completions in the inclusive range `[fromKey, toKey]`
  /// (`yyyy-MM-dd`), optionally limited to a single habit.
  Future<List<HabitCompletionModel>> fetchCompletions({
    required String fromKey,
    required String toKey,
    String? habitId,
  });

  /// Creates or updates a single completion record.
  Future<void> saveCompletion({
    required String habitId,
    required String dateKey,
    required bool completed,
  });
}
