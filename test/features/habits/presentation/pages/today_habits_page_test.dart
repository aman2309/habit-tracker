import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hiicampus_habit_tracker/core/error/failure.dart';
import 'package:hiicampus_habit_tracker/core/theme/app_theme.dart';
import 'package:hiicampus_habit_tracker/core/utils/app_date.dart';
import 'package:hiicampus_habit_tracker/features/habits/domain/usecases/get_today_summary_usecase.dart';
import 'package:hiicampus_habit_tracker/features/habits/domain/usecases/set_habit_completion_usecase.dart';
import 'package:hiicampus_habit_tracker/features/habits/presentation/cubit/today_cubit.dart';
import 'package:hiicampus_habit_tracker/features/habits/presentation/pages/today_habits_page.dart';
import 'package:hiicampus_habit_tracker/features/profile/presentation/cubit/user_name_cubit.dart';

import '../../../../helpers/fake_habit_repository.dart';
import '../../../../helpers/fake_user_name_store.dart';

void main() {
  Future<TodayCubit> pumpPage(
    WidgetTester tester,
    FakeHabitRepository repository,
  ) async {
    final cubit = TodayCubit(
      getTodaySummary: GetTodaySummaryUseCase(repository),
      setHabitCompletion: SetHabitCompletionUseCase(repository),
    );
    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider<TodayCubit>.value(value: cubit..loadToday()),
          BlocProvider<UserNameCubit>(
            create: (_) =>
                UserNameCubit(store: FakeUserNameStore(name: 'Aman'))..load(),
          ),
        ],
        child: MaterialApp(
          theme: AppTheme.light,
          home: const TodayHabitsPage(),
        ),
      ),
    );
    await tester.pumpAndSettle();
    return cubit;
  }

  testWidgets('renders progress, points and habits', (tester) async {
    final repository = FakeHabitRepository(
      habits: [
        buildHabit(id: 'a', name: 'Drink water', points: 10),
        buildHabit(id: 'b', name: 'Read', description: 'Ten pages', points: 5),
      ],
      completedDays: {
        'a': {today()},
      },
    );

    final cubit = await pumpPage(tester, repository);
    addTearDown(cubit.close);

    expect(find.text('1 of 2 completed'), findsOneWidget);
    expect(find.text('Drink water'), findsOneWidget);
    expect(find.text('Read'), findsOneWidget);
    expect(find.text('Ten pages'), findsOneWidget);
    expect(find.text('10 pts'), findsOneWidget);
    expect(find.text('5 pts'), findsOneWidget);
    expect(find.byTooltip('Mark Read as done for today'), findsOneWidget);
  });

  testWidgets('marks a habit done through the completion control', (
    tester,
  ) async {
    final repository = FakeHabitRepository(
      habits: [buildHabit(id: 'b', name: 'Read', points: 5)],
    );

    final cubit = await pumpPage(tester, repository);
    addTearDown(cubit.close);

    expect(find.text('0 of 1 completed'), findsOneWidget);

    await tester.tap(find.byTooltip('Mark Read as done for today'));
    await tester.pumpAndSettle();

    expect(find.text('1 of 1 completed'), findsOneWidget);
    expect(find.byTooltip('Mark Read as not done for today'), findsOneWidget);
    expect(cubit.state.summary!.habits.single.completed, isTrue);
  });

  testWidgets('shows the empty state without any habits', (tester) async {
    final repository = FakeHabitRepository();

    final cubit = await pumpPage(tester, repository);
    addTearDown(cubit.close);

    expect(find.text('No habits yet'), findsOneWidget);
    expect(find.text('Add habit'), findsWidgets);
  });

  testWidgets('shows an honest unavailable state when storage is missing', (
    tester,
  ) async {
    final repository = FakeHabitRepository(
      failure: const NotConfiguredFailure(),
    );

    final cubit = await pumpPage(tester, repository);
    addTearDown(cubit.close);

    expect(find.text('Storage not connected'), findsOneWidget);
    expect(find.text('Try again'), findsOneWidget);
    expect(find.text('No habits yet'), findsNothing);
  });
}
