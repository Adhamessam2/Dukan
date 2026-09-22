import 'package:equatable/equatable.dart';
import '../../domain/entities/order_entity.dart';

class PaymentWebViewArgs extends Equatable {
  final String url;
  final OrderEntity order;

  const PaymentWebViewArgs({
    required this.url,
    required this.order,
  });

  @override
  List<Object?> get props => [url, order];
}
