/// Pure-Dart definitions for the development seed data.
///
/// Kept free of Flutter and Firebase imports so it can be unit tested with the
/// normal test runner and reused by the seeding script.
library;

/// The single documented development identity used by the seed.
const String seedUserId = 'dev-user';

/// One seeded habit plus the days (relative to today) marked complete.
class SeedHabit {
  const SeedHabit({
    required this.id,
    required this.name,
    required this.description,
    required this.points,
    required this.completedOffsets,
  });

  /// Stable document id, so re-running the seed never duplicates a habit.
  final String id;

  final String name;
  final String description;
  final int points;

  /// Days before today that are complete. `0` is today, `6` is six days ago.
  final List<int> completedOffsets;
}

/// The five sample habits described by the assignment.
const List<SeedHabit> seedHabits = [
  SeedHabit(
    id: 'morning-exercise',
    name: 'Morning Exercise',
    description: 'Move for 30 minutes to start the day.',
    points: 10,
    completedOffsets: [6, 5, 4, 2, 1],
  ),
  SeedHabit(
    id: 'read-20-minutes',
    name: 'Read for 20 Minutes',
    description: 'Read a book or an article away from screens.',
    points: 5,
    completedOffsets: [6, 5, 4, 3, 2, 1, 0],
  ),
  SeedHabit(
    id: 'drink-water',
    name: 'Drink Enough Water',
    description: 'Drink eight glasses of water through the day.',
    points: 5,
    completedOffsets: [6, 5, 3, 2, 0],
  ),
  SeedHabit(
    id: 'practice-coding',
    name: 'Practice Coding',
    description: 'Solve one problem or work on a personal project.',
    points: 15,
    completedOffsets: [6, 5, 4, 3, 2, 1],
  ),
  SeedHabit(
    id: 'meditate',
    name: 'Meditate',
    description: 'Sit quietly and breathe for ten minutes.',
    points: 5,
    completedOffsets: [5, 4, 2, 1, 0],
  ),
];

/// A single document the seeder should create.
class SeedDocument {
  const SeedDocument({
    required this.path,
    required this.fields,
    required this.label,
  });

  /// Path below the database root, e.g.
  /// `users/dev-user/habits/morning-exercise`.
  final String path;

  /// Field values written to the document.
  final Map<String, Object?> fields;

  /// Human readable label used in logs.
  final String label;
}

/// `users/{userId}/habits/{habitId}`.
String habitPath(String userId, String habitId) =>
    'users/$userId/habits/$habitId';

/// `users/{userId}/habits/{habitId}/completions/{yyyy-MM-dd}`.
String completionPath(String userId, String habitId, String day) =>
    '${habitPath(userId, habitId)}/completions/$day';

/// Canonical `yyyy-MM-dd` key for a local calendar day.
String dayKey(DateTime date) {
  final month = date.month.toString().padLeft(2, '0');
  final day = date.day.toString().padLeft(2, '0');
  return '${date.year.toString().padLeft(4, '0')}-$month-$day';
}

/// Adds [days] calendar days to [date].
DateTime addDays(DateTime date, int days) =>
    DateTime(date.year, date.month, date.day + days);

/// Builds the full, deterministic list of documents for the seed.
///
/// The plan is purely a function of [userId] and [today], so it is safe to
/// recompute and compare on every run.
List<SeedDocument> buildSeedPlan({
  required String userId,
  required DateTime today,
}) {
  final createdAt = addDays(today, -30);
  final documents = <SeedDocument>[];

  for (final habit in seedHabits) {
    documents.add(
      SeedDocument(
        path: habitPath(userId, habit.id),
        label: 'habit ${habit.id}',
        fields: {
          'name': habit.name,
          'description': habit.description,
          'points': habit.points,
          'createdAt': createdAt,
        },
      ),
    );

    for (final offset in habit.completedOffsets) {
      final day = dayKey(addDays(today, -offset));
      documents.add(
        SeedDocument(
          path: completionPath(userId, habit.id, day),
          label: 'completion ${habit.id} $day',
          fields: const {'completed': true},
        ),
      );
    }
  }

  return documents;
}

/// Documents that still need to be created, given the paths that already exist.
///
/// This is what makes the seed idempotent *and* non-destructive: existing
/// documents are never touched or overwritten.
List<SeedDocument> missingDocuments({
  required List<SeedDocument> plan,
  required Set<String> existingPaths,
}) => [
  for (final document in plan)
    if (!existingPaths.contains(document.path)) document,
];
