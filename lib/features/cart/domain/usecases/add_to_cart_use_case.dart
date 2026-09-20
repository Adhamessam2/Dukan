import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/cart_item_entity.dart';
import '../repositories/cart_repository.dart';

class AddToCartParams extends Equatable {
  final int productId;
  final int quantity;

  const AddToCartParams({required this.productId, required this.quantity});

  @override
  List<Object?> get props => [productId, quantity];
}

class AddToCartUseCase implements UseCase<CartItemEntity, AddToCartParams> {
  final CartRepository repository;

  AddToCartUseCase(this.repository);

  @override
  Future<Either<Failure, CartItemEntity>> call(AddToCartParams params) {
    return repository.addToCart(
      productId: params.productId,
      quantity: params.quantity,
    );
  }
}
