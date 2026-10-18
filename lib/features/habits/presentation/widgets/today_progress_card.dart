import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/daily_summary.dart';

/// Header card for the "Today" screen: progress, points and counts.
class TodayProgressCard extends StatelessWidget {
  const TodayProgressCard({super.key, required this.summary});

  final DailySummary summary;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final percent = (summary.progress * 100).round();
    final allDone =
        summary.totalCount > 0 && summary.completedCount == summary.totalCount;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${summary.completedCount} of ${summary.totalCount} completed',
                        style: theme.textTheme.headlineSmall,
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        allDone
                            ? 'All done for today. Great work!'
                            : 'Tap a habit to mark it done.',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppColors.inkSoft,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.lg),
                _ProgressRing(value: summary.progress, label: '$percent%'),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),
            ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.pill),
              child: LinearProgressIndicator(
                value: summary.progress,
                minHeight: 8,
                backgroundColor: AppColors.surfaceMuted,
                color: AppColors.ink,
                semanticsLabel: 'Daily completion progress',
                semanticsValue: '$percent%',
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            Row(
              children: [
                Expanded(
                  child: _MetricTile(
                    icon: Icons.stars_rounded,
                    label: 'Points earned today',
                    value: '${summary.pointsEarned}',
                    hint: 'of ${summary.totalPoints}',
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: _MetricTile(
                    icon: Icons.check_circle_rounded,
                    label: 'Habits done',
                    value: '${summary.completedCount}',
                    hint: 'of ${summary.totalCount}',
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

class _ProgressRing extends StatelessWidget {
  const _ProgressRing({required this.value, required this.label});

  final double value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 68,
      height: 68,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 68,
            height: 68,
            child: CircularProgressIndicator(
              value: value,
              strokeWidth: 7,
              strokeCap: StrokeCap.round,
              backgroundColor: AppColors.surfaceMuted,
              color: AppColors.ink,
            ),
          ),
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.labelLarge?.copyWith(color: AppColors.ink),
          ),
        ],
      ),
    );
  }
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.hint,
  });

  final IconData icon;
  final String label;
  final String value;
  final String hint;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceMuted,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: AppColors.ink),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: AppColors.inkSoft,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(value, style: theme.textTheme.titleLarge),
              const SizedBox(width: AppSpacing.xs),
              Text(
                hint,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppColors.inkFaint,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
