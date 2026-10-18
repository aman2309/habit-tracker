import '../../../../core/error/exceptions.dart';
import '../models/habit_completion_model.dart';
import '../models/habit_model.dart';
import 'habit_remote_data_source.dart';

/// Data source used while the backing storage is not wired up yet.
///
/// It performs no reads or writes and never fabricates records: every call
/// reports that storage is unavailable so the UI can show an honest
/// "not connected" state.
class UnconfiguredHabitRemoteDataSource implements HabitRemoteDataSource {
  const UnconfiguredHabitRemoteDataSource();

  static const String _message =
      'Habit storage is not connected yet. Firestore will be enabled in a '
      'later phase, so nothing has been saved.';

  Never _unavailable() =>
      throw const DataSourceNotConfiguredException(_message);

  @override
  Future<HabitModel> createHabit({
    required String name,
    required String description,
    required int points,
  }) async => _unavailable();

  @override
  Future<HabitModel> fetchHabitById(String id) async => _unavailable();

  @override
  Future<List<HabitModel>> fetchHabits() async => _unavailable();

  @override
  Future<HabitModel> updateHabit({
    required String id,
    required String name,
    required String description,
    required int points,
  }) async => _unavailable();

  @override
  Future<void> deleteHabit(String id) async => _unavailable();

  @override
  Future<List<HabitCompletionModel>> fetchCompletions({
    required String fromKey,
    required String toKey,
    String? habitId,
  }) async => _unavailable();

  @override
  Future<void> saveCompletion({
    required String habitId,
    required String dateKey,
    required bool completed,
  }) async => _unavailable();
}
