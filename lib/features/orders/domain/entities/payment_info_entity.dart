import 'package:equatable/equatable.dart';

class PaymentInfoEntity extends Equatable {
  final String checkoutUrl;
  final String clientSecret;

  const PaymentInfoEntity({
    required this.checkoutUrl,
    required this.clientSecret,
  });

  @override
  List<Object?> get props => [checkoutUrl, clientSecret];
}
