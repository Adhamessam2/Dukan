import '../../../home/data/models/product_model.dart';
import '../../domain/entities/cart_item_entity.dart';

class CartItemModel extends CartItemEntity {
  const CartItemModel({
    super.cartId,
    required super.productId,
    required super.quantity,
    super.isDeleted = false,
    super.product,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      cartId: (json['cartId'] as num?)?.toInt(),
      productId: (json['productId'] as num?)?.toInt() ?? 0,
      quantity: (json['quantity'] as num?)?.toInt() ?? 1,
      isDeleted: json['isDeleted'] as bool? ?? false,
      product: json['product'] is Map
          ? ProductModel.fromJson(
              Map<String, dynamic>.from(json['product'] as Map),
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {'productId': productId, 'quantity': quantity};
  }
}
