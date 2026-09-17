import 'package:fpdart/fpdart.dart';
import 'package:equatable/equatable.dart';
import '../errors/failure.dart';

/// Base UseCase contract
abstract class UseCase<T, Params> {
  Future<Either<Failure, T>> call(Params params);
}

/// Helper class for use cases that require no parameters
class NoParams extends Equatable {
  const NoParams();

  @override
  List<Object?> get props => [];
}
