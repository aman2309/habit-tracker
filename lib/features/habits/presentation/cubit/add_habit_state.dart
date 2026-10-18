import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/common/load_status.dart';
import '../../../../core/error/failure.dart';

part 'add_habit_state.freezed.dart';

@freezed
abstract class AddHabitState with _$AddHabitState {
  const factory AddHabitState({
    @Default(LoadStatus.initial) LoadStatus status,
    Failure? failure,
  }) = _AddHabitState;

  const AddHabitState._();

  bool get isSubmitting => status == LoadStatus.loading;

  bool get isSuccess => status == LoadStatus.success;

  String? get errorMessage => failure?.message;
}
