import 'package:flutter_test/flutter_test.dart';

import '../../tool/seed_plan.dart';

void main() {
  final today = DateTime(2026, 10, 18);

  test('builds one habit document per sample habit', () {
    final plan = buildSeedPlan(userId: seedUserId, today: today);
    final habitDocs = plan
        .where((d) => !d.path.contains('/completions/'))
        .toList();

    expect(habitDocs, hasLength(seedHabits.length));
    expect(
      habitDocs.map((d) => d.path),
      contains('users/dev-user/habits/meditate'),
    );
  });

  test('seeds one completion document per completed day', () {
    final plan = buildSeedPlan(userId: seedUserId, today: today);
    final expected = seedHabits.fold<int>(
      0,
      (total, habit) => total + habit.completedOffsets.length,
    );

    expect(
      plan.where((d) => d.path.contains('/completions/')),
      hasLength(expected),
    );
  });

  test('completion documents use deterministic yyyy-MM-dd paths', () {
    final plan = buildSeedPlan(userId: seedUserId, today: today);
    final readFullWeek = plan.firstWhere(
      (d) =>
          d.path ==
          'users/dev-user/habits/read-20-minutes/completions/2026-10-18',
    );

    expect(readFullWeek.fields['completed'], isTrue);
  });

  test('running against an already-seeded database creates nothing', () {
    final plan = buildSeedPlan(userId: seedUserId, today: today);
    final existing = plan.map((d) => d.path).toSet();

    expect(missingDocuments(plan: plan, existingPaths: existing), isEmpty);
  });

  test('only missing documents are returned as work to do', () {
    final plan = buildSeedPlan(userId: seedUserId, today: today);
    final existing = {plan.first.path};

    final missing = missingDocuments(plan: plan, existingPaths: existing);

    expect(missing, hasLength(plan.length - 1));
    expect(missing.map((d) => d.path), isNot(contains(plan.first.path)));
  });

  test('the plan is stable for the same day', () {
    final first = buildSeedPlan(userId: seedUserId, today: today);
    final second = buildSeedPlan(userId: seedUserId, today: today);

    expect(
      first.map((d) => d.path).toList(),
      second.map((d) => d.path).toList(),
    );
  });
}
