import 'package:equatable/equatable.dart';
import 'order_item_entity.dart';
import 'payment_info_entity.dart';
import 'payment_method.dart';

class OrderEntity extends Equatable {
  final int id;
  final int userId;
  final int? shippingAddressId;
  final String shippingCity;
  final String shippingStreet;
  final String shippingBuilding;
  final String orderStatus;
  final double totalAmount;
  final PaymentMethod paymentMethod;
  final DateTime createdAt;
  final DateTime updatedAt;
  final PaymentInfoEntity? payment;
  final List<OrderItemEntity> items;

  const OrderEntity({
    required this.id,
    int? userId,
    this.shippingAddressId,
    required this.shippingCity,
    required this.shippingStreet,
    required this.shippingBuilding,
    required this.orderStatus,
    required this.totalAmount,
    required this.paymentMethod,
    required this.createdAt,
    DateTime? updatedAt,
    this.payment,
    this.items = const [],
  }) : userId = userId ?? 0,
       updatedAt = updatedAt ?? createdAt;

  OrderEntity copyWith({
    int? id,
    int? userId,
    int? shippingAddressId,
    String? shippingCity,
    String? shippingStreet,
    String? shippingBuilding,
    String? orderStatus,
    double? totalAmount,
    PaymentMethod? paymentMethod,
    DateTime? createdAt,
    DateTime? updatedAt,
    PaymentInfoEntity? payment,
    List<OrderItemEntity>? items,
  }) {
    return OrderEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      shippingAddressId: shippingAddressId ?? this.shippingAddressId,
      shippingCity: shippingCity ?? this.shippingCity,
      shippingStreet: shippingStreet ?? this.shippingStreet,
      shippingBuilding: shippingBuilding ?? this.shippingBuilding,
      orderStatus: orderStatus ?? this.orderStatus,
      totalAmount: totalAmount ?? this.totalAmount,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      payment: payment ?? this.payment,
      items: items ?? this.items,
    );
  }

  bool get isPending => orderStatus.toUpperCase() == 'PENDING';

  bool get isProcessing => orderStatus.toUpperCase() == 'PROCESSING';

  bool get isShipped => orderStatus.toUpperCase() == 'SHIPPED';

  bool get isDelivered {
    final s = orderStatus.toUpperCase();
    return s == 'DELIVERED' || s == 'COMPLETED';
  }

  bool get isCancelled {
    final s = orderStatus.toUpperCase();
    return s == 'CANCELLED' || s == 'CANCELED';
  }

  /// True for any active (non-terminal) order status.
  bool get isInProgress {
    final s = orderStatus.toUpperCase();
    return s == 'PENDING' ||
        s == 'PROCESSING' ||
        s == 'SHIPPED' ||
        s == 'IN_PROGRESS';
  }

  @override
  List<Object?> get props => [
    id,
    userId,
    shippingAddressId,
    shippingCity,
    shippingStreet,
    shippingBuilding,
    orderStatus,
    totalAmount,
    paymentMethod,
    createdAt,
    updatedAt,
    payment,
    items,
  ];
}
