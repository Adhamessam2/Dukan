import 'package:equatable/equatable.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/entities/payment_method.dart';

enum CheckoutStatus { initial, submitting, success, failure }

class CheckoutState extends Equatable {
  final CheckoutStatus status;
  final PaymentMethod selectedPaymentMethod;
  final OrderEntity? createdOrder;
  final String? errorMessage;

  const CheckoutState({
    this.status = CheckoutStatus.initial,
    this.selectedPaymentMethod = PaymentMethod.cash,
    this.createdOrder,
    this.errorMessage,
  });

  CheckoutState copyWith({
    CheckoutStatus? status,
    PaymentMethod? selectedPaymentMethod,
    OrderEntity? createdOrder,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return CheckoutState(
      status: status ?? this.status,
      selectedPaymentMethod:
          selectedPaymentMethod ?? this.selectedPaymentMethod,
      createdOrder: createdOrder ?? this.createdOrder,
      errorMessage: clearErrorMessage
          ? null
          : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [
    status,
    selectedPaymentMethod,
    createdOrder,
    errorMessage,
  ];
}
