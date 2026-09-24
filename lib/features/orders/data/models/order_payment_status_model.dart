import '../../../../core/api/api_keys.dart';
import '../../domain/entities/order_payment_status_entity.dart';
import 'payment_transaction_model.dart';

class OrderPaymentStatusModel extends OrderPaymentStatusEntity {
  const OrderPaymentStatusModel({
    required super.id,
    required super.orderStatus,
    required super.totalAmount,
    required super.payments,
  });

  factory OrderPaymentStatusModel.fromJson(Map<String, dynamic> json) {
    return OrderPaymentStatusModel(
      id: _parseInt(json[ApiKeys.id]),
      orderStatus: json[ApiKeys.orderStatus]?.toString() ?? '',
      totalAmount: _parseDouble(json[ApiKeys.totalAmount]),
      payments:
          (json[ApiKeys.payments] as List<dynamic>?)
              ?.whereType<Map>()
              .map(
                (item) => PaymentTransactionModel.fromJson(
                  Map<String, dynamic>.from(item),
                ),
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

  static double _parseDouble(dynamic value, [double defaultValue = 0.0]) {
    if (value == null) return defaultValue;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString()) ?? defaultValue;
  }

  Map<String, dynamic> toJson() {
    return {
      ApiKeys.id: id,
      ApiKeys.orderStatus: orderStatus,
      ApiKeys.totalAmount: totalAmount.toString(),
      ApiKeys.payments: payments
          .map(
            (p) => p is PaymentTransactionModel
                ? p.toJson()
                : {
                    ApiKeys.id: p.id,
                    ApiKeys.status: p.status,
                    ApiKeys.provider: p.provider,
                    ApiKeys.updatedAt: p.updatedAt.toIso8601String(),
                  },
          )
          .toList(),
    };
  }
}
