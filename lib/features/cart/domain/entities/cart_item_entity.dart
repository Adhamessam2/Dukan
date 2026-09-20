import 'package:equatable/equatable.dart';
import '../../../home/domain/entities/product_entity.dart';

class CartItemEntity extends Equatable {
  final int? cartId;
  final int productId;
  final int quantity;
  final bool isDeleted;
  final ProductEntity? product;

  const CartItemEntity({
    this.cartId,
    required this.productId,
    required this.quantity,
    this.isDeleted = false,
    this.product,
  });

  @override
  List<Object?> get props => [cartId, productId, quantity, isDeleted, product];
}
