import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/common/load_status.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/get_today_summary_usecase.dart';
import '../../domain/usecases/set_habit_completion_usecase.dart';
import 'today_state.dart';

/// Drives the "Today's Habits" screen.
class TodayCubit extends Cubit<TodayState> {
  TodayCubit({required this.getTodaySummary, required this.setHabitCompletion})
    : super(const TodayState());

  final GetTodaySummaryUseCase getTodaySummary;
  final SetHabitCompletionUseCase setHabitCompletion;

  /// Loads (or reloads) today's summary.
  Future<void> loadToday({bool showLoading = true}) async {
    if (showLoading) {
      emit(state.copyWith(status: LoadStatus.loading, failure: null));
    }

    final result = await getTodaySummary(const NoParams());
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
      (summary) => emit(
        state.copyWith(
          status: LoadStatus.success,
          summary: summary,
          failure: null,
          isToggling: false,
        ),
      ),
    );
  }

  /// Marks [habitId] done or undone for today.
  ///
  /// The change is applied optimistically and rolled back when storage
  /// rejects it.
  Future<void> toggleCompletion({
    required String habitId,
    required bool completed,
  }) async {
    final previous = state.summary;
    if (previous == null || state.isToggling) return;

    emit(
      state.copyWith(
        summary: previous.withCompletion(
          habitId: habitId,
          completed: completed,
        ),
        isToggling: true,
        failure: null,
      ),
    );

    final result = await setHabitCompletion(
      SetHabitCompletionParams(
        habitId: habitId,
        date: previous.date,
        completed: completed,
      ),
    );
    if (isClosed) return;

    result.fold(
      (failure) => emit(
        state.copyWith(
          summary: previous,
          isToggling: false,
          failure: failure,
          feedbackMessage: failure.message,
        ),
      ),
      (_) => emit(state.copyWith(isToggling: false, failure: null)),
    );
  }

  /// Clears the transient snackbar message.
  void clearFeedback() {
    if (state.feedbackMessage != null) {
      emit(state.copyWith(feedbackMessage: null));
    }
  }
}
