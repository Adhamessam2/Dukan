import '../../../../core/api/api_keys.dart';
import '../../domain/entities/payment_info_entity.dart';

class PaymentInfoModel extends PaymentInfoEntity {
  const PaymentInfoModel({
    required super.checkoutUrl,
    required super.clientSecret,
  });

  factory PaymentInfoModel.fromJson(Map<String, dynamic> json) {
    return PaymentInfoModel(
      checkoutUrl: json[ApiKeys.checkoutUrl] as String? ?? '',
      clientSecret: json[ApiKeys.clientSecret] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      ApiKeys.checkoutUrl: checkoutUrl,
      ApiKeys.clientSecret: clientSecret,
    };
  }
}
