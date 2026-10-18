import 'package:flutter_test/flutter_test.dart';
import 'package:hiicampus_habit_tracker/core/config/dev_identity.dart';
import 'package:hiicampus_habit_tracker/core/di/injection_container.dart';
import 'package:hiicampus_habit_tracker/features/habits/data/datasources/habit_remote_data_source.dart';
import 'package:hiicampus_habit_tracker/features/habits/data/repositories/habit_repository_impl.dart';
import 'package:hiicampus_habit_tracker/features/habits/domain/repositories/habit_repository.dart';
import 'package:hiicampus_habit_tracker/features/habits/domain/usecases/create_habit_usecase.dart';
import 'package:hiicampus_habit_tracker/features/habits/domain/usecases/delete_habit_usecase.dart';
import 'package:hiicampus_habit_tracker/features/habits/domain/usecases/get_habit_by_id_usecase.dart';
import 'package:hiicampus_habit_tracker/features/habits/domain/usecases/get_habit_detail_usecase.dart';
import 'package:hiicampus_habit_tracker/features/habits/domain/usecases/get_today_summary_usecase.dart';
import 'package:hiicampus_habit_tracker/features/habits/domain/usecases/set_habit_completion_usecase.dart';
import 'package:hiicampus_habit_tracker/features/habits/domain/usecases/update_habit_usecase.dart';
import 'package:hiicampus_habit_tracker/features/habits/presentation/cubit/add_habit_cubit.dart';
import 'package:hiicampus_habit_tracker/features/habits/presentation/cubit/edit_habit_cubit.dart';
import 'package:hiicampus_habit_tracker/features/habits/presentation/cubit/habit_detail_cubit.dart';
import 'package:hiicampus_habit_tracker/features/habits/presentation/cubit/today_cubit.dart';
import 'package:hiicampus_habit_tracker/features/profile/presentation/cubit/user_name_cubit.dart';

import '../../helpers/fake_habit_remote_data_source.dart';
import '../../helpers/fake_user_name_store.dart';

void main() {
  setUp(() async {
    await resetDependencies();
  });

  tearDown(() async {
    await resetDependencies();
  });

  void register() {
    initDependencies(
      habitRemoteDataSource: FakeHabitRemoteDataSource(),
      userNameStore: FakeUserNameStore(name: 'Aman'),
    );
  }

  test('wires the full graph using the injected data source', () {
    register();

    expect(getIt<UserIdProvider>().userId, kDevUserId);
    expect(getIt<HabitRemoteDataSource>(), isA<FakeHabitRemoteDataSource>());
    expect(getIt<HabitRepository>(), isA<HabitRepositoryImpl>());
    expect(getIt<GetTodaySummaryUseCase>(), isA<GetTodaySummaryUseCase>());
    expect(getIt<CreateHabitUseCase>(), isA<CreateHabitUseCase>());
    expect(getIt<GetHabitByIdUseCase>(), isA<GetHabitByIdUseCase>());
    expect(getIt<UpdateHabitUseCase>(), isA<UpdateHabitUseCase>());
    expect(getIt<DeleteHabitUseCase>(), isA<DeleteHabitUseCase>());
    expect(
      getIt<SetHabitCompletionUseCase>(),
      isA<SetHabitCompletionUseCase>(),
    );
    expect(getIt<GetHabitDetailUseCase>(), isA<GetHabitDetailUseCase>());
    expect(getIt<TodayCubit>(), isA<TodayCubit>());
    expect(getIt<AddHabitCubit>(), isA<AddHabitCubit>());
    expect(getIt<HabitDetailCubit>(), isA<HabitDetailCubit>());
    expect(getIt<EditHabitCubit>(), isA<EditHabitCubit>());
    expect(getIt<UserNameCubit>(), isA<UserNameCubit>());
  });

  test('uses the development identity by default', () {
    register();

    expect(getIt<UserIdProvider>().userId, 'dev-user');
  });

  test('accepts a custom user id provider', () {
    initDependencies(
      habitRemoteDataSource: FakeHabitRemoteDataSource(),
      userIdProvider: const DevUserIdProvider('dev-alice'),
      userNameStore: FakeUserNameStore(name: 'Aman'),
    );

    expect(getIt<UserIdProvider>().userId, 'dev-alice');
  });
}
