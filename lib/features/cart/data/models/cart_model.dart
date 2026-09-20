import '../../domain/entities/cart_entity.dart';
import 'cart_item_model.dart';

class CartModel extends CartEntity {
  const CartModel({
    required super.id,
    required super.items,
    required super.totalPrice,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      items:
          (json['items'] as List<dynamic>?)
              ?.whereType<Map>()
              .map(
                (item) =>
                    CartItemModel.fromJson(Map<String, dynamic>.from(item)),
              )
              .toList() ??
          const [],
      totalPrice: double.tryParse(json['totalPrice']?.toString() ?? '0') ?? 0.0,
    );
  }
}
