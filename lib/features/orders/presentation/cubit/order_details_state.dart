import 'package:equatable/equatable.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/entities/order_payment_status_entity.dart';

enum OrderDetailsStatus { initial, loading, success, failure }

class OrderDetailsState extends Equatable {
  final OrderDetailsStatus status;
  final OrderEntity? order;
  final OrderPaymentStatusEntity? paymentStatus;
  final String? errorMessage;
  final bool isReordering;

  const OrderDetailsState({
    this.status = OrderDetailsStatus.initial,
    this.order,
    this.paymentStatus,
    this.errorMessage,
    this.isReordering = false,
  });

  OrderDetailsState copyWith({
    OrderDetailsStatus? status,
    OrderEntity? order,
    OrderPaymentStatusEntity? paymentStatus,
    String? errorMessage,
    bool clearErrorMessage = false,
    bool? isReordering,
  }) {
    return OrderDetailsState(
      status: status ?? this.status,
      order: order ?? this.order,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      errorMessage: clearErrorMessage
          ? null
          : (errorMessage ?? this.errorMessage),
      isReordering: isReordering ?? this.isReordering,
    );
  }

  @override
  List<Object?> get props => [
    status,
    order,
    paymentStatus,
    errorMessage,
    isReordering,
  ];
}
