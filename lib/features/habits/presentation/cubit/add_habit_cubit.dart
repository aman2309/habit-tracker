import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/common/load_status.dart';
import '../../../../core/error/failure.dart';
import '../../domain/usecases/create_habit_usecase.dart';
import 'add_habit_state.dart';

/// Drives the "Add Habit" form.
class AddHabitCubit extends Cubit<AddHabitState> {
  AddHabitCubit({required this.createHabit}) : super(const AddHabitState());

  final CreateHabitUseCase createHabit;

  /// Validates and stores a new habit.
  ///
  /// Submissions are ignored while one is already running so the form cannot
  /// be submitted twice.
  Future<void> submit({
    required String name,
    required String description,
    required String points,
  }) async {
    if (state.isSubmitting) return;

    emit(state.copyWith(status: LoadStatus.loading, failure: null));

    final parsedPoints = int.tryParse(points.trim());
    if (parsedPoints == null) {
      emit(
        state.copyWith(
          status: LoadStatus.failure,
          failure: const ValidationFailure(
            'Points must be a whole number, for example 10.',
            field: 'points',
          ),
        ),
      );
      return;
    }

    final result = await createHabit(
      CreateHabitParams(
        name: name,
        description: description,
        points: parsedPoints,
      ),
    );
    if (isClosed) return;

    result.fold(
      (failure) =>
          emit(state.copyWith(status: LoadStatus.failure, failure: failure)),
      (_) => emit(state.copyWith(status: LoadStatus.success, failure: null)),
    );
  }

  /// Returns the form to its idle state (used after showing an error).
  void reset() {
    if (state.status != LoadStatus.initial) {
      emit(const AddHabitState());
    }
  }
}
