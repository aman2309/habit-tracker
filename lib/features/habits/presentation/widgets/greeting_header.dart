import 'package:flutter/material.dart';

import '../../../../core/config/dev_identity.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/app_date.dart';

/// Time-of-day greeting shown at the top of the Today screen.
String greetingFor(DateTime now) {
  final hour = now.hour;
  if (hour < 12) return 'Good morning';
  if (hour < 17) return 'Good afternoon';
  return 'Good evening';
}

/// Warm, editorial header: a greeting, the user's name and today's date.
///
/// Tapping the name (when [onEditName] is provided) lets the user rename
/// themselves.
class GreetingHeader extends StatelessWidget {
  const GreetingHeader({
    super.key,
    required this.date,
    this.name = kDevUserName,
    this.onEditName,
  });

  final String name;
  final DateTime date;
  final VoidCallback? onEditName;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${greetingFor(DateTime.now())},',
          style: theme.textTheme.bodyMedium?.copyWith(color: AppColors.inkSoft),
        ),
        const SizedBox(height: 2),
        _NameLine(name: name, onEditName: onEditName),
        const SizedBox(height: AppSpacing.xs),
        Text(
          formatFullDate(date),
          style: theme.textTheme.bodySmall?.copyWith(color: AppColors.inkFaint),
        ),
      ],
    );
  }
}

class _NameLine extends StatelessWidget {
  const _NameLine({required this.name, this.onEditName});

  final String name;
  final VoidCallback? onEditName;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final label = Text(
      name,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: theme.textTheme.headlineMedium,
    );

    if (onEditName == null) return label;

    return InkWell(
      onTap: onEditName,
      borderRadius: BorderRadius.circular(AppRadius.sm),
      child: Tooltip(
        message: 'Change name',
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(child: label),
            const SizedBox(width: AppSpacing.sm),
            const Icon(
              Icons.edit_outlined,
              size: 18,
              color: AppColors.inkFaint,
            ),
          ],
        ),
      ),
    );
  }
}
