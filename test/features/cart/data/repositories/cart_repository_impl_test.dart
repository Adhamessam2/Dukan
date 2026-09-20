import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:Dukan/core/errors/exceptions.dart';
import 'package:Dukan/core/errors/failure.dart';
import 'package:Dukan/core/network/network_info.dart';
import 'package:Dukan/features/cart/data/datasources/cart_remote_data_source.dart';
import 'package:Dukan/features/cart/data/models/cart_item_model.dart';
import 'package:Dukan/features/cart/data/models/cart_model.dart';
import 'package:Dukan/features/cart/data/repositories/cart_repository_impl.dart';
import 'package:Dukan/features/home/data/models/product_model.dart';

class MockCartRemoteDataSource implements CartRemoteDataSource {
  CartItemModel? responseToReturn;
  CartModel? cartResponseToReturn;
  ProductModel? cartItemProductResponseToReturn;
  Exception? exceptionToThrow;
  int? calledProductId;
  int? calledQuantity;
  bool getCartCalled = false;
  String? calledGetCartItemCartId;
  String? calledGetCartItemProductId;

  @override
  Future<CartItemModel> addToCart({
    required int productId,
    required int quantity,
  }) async {
    calledProductId = productId;
    calledQuantity = quantity;
    if (exceptionToThrow != null) throw exceptionToThrow!;
    return responseToReturn!;
  }

  @override
  Future<CartModel> getCart() async {
    getCartCalled = true;
    if (exceptionToThrow != null) throw exceptionToThrow!;
    return cartResponseToReturn!;
  }

  @override
  Future<ProductModel> getCartItem({
    required String cartId,
    required String productId,
  }) async {
    calledGetCartItemCartId = cartId;
    calledGetCartItemProductId = productId;
    if (exceptionToThrow != null) throw exceptionToThrow!;
    return cartItemProductResponseToReturn!;
  }

  CartItemModel? updateCartItemResponseToReturn;
  String? calledUpdateCartItemCartId;
  String? calledUpdateCartItemProductId;
  int? calledUpdateCartItemQuantity;

  @override
  Future<CartItemModel> updateCartItem({
    required String cartId,
    required String productId,
    required int quantity,
  }) async {
    calledUpdateCartItemCartId = cartId;
    calledUpdateCartItemProductId = productId;
    calledUpdateCartItemQuantity = quantity;
    if (exceptionToThrow != null) throw exceptionToThrow!;
    return updateCartItemResponseToReturn!;
  }

  CartItemModel? deleteCartItemResponseToReturn;
  String? calledDeleteCartItemCartId;
  String? calledDeleteCartItemProductId;

  @override
  Future<CartItemModel> deleteCartItem({
    required String cartId,
    required String productId,
  }) async {
    calledDeleteCartItemCartId = cartId;
    calledDeleteCartItemProductId = productId;
    if (exceptionToThrow != null) throw exceptionToThrow!;
    return deleteCartItemResponseToReturn!;
  }

  int? clearCartResponseToReturn;
  bool clearCartCalled = false;

  @override
  Future<int> clearCart() async {
    clearCartCalled = true;
    if (exceptionToThrow != null) throw exceptionToThrow!;
    return clearCartResponseToReturn!;
  }
}

class MockNetworkInfo implements NetworkInfo {
  bool isConnectedValue = true;

  @override
  Future<bool> get isConnected async => isConnectedValue;

  @override
  Stream<InternetStatus> get onStatusChange => throw UnimplementedError();
}

void main() {
  late CartRepositoryImpl repository;
  late MockCartRemoteDataSource mockRemoteDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockCartRemoteDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = CartRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  const tProductId = 1;
  const tQuantity = 2;
  const tCartItemModel = CartItemModel(
    cartId: 10,
    productId: tProductId,
    quantity: tQuantity,
    isDeleted: false,
  );

  test(
    'should return NetworkFailure when offline without calling remoteDataSource',
    () async {
      mockNetworkInfo.isConnectedValue = false;

      final result = await repository.addToCart(
        productId: tProductId,
        quantity: tQuantity,
      );

      expect(result, const Left(NetworkFailure()));
      expect(mockRemoteDataSource.calledProductId, isNull);
      expect(mockRemoteDataSource.calledQuantity, isNull);
    },
  );

  test(
    'should return Right(CartItemModel) when online and remote call succeeds',
    () async {
      mockNetworkInfo.isConnectedValue = true;
      mockRemoteDataSource.responseToReturn = tCartItemModel;

      final result = await repository.addToCart(
        productId: tProductId,
        quantity: tQuantity,
      );

      expect(mockRemoteDataSource.calledProductId, equals(tProductId));
      expect(mockRemoteDataSource.calledQuantity, equals(tQuantity));
      expect(result, const Right(tCartItemModel));
    },
  );

  test(
    'should return Left(ServerFailure) when remote call throws ServerException',
    () async {
      mockNetworkInfo.isConnectedValue = true;
      mockRemoteDataSource.exceptionToThrow = ServerException(
        message: 'Server error',
        statusCode: 500,
      );

      final result = await repository.addToCart(
        productId: tProductId,
        quantity: tQuantity,
      );

      expect(
        result,
        const Left(ServerFailure(message: 'Server error', code: 500)),
      );
    },
  );

  test(
    'should return Left(NotFoundFailure) when remote call throws NotFoundException',
    () async {
      mockNetworkInfo.isConnectedValue = true;
      mockRemoteDataSource.exceptionToThrow = NotFoundException(
        message: 'Product not found',
      );

      final result = await repository.addToCart(
        productId: tProductId,
        quantity: tQuantity,
      );

      expect(result, const Left(NotFoundFailure(message: 'Product not found')));
    },
  );

  test(
    'should return Left(ParseFailure) when remote call throws ParseException',
    () async {
      mockNetworkInfo.isConnectedValue = true;
      mockRemoteDataSource.exceptionToThrow = ParseException(
        message: 'Invalid response format',
      );

      final result = await repository.addToCart(
        productId: tProductId,
        quantity: tQuantity,
      );

      expect(
        result,
        const Left(ParseFailure(message: 'Invalid response format')),
      );
    },
  );

  test(
    'should return Left(ValidationFailure) when remote call throws ValidationException',
    () async {
      mockNetworkInfo.isConnectedValue = true;
      mockRemoteDataSource.exceptionToThrow = ValidationException(
        message: 'Validation failed',
        errors: {'quantity': 'Must be greater than 0'},
      );

      final result = await repository.addToCart(
        productId: tProductId,
        quantity: tQuantity,
      );

      expect(
        result,
        const Left(
          ValidationFailure(
            message: 'Validation failed',
            errors: {'quantity': 'Must be greater than 0'},
          ),
        ),
      );
    },
  );

  group('getCart', () {
    const tCartModel = CartModel(
      id: 4,
      items: [CartItemModel(productId: 1, quantity: 3, isDeleted: false)],
      totalPrice: 29999.97,
    );

    test(
      'should return NetworkFailure when offline without calling remoteDataSource',
      () async {
        mockNetworkInfo.isConnectedValue = false;

        final result = await repository.getCart();

        expect(result, const Left(NetworkFailure()));
        expect(mockRemoteDataSource.getCartCalled, isFalse);
      },
    );

    test(
      'should return Right(CartModel) when online and remote call succeeds',
      () async {
        mockNetworkInfo.isConnectedValue = true;
        mockRemoteDataSource.cartResponseToReturn = tCartModel;

        final result = await repository.getCart();

        expect(mockRemoteDataSource.getCartCalled, isTrue);
        expect(result, const Right(tCartModel));
      },
    );

    test(
      'should return Left(ServerFailure) when remote call throws ServerException',
      () async {
        mockNetworkInfo.isConnectedValue = true;
        mockRemoteDataSource.exceptionToThrow = ServerException(
          message: 'Server error',
          statusCode: 500,
        );

        final result = await repository.getCart();

        expect(
          result,
          const Left(ServerFailure(message: 'Server error', code: 500)),
        );
      },
    );

    test(
      'should return Left(NotFoundFailure) when remote call throws NotFoundException',
      () async {
        mockNetworkInfo.isConnectedValue = true;
        mockRemoteDataSource.exceptionToThrow = NotFoundException(
          message: 'Cart not found',
        );

        final result = await repository.getCart();

        expect(result, const Left(NotFoundFailure(message: 'Cart not found')));
      },
    );

    test(
      'should return Left(ParseFailure) when remote call throws ParseException',
      () async {
        mockNetworkInfo.isConnectedValue = true;
        mockRemoteDataSource.exceptionToThrow = ParseException(
          message: 'Malformed JSON',
        );

        final result = await repository.getCart();

        expect(result, const Left(ParseFailure(message: 'Malformed JSON')));
      },
    );
  });

  group('getCartItem', () {
    const tProductModel = ProductModel(
      id: 1,
      productName: 'Refurbished iPhone 14 Pro',
      price: 9999.99,
      stockQuantity: 3,
    );

    const tCartId = '4';
    const tProductId = '1';

    test(
      'should return NetworkFailure when offline without calling remoteDataSource',
      () async {
        mockNetworkInfo.isConnectedValue = false;

        final result = await repository.getCartItem(
          cartId: tCartId,
          productId: tProductId,
        );

        expect(result, const Left(NetworkFailure()));
        expect(mockRemoteDataSource.calledGetCartItemCartId, isNull);
        expect(mockRemoteDataSource.calledGetCartItemProductId, isNull);
      },
    );

    test(
      'should return Right(ProductModel) when online and remote call succeeds',
      () async {
        mockNetworkInfo.isConnectedValue = true;
        mockRemoteDataSource.cartItemProductResponseToReturn = tProductModel;

        final result = await repository.getCartItem(
          cartId: tCartId,
          productId: tProductId,
        );

        expect(mockRemoteDataSource.calledGetCartItemCartId, equals(tCartId));
        expect(
          mockRemoteDataSource.calledGetCartItemProductId,
          equals(tProductId),
        );
        expect(result, const Right(tProductModel));
      },
    );

    test(
      'should return Left(ServerFailure) when remote call throws ServerException',
      () async {
        mockNetworkInfo.isConnectedValue = true;
        mockRemoteDataSource.exceptionToThrow = ServerException(
          message: 'Server error',
          statusCode: 500,
        );

        final result = await repository.getCartItem(
          cartId: tCartId,
          productId: tProductId,
        );

        expect(
          result,
          const Left(ServerFailure(message: 'Server error', code: 500)),
        );
      },
    );

    test(
      'should return Left(NotFoundFailure) when remote call throws NotFoundException',
      () async {
        mockNetworkInfo.isConnectedValue = true;
        mockRemoteDataSource.exceptionToThrow = NotFoundException(
          message: 'Product not found in cart',
        );

        final result = await repository.getCartItem(
          cartId: tCartId,
          productId: tProductId,
        );

        expect(
          result,
          const Left(NotFoundFailure(message: 'Product not found in cart')),
        );
      },
    );

    test(
      'should return Left(ParseFailure) when remote call throws ParseException',
      () async {
        mockNetworkInfo.isConnectedValue = true;
        mockRemoteDataSource.exceptionToThrow = ParseException(
          message: 'Malformed JSON',
        );

        final result = await repository.getCartItem(
          cartId: tCartId,
          productId: tProductId,
        );

        expect(result, const Left(ParseFailure(message: 'Malformed JSON')));
      },
    );
  });

  group('updateCartItem', () {
    const tCartItemModel = CartItemModel(
      cartId: 1,
      productId: 1,
      quantity: 2,
      isDeleted: false,
    );

    const tCartId = '1';
    const tProductId = '1';
    const tQuantity = 2;

    test(
      'should return NetworkFailure when offline without calling remoteDataSource',
      () async {
        mockNetworkInfo.isConnectedValue = false;

        final result = await repository.updateCartItem(
          cartId: tCartId,
          productId: tProductId,
          quantity: tQuantity,
        );

        expect(result, const Left(NetworkFailure()));
        expect(mockRemoteDataSource.calledUpdateCartItemCartId, isNull);
        expect(mockRemoteDataSource.calledUpdateCartItemProductId, isNull);
        expect(mockRemoteDataSource.calledUpdateCartItemQuantity, isNull);
      },
    );

    test(
      'should return Right(CartItemModel) when online and remote call succeeds',
      () async {
        mockNetworkInfo.isConnectedValue = true;
        mockRemoteDataSource.updateCartItemResponseToReturn = tCartItemModel;

        final result = await repository.updateCartItem(
          cartId: tCartId,
          productId: tProductId,
          quantity: tQuantity,
        );

        expect(
          mockRemoteDataSource.calledUpdateCartItemCartId,
          equals(tCartId),
        );
        expect(
          mockRemoteDataSource.calledUpdateCartItemProductId,
          equals(tProductId),
        );
        expect(
          mockRemoteDataSource.calledUpdateCartItemQuantity,
          equals(tQuantity),
        );
        expect(result, const Right(tCartItemModel));
      },
    );

    test(
      'should return Left(ServerFailure) when remote call throws ServerException',
      () async {
        mockNetworkInfo.isConnectedValue = true;
        mockRemoteDataSource.exceptionToThrow = ServerException(
          message: 'Server error',
          statusCode: 500,
        );

        final result = await repository.updateCartItem(
          cartId: tCartId,
          productId: tProductId,
          quantity: tQuantity,
        );

        expect(
          result,
          const Left(ServerFailure(message: 'Server error', code: 500)),
        );
      },
    );

    test(
      'should return Left(NotFoundFailure) when remote call throws NotFoundException',
      () async {
        mockNetworkInfo.isConnectedValue = true;
        mockRemoteDataSource.exceptionToThrow = NotFoundException(
          message: 'Item not found in cart',
        );

        final result = await repository.updateCartItem(
          cartId: tCartId,
          productId: tProductId,
          quantity: tQuantity,
        );

        expect(
          result,
          const Left(NotFoundFailure(message: 'Item not found in cart')),
        );
      },
    );

    test(
      'should return Left(ParseFailure) when remote call throws ParseException',
      () async {
        mockNetworkInfo.isConnectedValue = true;
        mockRemoteDataSource.exceptionToThrow = ParseException(
          message: 'Malformed JSON',
        );

        final result = await repository.updateCartItem(
          cartId: tCartId,
          productId: tProductId,
          quantity: tQuantity,
        );

        expect(result, const Left(ParseFailure(message: 'Malformed JSON')));
      },
    );
  });

  group('deleteCartItem', () {
    const tCartItemModel = CartItemModel(
      cartId: 1,
      productId: 1,
      quantity: 1,
      isDeleted: false,
    );

    const tCartId = '1';
    const tProductId = '1';

    test(
      'should return NetworkFailure when offline without calling remoteDataSource',
      () async {
        mockNetworkInfo.isConnectedValue = false;

        final result = await repository.deleteCartItem(
          cartId: tCartId,
          productId: tProductId,
        );

        expect(result, const Left(NetworkFailure()));
        expect(mockRemoteDataSource.calledDeleteCartItemCartId, isNull);
        expect(mockRemoteDataSource.calledDeleteCartItemProductId, isNull);
      },
    );

    test(
      'should return Right(CartItemModel) when online and remote call succeeds',
      () async {
        mockNetworkInfo.isConnectedValue = true;
        mockRemoteDataSource.deleteCartItemResponseToReturn = tCartItemModel;

        final result = await repository.deleteCartItem(
          cartId: tCartId,
          productId: tProductId,
        );

        expect(
          mockRemoteDataSource.calledDeleteCartItemCartId,
          equals(tCartId),
        );
        expect(
          mockRemoteDataSource.calledDeleteCartItemProductId,
          equals(tProductId),
        );
        expect(result, const Right(tCartItemModel));
      },
    );

    test(
      'should return Left(ServerFailure) when remote call throws ServerException',
      () async {
        mockNetworkInfo.isConnectedValue = true;
        mockRemoteDataSource.exceptionToThrow = ServerException(
          message: 'Server error',
          statusCode: 500,
        );

        final result = await repository.deleteCartItem(
          cartId: tCartId,
          productId: tProductId,
        );

        expect(
          result,
          const Left(ServerFailure(message: 'Server error', code: 500)),
        );
      },
    );

    test(
      'should return Left(NotFoundFailure) when remote call throws NotFoundException',
      () async {
        mockNetworkInfo.isConnectedValue = true;
        mockRemoteDataSource.exceptionToThrow = NotFoundException(
          message: 'Item not found in cart',
        );

        final result = await repository.deleteCartItem(
          cartId: tCartId,
          productId: tProductId,
        );

        expect(
          result,
          const Left(NotFoundFailure(message: 'Item not found in cart')),
        );
      },
    );

    test(
      'should return Left(ParseFailure) when remote call throws ParseException',
      () async {
        mockNetworkInfo.isConnectedValue = true;
        mockRemoteDataSource.exceptionToThrow = ParseException(
          message: 'Malformed JSON',
        );

        final result = await repository.deleteCartItem(
          cartId: tCartId,
          productId: tProductId,
        );

        expect(result, const Left(ParseFailure(message: 'Malformed JSON')));
      },
    );
  });

  group('clearCart', () {
    test(
      'should return NetworkFailure when offline without calling remoteDataSource',
      () async {
        mockNetworkInfo.isConnectedValue = false;

        final result = await repository.clearCart();

        expect(result, const Left(NetworkFailure()));
        expect(mockRemoteDataSource.clearCartCalled, isFalse);
      },
    );

    test(
      'should return Right(int) when online and remote call succeeds',
      () async {
        mockNetworkInfo.isConnectedValue = true;
        mockRemoteDataSource.clearCartResponseToReturn = 1;

        final result = await repository.clearCart();

        expect(mockRemoteDataSource.clearCartCalled, isTrue);
        expect(result, const Right(1));
      },
    );

    test(
      'should return Left(ServerFailure) when remote call throws ServerException',
      () async {
        mockNetworkInfo.isConnectedValue = true;
        mockRemoteDataSource.exceptionToThrow = ServerException(
          message: 'Server error',
          statusCode: 500,
        );

        final result = await repository.clearCart();

        expect(
          result,
          const Left(ServerFailure(message: 'Server error', code: 500)),
        );
      },
    );

    test(
      'should return Left(UnauthorizedFailure) when remote call throws UnauthorizedException',
      () async {
        mockNetworkInfo.isConnectedValue = true;
        mockRemoteDataSource.exceptionToThrow = UnauthorizedException(
          message: 'Unauthorized',
        );

        final result = await repository.clearCart();

        expect(
          result,
          const Left(UnauthorizedFailure(message: 'Unauthorized')),
        );
      },
    );

    test(
      'should return Left(ParseFailure) when remote call throws ParseException',
      () async {
        mockNetworkInfo.isConnectedValue = true;
        mockRemoteDataSource.exceptionToThrow = ParseException(
          message: 'Malformed JSON',
        );

        final result = await repository.clearCart();

        expect(result, const Left(ParseFailure(message: 'Malformed JSON')));
      },
    );
  });
}
