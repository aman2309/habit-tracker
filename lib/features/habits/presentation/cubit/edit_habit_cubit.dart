import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/common/load_status.dart';
import '../../../../core/error/failure.dart';
import '../../domain/usecases/get_habit_by_id_usecase.dart';
import '../../domain/usecases/update_habit_usecase.dart';
import 'edit_habit_state.dart';

/// Drives the "Edit Habit" form.
class EditHabitCubit extends Cubit<EditHabitState> {
  EditHabitCubit({required this.getHabitById, required this.updateHabit})
    : super(const EditHabitState());

  final GetHabitByIdUseCase getHabitById;
  final UpdateHabitUseCase updateHabit;

  /// Loads the habit that will be edited.
  Future<void> load(String habitId) async {
    emit(state.copyWith(status: LoadStatus.loading, failure: null));
    final result = await getHabitById(GetHabitByIdParams(habitId: habitId));
    if (isClosed) return;

    result.fold(
      (failure) =>
          emit(state.copyWith(status: LoadStatus.failure, failure: failure)),
      (habit) => emit(
        state.copyWith(status: LoadStatus.success, habit: habit, failure: null),
      ),
    );
  }

  /// Validates and saves the edited fields.
  ///
  /// Submissions are ignored while one is already running.
  Future<void> save({
    required String name,
    required String description,
    required String points,
  }) async {
    final habit = state.habit;
    if (habit == null || state.isSaving) return;

    emit(state.copyWith(isSaving: true, failure: null, isSaved: false));

    final parsedPoints = int.tryParse(points.trim());
    if (parsedPoints == null) {
      emit(
        state.copyWith(
          isSaving: false,
          failure: const ValidationFailure(
            'Points must be a whole number, for example 10.',
            field: 'points',
          ),
        ),
      );
      return;
    }

    final result = await updateHabit(
      UpdateHabitParams(
        id: habit.id,
        name: name,
        description: description,
        points: parsedPoints,
      ),
    );
    if (isClosed) return;

    result.fold(
      (failure) => emit(state.copyWith(isSaving: false, failure: failure)),
      (_) =>
          emit(state.copyWith(isSaving: false, isSaved: true, failure: null)),
    );
  }

  /// Clears the transient error message.
  void clearError() {
    if (state.failure != null) {
      emit(state.copyWith(failure: null));
    }
  }
}
