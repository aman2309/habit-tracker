import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/di/injection_container.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/habits/presentation/cubit/today_cubit.dart';
import 'features/profile/presentation/cubit/user_name_cubit.dart';
import 'features/profile/presentation/pages/name_setup_page.dart';

/// Root widget: owns the app wide cubits and decides what to show first.
class HabitTrackerApp extends StatelessWidget {
  const HabitTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<TodayCubit>(
          create: (_) => getIt<TodayCubit>()..loadToday(),
        ),
        BlocProvider<UserNameCubit>(
          create: (_) => getIt<UserNameCubit>()..load(),
        ),
      ],
      child: const _AppGate(),
    );
  }
}

/// Shows a lightweight splash while the name loads, the name setup screen when
/// no name has been set yet, and the router once a name exists.
class _AppGate extends StatelessWidget {
  const _AppGate();

  @override
  Widget build(BuildContext context) {
    final state = context.watch<UserNameCubit>().state;

    if (state.isLoading && !state.hasName) {
      return MaterialApp(
        title: 'HiiCampus Habit Tracker',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        home: const _StartupScreen(),
      );
    }

    if (!state.hasName) {
      return MaterialApp(
        title: 'HiiCampus Habit Tracker',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        home: const NameSetupPage(),
      );
    }

    return MaterialApp.router(
      title: 'HiiCampus Habit Tracker',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      routerConfig: appRouter,
    );
  }
}

class _StartupScreen extends StatelessWidget {
  const _StartupScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
