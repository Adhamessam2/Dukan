import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:Dukan/core/errors/failure.dart';
import 'package:Dukan/features/cart/domain/entities/cart_entity.dart';
import 'package:Dukan/features/cart/domain/entities/cart_item_entity.dart';
import 'package:Dukan/features/cart/domain/repositories/cart_repository.dart';
import 'package:Dukan/features/cart/domain/usecases/add_to_cart_use_case.dart';
import 'package:Dukan/features/cart/domain/usecases/clear_cart_use_case.dart';
import 'package:Dukan/features/cart/domain/usecases/delete_cart_item_use_case.dart';
import 'package:Dukan/features/cart/domain/usecases/get_cart_item_use_case.dart';
import 'package:Dukan/features/cart/domain/usecases/get_cart_use_case.dart';
import 'package:Dukan/features/cart/domain/usecases/update_cart_item_use_case.dart';
import 'package:Dukan/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:Dukan/features/home/domain/entities/product_entity.dart';
import 'package:Dukan/features/orders/domain/entities/order_entity.dart';
import 'package:Dukan/features/orders/domain/entities/order_item_entity.dart';
import 'package:Dukan/features/orders/domain/entities/order_payment_status_entity.dart';
import 'package:Dukan/features/orders/domain/entities/payment_method.dart';
import 'package:Dukan/features/orders/domain/repositories/orders_repository.dart';
import 'package:Dukan/features/orders/domain/usecases/get_order_by_id_use_case.dart';
import 'package:Dukan/features/orders/domain/usecases/get_order_payment_status_use_case.dart';
import 'package:Dukan/features/orders/presentation/cubit/order_details_cubit.dart';
import 'package:Dukan/features/orders/presentation/cubit/order_details_state.dart';

class MockGetOrderByIdUseCase implements GetOrderByIdUseCase {
  Either<Failure, OrderEntity>? resultToReturn;
  int? capturedId;

  @override
  OrdersRepository get repository => throw UnimplementedError();

  @override
  Future<Either<Failure, OrderEntity>> call(int id) async {
    capturedId = id;
    return resultToReturn!;
  }
}

class MockGetOrderPaymentStatusUseCase implements GetOrderPaymentStatusUseCase {
  Either<Failure, OrderPaymentStatusEntity>? resultToReturn;
  int? capturedId;

  @override
  OrdersRepository get repository => throw UnimplementedError();

  @override
  Future<Either<Failure, OrderPaymentStatusEntity>> call(int id) async {
    capturedId = id;
    return resultToReturn!;
  }
}

class MockCartRepository implements CartRepository {
  final List<Map<String, int>> addedItems = [];

  @override
  Future<Either<Failure, CartItemEntity>> addToCart({
    required int productId,
    required int quantity,
  }) async {
    addedItems.add({'productId': productId, 'quantity': quantity});
    return Right(
      CartItemEntity(
        cartId: 1,
        productId: productId,
        quantity: quantity,
        isDeleted: false,
      ),
    );
  }

  @override
  Future<Either<Failure, CartEntity>> getCart() => throw UnimplementedError();

  @override
  Future<Either<Failure, ProductEntity>> getCartItem({
    required String cartId,
    required String productId,
  }) => throw UnimplementedError();

  @override
  Future<Either<Failure, CartItemEntity>> updateCartItem({
    required String cartId,
    required String productId,
    required int quantity,
  }) => throw UnimplementedError();

  @override
  Future<Either<Failure, CartItemEntity>> deleteCartItem({
    required String cartId,
    required String productId,
  }) => throw UnimplementedError();

  @override
  Future<Either<Failure, int>> clearCart() => throw UnimplementedError();
}

void main() {
  late OrderDetailsCubit cubit;
  late MockGetOrderByIdUseCase mockGetOrderByIdUseCase;
  late MockGetOrderPaymentStatusUseCase mockGetOrderPaymentStatusUseCase;
  late MockCartRepository mockCartRepository;
  late CartCubit cartCubit;

  const tProduct1 = ProductEntity(
    id: 101,
    productName: 'Kinfolk Amber Diffuser',
    price: 46.0,
  );
  const tProduct2 = ProductEntity(
    id: 102,
    productName: 'Handcrafted Stoneware',
    price: 56.0,
  );

  final tOrder = OrderEntity(
    id: 8740,
    shippingCity: 'Riyadh',
    shippingStreet: 'King Fahd Rd',
    shippingBuilding: 'Tower A',
    orderStatus: 'PENDING',
    totalAmount: 148.0,
    paymentMethod: PaymentMethod.creditCard,
    createdAt: DateTime(2026, 3, 15, 14, 30),
    items: const [
      OrderItemEntity(quantity: 2, product: tProduct1),
      OrderItemEntity(quantity: 1, product: tProduct2),
    ],
  );

  const tPaymentStatus = OrderPaymentStatusEntity(
    id: 8740,
    orderStatus: 'PENDING',
    totalAmount: 148.0,
    payments: [],
  );

  setUp(() {
    mockGetOrderByIdUseCase = MockGetOrderByIdUseCase();
    mockGetOrderPaymentStatusUseCase = MockGetOrderPaymentStatusUseCase();
    mockCartRepository = MockCartRepository();
    cartCubit = CartCubit(
      addToCartUseCase: AddToCartUseCase(mockCartRepository),
      getCartUseCase: GetCartUseCase(mockCartRepository),
      getCartItemUseCase: GetCartItemUseCase(mockCartRepository),
      updateCartItemUseCase: UpdateCartItemUseCase(mockCartRepository),
      deleteCartItemUseCase: DeleteCartItemUseCase(mockCartRepository),
      clearCartUseCase: ClearCartUseCase(mockCartRepository),
    );
    cubit = OrderDetailsCubit(
      getOrderByIdUseCase: mockGetOrderByIdUseCase,
      getOrderPaymentStatusUseCase: mockGetOrderPaymentStatusUseCase,
    );
  });

  tearDown(() {
    cubit.close();
    cartCubit.close();
  });

  group('OrderDetailsCubit', () {
    test('initial state has correct default values', () {
      expect(cubit.state.status, OrderDetailsStatus.initial);
      expect(cubit.state.order, isNull);
      expect(cubit.state.paymentStatus, isNull);
      expect(cubit.state.errorMessage, isNull);
      expect(cubit.state.isReordering, isFalse);
    });

    test(
      'loadOrderDetails emits [loading, success] when both order and payment status succeed',
      () async {
        mockGetOrderByIdUseCase.resultToReturn = Right(tOrder);
        mockGetOrderPaymentStatusUseCase.resultToReturn = const Right(
          tPaymentStatus,
        );

        final expectedStates = [
          const OrderDetailsState(status: OrderDetailsStatus.loading),
          OrderDetailsState(
            status: OrderDetailsStatus.success,
            order: tOrder,
            paymentStatus: tPaymentStatus,
          ),
        ];

        expectLater(cubit.stream, emitsInOrder(expectedStates));

        await cubit.loadOrderDetails(8740);

        expect(mockGetOrderByIdUseCase.capturedId, 8740);
        expect(mockGetOrderPaymentStatusUseCase.capturedId, 8740);
      },
    );

    test(
      'loadOrderDetails emits [loading, success] with paymentStatus: null when order succeeds but payment status fails (graceful degradation)',
      () async {
        mockGetOrderByIdUseCase.resultToReturn = Right(tOrder);
        mockGetOrderPaymentStatusUseCase.resultToReturn = const Left(
          ServerFailure(message: 'Payment status error'),
        );

        final expectedStates = [
          const OrderDetailsState(status: OrderDetailsStatus.loading),
          OrderDetailsState(
            status: OrderDetailsStatus.success,
            order: tOrder,
            paymentStatus: null,
          ),
        ];

        expectLater(cubit.stream, emitsInOrder(expectedStates));

        await cubit.loadOrderDetails(8740);

        expect(cubit.state.status, OrderDetailsStatus.success);
        expect(cubit.state.order, tOrder);
        expect(cubit.state.paymentStatus, isNull);
      },
    );

    test(
      'loadOrderDetails emits [loading, failure] when getOrderById fails',
      () async {
        mockGetOrderByIdUseCase.resultToReturn = const Left(
          ServerFailure(message: 'Order not found'),
        );
        mockGetOrderPaymentStatusUseCase.resultToReturn = const Right(
          tPaymentStatus,
        );

        final expectedStates = [
          const OrderDetailsState(status: OrderDetailsStatus.loading),
          const OrderDetailsState(
            status: OrderDetailsStatus.failure,
            errorMessage: 'Order not found',
          ),
        ];

        expectLater(cubit.stream, emitsInOrder(expectedStates));

        await cubit.loadOrderDetails(8740);

        expect(cubit.state.status, OrderDetailsStatus.failure);
        expect(cubit.state.errorMessage, 'Order not found');
      },
    );

    test(
      'reorderAllItems calls cartCubit.addToCart for each item and toggles isReordering',
      () async {
        mockGetOrderByIdUseCase.resultToReturn = Right(tOrder);
        mockGetOrderPaymentStatusUseCase.resultToReturn = const Right(
          tPaymentStatus,
        );

        await cubit.loadOrderDetails(8740);

        final expectedStates = [
          cubit.state.copyWith(isReordering: true),
          cubit.state.copyWith(isReordering: false),
        ];

        expectLater(cubit.stream, emitsInOrder(expectedStates));

        await cubit.reorderAllItems(cartCubit);

        expect(mockCartRepository.addedItems.length, 2);
        expect(mockCartRepository.addedItems[0], {
          'productId': 101,
          'quantity': 2,
        });
        expect(mockCartRepository.addedItems[1], {
          'productId': 102,
          'quantity': 1,
        });
      },
    );

    test('reorderAllItems does nothing when state.order is null', () async {
      expect(cubit.state.order, isNull);

      await cubit.reorderAllItems(cartCubit);

      expect(mockCartRepository.addedItems, isEmpty);
      expect(cubit.state.isReordering, isFalse);
    });

    test(
      'reorderAllItems does nothing when state.order items are empty',
      () async {
        final emptyOrder = tOrder.copyWith(items: []);
        mockGetOrderByIdUseCase.resultToReturn = Right(emptyOrder);
        mockGetOrderPaymentStatusUseCase.resultToReturn = const Right(
          tPaymentStatus,
        );

        await cubit.loadOrderDetails(8740);

        await cubit.reorderAllItems(cartCubit);

        expect(mockCartRepository.addedItems, isEmpty);
        expect(cubit.state.isReordering, isFalse);
      },
    );
  });
}
