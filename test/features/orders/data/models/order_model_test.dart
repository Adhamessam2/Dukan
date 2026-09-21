import 'package:flutter_test/flutter_test.dart';
import 'package:Dukan/features/orders/data/models/create_order_request_model.dart';
import 'package:Dukan/features/orders/data/models/order_model.dart';
import 'package:Dukan/features/orders/data/models/payment_info_model.dart';
import 'package:Dukan/features/orders/domain/entities/create_order_params.dart';
import 'package:Dukan/features/orders/domain/entities/payment_method.dart';
import 'package:Dukan/features/orders/domain/entities/shipping_address_entity.dart';

void main() {
  group('CreateOrderRequestModel', () {
    test('serializes address and paymentMethod to required JSON', () {
      final params = CreateOrderParams(
        address: const ShippingAddressEntity(
          city: 'Cairo',
          street: 'Tahrir',
          building: '12',
        ),
        paymentMethod: PaymentMethod.cash,
        idempotencyKey: 'fixed-key',
      );

      final json = CreateOrderRequestModel.fromEntity(params).toJson();

      expect(json, {
        'address': {
          'shippingCity': 'Cairo',
          'shippingStreet': 'Tahrir',
          'shippingBuilding': '12',
        },
        'paymentMethod': 'CASH',
      });
    });

    test('serializes credit card payment method correctly', () {
      final params = CreateOrderParams(
        address: const ShippingAddressEntity(
          city: 'Giza',
          street: 'Pyramids',
          building: '5',
        ),
        paymentMethod: PaymentMethod.creditCard,
      );

      final json = CreateOrderRequestModel.fromEntity(params).toJson();

      expect(json['paymentMethod'], 'CREDIT_CARD');
    });
  });

  group('PaymentInfoModel', () {
    test('fromJson and toJson round-trip', () {
      final json = {
        'checkoutUrl': 'https://accept.paymob.com/checkout',
        'clientSecret': 'sec_123',
      };

      final model = PaymentInfoModel.fromJson(json);

      expect(model.checkoutUrl, 'https://accept.paymob.com/checkout');
      expect(model.clientSecret, 'sec_123');
      expect(model.toJson(), json);
    });

    test('fromJson handles null safely', () {
      final model = PaymentInfoModel.fromJson(const {});

      expect(model.checkoutUrl, '');
      expect(model.clientSecret, '');
    });
  });

  group('OrderModel', () {
    test('fromJson parses CASH response successfully with null payment', () {
      final json = {
        "id": 4,
        "userId": 19,
        "shippingAddressId": null,
        "shippingCity": "Cairo",
        "shippingStreet": "Tahrir",
        "shippingBuilding": "12",
        "orderStatus": "PENDING",
        "totalAmount": "136.5",
        "paymentMethod": "CASH",
        "createdAt": "2026-09-20T15:29:49.683Z",
        "updatedAt": "2026-09-20T15:29:49.683Z",
        "payment": null,
      };

      final model = OrderModel.fromJson(json);

      expect(model.id, 4);
      expect(model.userId, 19);
      expect(model.shippingAddressId, isNull);
      expect(model.shippingCity, 'Cairo');
      expect(model.shippingStreet, 'Tahrir');
      expect(model.shippingBuilding, '12');
      expect(model.orderStatus, 'PENDING');
      expect(model.totalAmount, 136.5);
      expect(model.paymentMethod, PaymentMethod.cash);
      expect(model.payment, isNull);
      expect(model.createdAt, DateTime.parse('2026-09-20T15:29:49.683Z'));
      expect(model.updatedAt, DateTime.parse('2026-09-20T15:29:49.683Z'));
    });

    test(
      'fromJson parses CREDIT_CARD response successfully with payment populated',
      () {
        final json = {
          "id": 5,
          "userId": 19,
          "shippingAddressId": null,
          "shippingCity": "Cairo",
          "shippingStreet": "Tahrir",
          "shippingBuilding": "12",
          "orderStatus": "PENDING",
          "totalAmount": 150.0,
          "paymentMethod": "CREDIT_CARD",
          "createdAt": "2026-09-20T15:29:49.683Z",
          "updatedAt": "2026-09-20T15:29:49.683Z",
          "payment": {
            "checkoutUrl": "https://accept.paymob.com/checkout",
            "clientSecret": "secret-key",
          },
        };

        final model = OrderModel.fromJson(json);

        expect(model.id, 5);
        expect(model.totalAmount, 150.0);
        expect(model.paymentMethod, PaymentMethod.creditCard);
        expect(model.payment, isNotNull);
        expect(
          model.payment?.checkoutUrl,
          "https://accept.paymob.com/checkout",
        );
        expect(model.payment?.clientSecret, "secret-key");
      },
    );

    test(
      'fromJson handles numbers as strings or doubles and malformed dates safely',
      () {
        final json = {
          "id": "4",
          "userId": 19.0,
          "shippingAddressId": "100",
          "shippingCity": "Cairo",
          "shippingStreet": "Tahrir",
          "shippingBuilding": "12",
          "orderStatus": "PENDING",
          "totalAmount": 136.5,
          "paymentMethod": "creditCard",
          "createdAt": "invalid-date",
          "updatedAt": "invalid-date",
          "payment": "not-a-map",
        };

        final model = OrderModel.fromJson(json);

        expect(model.id, 4);
        expect(model.userId, 19);
        expect(model.shippingAddressId, 100);
        expect(model.paymentMethod, PaymentMethod.creditCard);
        expect(model.payment, isNull);
        expect(model.createdAt, DateTime.fromMillisecondsSinceEpoch(0));
        expect(model.updatedAt, DateTime.fromMillisecondsSinceEpoch(0));
      },
    );

    test('fromJson parses GET /order items and products accurately', () {
      final json = {
        "id": 4,
        "shippingCity": "Cairo",
        "shippingBuilding": "12",
        "shippingStreet": "Tahrir",
        "orderStatus": "PENDING",
        "totalAmount": "136.5",
        "paymentMethod": "CASH",
        "createdAt": "2026-09-20T15:29:49.683Z",
        "items": [
          {
            "quantity": 3,
            "product": {
              "id": 2,
              "productName": "Paracetamol 500mg",
              "price": "45.5",
              "productImages": [
                {
                  "url": "https://example.com/img1.png",
                  "isPrimary": true,
                  "order": 1,
                },
              ],
            },
          },
        ],
      };

      final model = OrderModel.fromJson(json);

      expect(model.id, 4);
      expect(model.items.length, 1);
      expect(model.items.first.quantity, 3);
      expect(model.items.first.product.id, 2);
      expect(model.items.first.product.productName, "Paracetamol 500mg");
      expect(model.items.first.product.price, 45.5);
      expect(
        model.items.first.product.productImages.first.url,
        "https://example.com/img1.png",
      );
      expect(model.items.first.product.productImages.first.isPrimary, true);
    });
  });
}
