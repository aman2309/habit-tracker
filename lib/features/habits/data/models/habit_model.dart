import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/habit.dart';

part 'habit_model.freezed.dart';
part 'habit_model.g.dart';

/// Storage representation of a [Habit].
///
/// Lives in the data layer so the domain entity stays free of serialization
/// concerns. Mapping helpers keep entity/model conversion in one place.
@freezed
abstract class HabitModel with _$HabitModel {
  const HabitModel._();

  const factory HabitModel({
    required String id,
    required String name,
    required String description,
    required int points,
    @JsonKey(name: 'createdAt') required DateTime createdAt,
  }) = _HabitModel;

  factory HabitModel.fromJson(Map<String, dynamic> json) =>
      _$HabitModelFromJson(json);

  /// Builds a model from a Firestore document.
  ///
  /// The document id is the habit id. Missing or malformed fields are coerced
  /// to safe defaults instead of throwing, so a single bad document cannot
  /// break the whole list.
  factory HabitModel.fromFirestore(String id, Map<String, dynamic> data) {
    final rawPoints = data['points'];
    return HabitModel(
      id: id,
      name: (data['name'] as String?)?.trim() ?? '',
      description: (data['description'] as String?)?.trim() ?? '',
      points: rawPoints is int ? rawPoints : int.tryParse('$rawPoints') ?? 0,
      createdAt: _readCreatedAt(data['createdAt']) ?? DateTime.now(),
    );
  }

  /// Fields written to Firestore. The document id is not stored in the body.
  Map<String, Object?> toFirestore() => {
    'name': name,
    'description': description,
    'points': points,
    'createdAt': Timestamp.fromDate(createdAt),
  };

  Habit toEntity() => Habit(
    id: id,
    name: name,
    description: description,
    points: points,
    createdAt: createdAt,
  );

  factory HabitModel.fromEntity(Habit habit) => HabitModel(
    id: habit.id,
    name: habit.name,
    description: habit.description,
    points: habit.points,
    createdAt: habit.createdAt,
  );
}

/// Accepts the shapes Firestore (or JSON) may hand back for a timestamp.
DateTime? _readCreatedAt(Object? value) {
  if (value is Timestamp) return value.toDate();
  if (value is DateTime) return value;
  if (value is int) return DateTime.fromMillisecondsSinceEpoch(value);
  if (value is String) return DateTime.tryParse(value);
  return null;
}
