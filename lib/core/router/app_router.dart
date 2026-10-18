import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../features/habits/presentation/cubit/add_habit_cubit.dart';
import '../../features/habits/presentation/cubit/edit_habit_cubit.dart';
import '../../features/habits/presentation/cubit/habit_detail_cubit.dart';
import '../../features/habits/presentation/pages/add_habit_page.dart';
import '../../features/habits/presentation/pages/edit_habit_page.dart';
import '../../features/habits/presentation/pages/habit_detail_page.dart';
import '../../features/habits/presentation/pages/today_habits_page.dart';
import '../di/injection_container.dart';
import '../theme/app_colors.dart';
import 'app_routes.dart';

/// Notifies screens when a pushed route is popped back to them.
final RouteObserver<ModalRoute<void>> appRouteObserver =
    RouteObserver<ModalRoute<void>>();

/// Application router.
final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.today,
  observers: [appRouteObserver],
  routes: [
    GoRoute(
      path: AppRoutes.today,
      name: AppRouteNames.today,
      builder: (context, state) => const TodayHabitsPage(),
    ),
    GoRoute(
      path: AppRoutes.addHabit,
      name: AppRouteNames.addHabit,
      builder: (context, state) => BlocProvider(
        create: (_) => getIt<AddHabitCubit>(),
        child: const AddHabitPage(),
      ),
    ),
    GoRoute(
      path: AppRoutes.habitDetail,
      name: AppRouteNames.habitDetail,
      builder: (context, state) {
        final habitId = state.pathParameters['habitId'] ?? '';
        return BlocProvider(
          create: (_) => getIt<HabitDetailCubit>()..load(habitId),
          child: HabitDetailPage(habitId: habitId),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.editHabit,
      name: AppRouteNames.editHabit,
      builder: (context, state) {
        final habitId = state.pathParameters['habitId'] ?? '';
        return BlocProvider(
          create: (_) => getIt<EditHabitCubit>()..load(habitId),
          child: EditHabitPage(habitId: habitId),
        );
      },
    ),
  ],
  errorBuilder: (context, state) => const _RouteNotFoundPage(),
);

/// Route names, kept next to the paths they belong to.
abstract final class AppRouteNames {
  static const String today = 'today';
  static const String addHabit = 'add-habit';
  static const String habitDetail = 'habit-detail';
  static const String editHabit = 'edit-habit';
}

class _RouteNotFoundPage extends StatelessWidget {
  const _RouteNotFoundPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Not found')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.explore_off_rounded,
                size: 48,
                color: Colors.black38,
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                'This screen does not exist.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: AppSpacing.xl),
              FilledButton(
                onPressed: () => context.go(AppRoutes.today),
                child: const Text('Back to today'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
