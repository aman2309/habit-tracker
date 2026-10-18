import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hiicampus_habit_tracker/core/theme/app_theme.dart';
import 'package:hiicampus_habit_tracker/core/utils/app_date.dart';
import 'package:hiicampus_habit_tracker/features/habits/domain/usecases/delete_habit_usecase.dart';
import 'package:hiicampus_habit_tracker/features/habits/domain/usecases/get_habit_detail_usecase.dart';
import 'package:hiicampus_habit_tracker/features/habits/domain/usecases/set_habit_completion_usecase.dart';
import 'package:hiicampus_habit_tracker/features/habits/presentation/cubit/habit_detail_cubit.dart';
import 'package:hiicampus_habit_tracker/features/habits/presentation/pages/habit_detail_page.dart';

import '../../../../helpers/fake_habit_repository.dart';

void main() {
  Future<HabitDetailCubit> pumpPage(
    WidgetTester tester,
    FakeHabitRepository repository, {
    String habitId = 'a',
  }) async {
    final cubit = HabitDetailCubit(
      getHabitDetail: GetHabitDetailUseCase(repository),
      setHabitCompletion: SetHabitCompletionUseCase(repository),
      deleteHabit: DeleteHabitUseCase(repository),
    );
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: BlocProvider<HabitDetailCubit>.value(
          value: cubit..load(habitId),
          child: HabitDetailPage(habitId: habitId),
        ),
      ),
    );
    await tester.pumpAndSettle();
    return cubit;
  }

  testWidgets('shows details, streak and history', (tester) async {
    final day = today();
    final repository = FakeHabitRepository(
      habits: [
        buildHabit(
          id: 'a',
          name: 'Drink water',
          description: 'Two litres a day',
          points: 8,
        ),
      ],
      completedDays: {
        'a': {addDays(day, -1), addDays(day, -2)},
      },
    );

    final cubit = await pumpPage(tester, repository);
    addTearDown(cubit.close);

    expect(find.text('Drink water'), findsOneWidget);
    expect(find.text('Two litres a day'), findsOneWidget);
    expect(find.text('8 pts'), findsOneWidget);
    expect(find.text('Current streak'), findsOneWidget);
    expect(find.text('2 days in a row'), findsOneWidget);
    expect(find.text('Last 7 days'), findsOneWidget);
    expect(find.text('Today'), findsOneWidget);
    expect(find.text('Mark as done today'), findsOneWidget);
  });

  testWidgets('toggles today through the primary action', (tester) async {
    final repository = FakeHabitRepository(habits: [buildHabit(id: 'a')]);

    final cubit = await pumpPage(tester, repository);
    addTearDown(cubit.close);

    expect(find.text('No active streak'), findsOneWidget);

    await tester.ensureVisible(
      find.byKey(const Key('habit_detail_toggle_button')),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('habit_detail_toggle_button')));
    await tester.pumpAndSettle();

    expect(find.text('Mark as not done today'), findsOneWidget);
    expect(cubit.state.detail!.completedToday, isTrue);
  });

  testWidgets('shows an error state for an unknown habit', (tester) async {
    final repository = FakeHabitRepository(habits: [buildHabit(id: 'a')]);

    final cubit = await pumpPage(tester, repository, habitId: 'missing');
    addTearDown(cubit.close);

    expect(find.text('Not found'), findsOneWidget);
    expect(find.text('Try again'), findsOneWidget);
  });
}
