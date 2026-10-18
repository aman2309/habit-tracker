import 'package:dartz/dartz.dart';

import '../error/failure.dart';

/// Signature for use cases that take no parameters.
class NoParams {
  const NoParams();
}

/// Every use case exposes a single [call] method returning
/// `Either<Failure, T>`.
///
/// Cubits depend on use cases only; use cases depend on repository interfaces
/// only.
abstract interface class UseCase<T, Params> {
  Future<Either<Failure, T>> call(Params params);
}
