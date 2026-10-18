import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hiicampus_habit_tracker/core/theme/app_theme.dart';
import 'package:hiicampus_habit_tracker/features/profile/presentation/cubit/user_name_cubit.dart';
import 'package:hiicampus_habit_tracker/features/profile/presentation/pages/name_setup_page.dart';

import '../../../../helpers/fake_user_name_store.dart';

void main() {
  Future<UserNameCubit> pumpPage(
    WidgetTester tester,
    FakeUserNameStore store,
  ) async {
    final cubit = UserNameCubit(store: store);
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: BlocProvider<UserNameCubit>.value(
          value: cubit,
          child: const NameSetupPage(),
        ),
      ),
    );
    addTearDown(cubit.close);
    return cubit;
  }

  testWidgets('saves the entered name', (tester) async {
    final store = FakeUserNameStore();
    final cubit = await pumpPage(tester, store);

    await tester.enterText(find.byKey(const Key('name_setup_field')), 'Aman');
    await tester.tap(find.byKey(const Key('name_setup_button')));
    await tester.pumpAndSettle();

    expect(store.name, 'Aman');
    expect(cubit.state.name, 'Aman');
  });

  testWidgets('shows a validation error for an empty name', (tester) async {
    final store = FakeUserNameStore();
    await pumpPage(tester, store);

    await tester.tap(find.byKey(const Key('name_setup_button')));
    await tester.pumpAndSettle();

    expect(find.text('Please enter your name.'), findsOneWidget);
    expect(store.writes, 0);
  });
}
