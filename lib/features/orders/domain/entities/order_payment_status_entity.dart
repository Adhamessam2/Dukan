import 'package:equatable/equatable.dart';
import 'payment_transaction_entity.dart';

class OrderPaymentStatusEntity extends Equatable {
  final int id;
  final String orderStatus;
  final double totalAmount;
  final List<PaymentTransactionEntity> payments;

  const OrderPaymentStatusEntity({
    required this.id,
    required this.orderStatus,
    required this.totalAmount,
    required this.payments,
  });

  PaymentTransactionEntity? get latestPayment =>
      payments.isNotEmpty ? payments.last : null;

  bool get isPaid => payments.any(
    (p) =>
        p.status.toUpperCase() == 'SUCCESS' || p.status.toUpperCase() == 'PAID',
  );

  @override
  List<Object?> get props => [id, orderStatus, totalAmount, payments];
}
