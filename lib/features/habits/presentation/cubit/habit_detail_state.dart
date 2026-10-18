import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/common/load_status.dart';
import '../../../../core/error/failure.dart';
import '../../domain/entities/habit_detail.dart';

part 'habit_detail_state.freezed.dart';

@freezed
abstract class HabitDetailState with _$HabitDetailState {
  const factory HabitDetailState({
    @Default('') String habitId,
    @Default(LoadStatus.loading) LoadStatus status,
    HabitDetail? detail,
    Failure? failure,
    @Default(false) bool isToggling,
    @Default(false) bool isDeleting,
    @Default(false) bool isDeleted,
    String? feedbackMessage,
  }) = _HabitDetailState;

  const HabitDetailState._();

  bool get hasData => detail != null;
}
