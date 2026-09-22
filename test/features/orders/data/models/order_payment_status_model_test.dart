import 'package:flutter_test/flutter_test.dart';
import 'package:Dukan/features/orders/data/models/order_payment_status_model.dart';
import 'package:Dukan/features/orders/data/models/payment_transaction_model.dart';
import 'package:Dukan/features/orders/domain/entities/order_payment_status_entity.dart';

void main() {
  final tJson = {
    "id": 5,
    "orderStatus": "PENDING",
    "totalAmount": "0.5",
    "payments": [
      {
        "id": "cmu9z81di00005mohki9g8mgy",
        "status": "PENDING",
        "provider": "PAYMOB",
        "updatedAt": "2026-09-20T15:34:00.421Z",
      },
    ],
  };

  final tModel = OrderPaymentStatusModel(
    id: 5,
    orderStatus: 'PENDING',
    totalAmount: 0.5,
    payments: [
      PaymentTransactionModel(
        id: 'cmu9z81di00005mohki9g8mgy',
        status: 'PENDING',
        provider: 'PAYMOB',
        updatedAt: DateTime.parse('2026-09-20T15:34:00.421Z'),
      ),
    ],
  );

  test('should be a subclass of OrderPaymentStatusEntity', () {
    expect(tModel, isA<OrderPaymentStatusEntity>());
  });

  group('fromJson', () {
    test('parses correctly when totalAmount is a String', () {
      final result = OrderPaymentStatusModel.fromJson(tJson);
      expect(result.id, 5);
      expect(result.orderStatus, 'PENDING');
      expect(result.totalAmount, 0.5);
      expect(result.payments.length, 1);
      expect(result.payments.first.id, 'cmu9z81di00005mohki9g8mgy');
      expect(result.payments.first.status, 'PENDING');
      expect(result.payments.first.provider, 'PAYMOB');
      expect(result.isPaid, isFalse);
      expect(result.latestPayment?.id, 'cmu9z81di00005mohki9g8mgy');
    });

    test(
      'parses correctly when totalAmount is a num and payments has success status',
      () {
        final jsonWithNum = {
          "id": 5,
          "orderStatus": "DELIVERED",
          "totalAmount": 120.0,
          "payments": [
            {
              "id": "pay_1",
              "status": "SUCCESS",
              "provider": "PAYMOB",
              "updatedAt": "2026-09-20T15:34:00.421Z",
            },
          ],
        };
        final result = OrderPaymentStatusModel.fromJson(jsonWithNum);
        expect(result.totalAmount, 120.0);
        expect(result.isPaid, isTrue);
      },
    );

    test('handles missing or empty payments list gracefully', () {
      final jsonEmptyPayments = {
        "id": 5,
        "orderStatus": "PENDING",
        "totalAmount": "0.0",
      };
      final result = OrderPaymentStatusModel.fromJson(jsonEmptyPayments);
      expect(result.payments, isEmpty);
      expect(result.latestPayment, isNull);
      expect(result.isPaid, isFalse);
    });
  });

  group('toJson', () {
    test('returns valid Map representation', () {
      final json = tModel.toJson();
      expect(json['id'], 5);
      expect(json['orderStatus'], 'PENDING');
      expect(json['totalAmount'], '0.5');
      expect((json['payments'] as List).length, 1);
    });
  });
}
