import 'app_date.dart';

/// Number of consecutive completed days ending at [today].
///
/// A day counts as part of the streak when a completion record exists for it.
/// Today does not break the streak while it is still unfinished, so the streak
/// is only measured against days that have already passed.
int currentStreak({
  required Set<DateTime> completedDays,
  required DateTime today,
}) {
  final completed = completedDays.map(dateOnly).toSet();
  var streak = 0;
  var cursor = dateOnly(today);

  if (!completed.contains(cursor)) {
    cursor = addDays(cursor, -1);
  }

  while (completed.contains(cursor)) {
    streak += 1;
    cursor = addDays(cursor, -1);
  }

  return streak;
}

/// The seven calendar days that end on [today], oldest first.
List<DateTime> lastSevenDays(DateTime today) =>
    List.generate(7, (index) => addDays(dateOnly(today), index - 6));
