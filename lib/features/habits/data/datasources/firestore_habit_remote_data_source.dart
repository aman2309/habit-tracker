import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/config/dev_identity.dart';
import '../../../../core/error/exceptions.dart';
import '../models/habit_completion_model.dart';
import '../models/habit_model.dart';
import 'habit_remote_data_source.dart';

/// Firestore-backed implementation of [HabitRemoteDataSource].
///
/// Data layout (all dates are **local** calendar days, `yyyy-MM-dd`):
///
/// * `users/{userId}/habits/{habitId}`
///   * `name: string`
///   * `description: string`
///   * `points: number`
///   * `createdAt: timestamp`
/// * `users/{userId}/habits/{habitId}/completions/{yyyy-MM-dd}`
///   * `completed: bool`
///
/// The completion document id *is* the day, so there is no duplicated `date`
/// field. Only completed days are stored; clearing a completion deletes the
/// document.
///
/// Firestore exceptions (permission denied, offline, missing documents,
/// malformed data) are translated into data-layer exceptions here; the
/// repository is responsible for turning those into domain failures.
class FirestoreHabitRemoteDataSource implements HabitRemoteDataSource {
  FirestoreHabitRemoteDataSource(this._firestore, this._userIdProvider);

  final FirebaseFirestore _firestore;
  final UserIdProvider _userIdProvider;

  CollectionReference<Map<String, dynamic>> get _habits => _firestore
      .collection('users')
      .doc(_userIdProvider.userId)
      .collection('habits');

  CollectionReference<Map<String, dynamic>> _completions(String habitId) =>
      _habits.doc(habitId).collection('completions');

  @override
  Future<HabitModel> createHabit({
    required String name,
    required String description,
    required int points,
  }) => _guard(() async {
    final document = _habits.doc();
    final model = HabitModel(
      id: document.id,
      name: name,
      description: description,
      points: points,
      createdAt: DateTime.now(),
    );
    await document.set(model.toFirestore());
    return model;
  });

  @override
  Future<HabitModel> fetchHabitById(String id) => _guard(() async {
    final snapshot = await _habits.doc(id).get();
    final data = snapshot.data();
    if (!snapshot.exists || data == null) {
      throw const RecordNotFoundException('That habit no longer exists.');
    }
    return HabitModel.fromFirestore(snapshot.id, data);
  });

  @override
  Future<List<HabitModel>> fetchHabits() => _guard(() async {
    final snapshot = await _habits.get();
    final models = [
      for (final document in snapshot.docs)
        HabitModel.fromFirestore(document.id, document.data()),
    ];
    models.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    return models;
  });

  @override
  Future<HabitModel> updateHabit({
    required String id,
    required String name,
    required String description,
    required int points,
  }) => _guard(() async {
    final document = _habits.doc(id);
    final snapshot = await document.get();
    final data = snapshot.data();
    if (!snapshot.exists || data == null) {
      throw const RecordNotFoundException('That habit no longer exists.');
    }
    final updated = HabitModel.fromFirestore(
      id,
      data,
    ).copyWith(name: name, description: description, points: points);
    await document.set(updated.toFirestore());
    return updated;
  });

  @override
  Future<void> deleteHabit(String id) => _guard(() async {
    // Remove completion records first so no orphaned subcollection is left
    // behind, then delete the habit document itself.
    final completions = await _completions(id).get();
    final batch = _firestore.batch();
    for (final document in completions.docs) {
      batch.delete(document.reference);
    }
    batch.delete(_habits.doc(id));
    await batch.commit();
  });

  @override
  Future<List<HabitCompletionModel>> fetchCompletions({
    required String fromKey,
    required String toKey,
    String? habitId,
  }) => _guard(() async {
    final ids = habitId != null
        ? [habitId]
        : (await _habits.get()).docs.map((doc) => doc.id).toList();

    final completions = <HabitCompletionModel>[];
    for (final id in ids) {
      final snapshot = await _completions(id)
          .where(FieldPath.documentId, isGreaterThanOrEqualTo: fromKey)
          .where(FieldPath.documentId, isLessThanOrEqualTo: toKey)
          .get();
      for (final document in snapshot.docs) {
        completions.add(
          HabitCompletionModel.fromFirestore(
            habitId: id,
            dayKey: document.id,
            data: document.data(),
          ),
        );
      }
    }
    return completions;
  });

  @override
  Future<void> saveCompletion({
    required String habitId,
    required String dateKey,
    required bool completed,
  }) => _guard(() async {
    final document = _completions(habitId).doc(dateKey);
    if (completed) {
      await document.set(
        HabitCompletionModel(
          habitId: habitId,
          date: dateKey,
          completed: true,
        ).toFirestore(),
      );
    } else {
      // Only completed days are stored, so clearing removes the record.
      await document.delete();
    }
  });

  /// Runs [action] and converts any backend error into a data-layer exception.
  Future<T> _guard<T>(Future<T> Function() action) async {
    try {
      return await action();
    } on FirebaseException catch (error) {
      throw _mapFirebaseException(error);
    } on AppException {
      rethrow;
    } catch (error) {
      throw SerializationException(
        'Stored habit data could not be read: $error',
      );
    }
  }

  AppException _mapFirebaseException(FirebaseException error) {
    switch (error.code) {
      case 'permission-denied':
        return const PermissionDeniedException(
          'Firestore security rules rejected this request.',
        );
      case 'unavailable':
      case 'deadline-exceeded':
        return const UnavailableException(
          'Firestore is unreachable right now.',
        );
      case 'not-found':
        return const RecordNotFoundException('That habit no longer exists.');
      case 'failed-precondition':
      case 'invalid-argument':
      case 'already-exists':
        return RemoteDataException(
          'Firestore rejected the request (${error.code}).',
        );
      default:
        return RemoteDataException('Firestore error (${error.code}).');
    }
  }
}
