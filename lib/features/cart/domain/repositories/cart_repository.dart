import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failure.dart';
import '../../../home/domain/entities/product_entity.dart';
import '../entities/cart_entity.dart';
import '../entities/cart_item_entity.dart';

abstract class CartRepository {
  Future<Either<Failure, CartItemEntity>> addToCart({
    required int productId,
    required int quantity,
  });

  Future<Either<Failure, CartEntity>> getCart();

  Future<Either<Failure, ProductEntity>> getCartItem({
    required String cartId,
    required String productId,
  });

  Future<Either<Failure, CartItemEntity>> updateCartItem({
    required String cartId,
    required String productId,
    required int quantity,
  });

  Future<Either<Failure, CartItemEntity>> deleteCartItem({
    required String cartId,
    required String productId,
  });

  Future<Either<Failure, int>> clearCart();
}
