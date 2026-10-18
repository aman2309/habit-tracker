import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hiicampus_habit_tracker/features/habits/data/models/habit_model.dart';

void main() {
  final created = DateTime(2026, 3, 4, 9, 30);

  test('toFirestore writes name, description, points and a timestamp', () {
    final model = HabitModel(
      id: 'h1',
      name: 'Read',
      description: 'Twenty pages',
      points: 5,
      createdAt: created,
    );

    final data = model.toFirestore();

    expect(data['name'], 'Read');
    expect(data['description'], 'Twenty pages');
    expect(data['points'], 5);
    expect(data['createdAt'], isA<Timestamp>());
    expect((data['createdAt']! as Timestamp).toDate(), created);
    expect(data.containsKey('id'), isFalse);
  });

  test('fromFirestore reads a native timestamp document', () {
    final model = HabitModel.fromFirestore('h1', {
      'name': 'Read',
      'description': 'Twenty pages',
      'points': 5,
      'createdAt': Timestamp.fromDate(created),
    });

    expect(model.id, 'h1');
    expect(model.name, 'Read');
    expect(model.points, 5);
    expect(model.createdAt, created);
  });

  test('fromFirestore tolerates missing and malformed fields', () {
    final model = HabitModel.fromFirestore('h1', const {});

    expect(model.id, 'h1');
    expect(model.name, '');
    expect(model.description, '');
    expect(model.points, 0);
    expect(model.createdAt, isA<DateTime>());
  });

  test('fromFirestore coerces string points and ISO createdAt', () {
    final model = HabitModel.fromFirestore('h1', {
      'name': 'Read',
      'description': null,
      'points': '7',
      'createdAt': created.toIso8601String(),
    });

    expect(model.points, 7);
    expect(model.description, '');
    expect(model.createdAt, created);
  });

  test('toEntity round-trips through the storage model', () {
    final habit = HabitModel(
      id: 'h1',
      name: 'Read',
      description: 'Twenty pages',
      points: 5,
      createdAt: created,
    ).toEntity();

    final model = HabitModel.fromEntity(habit);

    expect(model.id, habit.id);
    expect(model.name, habit.name);
    expect(model.points, habit.points);
    expect(model.createdAt, habit.createdAt);
  });
}
