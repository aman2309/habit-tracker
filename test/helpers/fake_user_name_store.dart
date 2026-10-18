import 'package:hiicampus_habit_tracker/features/profile/data/user_name_store.dart';

/// In-memory [UserNameStore] used by tests only.
class FakeUserNameStore implements UserNameStore {
  FakeUserNameStore({this.name, this.throwOnRead = false});

  String? name;

  /// When true, [readName] throws to exercise the fallback path.
  bool throwOnRead;

  int writes = 0;

  @override
  Future<String?> readName() async {
    if (throwOnRead) {
      throw StateError('storage unavailable');
    }
    return name;
  }

  @override
  Future<void> writeName(String value) async {
    writes += 1;
    name = value;
  }
}
