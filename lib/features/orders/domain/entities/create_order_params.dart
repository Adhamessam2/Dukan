import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';
import 'payment_method.dart';
import 'shipping_address_entity.dart';

class CreateOrderParams extends Equatable {
  final ShippingAddressEntity address;
  final PaymentMethod paymentMethod;
  final String idempotencyKey;

  CreateOrderParams({
    required this.address,
    required this.paymentMethod,
    String? idempotencyKey,
  }) : idempotencyKey = idempotencyKey ?? const Uuid().v4();

  @override
  List<Object?> get props => [address, paymentMethod, idempotencyKey];
}
