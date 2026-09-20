import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/cart_item_entity.dart';
import '../repositories/cart_repository.dart';

class DeleteCartItemParams extends Equatable {
  final String cartId;
  final String productId;

  const DeleteCartItemParams({required this.cartId, required this.productId});

  @override
  List<Object?> get props => [cartId, productId];
}

class DeleteCartItemUseCase
    implements UseCase<CartItemEntity, DeleteCartItemParams> {
  final CartRepository repository;

  DeleteCartItemUseCase(this.repository);

  @override
  Future<Either<Failure, CartItemEntity>> call(DeleteCartItemParams params) {
    return repository.deleteCartItem(
      cartId: params.cartId,
      productId: params.productId,
    );
  }
}
