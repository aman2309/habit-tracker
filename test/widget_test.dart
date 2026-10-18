import 'package:flutter_test/flutter_test.dart';
import 'package:hiicampus_habit_tracker/app.dart';
import 'package:hiicampus_habit_tracker/core/di/injection_container.dart';

import 'helpers/fake_habit_remote_data_source.dart';
import 'helpers/fake_user_name_store.dart';

void main() {
  setUp(() async {
    await resetDependencies();
    initDependencies(
      habitRemoteDataSource: FakeHabitRemoteDataSource(),
      userNameStore: FakeUserNameStore(name: 'Aman'),
    );
  });

  tearDown(() async {
    await resetDependencies();
  });

  testWidgets('starts on Today with real storage wiring', (tester) async {
    await tester.pumpWidget(const HabitTrackerApp());
    await tester.pumpAndSettle();

    expect(find.text('Aman'), findsOneWidget);
    expect(find.text('No habits yet'), findsOneWidget);
    expect(find.text('Storage not connected'), findsNothing);
  });
}
