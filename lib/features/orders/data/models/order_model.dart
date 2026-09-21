import '../../domain/entities/order_entity.dart';
import '../../domain/entities/payment_method.dart';
import 'order_item_model.dart';
import 'payment_info_model.dart';

class OrderModel extends OrderEntity {
  const OrderModel({
    required super.id,
    super.userId,
    super.shippingAddressId,
    required super.shippingCity,
    required super.shippingStreet,
    required super.shippingBuilding,
    required super.orderStatus,
    required super.totalAmount,
    required super.paymentMethod,
    required super.createdAt,
    super.updatedAt,
    super.payment,
    super.items,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    final createdAt =
        DateTime.tryParse(json['createdAt']?.toString() ?? '') ??
        DateTime.fromMillisecondsSinceEpoch(0);
    final updatedAt =
        DateTime.tryParse(json['updatedAt']?.toString() ?? '') ?? createdAt;

    return OrderModel(
      id: _parseInt(json['id']),
      userId: _parseInt(json['userId']),
      shippingAddressId: _parseNullableInt(json['shippingAddressId']),
      shippingCity: json['shippingCity']?.toString() ?? '',
      shippingStreet: json['shippingStreet']?.toString() ?? '',
      shippingBuilding: json['shippingBuilding']?.toString() ?? '',
      orderStatus: json['orderStatus']?.toString() ?? '',
      totalAmount: _parseDouble(json['totalAmount']),
      paymentMethod: PaymentMethod.fromString(
        json['paymentMethod']?.toString() ?? '',
      ),
      createdAt: createdAt,
      updatedAt: updatedAt,
      payment: json['payment'] is Map
          ? PaymentInfoModel.fromJson(
              Map<String, dynamic>.from(json['payment'] as Map),
            )
          : null,
      items:
          (json['items'] as List<dynamic>?)
              ?.whereType<Map>()
              .map(
                (item) =>
                    OrderItemModel.fromJson(Map<String, dynamic>.from(item)),
              )
              .toList() ??
          const [],
    );
  }

  static int _parseInt(dynamic value, [int defaultValue = 0]) {
    if (value == null) return defaultValue;
    if (value is num) return value.toInt();
    return int.tryParse(value.toString()) ?? defaultValue;
  }

  static int? _parseNullableInt(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toInt();
    return int.tryParse(value.toString());
  }

  static double _parseDouble(dynamic value, [double defaultValue = 0.0]) {
    if (value == null) return defaultValue;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString()) ?? defaultValue;
  }
}
