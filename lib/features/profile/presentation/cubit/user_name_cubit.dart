import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/common/load_status.dart';
import '../../../../core/error/failure.dart';
import '../../data/user_name_store.dart';
import 'user_name_state.dart';

/// Owns the user's display name: loads it once and lets the user set or change
/// it. The name is persisted locally via [UserNameStore].
class UserNameCubit extends Cubit<UserNameState> {
  UserNameCubit({required this.store}) : super(const UserNameState());

  final UserNameStore store;

  static const int maxNameLength = 40;

  /// Reads the stored name. An unreadable store is treated as "no name yet"
  /// so the user can still set one instead of being stuck on a splash.
  Future<void> load() async {
    emit(state.copyWith(status: LoadStatus.loading, failure: null));
    String? stored;
    try {
      stored = await store.readName();
    } catch (_) {
      stored = null;
    }
    if (isClosed) return;
    emit(state.copyWith(status: LoadStatus.success, name: stored ?? ''));
  }

  /// Validates and persists a new name.
  Future<void> saveName(String rawName) async {
    final name = rawName.trim();
    if (name.isEmpty) {
      emit(
        state.copyWith(
          failure: const ValidationFailure('Please enter your name.'),
        ),
      );
      return;
    }
    if (name.length > maxNameLength) {
      emit(
        state.copyWith(
          failure: ValidationFailure(
            'Please use $maxNameLength characters or fewer.',
          ),
        ),
      );
      return;
    }

    emit(state.copyWith(isSaving: true, failure: null));

    try {
      await store.writeName(name);
    } catch (_) {
      if (isClosed) return;
      emit(
        state.copyWith(
          isSaving: false,
          failure: const ValidationFailure(
            'Could not save your name. Try again.',
          ),
        ),
      );
      return;
    }
    if (isClosed) return;
    emit(state.copyWith(isSaving: false, name: name, failure: null));
  }

  /// Clears the transient validation error.
  void clearError() {
    if (state.failure != null) {
      emit(state.copyWith(failure: null));
    }
  }
}
