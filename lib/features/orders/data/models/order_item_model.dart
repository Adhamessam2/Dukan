import '../../../../core/api/api_keys.dart';
import '../../../home/data/models/product_model.dart';
import '../../domain/entities/order_item_entity.dart';

class OrderItemModel extends OrderItemEntity {
  const OrderItemModel({required super.quantity, required super.product});

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      quantity: json[ApiKeys.quantity] is num
          ? (json[ApiKeys.quantity] as num).toInt()
          : int.tryParse(json[ApiKeys.quantity]?.toString() ?? '0') ?? 0,
      product: json[ApiKeys.product] is Map
          ? ProductModel.fromJson(
              Map<String, dynamic>.from(json[ApiKeys.product] as Map),
            )
          : const ProductModel(id: 0, productName: '', price: 0.0),
    );
  }
}
