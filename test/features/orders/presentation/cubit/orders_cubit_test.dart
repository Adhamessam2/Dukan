import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:Dukan/core/errors/failure.dart';
import 'package:Dukan/core/usecases/usecase.dart';
import 'package:Dukan/features/home/domain/entities/product_entity.dart';
import 'package:Dukan/features/orders/domain/entities/order_entity.dart';
import 'package:Dukan/features/orders/domain/entities/order_item_entity.dart';
import 'package:Dukan/features/orders/domain/entities/payment_method.dart';
import 'package:Dukan/features/orders/domain/repositories/orders_repository.dart';
import 'package:Dukan/features/orders/domain/usecases/cancel_order_use_case.dart';
import 'package:Dukan/features/orders/domain/usecases/get_orders_use_case.dart';
import 'package:Dukan/features/orders/presentation/cubit/orders_cubit.dart';
import 'package:Dukan/features/orders/presentation/cubit/orders_state.dart';

class MockGetOrdersUseCase implements GetOrdersUseCase {
  Either<Failure, List<OrderEntity>>? resultToReturn;
  bool called = false;

  @override
  OrdersRepository get repository => throw UnimplementedError();

  @override
  Future<Either<Failure, List<OrderEntity>>> call(NoParams params) async {
    called = true;
    return resultToReturn!;
  }
}

class MockCancelOrderUseCase implements CancelOrderUseCase {
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

void main() {
  late OrdersCubit cubit;
  late MockGetOrdersUseCase mockGetOrdersUseCase;
  late MockCancelOrderUseCase mockCancelOrderUseCase;

  const tProduct1 = ProductEntity(
    id: 1,
    productName: 'Kinfolk Amber Diffuser',
    price: 46.0,
  );
  const tProduct2 = ProductEntity(
    id: 2,
    productName: 'Handcrafted Stoneware',
    price: 56.0,
  );

  final tOrderPending = OrderEntity(
    id: 8740,
    userId: 1,
    shippingCity: 'Cairo',
    shippingStreet: 'Zamalek',
    shippingBuilding: '12',
    orderStatus: 'PENDING',
    totalAmount: 46.0,
    paymentMethod: PaymentMethod.cash,
    createdAt: DateTime(2024, 11, 12),
    items: const [OrderItemEntity(quantity: 1, product: tProduct1)],
  );

  final tOrderDelivered = OrderEntity(
    id: 8921,
    userId: 1,
    shippingCity: 'Giza',
    shippingStreet: 'Pyramids',
    shippingBuilding: '5',
    orderStatus: 'DELIVERED',
    totalAmount: 112.0,
    paymentMethod: PaymentMethod.creditCard,
    createdAt: DateTime(2024, 10, 24),
    items: const [OrderItemEntity(quantity: 2, product: tProduct2)],
  );

  final tOrderCancelled = OrderEntity(
    id: 8419,
    userId: 1,
    shippingCity: 'Alexandria',
    shippingStreet: 'Corniche',
    shippingBuilding: '3',
    orderStatus: 'CANCELLED',
    totalAmount: 215.0,
    paymentMethod: PaymentMethod.cash,
    createdAt: DateTime(2024, 9, 18),
    items: const [OrderItemEntity(quantity: 1, product: tProduct1)],
  );

  final tOrdersList = [tOrderPending, tOrderDelivered, tOrderCancelled];

  setUp(() {
    mockGetOrdersUseCase = MockGetOrdersUseCase();
    mockCancelOrderUseCase = MockCancelOrderUseCase();
    cubit = OrdersCubit(
      getOrdersUseCase: mockGetOrdersUseCase,
      cancelOrderUseCase: mockCancelOrderUseCase,
    );
  });

  tearDown(() {
    cubit.close();
  });

  group('OrdersState', () {
    test('initial state has correct default values', () {
      const state = OrdersState();
      expect(state.status, OrdersStatus.initial);
      expect(state.orders, isEmpty);
      expect(state.selectedFilter, OrdersFilterTab.all);
      expect(state.searchQuery, isEmpty);
      expect(state.errorMessage, isNull);
      expect(state.filteredOrders, isEmpty);
      expect(state.activeShipmentsCount, equals(0));
    });

    test('activeShipmentsCount returns number of in-progress orders', () {
      final state = OrdersState(orders: tOrdersList);
      expect(state.activeShipmentsCount, equals(1));
    });

    test('filteredOrders filters by tab correctly', () {
      final state = OrdersState(orders: tOrdersList);

      // All
      expect(state.filteredOrders.length, equals(3));

      // Pending
      final pendingState = state.copyWith(
        selectedFilter: OrdersFilterTab.pending,
      );
      expect(pendingState.filteredOrders.length, equals(1));
      expect(pendingState.filteredOrders.first.id, equals(8740));

      // Delivered
      final deliveredState = state.copyWith(
        selectedFilter: OrdersFilterTab.delivered,
      );
      expect(deliveredState.filteredOrders.length, equals(1));
      expect(deliveredState.filteredOrders.first.id, equals(8921));

      // Cancelled
      final cancelledState = state.copyWith(
        selectedFilter: OrdersFilterTab.cancelled,
      );
      expect(cancelledState.filteredOrders.length, equals(1));
      expect(cancelledState.filteredOrders.first.id, equals(8419));
    });

    test(
      'filteredOrders filters by search query matching order id and product name',
      () {
        final state = OrdersState(orders: tOrdersList);

        // Search by ID
        final searchById = state.copyWith(searchQuery: '8740');
        expect(searchById.filteredOrders.length, equals(1));
        expect(searchById.filteredOrders.first.id, equals(8740));

        // Search by #DK-ID
        final searchByDkId = state.copyWith(searchQuery: '#dk-8921');
        expect(searchByDkId.filteredOrders.length, equals(1));
        expect(searchByDkId.filteredOrders.first.id, equals(8921));

        // Search by product name
        final searchByProduct = state.copyWith(searchQuery: 'diffuser');
        expect(
          searchByProduct.filteredOrders.length,
          equals(2),
        ); // pending and cancelled contain diffuser
      },
    );
  });

  group('OrdersCubit.loadOrders', () {
    test('emits [loading, success] when getOrders succeeds', () async {
      mockGetOrdersUseCase.resultToReturn = Right(tOrdersList);

      final expectedStates = [
        const OrdersState(status: OrdersStatus.loading),
        OrdersState(status: OrdersStatus.success, orders: tOrdersList),
      ];

      expectLater(cubit.stream, emitsInOrder(expectedStates));

      await cubit.loadOrders();
      expect(mockGetOrdersUseCase.called, isTrue);
    });

    test('emits [loading, failure] when getOrders fails', () async {
      mockGetOrdersUseCase.resultToReturn = const Left(
        ServerFailure(message: 'Network error'),
      );

      final expectedStates = [
        const OrdersState(status: OrdersStatus.loading),
        const OrdersState(
          status: OrdersStatus.failure,
          errorMessage: 'Network error',
        ),
      ];

      expectLater(cubit.stream, emitsInOrder(expectedStates));

      await cubit.loadOrders();
      expect(mockGetOrdersUseCase.called, isTrue);
    });
  });

  group('OrdersCubit filter and search', () {
    test('setFilter updates selectedFilter in state', () {
      cubit.setFilter(OrdersFilterTab.pending);
      expect(cubit.state.selectedFilter, equals(OrdersFilterTab.pending));
    });

    test('setSearchQuery updates searchQuery in state', () {
      cubit.setSearchQuery('amber');
      expect(cubit.state.searchQuery, equals('amber'));
    });
  });

  group('OrdersCubit.cancelOrder', () {
    test('updates cancelled order in state on success', () async {
      mockGetOrdersUseCase.resultToReturn = Right(tOrdersList);
      await cubit.loadOrders();

      final cancelledOrder = tOrderPending.copyWith(orderStatus: 'CANCELLED');
      mockCancelOrderUseCase.resultToReturn = Right(cancelledOrder);

      await cubit.cancelOrder(8740);

      expect(mockCancelOrderUseCase.capturedId, equals(8740));
      final updatedOrder = cubit.state.orders.firstWhere((o) => o.id == 8740);
      expect(updatedOrder.orderStatus, equals('CANCELLED'));
    });
  });
}
