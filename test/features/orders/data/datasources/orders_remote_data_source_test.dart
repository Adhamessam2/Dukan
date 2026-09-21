import 'package:flutter_test/flutter_test.dart';
import 'package:Dukan/core/api/api_consumer.dart';
import 'package:Dukan/core/api/server_strings.dart';
import 'package:Dukan/core/errors/exceptions.dart';
import 'package:Dukan/features/orders/data/datasources/orders_remote_data_source.dart';
import 'package:Dukan/features/orders/domain/entities/create_order_params.dart';
import 'package:Dukan/features/orders/domain/entities/payment_method.dart';
import 'package:Dukan/features/orders/domain/entities/shipping_address_entity.dart';

class FakeApiConsumer implements ApiConsumer {
  String? lastPath;
  Map<String, dynamic>? lastBody;
  Map<String, String>? lastHeaders;
  dynamic mockResponse;

  @override
  Future<dynamic> post(
    String path, {
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    lastPath = path;
    lastBody = body;
    lastHeaders = headers;
    return mockResponse;
  }

  @override
  Future get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    lastPath = path;
    lastHeaders = headers;
    return mockResponse;
  }

  @override
  Future put(
    String path, {
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) => throw UnimplementedError();
  @override
  Future delete(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) => throw UnimplementedError();
  @override
  Future patch(
    String path, {
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    lastPath = path;
    lastBody = body;
    lastHeaders = headers;
    return mockResponse;
  }
}

void main() {
  test(
    'createOrder sends POST with Idempotency-Key and correct body',
    () async {
      final fakeApi = FakeApiConsumer();
      final dataSource = OrdersRemoteDataSourceImpl(apiConsumer: fakeApi);

      fakeApi.mockResponse = {
        "success": true,
        "statusCode": 201,
        "data": {
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
        },
      };

      final params = CreateOrderParams(
        address: const ShippingAddressEntity(
          city: 'Cairo',
          street: 'Tahrir',
          building: '12',
        ),
        paymentMethod: PaymentMethod.cash,
        idempotencyKey: 'custom-uuid-999',
      );

      final result = await dataSource.createOrder(params);

      expect(fakeApi.lastPath, ServerStrings.order);
      expect(fakeApi.lastHeaders?['Idempotency-Key'], 'custom-uuid-999');
      expect(fakeApi.lastBody, {
        'address': {
          'shippingCity': 'Cairo',
          'shippingStreet': 'Tahrir',
          'shippingBuilding': '12',
        },
        'paymentMethod': 'CASH',
      });
      expect(result.id, 4);
      expect(result.paymentMethod, PaymentMethod.cash);
    },
  );

  test(
    'createOrder throws ParseException when response data is missing',
    () async {
      final fakeApi = FakeApiConsumer();
      final dataSource = OrdersRemoteDataSourceImpl(apiConsumer: fakeApi);

      fakeApi.mockResponse = {"success": true, "statusCode": 201, "data": null};

      final params = CreateOrderParams(
        address: const ShippingAddressEntity(
          city: 'Cairo',
          street: 'Tahrir',
          building: '12',
        ),
        paymentMethod: PaymentMethod.cash,
      );

      expect(
        () => dataSource.createOrder(params),
        throwsA(isA<ParseException>()),
      );
    },
  );

  test(
    'getOrders sends GET to ServerStrings.order and returns list of OrderModel',
    () async {
      final fakeApi = FakeApiConsumer();
      final dataSource = OrdersRemoteDataSourceImpl(apiConsumer: fakeApi);

      fakeApi.mockResponse = {
        "success": true,
        "statusCode": 200,
        "data": [
          {
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
                  "productName": "Panadol",
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
          },
        ],
      };

      final result = await dataSource.getOrders();

      expect(fakeApi.lastPath, ServerStrings.order);
      expect(result.length, 1);
      expect(result.first.id, 4);
      expect(result.first.items.first.quantity, 3);
      expect(result.first.items.first.product.productName, "Panadol");
    },
  );

  test(
    'getOrders throws ParseException when response data is not a list',
    () async {
      final fakeApi = FakeApiConsumer();
      final dataSource = OrdersRemoteDataSourceImpl(apiConsumer: fakeApi);

      fakeApi.mockResponse = {
        "success": true,
        "statusCode": 200,
        "data": "invalid",
      };

      expect(() => dataSource.getOrders(), throwsA(isA<ParseException>()));
    },
  );

  test(
    'getOrderById sends GET to ServerStrings.orderById(id) and returns OrderModel',
    () async {
      final fakeApi = FakeApiConsumer();
      final dataSource = OrdersRemoteDataSourceImpl(apiConsumer: fakeApi);

      fakeApi.mockResponse = {
        "success": true,
        "statusCode": 200,
        "data": {
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
                "productName": "Panadol Extra",
                "price": "45.5",
                "productImages": [
                  {
                    "id": "img1",
                    "productId": 2,
                    "url": "https://example.com/panadol.jpg",
                    "isPrimary": true,
                    "order": 1,
                  },
                ],
              },
            },
          ],
        },
      };

      final result = await dataSource.getOrderById(4);

      expect(fakeApi.lastPath, ServerStrings.orderById(4));
      expect(result.id, 4);
      expect(result.items.first.product.productName, "Panadol Extra");
      expect(
        result.items.first.product.productImages.first.url,
        "https://example.com/panadol.jpg",
      );
    },
  );

  test(
    'getOrderById throws ParseException when response data is missing',
    () async {
      final fakeApi = FakeApiConsumer();
      final dataSource = OrdersRemoteDataSourceImpl(apiConsumer: fakeApi);

      fakeApi.mockResponse = {"success": true, "statusCode": 200, "data": null};

      expect(() => dataSource.getOrderById(4), throwsA(isA<ParseException>()));
    },
  );

  test(
    'getOrderById throws ServerException with server message when success is false',
    () async {
      final fakeApi = FakeApiConsumer();
      final dataSource = OrdersRemoteDataSourceImpl(apiConsumer: fakeApi);

      fakeApi.mockResponse = {
        "success": false,
        "statusCode": 404,
        "message": "Order not found",
        "data": null,
      };

      expect(
        () => dataSource.getOrderById(999),
        throwsA(
          isA<ServerException>().having(
            (e) => e.message,
            'message',
            'Order not found',
          ),
        ),
      );
    },
  );

  test(
    'cancelOrder sends PATCH to ServerStrings.cancelOrder(id) and returns updated OrderModel',
    () async {
      final fakeApi = FakeApiConsumer();
      final dataSource = OrdersRemoteDataSourceImpl(apiConsumer: fakeApi);

      fakeApi.mockResponse = {
        "success": true,
        "statusCode": 200,
        "data": {
          "id": 4,
          "userId": 19,
          "shippingAddressId": null,
          "shippingCity": "Cairo",
          "shippingStreet": "Tahrir",
          "shippingBuilding": "12",
          "orderStatus": "CANCELLED",
          "totalAmount": "136.5",
          "paymentMethod": "CASH",
          "createdAt": "2026-09-20T15:29:49.683Z",
          "updatedAt": "2026-09-21T14:44:26.776Z",
        },
      };

      final result = await dataSource.cancelOrder(4);

      expect(fakeApi.lastPath, ServerStrings.cancelOrder(4));
      expect(result.id, 4);
      expect(result.orderStatus, "CANCELLED");
      expect(result.updatedAt, DateTime.parse("2026-09-21T14:44:26.776Z"));
    },
  );

  test(
    'cancelOrder throws ServerException with server message when success is false',
    () async {
      final fakeApi = FakeApiConsumer();
      final dataSource = OrdersRemoteDataSourceImpl(apiConsumer: fakeApi);

      fakeApi.mockResponse = {
        "success": false,
        "statusCode": 400,
        "message": "Order cannot be cancelled",
        "data": null,
      };

      expect(
        () => dataSource.cancelOrder(4),
        throwsA(
          isA<ServerException>().having(
            (e) => e.message,
            'message',
            'Order cannot be cancelled',
          ),
        ),
      );
    },
  );

  test(
    'cancelOrder throws ParseException when response data is missing or invalid',
    () async {
      final fakeApi = FakeApiConsumer();
      final dataSource = OrdersRemoteDataSourceImpl(apiConsumer: fakeApi);

      fakeApi.mockResponse = {"success": true, "statusCode": 200, "data": null};

      expect(() => dataSource.cancelOrder(4), throwsA(isA<ParseException>()));
    },
  );
}
