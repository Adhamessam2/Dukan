import 'package:flutter_test/flutter_test.dart';
import 'package:Dukan/features/orders/domain/entities/order_entity.dart';
import 'package:Dukan/features/orders/domain/entities/payment_method.dart';
import 'package:Dukan/features/orders/presentation/views/payment_webview_args.dart';

void main() {
  group('PaymentWebViewArgs', () {
    final testOrder = OrderEntity(
      id: 101,
      shippingCity: 'Cairo',
      shippingStreet: 'Tahrir',
      shippingBuilding: '10',
      orderStatus: 'PENDING',
      totalAmount: 150.0,
      paymentMethod: PaymentMethod.creditCard,
      createdAt: DateTime(2026, 1, 1),
    );

    test('supports value equality', () {
      final args1 = PaymentWebViewArgs(
        url: 'https://payment.test/gateway',
        order: testOrder,
      );
      final args2 = PaymentWebViewArgs(
        url: 'https://payment.test/gateway',
        order: testOrder,
      );

      expect(args1, equals(args2));
      expect(args1.props, equals(['https://payment.test/gateway', testOrder]));
    });

    test('different values are not equal', () {
      final args1 = PaymentWebViewArgs(
        url: 'https://payment.test/gateway1',
        order: testOrder,
      );
      final args2 = PaymentWebViewArgs(
        url: 'https://payment.test/gateway2',
        order: testOrder,
      );

      expect(args1, isNot(equals(args2)));
    });
  });
}
