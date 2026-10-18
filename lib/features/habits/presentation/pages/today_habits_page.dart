import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/common/load_status.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/app_date.dart';
import '../../../profile/presentation/cubit/user_name_cubit.dart';
import '../../../profile/presentation/widgets/rename_name_dialog.dart';
import '../cubit/today_cubit.dart';
import '../cubit/today_state.dart';
import '../widgets/greeting_header.dart';
import '../widgets/habit_card.dart';
import '../widgets/state_views.dart';
import '../widgets/today_progress_card.dart';

/// Screen A: today's habits with progress, points and completion controls.
class TodayHabitsPage extends StatefulWidget {
  const TodayHabitsPage({super.key});

  @override
  State<TodayHabitsPage> createState() => _TodayHabitsPageState();
}

class _TodayHabitsPageState extends State<TodayHabitsPage> with RouteAware {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (route != null) {
      appRouteObserver.subscribe(this, route);
    }
  }

  @override
  void dispose() {
    appRouteObserver.unsubscribe(this);
    super.dispose();
  }

  /// Reloads when a child route (add / detail) is popped back to this screen.
  @override
  void didPopNext() {
    if (mounted) {
      context.read<TodayCubit>().loadToday(showLoading: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(AppRoutes.addHabit),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Add habit'),
      ),
      body: SafeArea(
        bottom: false,
        child: BlocConsumer<TodayCubit, TodayState>(
          listenWhen: (previous, current) =>
              current.feedbackMessage != null &&
              previous.feedbackMessage != current.feedbackMessage,
          listener: (context, state) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text(state.feedbackMessage!)));
            context.read<TodayCubit>().clearFeedback();
          },
          builder: (context, state) => Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  top: AppSpacing.lg,
                  bottom: AppSpacing.lg,
                ),
                child: ContentContainer(
                  child: GreetingHeader(
                    date: today(),
                    name: context.watch<UserNameCubit>().state.name,
                    onEditName: () => showRenameDialog(context),
                  ),
                ),
              ),
              Expanded(child: _TodayBody(state: state)),
            ],
          ),
        ),
      ),
    );
  }
}

class _TodayBody extends StatelessWidget {
  const _TodayBody({required this.state});

  final TodayState state;

  @override
  Widget build(BuildContext context) {
    final summary = state.summary;

    if (state.status == LoadStatus.loading && !state.hasData) {
      return const LoadingStateView(message: 'Loading your habits...');
    }

    if (summary == null) {
      return _Refreshable(
        child: ErrorStateView(
          failure: state.failure!,
          onRetry: () => context.read<TodayCubit>().loadToday(),
        ),
      );
    }

    if (summary.isEmpty) {
      return _Refreshable(
        child: EmptyStateView(
          icon: Icons.playlist_add_rounded,
          title: 'No habits yet',
          message:
              'Add your first habit to start tracking your daily progress.',
          actionLabel: 'Add habit',
          onAction: () => context.push(AppRoutes.addHabit),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => context.read<TodayCubit>().loadToday(showLoading: false),
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.only(bottom: 140),
        children: [
          ContentContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TodayProgressCard(summary: summary),
                const SizedBox(height: AppSpacing.xl),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Your habits',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    Text(
                      '${summary.completedCount}/${summary.totalCount} done',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: AppColors.inkFaint,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                for (final status in summary.habits)
                  Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.md),
                    child: HabitCard(
                      status: status,
                      isBusy: state.isToggling,
                      onToggle: () =>
                          context.read<TodayCubit>().toggleCompletion(
                            habitId: status.habit.id,
                            completed: !status.completed,
                          ),
                      onOpen: () => context.push(
                        AppRoutes.habitDetailPath(status.habit.id),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Makes non-list states pull-to-refreshable.
class _Refreshable extends StatelessWidget {
  const _Refreshable({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => context.read<TodayCubit>().loadToday(showLoading: false),
      child: LayoutBuilder(
        builder: (context, constraints) => SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: child,
          ),
        ),
      ),
    );
  }
}
