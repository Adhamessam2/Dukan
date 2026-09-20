import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/cart_repository.dart';

class ClearCartUseCase implements UseCase<int, NoParams> {
  final CartRepository repository;

  ClearCartUseCase(this.repository);

  @override
  Future<Either<Failure, int>> call(NoParams params) {
    return repository.clearCart();
  }
}
