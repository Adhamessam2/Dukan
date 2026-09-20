import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/cart_entity.dart';
import '../repositories/cart_repository.dart';

class GetCartUseCase implements UseCase<CartEntity, NoParams> {
  final CartRepository repository;

  GetCartUseCase(this.repository);

  @override
  Future<Either<Failure, CartEntity>> call(NoParams params) {
    return repository.getCart();
  }
}
