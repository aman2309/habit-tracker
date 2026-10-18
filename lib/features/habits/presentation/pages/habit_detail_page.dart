import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/common/load_status.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/app_date.dart';
import '../../domain/entities/habit_detail.dart';
import '../cubit/habit_detail_cubit.dart';
import '../cubit/habit_detail_state.dart';
import '../widgets/points_badge.dart';
import '../widgets/state_views.dart';
import '../widgets/week_history_strip.dart';

/// Screen C: details, seven day history and streak for one habit.
class HabitDetailPage extends StatelessWidget {
  const HabitDetailPage({super.key, required this.habitId});

  final String habitId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Habit'),
        leading: BackButton(onPressed: () => _back(context)),
        actions: [
          BlocBuilder<HabitDetailCubit, HabitDetailState>(
            buildWhen: (previous, current) =>
                previous.detail?.habit.id != current.detail?.habit.id,
            builder: (context, state) {
              final detail = state.detail;
              if (detail == null) return const SizedBox.shrink();
              return IconButton(
                tooltip: 'Edit habit',
                onPressed: () => _openEdit(context, detail.habit.id),
                icon: const Icon(Icons.edit_outlined),
              );
            },
          ),
          const SizedBox(width: AppSpacing.xs),
        ],
      ),
      body: BlocConsumer<HabitDetailCubit, HabitDetailState>(
        listenWhen: (previous, current) =>
            current.isDeleted != previous.isDeleted ||
            (current.feedbackMessage != null &&
                previous.feedbackMessage != current.feedbackMessage),
        listener: (context, state) {
          if (state.isDeleted) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(const SnackBar(content: Text('Habit deleted.')));
            _back(context);
            return;
          }
          if (state.feedbackMessage != null) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text(state.feedbackMessage!)));
            context.read<HabitDetailCubit>().clearFeedback();
          }
        },
        builder: (context, state) => _DetailBody(state: state),
      ),
    );
  }

  Future<void> _openEdit(BuildContext context, String habitId) async {
    final cubit = context.read<HabitDetailCubit>();
    await context.push(AppRoutes.editHabitPath(habitId));
    if (context.mounted) {
      cubit.load(habitId, showLoading: false);
    }
  }

  void _back(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go(AppRoutes.today);
    }
  }
}

class _DetailBody extends StatelessWidget {
  const _DetailBody({required this.state});

  final HabitDetailState state;

  @override
  Widget build(BuildContext context) {
    final detail = state.detail;

    if (state.status == LoadStatus.loading && !state.hasData) {
      return const LoadingStateView(message: 'Loading habit...');
    }

    if (detail == null) {
      return ErrorStateView(
        failure: state.failure!,
        onRetry: () => context.read<HabitDetailCubit>().load(state.habitId),
      );
    }

    return ListView(
      padding: const EdgeInsets.only(bottom: 120),
      children: [
        ContentContainer(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.lg,
            AppSpacing.lg,
            AppSpacing.lg,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _HeaderCard(detail: detail),
              const SizedBox(height: AppSpacing.lg),
              _StreakCard(detail: detail),
              const SizedBox(height: AppSpacing.lg),
              _HistoryCard(detail: detail),
              const SizedBox(height: AppSpacing.xl),
              _ToggleButton(state: state, detail: detail),
              const SizedBox(height: AppSpacing.md),
              _DeleteButton(state: state, detail: detail),
            ],
          ),
        ),
      ],
    );
  }
}

class _HeaderCard extends StatelessWidget {
  const _HeaderCard({required this.detail});

  final HabitDetail detail;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasDescription = detail.habit.description.trim().isNotEmpty;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(detail.habit.name, style: theme.textTheme.headlineSmall),
            const SizedBox(height: AppSpacing.sm),
            Text(
              hasDescription
                  ? detail.habit.description
                  : 'No description added for this habit.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: hasDescription ? AppColors.ink : AppColors.inkFaint,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Row(
              children: [
                PointsBadge(points: detail.habit.points),
                const Spacer(),
                Text(
                  'Added ${formatShortDate(detail.habit.createdAt)}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.inkFaint,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StreakCard extends StatelessWidget {
  const _StreakCard({required this.detail});

  final HabitDetail detail;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final streak = detail.currentStreak;

    final String hint;
    if (streak == 0) {
      hint = 'Complete this habit today to start a streak.';
    } else if (detail.completedToday) {
      hint = 'Today is done. Keep the momentum going!';
    } else {
      hint = 'Complete it today to keep your streak alive.';
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.points.withValues(alpha: 0.14),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.local_fire_department_rounded,
                color: AppColors.points,
              ),
            ),
            const SizedBox(width: AppSpacing.lg),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Current streak', style: theme.textTheme.labelLarge),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    streak == 0
                        ? 'No active streak'
                        : '$streak ${streak == 1 ? 'day' : 'days'} in a row',
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    hint,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.inkSoft,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HistoryCard extends StatelessWidget {
  const _HistoryCard({required this.detail});

  final HabitDetail detail;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Last 7 days', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: AppSpacing.lg),
            WeekHistoryStrip(week: detail.weekHistory, today: today()),
          ],
        ),
      ),
    );
  }
}

class _ToggleButton extends StatelessWidget {
  const _ToggleButton({required this.state, required this.detail});

  final HabitDetailState state;
  final HabitDetail detail;

  @override
  Widget build(BuildContext context) {
    final completedToday = detail.completedToday;
    final isToggling = state.isToggling;

    final content = isToggling
        ? const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              ),
              SizedBox(width: AppSpacing.md),
              Text('Saving...'),
            ],
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                completedToday
                    ? Icons.undo_rounded
                    : Icons.check_circle_rounded,
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                completedToday
                    ? 'Mark as not done today'
                    : 'Mark as done today',
              ),
            ],
          );

    if (completedToday) {
      return OutlinedButton(
        key: const Key('habit_detail_toggle_button'),
        onPressed: isToggling
            ? null
            : () => context.read<HabitDetailCubit>().toggleToday(),
        child: content,
      );
    }

    return FilledButton(
      key: const Key('habit_detail_toggle_button'),
      onPressed: isToggling
          ? null
          : () => context.read<HabitDetailCubit>().toggleToday(),
      child: content,
    );
  }
}

class _DeleteButton extends StatelessWidget {
  const _DeleteButton({required this.state, required this.detail});

  final HabitDetailState state;
  final HabitDetail detail;

  @override
  Widget build(BuildContext context) {
    final isDeleting = state.isDeleting;

    return OutlinedButton.icon(
      key: const Key('habit_detail_delete_button'),
      onPressed: isDeleting ? null : () => _confirm(context),
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.danger,
        side: const BorderSide(color: AppColors.danger, width: 1.2),
      ),
      icon: isDeleting
          ? const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.danger,
              ),
            )
          : const Icon(Icons.delete_outline_rounded),
      label: Text(isDeleting ? 'Deleting...' : 'Delete habit'),
    );
  }

  Future<void> _confirm(BuildContext context) async {
    final cubit = context.read<HabitDetailCubit>();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete habit?'),
        content: Text(
          'This permanently removes "${detail.habit.name}" and its completion '
          'history. This cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.danger,
              minimumSize: const Size(0, 0),
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.xl,
                vertical: AppSpacing.md,
              ),
            ),
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      cubit.delete();
    }
  }
}
