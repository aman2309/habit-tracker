import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:hiicampus_habit_tracker/core/error/failure.dart';
import 'package:hiicampus_habit_tracker/features/habits/domain/usecases/create_habit_usecase.dart';
import 'package:hiicampus_habit_tracker/features/habits/presentation/cubit/add_habit_cubit.dart';
import 'package:hiicampus_habit_tracker/features/habits/presentation/pages/add_habit_page.dart';

import '../../../../helpers/fake_habit_repository.dart';

void main() {
  late FakeHabitRepository repository;
  late AddHabitCubit cubit;
  late GoRouter router;

  setUp(() {
    repository = FakeHabitRepository();
    cubit = AddHabitCubit(createHabit: CreateHabitUseCase(repository));
    router = GoRouter(
      initialLocation: '/add-habit',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) =>
              const Scaffold(body: Center(child: Text('today screen'))),
        ),
        GoRoute(
          path: '/add-habit',
          builder: (context, state) => BlocProvider<AddHabitCubit>.value(
            value: cubit,
            child: const AddHabitPage(),
          ),
        ),
      ],
    );
  });

  tearDown(() async {
    await cubit.close();
    router.dispose();
  });

  Future<void> pumpPage(WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp.router(
        routerConfig: router,
        theme: ThemeData(useMaterial3: true),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('validates required fields before saving', (tester) async {
    await pumpPage(tester);

    await tester.enterText(find.byKey(const Key('add_habit_name_field')), '');
    await tester.enterText(find.byKey(const Key('add_habit_points_field')), '');
    await tester.tap(find.byKey(const Key('add_habit_submit_button')));
    await tester.pumpAndSettle();

    expect(find.text('Enter a habit name.'), findsOneWidget);
    expect(find.text('Enter the points for this habit.'), findsOneWidget);
    expect(repository.createCalls, 0);
    expect(find.text('today screen'), findsNothing);
  });

  testWidgets('creates a habit and returns to the previous screen', (
    tester,
  ) async {
    await pumpPage(tester);

    await tester.enterText(
      find.byKey(const Key('add_habit_name_field')),
      'Read 20 pages',
    );
    await tester.enterText(
      find.byKey(const Key('add_habit_description_field')),
      'Every evening',
    );
    await tester.enterText(
      find.byKey(const Key('add_habit_points_field')),
      '15',
    );
    await tester.tap(find.byKey(const Key('add_habit_submit_button')));
    await tester.pumpAndSettle();

    expect(repository.createCalls, 1);
    expect(repository.habits.single.name, 'Read 20 pages');
    expect(repository.habits.single.points, 15);
    expect(find.text('today screen'), findsOneWidget);
  });

  testWidgets('shows an inline error when saving fails', (tester) async {
    repository.failure = const NotConfiguredFailure('storage unavailable');
    await pumpPage(tester);

    await tester.enterText(
      find.byKey(const Key('add_habit_name_field')),
      'Read',
    );
    await tester.tap(find.byKey(const Key('add_habit_submit_button')));
    await tester.pumpAndSettle();

    expect(find.text('storage unavailable'), findsOneWidget);
    expect(find.text('today screen'), findsNothing);
  });
}
