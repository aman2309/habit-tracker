import 'package:flutter_test/flutter_test.dart';
import 'package:hiicampus_habit_tracker/core/utils/app_date.dart';
import 'package:hiicampus_habit_tracker/core/utils/habit_streak.dart';

void main() {
  group('currentStreak', () {
    test('counts consecutive days ending today', () {
      final day = today();
      final streak = currentStreak(
        completedDays: {day, addDays(day, -1), addDays(day, -2)},
        today: day,
      );

      expect(streak, 3);
    });

    test('keeps the streak when today is still open', () {
      final day = today();
      final streak = currentStreak(
        completedDays: {addDays(day, -1), addDays(day, -2)},
        today: day,
      );

      expect(streak, 2);
    });

    test('breaks on the first missed day', () {
      final day = today();
      final streak = currentStreak(
        completedDays: {day, addDays(day, -2), addDays(day, -3)},
        today: day,
      );

      expect(streak, 1);
    });

    test('returns zero without any completion', () {
      expect(currentStreak(completedDays: const {}, today: today()), 0);
    });

    test('ignores the time component', () {
      final day = today();
      final streak = currentStreak(
        completedDays: {day.add(const Duration(hours: 23))},
        today: day,
      );

      expect(streak, 1);
    });
  });

  group('lastSevenDays', () {
    test('returns seven days ending today, oldest first', () {
      final day = today();
      final week = lastSevenDays(day);

      expect(week, hasLength(7));
      expect(week.first, addDays(day, -6));
      expect(week.last, day);
      expect(week, equals([...week]..sort()));
    });
  });
}
