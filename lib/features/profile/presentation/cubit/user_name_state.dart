import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/common/load_status.dart';
import '../../../../core/error/failure.dart';

part 'user_name_state.freezed.dart';

@freezed
abstract class UserNameState with _$UserNameState {
  const factory UserNameState({
    @Default(LoadStatus.initial) LoadStatus status,
    @Default(false) bool isSaving,
    @Default('') String name,
    Failure? failure,
  }) = _UserNameState;

  const UserNameState._();

  /// True while the very first read from storage is still running.
  bool get isLoading =>
      status == LoadStatus.initial || status == LoadStatus.loading;

  /// True once storage has been read (with or without a name).
  bool get isLoaded => status == LoadStatus.success;

  /// Whether a usable name has been set.
  bool get hasName => name.trim().isNotEmpty;

  String? get errorMessage => failure?.message;
}
