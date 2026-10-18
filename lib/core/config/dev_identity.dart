/// Development identity configuration.
///
/// Firebase Authentication is **not** configured for this project yet, so the
/// app cannot derive a real user id. To keep the Firestore data model ready
/// for proper per-user isolation later, every document lives under
/// `users/{userId}/...`.
///
/// Until real auth exists, [kDevUserId] supplies a single, documented
/// development identity. It can be overridden at build/run time:
///
/// ```sh
/// flutter run --dart-define=HABIT_USER_ID=dev-alice
/// ```
///
/// WARNING: this is a development convenience only. It is **not**
/// authentication and provides **no** user isolation. Anyone can use the same
/// id. Firestore rules must be tightened (and real auth added) before any
/// release that stores more than throwaway test data.
library;

/// Default development user id used to build Firestore paths.
const String kDevUserId = String.fromEnvironment(
  'HABIT_USER_ID',
  defaultValue: 'dev-user',
);

/// Display name shown in the greeting on the Today screen. Same caveat as
/// [kDevUserId]: a convenience placeholder until real auth exists.
///
/// ```sh
/// flutter run --dart-define=HABIT_USER_NAME=Aman
/// ```
const String kDevUserName = String.fromEnvironment(
  'HABIT_USER_NAME',
  defaultValue: 'Aman',
);

/// Supplies the user id used to build Firestore paths such as
/// `users/{userId}/habits/{habitId}`.
///
/// When Firebase Authentication is added, swap the implementation registered
/// in the service locator for one backed by the signed-in user.
abstract interface class UserIdProvider {
  String get userId;
}

/// Returns the fixed development identity (see [kDevUserId]).
class DevUserIdProvider implements UserIdProvider {
  const DevUserIdProvider([this.userId = kDevUserId]);

  @override
  final String userId;
}
