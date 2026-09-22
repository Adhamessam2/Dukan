import '../../domain/entities/payment_transaction_entity.dart';

class PaymentTransactionModel extends PaymentTransactionEntity {
  const PaymentTransactionModel({
    required super.id,
    required super.status,
    required super.provider,
    required super.updatedAt,
  });

  factory PaymentTransactionModel.fromJson(Map<String, dynamic> json) {
    final parsedDate = DateTime.tryParse(json['updatedAt']?.toString() ?? '');
    return PaymentTransactionModel(
      id: json['id']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      provider: json['provider']?.toString() ?? '',
      updatedAt:
          parsedDate?.toUtc() ??
          DateTime.fromMillisecondsSinceEpoch(0, isUtc: true),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'status': status,
      'provider': provider,
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
