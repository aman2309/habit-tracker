import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/app_date.dart';
import '../entities/daily_summary.dart';
import '../repositories/habit_repository.dart';

/// Builds the summary shown on the "Today" screen.
class GetTodaySummaryUseCase implements UseCase<DailySummary, NoParams> {
  const GetTodaySummaryUseCase(this._repository);

  final HabitRepository _repository;

  @override
  Future<Either<Failure, DailySummary>> call(NoParams params) async {
    final day = today();

    final result = await _repository.getStatusesInRange(from: day, to: day);

    return result.map(
      (statuses) =>
          DailySummary(date: day, habits: List.unmodifiable(statuses)),
    );
  }
}
