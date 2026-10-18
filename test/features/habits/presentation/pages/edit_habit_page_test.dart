import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:hiicampus_habit_tracker/core/error/failure.dart';
import 'package:hiicampus_habit_tracker/core/theme/app_theme.dart';
import 'package:hiicampus_habit_tracker/features/habits/domain/usecases/get_habit_by_id_usecase.dart';
import 'package:hiicampus_habit_tracker/features/habits/domain/usecases/update_habit_usecase.dart';
import 'package:hiicampus_habit_tracker/features/habits/presentation/cubit/edit_habit_cubit.dart';
import 'package:hiicampus_habit_tracker/features/habits/presentation/pages/edit_habit_page.dart';

import '../../../../helpers/fake_habit_repository.dart';

void main() {
  Future<EditHabitCubit> pumpPage(
    WidgetTester tester,
    FakeHabitRepository repository, {
    String habitId = 'a',
  }) async {
    final cubit = EditHabitCubit(
      getHabitById: GetHabitByIdUseCase(repository),
      updateHabit: UpdateHabitUseCase(repository),
    );
    final router = GoRouter(
      initialLocation: '/habits/$habitId/edit',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) =>
              const Scaffold(body: Center(child: Text('today screen'))),
        ),
        GoRoute(
          path: '/habits/:habitId/edit',
          builder: (context, state) => BlocProvider<EditHabitCubit>.value(
            value: cubit,
            child: EditHabitPage(habitId: habitId),
          ),
        ),
      ],
    );

    await cubit.load(habitId);
    await tester.pumpWidget(
      MaterialApp.router(routerConfig: router, theme: AppTheme.light),
    );
    await tester.pumpAndSettle();

    addTearDown(() async {
      await cubit.close();
      router.dispose();
    });
    return cubit;
  }

  testWidgets('prefills the form with the current habit', (tester) async {
    final repository = FakeHabitRepository(
      habits: [
        buildHabit(id: 'a', name: 'Old name', description: 'old', points: 5),
      ],
    );

    await pumpPage(tester, repository);

    expect(find.text('Old name'), findsOneWidget);
    expect(find.text('old'), findsOneWidget);
    expect(find.text('5'), findsOneWidget);
  });

  testWidgets('saves edits and returns to the previous screen', (tester) async {
    final repository = FakeHabitRepository(
      habits: [buildHabit(id: 'a', name: 'Old name', points: 5)],
    );

    await pumpPage(tester, repository);

    await tester.enterText(
      find.byKey(const Key('edit_habit_name_field')),
      'New name',
    );
    await tester.enterText(
      find.byKey(const Key('edit_habit_points_field')),
      '9',
    );
    await tester.tap(find.byKey(const Key('edit_habit_submit_button')));
    await tester.pumpAndSettle();

    expect(repository.updateCalls, 1);
    expect(repository.habits.single.name, 'New name');
    expect(repository.habits.single.points, 9);
    expect(find.text('today screen'), findsOneWidget);
  });

  testWidgets('shows an inline error when saving fails', (tester) async {
    final repository = FakeHabitRepository(
      habits: [buildHabit(id: 'a', name: 'Old name', points: 5)],
    );

    await pumpPage(tester, repository);
    repository.failure = const NotConfiguredFailure('storage unavailable');

    await tester.enterText(
      find.byKey(const Key('edit_habit_name_field')),
      'New name',
    );
    await tester.tap(find.byKey(const Key('edit_habit_submit_button')));
    await tester.pumpAndSettle();

    expect(find.text('storage unavailable'), findsOneWidget);
    expect(find.text('today screen'), findsNothing);
  });
}
