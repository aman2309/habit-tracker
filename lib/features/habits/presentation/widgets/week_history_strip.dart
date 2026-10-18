import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/app_date.dart';
import '../../domain/entities/habit_day_status.dart';

/// Seven day completion strip used on the "Habit Detail" screen.
class WeekHistoryStrip extends StatelessWidget {
  const WeekHistoryStrip({super.key, required this.week, required this.today});

  final List<HabitDayStatus> week;
  final DateTime today;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (week.isEmpty) {
      return Text(
        'No history available yet. Complete this habit to start your streak.',
        style: theme.textTheme.bodyMedium?.copyWith(color: AppColors.inkSoft),
      );
    }

    final completedDays = week.where((status) => status.completed).length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            for (final status in week)
              Expanded(
                child: _DayCell(
                  status: status,
                  isToday: isSameDay(status.day, today),
                ),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          completedDays == 0
              ? 'No days completed in the last 7 days.'
              : '$completedDays of 7 days completed this week.',
          style: theme.textTheme.bodySmall?.copyWith(color: AppColors.inkSoft),
        ),
      ],
    );
  }
}

class _DayCell extends StatelessWidget {
  const _DayCell({required this.status, required this.isToday});

  final HabitDayStatus status;
  final bool isToday;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final completed = status.completed;
    final day = status.day;

    return Semantics(
      label:
          '${weekdayName(day)} ${formatShortDate(day)}: ${completed ? 'completed' : 'not completed'}',
      child: Column(
        children: [
          Text(
            weekdayLetter(day),
            style: theme.textTheme.labelMedium?.copyWith(
              color: isToday ? AppColors.primary : AppColors.inkFaint,
              fontWeight: isToday ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: completed ? AppColors.success : AppColors.background,
              shape: BoxShape.circle,
              border: Border.all(
                color: completed
                    ? AppColors.success
                    : isToday
                    ? AppColors.primary
                    : AppColors.line,
                width: isToday ? 2 : 1,
              ),
            ),
            alignment: Alignment.center,
            child: completed
                ? const Icon(Icons.check_rounded, size: 20, color: Colors.white)
                : Text(
                    '${day.day}',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: isToday ? AppColors.primary : AppColors.inkFaint,
                    ),
                  ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            isToday ? 'Today' : formatShortDate(day),
            maxLines: 1,
            overflow: TextOverflow.clip,
            style: theme.textTheme.labelSmall?.copyWith(
              color: isToday ? AppColors.primary : AppColors.inkFaint,
              fontWeight: isToday ? FontWeight.w700 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
