import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:Dukan/core/errors/failure.dart';
import 'package:Dukan/features/cart/domain/entities/cart_entity.dart';
import 'package:Dukan/features/cart/domain/entities/cart_item_entity.dart';
import 'package:Dukan/features/cart/domain/repositories/cart_repository.dart';
import 'package:Dukan/features/cart/domain/usecases/add_to_cart_use_case.dart';
import 'package:Dukan/features/cart/domain/usecases/delete_cart_item_use_case.dart';
import 'package:Dukan/features/cart/domain/usecases/get_cart_item_use_case.dart';
import 'package:Dukan/features/cart/domain/usecases/get_cart_use_case.dart';
import 'package:Dukan/features/cart/domain/usecases/clear_cart_use_case.dart';
import 'package:Dukan/features/cart/domain/usecases/update_cart_item_use_case.dart';
import 'package:Dukan/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:Dukan/features/cart/presentation/cubit/cart_state.dart';
import 'package:Dukan/features/home/domain/entities/product_entity.dart';

class MockCartRepository implements CartRepository {
  Either<Failure, CartItemEntity>? result;
  Either<Failure, CartEntity>? getCartResult;
  Either<Failure, ProductEntity>? getCartItemResult;
  Either<Failure, CartItemEntity>? updateCartItemResult;
  Either<Failure, CartItemEntity>? deleteCartItemResult;
  Either<Failure, int>? clearCartResult;
  int? calledProductId;
  int? calledQuantity;
  bool getCartCalled = false;
  bool clearCartCalled = false;
  String? calledGetCartItemCartId;
  String? calledGetCartItemProductId;
  String? calledUpdateCartItemCartId;
  String? calledUpdateCartItemProductId;
  int? calledUpdateCartItemQuantity;
  String? calledDeleteCartItemCartId;
  String? calledDeleteCartItemProductId;

  @override
  Future<Either<Failure, CartItemEntity>> addToCart({
    required int productId,
    required int quantity,
  }) async {
    calledProductId = productId;
    calledQuantity = quantity;
    return result!;
  }

  @override
  Future<Either<Failure, CartEntity>> getCart() async {
    getCartCalled = true;
    return getCartResult!;
  }

  @override
  Future<Either<Failure, ProductEntity>> getCartItem({
    required String cartId,
    required String productId,
  }) async {
    calledGetCartItemCartId = cartId;
    calledGetCartItemProductId = productId;
    return getCartItemResult!;
  }

  @override
  Future<Either<Failure, CartItemEntity>> updateCartItem({
    required String cartId,
    required String productId,
    required int quantity,
  }) async {
    calledUpdateCartItemCartId = cartId;
    calledUpdateCartItemProductId = productId;
    calledUpdateCartItemQuantity = quantity;
    return updateCartItemResult!;
  }

  @override
  Future<Either<Failure, CartItemEntity>> deleteCartItem({
    required String cartId,
    required String productId,
  }) async {
    calledDeleteCartItemCartId = cartId;
    calledDeleteCartItemProductId = productId;
    return deleteCartItemResult!;
  }

  @override
  Future<Either<Failure, int>> clearCart() async {
    clearCartCalled = true;
    return clearCartResult!;
  }
}

void main() {
  late CartCubit cubit;
  late MockCartRepository mockRepository;
  late AddToCartUseCase addToCartUseCase;
  late GetCartUseCase getCartUseCase;
  late GetCartItemUseCase getCartItemUseCase;
  late UpdateCartItemUseCase updateCartItemUseCase;
  late DeleteCartItemUseCase deleteCartItemUseCase;
  late ClearCartUseCase clearCartUseCase;

  const tCartItem = CartItemEntity(
    cartId: 1,
    productId: 1,
    quantity: 2,
    isDeleted: false,
  );

  const tCart = CartEntity(id: 4, items: [tCartItem], totalPrice: 19999.98);

  const tProduct = ProductEntity(
    id: 1,
    productName: 'Refurbished iPhone 14 Pro',
    price: 9999.99,
  );

  setUp(() {
    mockRepository = MockCartRepository();
    addToCartUseCase = AddToCartUseCase(mockRepository);
    getCartUseCase = GetCartUseCase(mockRepository);
    getCartItemUseCase = GetCartItemUseCase(mockRepository);
    updateCartItemUseCase = UpdateCartItemUseCase(mockRepository);
    deleteCartItemUseCase = DeleteCartItemUseCase(mockRepository);
    clearCartUseCase = ClearCartUseCase(mockRepository);
    cubit = CartCubit(
      addToCartUseCase: addToCartUseCase,
      getCartUseCase: getCartUseCase,
      getCartItemUseCase: getCartItemUseCase,
      updateCartItemUseCase: updateCartItemUseCase,
      deleteCartItemUseCase: deleteCartItemUseCase,
      clearCartUseCase: clearCartUseCase,
    );
  });

  tearDown(() {
    cubit.close();
  });

  test('initial state is correct', () {
    expect(cubit.state, const CartState());
    expect(cubit.state.status, CartStatus.initial);
    expect(cubit.state.addingProductId, isNull);
    expect(cubit.state.lastAddedItem, isNull);
    expect(cubit.state.errorMessage, isNull);
    expect(cubit.state.getCartStatus, CartStatus.initial);
    expect(cubit.state.cart, isNull);
    expect(cubit.state.getCartErrorMessage, isNull);
    expect(cubit.state.getCartItemStatus, CartStatus.initial);
    expect(cubit.state.cartItemProduct, isNull);
    expect(cubit.state.getCartItemErrorMessage, isNull);
    expect(cubit.state.updateCartItemStatus, CartStatus.initial);
    expect(cubit.state.updatedCartItem, isNull);
    expect(cubit.state.updateCartItemErrorMessage, isNull);
    expect(cubit.state.deleteCartItemStatus, CartStatus.initial);
    expect(cubit.state.deletedCartItem, isNull);
    expect(cubit.state.deleteCartItemErrorMessage, isNull);
  });

  test('addToCart emits [loading, success] on success', () async {
    mockRepository.result = const Right(tCartItem);

    final expectedStates = [
      const CartState(status: CartStatus.loading, addingProductId: 1),
      const CartState(
        status: CartStatus.success,
        addingProductId: null,
        lastAddedItem: tCartItem,
      ),
    ];

    final expectation = expectLater(cubit.stream, emitsInOrder(expectedStates));

    await cubit.addToCart(productId: 1, quantity: 2);
    await expectation;

    expect(mockRepository.calledProductId, equals(1));
    expect(mockRepository.calledQuantity, equals(2));
    expect(cubit.state.status, CartStatus.success);
    expect(cubit.state.lastAddedItem, tCartItem);
    expect(cubit.state.addingProductId, isNull);
    expect(cubit.state.errorMessage, isNull);
  });

  test('addToCart emits [loading, failure] on failure', () async {
    const tFailure = ServerFailure(message: 'Item out of stock', code: 400);
    mockRepository.result = const Left(tFailure);

    final expectedStates = [
      const CartState(status: CartStatus.loading, addingProductId: 1),
      const CartState(
        status: CartStatus.failure,
        addingProductId: null,
        errorMessage: 'Item out of stock',
      ),
    ];

    final expectation = expectLater(cubit.stream, emitsInOrder(expectedStates));

    await cubit.addToCart(productId: 1, quantity: 2);
    await expectation;

    expect(cubit.state.status, CartStatus.failure);
    expect(cubit.state.errorMessage, 'Item out of stock');
    expect(cubit.state.addingProductId, isNull);
  });

  test(
    'addToCart clears previous error message when starting a new operation',
    () async {
      const tFailure = ServerFailure(message: 'Initial error', code: 400);
      mockRepository.result = const Left(tFailure);

      await cubit.addToCart(productId: 1, quantity: 1);
      expect(cubit.state.errorMessage, 'Initial error');

      mockRepository.result = const Right(tCartItem);

      final expectedStates = [
        const CartState(
          status: CartStatus.loading,
          addingProductId: 1,
          errorMessage: null,
        ),
        const CartState(
          status: CartStatus.success,
          addingProductId: null,
          lastAddedItem: tCartItem,
          errorMessage: null,
        ),
      ];

      final expectation = expectLater(
        cubit.stream,
        emitsInOrder(expectedStates),
      );

      await cubit.addToCart(productId: 1, quantity: 2);
      await expectation;

      expect(cubit.state.status, CartStatus.success);
      expect(cubit.state.errorMessage, isNull);
    },
  );

  test(
    'does not emit state if cubit is closed before response returns',
    () async {
      mockRepository.result = const Right(tCartItem);

      // Call addToCart but close before it completes
      final future = cubit.addToCart(productId: 1, quantity: 2);
      await cubit.close();
      await future;

      // Verify it doesn't throw or emit after close
      expect(cubit.isClosed, isTrue);
    },
  );

  group('getCart', () {
    test('emits [loading, success] on success', () async {
      mockRepository.getCartResult = const Right(tCart);

      final expectedStates = [
        const CartState(getCartStatus: CartStatus.loading),
        const CartState(getCartStatus: CartStatus.success, cart: tCart),
      ];

      final expectation = expectLater(
        cubit.stream,
        emitsInOrder(expectedStates),
      );

      await cubit.getCart();
      await expectation;

      expect(mockRepository.getCartCalled, isTrue);
      expect(cubit.state.getCartStatus, CartStatus.success);
      expect(cubit.state.cart, tCart);
      expect(cubit.state.getCartErrorMessage, isNull);
    });

    test('emits [loading, failure] on failure', () async {
      const tFailure = ServerFailure(
        message: 'Failed to fetch cart',
        code: 500,
      );
      mockRepository.getCartResult = const Left(tFailure);

      final expectedStates = [
        const CartState(getCartStatus: CartStatus.loading),
        const CartState(
          getCartStatus: CartStatus.failure,
          getCartErrorMessage: 'Failed to fetch cart',
        ),
      ];

      final expectation = expectLater(
        cubit.stream,
        emitsInOrder(expectedStates),
      );

      await cubit.getCart();
      await expectation;

      expect(cubit.state.getCartStatus, CartStatus.failure);
      expect(cubit.state.getCartErrorMessage, 'Failed to fetch cart');
      expect(cubit.state.cart, isNull);
    });

    test(
      'clears previous getCartErrorMessage when starting a new operation',
      () async {
        const tFailure = ServerFailure(message: 'Initial error', code: 500);
        mockRepository.getCartResult = const Left(tFailure);

        await cubit.getCart();
        expect(cubit.state.getCartErrorMessage, 'Initial error');

        mockRepository.getCartResult = const Right(tCart);

        final expectedStates = [
          const CartState(
            getCartStatus: CartStatus.loading,
            getCartErrorMessage: null,
          ),
          const CartState(
            getCartStatus: CartStatus.success,
            cart: tCart,
            getCartErrorMessage: null,
          ),
        ];

        final expectation = expectLater(
          cubit.stream,
          emitsInOrder(expectedStates),
        );

        await cubit.getCart();
        await expectation;

        expect(cubit.state.getCartStatus, CartStatus.success);
        expect(cubit.state.getCartErrorMessage, isNull);
      },
    );

    test(
      'does not emit state if cubit is closed before response returns',
      () async {
        mockRepository.getCartResult = const Right(tCart);

        final future = cubit.getCart();
        await cubit.close();
        await future;

        expect(cubit.isClosed, isTrue);
      },
    );
  });

  group('getCartItem', () {
    test('emits [loading, success] on success', () async {
      mockRepository.getCartItemResult = const Right(tProduct);

      final expectedStates = [
        const CartState(getCartItemStatus: CartStatus.loading),
        const CartState(
          getCartItemStatus: CartStatus.success,
          cartItemProduct: tProduct,
        ),
      ];

      final expectation = expectLater(
        cubit.stream,
        emitsInOrder(expectedStates),
      );

      await cubit.getCartItem(cartId: '4', productId: '1');
      await expectation;

      expect(mockRepository.calledGetCartItemCartId, equals('4'));
      expect(mockRepository.calledGetCartItemProductId, equals('1'));
      expect(cubit.state.getCartItemStatus, CartStatus.success);
      expect(cubit.state.cartItemProduct, tProduct);
      expect(cubit.state.getCartItemErrorMessage, isNull);
    });

    test('emits [loading, failure] on failure', () async {
      const tFailure = ServerFailure(message: 'Product not found', code: 404);
      mockRepository.getCartItemResult = const Left(tFailure);

      final expectedStates = [
        const CartState(getCartItemStatus: CartStatus.loading),
        const CartState(
          getCartItemStatus: CartStatus.failure,
          getCartItemErrorMessage: 'Product not found',
        ),
      ];

      final expectation = expectLater(
        cubit.stream,
        emitsInOrder(expectedStates),
      );

      await cubit.getCartItem(cartId: '4', productId: '1');
      await expectation;

      expect(cubit.state.getCartItemStatus, CartStatus.failure);
      expect(cubit.state.getCartItemErrorMessage, 'Product not found');
      expect(cubit.state.cartItemProduct, isNull);
    });

    test(
      'clears previous getCartItemErrorMessage when starting a new operation',
      () async {
        const tFailure = ServerFailure(message: 'Initial error', code: 500);
        mockRepository.getCartItemResult = const Left(tFailure);

        await cubit.getCartItem(cartId: '4', productId: '1');
        expect(cubit.state.getCartItemErrorMessage, 'Initial error');

        mockRepository.getCartItemResult = const Right(tProduct);

        final expectedStates = [
          const CartState(
            getCartItemStatus: CartStatus.loading,
            getCartItemErrorMessage: null,
          ),
          const CartState(
            getCartItemStatus: CartStatus.success,
            cartItemProduct: tProduct,
            getCartItemErrorMessage: null,
          ),
        ];

        final expectation = expectLater(
          cubit.stream,
          emitsInOrder(expectedStates),
        );

        await cubit.getCartItem(cartId: '4', productId: '1');
        await expectation;

        expect(cubit.state.getCartItemStatus, CartStatus.success);
        expect(cubit.state.getCartItemErrorMessage, isNull);
      },
    );

    test(
      'does not emit state if cubit is closed before response returns',
      () async {
        mockRepository.getCartItemResult = const Right(tProduct);

        final future = cubit.getCartItem(cartId: '4', productId: '1');
        await cubit.close();
        await future;

        expect(cubit.isClosed, isTrue);
      },
    );
  });

  group('updateCartItem', () {
    test('emits [loading, success] on success', () async {
      mockRepository.updateCartItemResult = const Right(tCartItem);

      final expectedStates = [
        const CartState(
          updateCartItemStatus: CartStatus.loading,
          pendingProductIds: {1},
        ),
        const CartState(
          updateCartItemStatus: CartStatus.success,
          updatedCartItem: tCartItem,
          pendingProductIds: {},
        ),
      ];

      final expectation = expectLater(
        cubit.stream,
        emitsInOrder(expectedStates),
      );

      await cubit.updateCartItem(cartId: '1', productId: '1', quantity: 2);
      await expectation;

      expect(mockRepository.calledUpdateCartItemCartId, equals('1'));
      expect(mockRepository.calledUpdateCartItemProductId, equals('1'));
      expect(mockRepository.calledUpdateCartItemQuantity, equals(2));
      expect(cubit.state.updateCartItemStatus, CartStatus.success);
      expect(cubit.state.updatedCartItem, tCartItem);
      expect(cubit.state.updateCartItemErrorMessage, isNull);
    });

    test('emits [loading, failure] on failure', () async {
      const tFailure = ServerFailure(message: 'Update failed', code: 400);
      mockRepository.updateCartItemResult = const Left(tFailure);

      final expectedStates = [
        const CartState(
          updateCartItemStatus: CartStatus.loading,
          pendingProductIds: {1},
        ),
        const CartState(
          updateCartItemStatus: CartStatus.failure,
          updateCartItemErrorMessage: 'Update failed',
          pendingProductIds: {},
        ),
      ];

      final expectation = expectLater(
        cubit.stream,
        emitsInOrder(expectedStates),
      );

      await cubit.updateCartItem(cartId: '1', productId: '1', quantity: 2);
      await expectation;

      expect(cubit.state.updateCartItemStatus, CartStatus.failure);
      expect(cubit.state.updateCartItemErrorMessage, 'Update failed');
      expect(cubit.state.updatedCartItem, isNull);
    });

    test(
      'clears previous updateCartItemErrorMessage when starting a new operation',
      () async {
        const tFailure = ServerFailure(message: 'Initial error', code: 500);
        mockRepository.updateCartItemResult = const Left(tFailure);

        await cubit.updateCartItem(cartId: '1', productId: '1', quantity: 2);
        expect(cubit.state.updateCartItemErrorMessage, 'Initial error');

        mockRepository.updateCartItemResult = const Right(tCartItem);

        final expectedStates = [
          const CartState(
            updateCartItemStatus: CartStatus.loading,
            updateCartItemErrorMessage: null,
            pendingProductIds: {1},
          ),
          const CartState(
            updateCartItemStatus: CartStatus.success,
            updatedCartItem: tCartItem,
            updateCartItemErrorMessage: null,
            pendingProductIds: {},
          ),
        ];

        final expectation = expectLater(
          cubit.stream,
          emitsInOrder(expectedStates),
        );

        await cubit.updateCartItem(cartId: '1', productId: '1', quantity: 2);
        await expectation;

        expect(cubit.state.updateCartItemStatus, CartStatus.success);
        expect(cubit.state.updateCartItemErrorMessage, isNull);
      },
    );

    test(
      'does not emit state if cubit is closed before response returns',
      () async {
        mockRepository.updateCartItemResult = const Right(tCartItem);

        final future = cubit.updateCartItem(
          cartId: '1',
          productId: '1',
          quantity: 2,
        );
        await cubit.close();
        await future;

        expect(cubit.isClosed, isTrue);
      },
    );
  });

  group('deleteCartItem', () {
    test('emits [loading, success] on success', () async {
      mockRepository.deleteCartItemResult = const Right(tCartItem);

      final expectedStates = [
        const CartState(
          deleteCartItemStatus: CartStatus.loading,
          pendingProductIds: {1},
        ),
        const CartState(
          deleteCartItemStatus: CartStatus.success,
          deletedCartItem: tCartItem,
          pendingProductIds: {},
        ),
      ];

      final expectation = expectLater(
        cubit.stream,
        emitsInOrder(expectedStates),
      );

      await cubit.deleteCartItem(cartId: '1', productId: '1');
      await expectation;

      expect(mockRepository.calledDeleteCartItemCartId, equals('1'));
      expect(mockRepository.calledDeleteCartItemProductId, equals('1'));
      expect(cubit.state.deleteCartItemStatus, CartStatus.success);
      expect(cubit.state.deletedCartItem, tCartItem);
      expect(cubit.state.deleteCartItemErrorMessage, isNull);
    });

    test('emits [loading, failure] on failure', () async {
      const tFailure = ServerFailure(message: 'Delete failed', code: 400);
      mockRepository.deleteCartItemResult = const Left(tFailure);

      final expectedStates = [
        const CartState(
          deleteCartItemStatus: CartStatus.loading,
          pendingProductIds: {1},
        ),
        const CartState(
          deleteCartItemStatus: CartStatus.failure,
          deleteCartItemErrorMessage: 'Delete failed',
          pendingProductIds: {},
        ),
      ];

      final expectation = expectLater(
        cubit.stream,
        emitsInOrder(expectedStates),
      );

      await cubit.deleteCartItem(cartId: '1', productId: '1');
      await expectation;

      expect(cubit.state.deleteCartItemStatus, CartStatus.failure);
      expect(cubit.state.deleteCartItemErrorMessage, 'Delete failed');
      expect(cubit.state.deletedCartItem, isNull);
    });

    test(
      'clears previous deleteCartItemErrorMessage when starting a new operation',
      () async {
        const tFailure = ServerFailure(message: 'Initial error', code: 500);
        mockRepository.deleteCartItemResult = const Left(tFailure);

        await cubit.deleteCartItem(cartId: '1', productId: '1');
        expect(cubit.state.deleteCartItemErrorMessage, 'Initial error');

        mockRepository.deleteCartItemResult = const Right(tCartItem);

        final expectedStates = [
          const CartState(
            deleteCartItemStatus: CartStatus.loading,
            deleteCartItemErrorMessage: null,
            pendingProductIds: {1},
          ),
          const CartState(
            deleteCartItemStatus: CartStatus.success,
            deletedCartItem: tCartItem,
            deleteCartItemErrorMessage: null,
            pendingProductIds: {},
          ),
        ];

        final expectation = expectLater(
          cubit.stream,
          emitsInOrder(expectedStates),
        );

        await cubit.deleteCartItem(cartId: '1', productId: '1');
        await expectation;

        expect(cubit.state.deleteCartItemStatus, CartStatus.success);
        expect(cubit.state.deleteCartItemErrorMessage, isNull);
      },
    );

    test(
      'does not emit state if cubit is closed before response returns',
      () async {
        mockRepository.deleteCartItemResult = const Right(tCartItem);

        final future = cubit.deleteCartItem(cartId: '1', productId: '1');
        await cubit.close();
        await future;

        expect(cubit.isClosed, isTrue);
      },
    );
  });

  group('CartState', () {
    test(
      'copyWith preserves addingProductId when clearAddingProductId is false',
      () {
        const state = CartState(addingProductId: 123);
        final updated = state.copyWith(status: CartStatus.loading);
        expect(updated.addingProductId, equals(123));
      },
    );

    test(
      'copyWith clears addingProductId when clearAddingProductId is true',
      () {
        const state = CartState(addingProductId: 123);
        final updated = state.copyWith(clearAddingProductId: true);
        expect(updated.addingProductId, isNull);
      },
    );

    test(
      'copyWith clears getCartErrorMessage when clearGetCartErrorMessage is true',
      () {
        const state = CartState(getCartErrorMessage: 'Something went wrong');
        final updated = state.copyWith(clearGetCartErrorMessage: true);
        expect(updated.getCartErrorMessage, isNull);
      },
    );

    test(
      'copyWith clears getCartItemErrorMessage when clearGetCartItemErrorMessage is true',
      () {
        const state = CartState(getCartItemErrorMessage: 'Item error');
        final updated = state.copyWith(clearGetCartItemErrorMessage: true);
        expect(updated.getCartItemErrorMessage, isNull);
      },
    );

    test(
      'copyWith clears cartItemProduct when clearCartItemProduct is true',
      () {
        const state = CartState(cartItemProduct: tProduct);
        final updated = state.copyWith(clearCartItemProduct: true);
        expect(updated.cartItemProduct, isNull);
      },
    );

    test(
      'copyWith clears updateCartItemErrorMessage when clearUpdateCartItemErrorMessage is true',
      () {
        const state = CartState(updateCartItemErrorMessage: 'Update error');
        final updated = state.copyWith(clearUpdateCartItemErrorMessage: true);
        expect(updated.updateCartItemErrorMessage, isNull);
      },
    );

    test(
      'copyWith clears updatedCartItem when clearUpdatedCartItem is true',
      () {
        const state = CartState(updatedCartItem: tCartItem);
        final updated = state.copyWith(clearUpdatedCartItem: true);
        expect(updated.updatedCartItem, isNull);
      },
    );

    test(
      'copyWith clears deleteCartItemErrorMessage when clearDeleteCartItemErrorMessage is true',
      () {
        const state = CartState(deleteCartItemErrorMessage: 'Delete error');
        final updated = state.copyWith(clearDeleteCartItemErrorMessage: true);
        expect(updated.deleteCartItemErrorMessage, isNull);
      },
    );

    test(
      'copyWith clears deletedCartItem when clearDeletedCartItem is true',
      () {
        const state = CartState(deletedCartItem: tCartItem);
        final updated = state.copyWith(clearDeletedCartItem: true);
        expect(updated.deletedCartItem, isNull);
      },
    );
  });
}
