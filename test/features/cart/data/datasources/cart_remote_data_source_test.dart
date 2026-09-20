import 'package:flutter_test/flutter_test.dart';
import 'package:Dukan/core/api/api_consumer.dart';
import 'package:Dukan/core/api/server_strings.dart';
import 'package:Dukan/core/errors/exceptions.dart';
import 'package:Dukan/features/cart/data/datasources/cart_remote_data_source.dart';
import 'package:Dukan/features/cart/data/models/cart_item_model.dart';
import 'package:Dukan/features/cart/data/models/cart_model.dart';
import 'package:Dukan/features/home/data/models/product_model.dart';

class MockApiConsumer implements ApiConsumer {
  String? calledPath;
  dynamic calledBody;
  Map<String, dynamic>? calledQueryParameters;
  dynamic responseToReturn;
  Exception? exceptionToThrow;

  @override
  Future<dynamic> post(
    String path, {
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    calledPath = path;
    calledBody = body;
    calledQueryParameters = queryParameters;
    if (exceptionToThrow != null) throw exceptionToThrow!;
    return responseToReturn;
  }

  @override
  Future get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    calledPath = path;
    calledQueryParameters = queryParameters;
    if (exceptionToThrow != null) throw exceptionToThrow!;
    return responseToReturn;
  }

  @override
  Future delete(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    calledPath = path;
    calledQueryParameters = queryParameters;
    if (exceptionToThrow != null) throw exceptionToThrow!;
    return responseToReturn;
  }

  @override
  Future patch(
    String path, {
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) => throw UnimplementedError();

  @override
  Future put(
    String path, {
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    calledPath = path;
    calledBody = body;
    calledQueryParameters = queryParameters;
    if (exceptionToThrow != null) throw exceptionToThrow!;
    return responseToReturn;
  }
}

void main() {
  late CartRemoteDataSourceImpl dataSource;
  late MockApiConsumer mockApiConsumer;

  setUp(() {
    mockApiConsumer = MockApiConsumer();
    dataSource = CartRemoteDataSourceImpl(apiConsumer: mockApiConsumer);
  });

  const tProductId = 1;
  const tQuantity = 2;

  final tSuccessResponse = {
    'success': true,
    'statusCode': 200,
    'message': 'Cart item added successfully',
    'data': {
      'cartId': 10,
      'productId': tProductId,
      'quantity': tQuantity,
      'isDeleted': false,
    },
  };

  group('addToCart', () {
    test(
      'should call ApiConsumer.post with ServerStrings.cartItem and correct body',
      () async {
        mockApiConsumer.responseToReturn = tSuccessResponse;

        final result = await dataSource.addToCart(
          productId: tProductId,
          quantity: tQuantity,
        );

        expect(mockApiConsumer.calledPath, equals(ServerStrings.cartItem));
        expect(
          mockApiConsumer.calledBody,
          equals({'productId': tProductId, 'quantity': tQuantity}),
        );
        expect(
          result,
          equals(
            const CartItemModel(
              cartId: 10,
              productId: tProductId,
              quantity: tQuantity,
              isDeleted: false,
            ),
          ),
        );
      },
    );

    test(
      'should propagate NotFoundException thrown by ApiConsumer (e.g. from handleDioException)',
      () async {
        mockApiConsumer.exceptionToThrow = NotFoundException(
          message: 'Product not found',
        );

        expect(
          () =>
              dataSource.addToCart(productId: tProductId, quantity: tQuantity),
          throwsA(isA<NotFoundException>()),
        );
      },
    );

    test(
      'should propagate ServerException thrown by ApiConsumer (e.g. from handleDioException)',
      () async {
        mockApiConsumer.exceptionToThrow = ServerException(
          message: 'Internal server error',
          statusCode: 500,
        );

        expect(
          () =>
              dataSource.addToCart(productId: tProductId, quantity: tQuantity),
          throwsA(isA<ServerException>()),
        );
      },
    );

    test(
      'should throw TypeError / Exception when response data is null or not a map',
      () async {
        mockApiConsumer.responseToReturn = {'success': true, 'data': null};

        expect(
          () =>
              dataSource.addToCart(productId: tProductId, quantity: tQuantity),
          throwsA(isA<TypeError>()),
        );
      },
    );
  });

  group('getCart', () {
    final tCartResponse = {
      'success': true,
      'statusCode': 200,
      'data': {
        'id': 4,
        'items': [
          {
            'productId': 1,
            'quantity': 3,
            'product': {
              'id': 1,
              'productName': 'Refurbished iPhone 14 Pro',
              'price': '9999.99',
            },
          },
        ],
        'totalPrice': '29999.97',
      },
    };

    test(
      'should call ApiConsumer.get with ServerStrings.cart and return CartModel',
      () async {
        mockApiConsumer.responseToReturn = tCartResponse;

        final result = await dataSource.getCart();

        expect(mockApiConsumer.calledPath, equals(ServerStrings.cart));
        expect(result, isA<CartModel>());
        expect(result.id, equals(4));
        expect(result.items.length, equals(1));
        expect(result.items.first.productId, equals(1));
        expect(result.items.first.quantity, equals(3));
        expect(result.totalPrice, equals(29999.97));
      },
    );

    test('should propagate ServerException when ApiConsumer throws', () async {
      mockApiConsumer.exceptionToThrow = ServerException(
        message: 'Internal server error',
        statusCode: 500,
      );

      expect(() => dataSource.getCart(), throwsA(isA<ServerException>()));
    });
  });

  group('getCartItem', () {
    final tCartItemProductResponse = {
      'success': true,
      'statusCode': 200,
      'data': {
        'product': {
          'id': 1,
          'productName':
              '  Refurbished iPhone 14 Pro - 128GB (DEEP PURPLE) 📱 ',
          'productDescription':
              "Condition: Like New! Contains <b>minor micro-scratches</b> on bezel.\nIncludes charging cable & 1-year seller warranty.\nSKU Check: O'Reilly standard compliant.",
          'productImages': [
            {
              'id': 'cm1prodimg000108l4abcdef01',
              'productId': 1,
              'storageKey': 'uploads/2024/01/iphone14_front_view%20(1).jpg',
              'provider': 'CLOUDINARY',
              'url':
                  'https://4kwallpapers.com/images/walls/thumbs_3t/21872.jpg',
              'originalName': 'iphone14_front_view (1).jpg',
              'mimeType': 'image/jpeg',
              'size': 2048576,
              'isPrimary': true,
              'order': 1,
              'createdAt': '2024-01-15T08:05:00.000Z',
            },
            {
              'id': 'cm1prodimg000208l4abcdef02',
              'productId': 1,
              'storageKey': 'uploads/2024/01/iphone14_back_angle#2.png',
              'provider': 'CLOUDINARY',
              'url':
                  'https://4kwallpapers.com/images/walls/thumbs_3t/21872.jpg',
              'originalName': 'iphone14_back_angle#2.png',
              'mimeType': 'image/png',
              'size': 4194304,
              'isPrimary': false,
              'order': 2,
              'createdAt': '2024-01-15T08:06:00.000Z',
            },
          ],
          'stock': {'quantity': 3},
          'price': '9999.99',
        },
      },
    };

    test(
      'should call ApiConsumer.get with ServerStrings.cartItem, queryParameters, and return ProductModel',
      () async {
        mockApiConsumer.responseToReturn = tCartItemProductResponse;

        final result = await dataSource.getCartItem(
          cartId: '4',
          productId: '1',
        );

        expect(mockApiConsumer.calledPath, equals(ServerStrings.cartItem));
        expect(
          mockApiConsumer.calledQueryParameters,
          equals({'cartId': '4', 'productId': '1'}),
        );
        expect(result, isA<ProductModel>());
        expect(result.id, equals(1));
        expect(
          result.productName,
          equals('Refurbished iPhone 14 Pro - 128GB (DEEP PURPLE) 📱'),
        );
        expect(result.stockQuantity, equals(3));
        expect(result.price, equals(9999.99));
        expect(result.productImages.length, equals(2));
        expect(result.productImages.first.isPrimary, isTrue);
      },
    );

    test('should propagate ServerException when ApiConsumer throws', () async {
      mockApiConsumer.exceptionToThrow = ServerException(
        message: 'Internal server error',
        statusCode: 500,
      );

      expect(
        () => dataSource.getCartItem(cartId: '4', productId: '1'),
        throwsA(isA<ServerException>()),
      );
    });
  });

  group('updateCartItem', () {
    final tUpdateCartItemResponse = {
      'success': true,
      'statusCode': 200,
      'data': {'cartId': 1, 'productId': 1, 'quantity': 2, 'isDeleted': false},
    };

    test(
      'should call ApiConsumer.put with ServerStrings.cartItem, queryParameters, body, and return CartItemModel',
      () async {
        mockApiConsumer.responseToReturn = tUpdateCartItemResponse;

        final result = await dataSource.updateCartItem(
          cartId: '1',
          productId: '1',
          quantity: 2,
        );

        expect(mockApiConsumer.calledPath, equals(ServerStrings.cartItem));
        expect(
          mockApiConsumer.calledQueryParameters,
          equals({'cartId': '1', 'productId': '1'}),
        );
        expect(
          mockApiConsumer.calledBody,
          equals({'productId': 1, 'quantity': 2}),
        );
        expect(result, isA<CartItemModel>());
        expect(result.cartId, equals(1));
        expect(result.productId, equals(1));
        expect(result.quantity, equals(2));
        expect(result.isDeleted, isFalse);
      },
    );

    test('should propagate ServerException when ApiConsumer throws', () async {
      mockApiConsumer.exceptionToThrow = ServerException(
        message: 'Internal server error',
        statusCode: 500,
      );

      expect(
        () =>
            dataSource.updateCartItem(cartId: '1', productId: '1', quantity: 2),
        throwsA(isA<ServerException>()),
      );
    });
  });

  group('deleteCartItem', () {
    final tDeleteCartItemResponse = {
      'success': true,
      'statusCode': 200,
      'data': {'cartId': 1, 'productId': 1, 'quantity': 1, 'isDeleted': false},
    };

    test(
      'should call ApiConsumer.delete with ServerStrings.cartItem, queryParameters, and return CartItemModel',
      () async {
        mockApiConsumer.responseToReturn = tDeleteCartItemResponse;

        final result = await dataSource.deleteCartItem(
          cartId: '1',
          productId: '1',
        );

        expect(mockApiConsumer.calledPath, equals(ServerStrings.cartItem));
        expect(
          mockApiConsumer.calledQueryParameters,
          equals({'cartId': '1', 'productId': '1'}),
        );
        expect(result, isA<CartItemModel>());
        expect(result.cartId, equals(1));
        expect(result.productId, equals(1));
        expect(result.quantity, equals(1));
        expect(result.isDeleted, isFalse);
      },
    );

    test('should propagate ServerException when ApiConsumer throws', () async {
      mockApiConsumer.exceptionToThrow = ServerException(
        message: 'Internal server error',
        statusCode: 500,
      );

      expect(
        () => dataSource.deleteCartItem(cartId: '1', productId: '1'),
        throwsA(isA<ServerException>()),
      );
    });
  });

  group('clearCart', () {
    const tClearCartResponse = {
      'success': true,
      'statusCode': 200,
      'data': {'count': 1},
    };

    test(
      'should call ApiConsumer.delete with ServerStrings.cart and return count as int',
      () async {
        mockApiConsumer.responseToReturn = tClearCartResponse;

        final result = await dataSource.clearCart();

        expect(mockApiConsumer.calledPath, equals(ServerStrings.cart));
        expect(result, equals(1));
      },
    );

    test('should propagate ServerException when ApiConsumer throws', () async {
      mockApiConsumer.exceptionToThrow = ServerException(
        message: 'Internal server error',
        statusCode: 500,
      );

      expect(() => dataSource.clearCart(), throwsA(isA<ServerException>()));
    });
  });
}
