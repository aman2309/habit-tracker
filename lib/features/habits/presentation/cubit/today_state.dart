import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/common/load_status.dart';
import '../../../../core/error/failure.dart';
import '../../domain/entities/daily_summary.dart';

part 'today_state.freezed.dart';

@freezed
abstract class TodayState with _$TodayState {
  const factory TodayState({
    @Default(LoadStatus.loading) LoadStatus status,
    DailySummary? summary,
    Failure? failure,
    @Default(false) bool isToggling,
    String? feedbackMessage,
  }) = _TodayState;

  const TodayState._();

  bool get hasData => summary != null;

  bool get isEmpty =>
      status == LoadStatus.success && (summary?.isEmpty ?? false);
}
