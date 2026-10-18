import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';

import '../../features/habits/data/datasources/firestore_habit_remote_data_source.dart';
import '../../features/habits/data/datasources/habit_remote_data_source.dart';
import '../../features/habits/data/repositories/habit_repository_impl.dart';
import '../../features/habits/domain/repositories/habit_repository.dart';
import '../../features/habits/domain/usecases/create_habit_usecase.dart';
import '../../features/habits/domain/usecases/delete_habit_usecase.dart';
import '../../features/habits/domain/usecases/get_habit_by_id_usecase.dart';
import '../../features/habits/domain/usecases/get_habit_detail_usecase.dart';
import '../../features/habits/domain/usecases/get_today_summary_usecase.dart';
import '../../features/habits/domain/usecases/set_habit_completion_usecase.dart';
import '../../features/habits/domain/usecases/update_habit_usecase.dart';
import '../../features/habits/presentation/cubit/add_habit_cubit.dart';
import '../../features/habits/presentation/cubit/edit_habit_cubit.dart';
import '../../features/habits/presentation/cubit/habit_detail_cubit.dart';
import '../../features/habits/presentation/cubit/today_cubit.dart';
import '../../features/profile/data/user_name_store.dart';
import '../../features/profile/presentation/cubit/user_name_cubit.dart';
import '../config/dev_identity.dart';

/// Service locator used to wire layers together.
final GetIt getIt = GetIt.instance;

/// Registers data sources, repository, use cases and cubit factories.
///
/// The production data source is [FirestoreHabitRemoteDataSource]. Tests pass
/// [habitRemoteDataSource] and/or [userNameStore] to swap in doubles.
void initDependencies({
  HabitRemoteDataSource? habitRemoteDataSource,
  UserIdProvider? userIdProvider,
  UserNameStore? userNameStore,
}) {
  getIt
    ..registerLazySingleton<UserIdProvider>(
      () => userIdProvider ?? const DevUserIdProvider(),
    )
    ..registerLazySingleton<UserNameStore>(
      () => userNameStore ?? const SharedPreferencesUserNameStore(),
    )
    ..registerLazySingleton<HabitRemoteDataSource>(
      () =>
          habitRemoteDataSource ??
          FirestoreHabitRemoteDataSource(
            FirebaseFirestore.instance,
            getIt<UserIdProvider>(),
          ),
    )
    ..registerLazySingleton<HabitRepository>(() => HabitRepositoryImpl(getIt()))
    ..registerLazySingleton(() => GetTodaySummaryUseCase(getIt()))
    ..registerLazySingleton(() => CreateHabitUseCase(getIt()))
    ..registerLazySingleton(() => SetHabitCompletionUseCase(getIt()))
    ..registerLazySingleton(() => GetHabitDetailUseCase(getIt()))
    ..registerLazySingleton(() => GetHabitByIdUseCase(getIt()))
    ..registerLazySingleton(() => UpdateHabitUseCase(getIt()))
    ..registerLazySingleton(() => DeleteHabitUseCase(getIt()))
    ..registerFactory(
      () => TodayCubit(getTodaySummary: getIt(), setHabitCompletion: getIt()),
    )
    ..registerFactory(() => AddHabitCubit(createHabit: getIt()))
    ..registerFactory(
      () => HabitDetailCubit(
        getHabitDetail: getIt(),
        setHabitCompletion: getIt(),
        deleteHabit: getIt(),
      ),
    )
    ..registerFactory(
      () => EditHabitCubit(getHabitById: getIt(), updateHabit: getIt()),
    )
    ..registerFactory(() => UserNameCubit(store: getIt()));
}

/// Clears all registrations (used by tests).
Future<void> resetDependencies() => getIt.reset();
