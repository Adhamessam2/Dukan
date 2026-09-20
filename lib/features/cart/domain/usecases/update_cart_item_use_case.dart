import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/cart_item_entity.dart';
import '../repositories/cart_repository.dart';

class UpdateCartItemParams extends Equatable {
  final String cartId;
  final String productId;
  final int quantity;

  const UpdateCartItemParams({
    required this.cartId,
    required this.productId,
    required this.quantity,
  });

  @override
  List<Object?> get props => [cartId, productId, quantity];
}

class UpdateCartItemUseCase
    implements UseCase<CartItemEntity, UpdateCartItemParams> {
  final CartRepository repository;

  UpdateCartItemUseCase(this.repository);

  @override
  Future<Either<Failure, CartItemEntity>> call(UpdateCartItemParams params) {
    return repository.updateCartItem(
      cartId: params.cartId,
      productId: params.productId,
      quantity: params.quantity,
    );
  }
}
