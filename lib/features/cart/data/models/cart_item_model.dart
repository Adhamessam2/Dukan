import '../../../../core/api/api_keys.dart';
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
      cartId: (json[ApiKeys.cartId] as num?)?.toInt(),
      productId: (json[ApiKeys.productId] as num?)?.toInt() ?? 0,
      quantity: (json[ApiKeys.quantity] as num?)?.toInt() ?? 1,
      isDeleted: json[ApiKeys.isDeleted] as bool? ?? false,
      product: json[ApiKeys.product] is Map
          ? ProductModel.fromJson(Map<String, dynamic>.from(json[ApiKeys.product] as Map))
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {ApiKeys.productId: productId, ApiKeys.quantity: quantity};
  }
}
