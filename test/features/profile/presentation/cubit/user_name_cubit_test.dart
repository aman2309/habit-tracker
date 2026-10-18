import 'package:flutter_test/flutter_test.dart';
import 'package:hiicampus_habit_tracker/core/common/load_status.dart';
import 'package:hiicampus_habit_tracker/core/error/failure.dart';
import 'package:hiicampus_habit_tracker/features/profile/presentation/cubit/user_name_cubit.dart';

import '../../../../helpers/fake_user_name_store.dart';

void main() {
  test('load exposes the stored name', () async {
    final cubit = UserNameCubit(store: FakeUserNameStore(name: 'Aman'));

    await cubit.load();

    expect(cubit.state.status, LoadStatus.success);
    expect(cubit.state.name, 'Aman');
    expect(cubit.state.hasName, isTrue);
  });

  test('load falls back to an empty name when storage fails', () async {
    final cubit = UserNameCubit(store: FakeUserNameStore(throwOnRead: true));

    await cubit.load();

    expect(cubit.state.isLoaded, isTrue);
    expect(cubit.state.hasName, isFalse);
  });

  test('saveName trims and persists the name', () async {
    final store = FakeUserNameStore();
    final cubit = UserNameCubit(store: store);

    await cubit.saveName('  Aman  ');

    expect(store.name, 'Aman');
    expect(store.writes, 1);
    expect(cubit.state.name, 'Aman');
    expect(cubit.state.isSaving, isFalse);
  });

  test('saveName rejects an empty name', () async {
    final store = FakeUserNameStore();
    final cubit = UserNameCubit(store: store);

    await cubit.saveName('   ');

    expect(cubit.state.failure, isA<ValidationFailure>());
    expect(store.writes, 0);
  });

  test('saveName rejects a name that is too long', () async {
    final store = FakeUserNameStore();
    final cubit = UserNameCubit(store: store);

    await cubit.saveName('a' * (UserNameCubit.maxNameLength + 1));

    expect(cubit.state.failure, isA<ValidationFailure>());
    expect(store.writes, 0);
  });
}
