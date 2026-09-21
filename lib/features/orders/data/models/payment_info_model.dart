import '../../domain/entities/payment_info_entity.dart';

class PaymentInfoModel extends PaymentInfoEntity {
  const PaymentInfoModel({
    required super.checkoutUrl,
    required super.clientSecret,
  });

  factory PaymentInfoModel.fromJson(Map<String, dynamic> json) {
    return PaymentInfoModel(
      checkoutUrl: json['checkoutUrl'] as String? ?? '',
      clientSecret: json['clientSecret'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'checkoutUrl': checkoutUrl, 'clientSecret': clientSecret};
  }
}
