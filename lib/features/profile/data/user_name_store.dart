import 'package:shared_preferences/shared_preferences.dart';

/// Persists the user's display name.
///
/// Declared as an interface so tests can swap in an in-memory double and the
/// app never depends on a concrete storage plugin.
abstract interface class UserNameStore {
  /// Returns the stored name, or `null` when nothing has been saved yet.
  Future<String?> readName();

  /// Persists [name] (already trimmed by the caller).
  Future<void> writeName(String name);
}

/// `shared_preferences` backed implementation used by the app.
class SharedPreferencesUserNameStore implements UserNameStore {
  const SharedPreferencesUserNameStore();

  static const String _key = 'user_name';

  @override
  Future<String?> readName() async {
    final preferences = await SharedPreferences.getInstance();
    final value = preferences.getString(_key)?.trim();
    return (value == null || value.isEmpty) ? null : value;
  }

  @override
  Future<void> writeName(String name) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(_key, name.trim());
  }
}
