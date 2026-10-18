import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/common/load_status.dart';
import '../../../../core/utils/app_date.dart';
import '../../domain/usecases/delete_habit_usecase.dart';
import '../../domain/usecases/get_habit_detail_usecase.dart';
import '../../domain/usecases/set_habit_completion_usecase.dart';
import 'habit_detail_state.dart';

/// Drives the "Habit Detail" screen.
class HabitDetailCubit extends Cubit<HabitDetailState> {
  HabitDetailCubit({
    required this.getHabitDetail,
    required this.setHabitCompletion,
    required this.deleteHabit,
  }) : super(const HabitDetailState());

  final GetHabitDetailUseCase getHabitDetail;
  final SetHabitCompletionUseCase setHabitCompletion;
  final DeleteHabitUseCase deleteHabit;

  /// Loads the habit, its seven day history and current streak.
  Future<void> load(String habitId, {bool showLoading = true}) async {
    emit(
      state.copyWith(
        habitId: habitId,
        status: showLoading || !state.hasData
            ? LoadStatus.loading
            : state.status,
        failure: null,
      ),
    );

    final result = await getHabitDetail(GetHabitDetailParams(habitId: habitId));
    if (isClosed) return;

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: state.hasData ? LoadStatus.success : LoadStatus.failure,
          failure: failure,
          feedbackMessage: state.hasData ? failure.message : null,
          isToggling: false,
        ),
      ),
      (detail) => emit(
        state.copyWith(
          status: LoadStatus.success,
          detail: detail,
          failure: null,
          isToggling: false,
        ),
      ),
    );
  }

  /// Toggles today's completion for the loaded habit.
  Future<void> toggleToday() async {
    final detail = state.detail;
    if (detail == null || state.isToggling) return;

    emit(state.copyWith(isToggling: true, failure: null));

    final result = await setHabitCompletion(
      SetHabitCompletionParams(
        habitId: detail.habit.id,
        date: today(),
        completed: !detail.completedToday,
      ),
    );
    if (isClosed) return;

    await result.fold(
      (failure) async => emit(
        state.copyWith(
          isToggling: false,
          failure: failure,
          feedbackMessage: failure.message,
        ),
      ),
      (_) => load(detail.habit.id, showLoading: false),
    );
  }

  /// Deletes the loaded habit and its completion history.
  Future<void> delete() async {
    final detail = state.detail;
    if (detail == null || state.isDeleting) return;

    emit(state.copyWith(isDeleting: true, failure: null));

    final result = await deleteHabit(
      DeleteHabitParams(habitId: detail.habit.id),
    );
    if (isClosed) return;

    result.fold(
      (failure) => emit(
        state.copyWith(
          isDeleting: false,
          failure: failure,
          feedbackMessage: failure.message,
        ),
      ),
      (_) => emit(state.copyWith(isDeleting: false, isDeleted: true)),
    );
  }

  /// Clears the transient snackbar message.
  void clearFeedback() {
    if (state.feedbackMessage != null) {
      emit(state.copyWith(feedbackMessage: null));
    }
  }
}
