import '../../../home/data/models/product_model.dart';
import '../../domain/entities/order_item_entity.dart';

class OrderItemModel extends OrderItemEntity {
  const OrderItemModel({required super.quantity, required super.product});

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      quantity: json['quantity'] is num
          ? (json['quantity'] as num).toInt()
          : int.tryParse(json['quantity']?.toString() ?? '0') ?? 0,
      product: json['product'] is Map
          ? ProductModel.fromJson(
              Map<String, dynamic>.from(json['product'] as Map),
            )
          : const ProductModel(id: 0, productName: '', price: 0.0),
    );
  }
}
