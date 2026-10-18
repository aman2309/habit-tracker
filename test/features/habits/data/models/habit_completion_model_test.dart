import 'package:flutter_test/flutter_test.dart';
import 'package:hiicampus_habit_tracker/features/habits/data/models/habit_completion_model.dart';

void main() {
  test('toFirestore stores only the completed flag', () {
    const model = HabitCompletionModel(
      habitId: 'h1',
      date: '2026-03-04',
      completed: true,
    );

    expect(model.toFirestore(), {'completed': true});
  });

  test('fromFirestore uses the document id as the day', () {
    final model = HabitCompletionModel.fromFirestore(
      habitId: 'h1',
      dayKey: '2026-03-04',
      data: const {'completed': true},
    );

    expect(model.habitId, 'h1');
    expect(model.date, '2026-03-04');
    expect(model.completed, isTrue);
    expect(model.day, DateTime(2026, 3, 4));
  });

  test('fromFirestore treats a missing flag as not completed', () {
    final model = HabitCompletionModel.fromFirestore(
      habitId: 'h1',
      dayKey: '2026-03-04',
      data: const {},
    );

    expect(model.completed, isFalse);
  });

  test('day getter survives a malformed date string', () {
    const model = HabitCompletionModel(
      habitId: 'h1',
      date: 'not-a-date',
      completed: true,
    );

    expect(model.day, isA<DateTime>());
  });

  test('dateKey pads the month and day', () {
    expect(dateKey(DateTime(2026, 3, 4)), '2026-03-04');
    expect(dateKey(DateTime(2026, 12, 31)), '2026-12-31');
  });
}
