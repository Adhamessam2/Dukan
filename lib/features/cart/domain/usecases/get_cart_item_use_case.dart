import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../home/domain/entities/product_entity.dart';
import '../repositories/cart_repository.dart';

class GetCartItemParams extends Equatable {
  final String cartId;
  final String productId;

  const GetCartItemParams({required this.cartId, required this.productId});

  @override
  List<Object?> get props => [cartId, productId];
}

class GetCartItemUseCase implements UseCase<ProductEntity, GetCartItemParams> {
  final CartRepository repository;

  GetCartItemUseCase(this.repository);

  @override
  Future<Either<Failure, ProductEntity>> call(GetCartItemParams params) {
    return repository.getCartItem(
      cartId: params.cartId,
      productId: params.productId,
    );
  }
}
