import 'package:equatable/equatable.dart';

/// Domain-level error returned by every repository call.
///
/// Failures are the only error type the presentation layer ever sees, which
/// keeps error handling explicit and consistent across the app.
sealed class Failure extends Equatable {
  const Failure(this.message);

  /// Human readable description safe to show in the UI.
  final String message;

  @override
  List<Object?> get props => [message];
}

final class NotConfiguredFailure extends Failure {
  const NotConfiguredFailure([
    super.message =
        'Habit storage is not connected yet. It will be enabled in a later phase.',
  ]);
}

final class ValidationFailure extends Failure {
  const ValidationFailure(super.message, {this.field});

  /// Optional field name (e.g. `name`, `points`) the message belongs to.
  final String? field;

  @override
  List<Object?> get props => [message, field];
}

final class NotFoundFailure extends Failure {
  const NotFoundFailure([
    super.message = 'We could not find what you were looking for.',
  ]);
}

final class RemoteFailure extends Failure {
  const RemoteFailure([
    super.message = 'Something went wrong while talking to storage.',
  ]);
}

/// Returned when Firestore security rules reject the operation.
final class PermissionFailure extends Failure {
  const PermissionFailure([
    super.message =
        'Storage denied access. Check the Firestore security rules.',
  ]);
}

/// Returned when the backend is unreachable, for example while offline.
final class NetworkFailure extends Failure {
  const NetworkFailure([
    super.message =
        'You appear to be offline. Habit data will sync when you are back online.',
  ]);
}

final class UnexpectedFailure extends Failure {
  const UnexpectedFailure([
    super.message = 'Something unexpected happened. Please try again.',
  ]);
}
