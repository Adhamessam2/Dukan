import '../../../../core/api/api_keys.dart';
import '../../domain/entities/payment_transaction_entity.dart';

class PaymentTransactionModel extends PaymentTransactionEntity {
  const PaymentTransactionModel({
    required super.id,
    required super.status,
    required super.provider,
    required super.updatedAt,
  });

  factory PaymentTransactionModel.fromJson(Map<String, dynamic> json) {
    final parsedDate = DateTime.tryParse(json[ApiKeys.updatedAt]?.toString() ?? '');
    return PaymentTransactionModel(
      id: json[ApiKeys.id]?.toString() ?? '',
      status: json[ApiKeys.status]?.toString() ?? '',
      provider: json[ApiKeys.provider]?.toString() ?? '',
      updatedAt:
          parsedDate?.toUtc() ??
          DateTime.fromMillisecondsSinceEpoch(0, isUtc: true),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      ApiKeys.id: id,
      ApiKeys.status: status,
      ApiKeys.provider: provider,
      ApiKeys.updatedAt: updatedAt.toIso8601String(),
    };
  }
}
