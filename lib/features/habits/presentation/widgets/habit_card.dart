import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/habit_day_status.dart';
import 'points_badge.dart';

/// Habit row shown on the "Today" screen.
class HabitCard extends StatelessWidget {
  const HabitCard({
    super.key,
    required this.status,
    required this.onToggle,
    required this.onOpen,
    this.isBusy = false,
  });

  final HabitDayStatus status;
  final VoidCallback onToggle;
  final VoidCallback onOpen;
  final bool isBusy;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final habit = status.habit;
    final completed = status.completed;
    final hasDescription = habit.description.trim().isNotEmpty;

    return Card(
      color: completed ? AppColors.surfaceMuted : AppColors.surface,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onOpen,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.sm,
            AppSpacing.md,
            AppSpacing.lg,
            AppSpacing.md,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _CompletionToggle(
                completed: completed,
                isBusy: isBusy,
                habitName: habit.name,
                onPressed: onToggle,
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      habit.name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        decoration: completed
                            ? TextDecoration.lineThrough
                            : null,
                        decorationColor: AppColors.inkFaint,
                        color: completed ? AppColors.inkFaint : AppColors.ink,
                      ),
                    ),
                    if (hasDescription) ...[
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        habit.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppColors.inkSoft,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              PointsBadge(points: habit.points, dimmed: !completed),
            ],
          ),
        ),
      ),
    );
  }
}

class _CompletionToggle extends StatelessWidget {
  const _CompletionToggle({
    required this.completed,
    required this.isBusy,
    required this.habitName,
    required this.onPressed,
  });

  final bool completed;
  final bool isBusy;
  final String habitName;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    if (isBusy) {
      return const SizedBox(
        width: 44,
        height: 44,
        child: Padding(
          padding: EdgeInsets.all(10),
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      );
    }

    return SizedBox(
      width: 44,
      height: 44,
      child: IconButton(
        onPressed: onPressed,
        tooltip: completed
            ? 'Mark $habitName as not done for today'
            : 'Mark $habitName as done for today',
        iconSize: 30,
        color: completed ? AppColors.ink : AppColors.inkFaint,
        icon: Icon(
          completed
              ? Icons.check_circle_rounded
              : Icons.radio_button_unchecked_rounded,
        ),
      ),
    );
  }
}
