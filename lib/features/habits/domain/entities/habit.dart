import 'package:freezed_annotation/freezed_annotation.dart';

part 'habit.freezed.dart';

/// Core habit definition independent of any storage format.
@freezed
abstract class Habit with _$Habit {
  const Habit._();

  const factory Habit({
    required String id,
    required String name,
    required String description,
    required int points,
    required DateTime createdAt,
  }) = _Habit;
}
