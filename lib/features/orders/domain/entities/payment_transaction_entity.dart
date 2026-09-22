import 'package:equatable/equatable.dart';

class PaymentTransactionEntity extends Equatable {
  final String id;
  final String status;
  final String provider;
  final DateTime updatedAt;

  const PaymentTransactionEntity({
    required this.id,
    required this.status,
    required this.provider,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [id, status, provider, updatedAt];
}
