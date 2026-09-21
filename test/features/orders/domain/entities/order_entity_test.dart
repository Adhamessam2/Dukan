import 'package:flutter_test/flutter_test.dart';
import 'package:Dukan/features/orders/domain/entities/order_entity.dart';
import 'package:Dukan/features/orders/domain/entities/payment_info_entity.dart';
import 'package:Dukan/features/orders/domain/entities/payment_method.dart';
import 'package:Dukan/features/orders/domain/entities/shipping_address_entity.dart';

void main() {
  group('PaymentMethod', () {
    test('should map from string correctly', () {
      expect(PaymentMethod.fromString('CASH'), PaymentMethod.cash);
      expect(PaymentMethod.fromString('cash'), PaymentMethod.cash);
      expect(PaymentMethod.fromString('CREDIT_CARD'), PaymentMethod.creditCard);
      expect(PaymentMethod.fromString('credit_card'), PaymentMethod.creditCard);
      expect(PaymentMethod.fromString('creditCard'), PaymentMethod.creditCard);
      expect(PaymentMethod.fromString('credit-card'), PaymentMethod.creditCard);
      expect(PaymentMethod.fromString('UNKNOWN'), PaymentMethod.cash);
    });

    test('should expose correct API string values', () {
      expect(PaymentMethod.cash.value, 'CASH');
      expect(PaymentMethod.creditCard.value, 'CREDIT_CARD');
    });
  });

  group('ShippingAddressEntity', () {
    test('should support value equality', () {
      const address1 = ShippingAddressEntity(
        city: 'Cairo',
        street: 'Tahrir',
        building: '12',
      );
      const address2 = ShippingAddressEntity(
        city: 'Cairo',
        street: 'Tahrir',
        building: '12',
      );

      expect(address1, equals(address2));
    });
  });

  group('PaymentInfoEntity', () {
    test('should support value equality', () {
      const payment1 = PaymentInfoEntity(
        checkoutUrl: 'https://accept.paymob.com/checkout',
        clientSecret: 'secret-123',
      );
      const payment2 = PaymentInfoEntity(
        checkoutUrl: 'https://accept.paymob.com/checkout',
        clientSecret: 'secret-123',
      );

      expect(payment1, equals(payment2));
    });
  });

  group('OrderEntity', () {
    final order = OrderEntity(
      id: 4,
      userId: 19,
      shippingAddressId: null,
      shippingCity: 'Cairo',
      shippingStreet: 'Tahrir',
      shippingBuilding: '12',
      orderStatus: 'PENDING',
      totalAmount: 136.5,
      paymentMethod: PaymentMethod.cash,
      createdAt: DateTime.parse('2026-09-20T15:29:49.683Z'),
      updatedAt: DateTime.parse('2026-09-20T15:29:49.683Z'),
      payment: null,
    );

    test('should support value equality via Equatable', () {
      final orderDuplicate = OrderEntity(
        id: 4,
        userId: 19,
        shippingAddressId: null,
        shippingCity: 'Cairo',
        shippingStreet: 'Tahrir',
        shippingBuilding: '12',
        orderStatus: 'PENDING',
        totalAmount: 136.5,
        paymentMethod: PaymentMethod.cash,
        createdAt: DateTime.parse('2026-09-20T15:29:49.683Z'),
        updatedAt: DateTime.parse('2026-09-20T15:29:49.683Z'),
        payment: null,
      );

      expect(order, equals(orderDuplicate));
    });

    test('defaults userId to 0 and updatedAt to createdAt when omitted', () {
      final now = DateTime.now();
      final orderMinimal = OrderEntity(
        id: 10,
        shippingCity: 'Alexandria',
        shippingStreet: 'Corniche',
        shippingBuilding: '7',
        orderStatus: 'CONFIRMED',
        totalAmount: 90.0,
        paymentMethod: PaymentMethod.cash,
        createdAt: now,
      );

      expect(orderMinimal.userId, 0);
      expect(orderMinimal.updatedAt, now);
      expect(orderMinimal.items, isEmpty);
    });
  });
}
