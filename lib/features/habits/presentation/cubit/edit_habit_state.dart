import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/common/load_status.dart';
import '../../../../core/error/failure.dart';
import '../../domain/entities/habit.dart';

part 'edit_habit_state.freezed.dart';

@freezed
abstract class EditHabitState with _$EditHabitState {
  const factory EditHabitState({
    @Default(LoadStatus.initial) LoadStatus status,
    Habit? habit,
    Failure? failure,
    @Default(false) bool isSaving,
    @Default(false) bool isSaved,
  }) = _EditHabitState;

  const EditHabitState._();

  /// True while the habit itself is being fetched and has not arrived yet.
  bool get isLoadingHabit => status == LoadStatus.loading && habit == null;

  /// True when the habit could not be loaded at all.
  bool get isMissing => status == LoadStatus.failure && habit == null;

  /// True once the habit has loaded; saving failures keep the form usable.
  bool get hasHabit => habit != null;

  String? get errorMessage => failure?.message;
}
