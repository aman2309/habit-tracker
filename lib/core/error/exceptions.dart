/// Base exception thrown by the data layer.
///
/// Exceptions never cross the repository boundary: repository implementations
/// translate them into [Failure] values before returning to the domain layer.
class AppException implements Exception {
  const AppException(this.message);

  final String message;

  @override
  String toString() => '$runtimeType: $message';
}

/// Thrown while the data source has no backing storage wired up yet
/// (for example, before Firestore is integrated).
class DataSourceNotConfiguredException extends AppException {
  const DataSourceNotConfiguredException(super.message);
}

/// Thrown when the remote storage responds with an error.
class RemoteDataException extends AppException {
  const RemoteDataException(super.message);
}

/// Thrown when a requested record cannot be found.
class RecordNotFoundException extends AppException {
  const RecordNotFoundException(super.message);
}

/// Thrown when the backend refuses the request because of security rules.
class PermissionDeniedException extends AppException {
  const PermissionDeniedException(super.message);
}

/// Thrown when the backend is temporarily unreachable (offline, timeout).
class UnavailableException extends AppException {
  const UnavailableException(super.message);
}

/// Thrown when stored data could not be decoded or validated.
class SerializationException extends AppException {
  const SerializationException(super.message);
}
