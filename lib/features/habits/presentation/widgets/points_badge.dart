import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// Small pill that shows how many points a habit is worth.
class PointsBadge extends StatelessWidget {
  const PointsBadge({super.key, required this.points, this.dimmed = false});

  final int points;
  final bool dimmed;

  @override
  Widget build(BuildContext context) {
    final background = dimmed ? AppColors.surfaceMuted : AppColors.ink;
    final foreground = dimmed ? AppColors.inkSoft : Colors.white;
    final label = points == 1 ? '1 pt' : '$points pts';

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.stars_rounded, size: 15, color: foreground),
          const SizedBox(width: AppSpacing.xs),
          Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: foreground,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
