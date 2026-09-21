import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:go_router/go_router.dart';
import 'package:Dukan/core/errors/failure.dart';
import 'package:Dukan/core/theme/app_theme.dart';
import 'package:Dukan/core/usecases/usecase.dart';
import 'package:Dukan/core/utils/constants.dart';
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
import 'package:Dukan/features/home/presentation/widgets/home_bottom_nav_bar.dart';
import 'package:Dukan/features/orders/domain/entities/order_entity.dart';
import 'package:Dukan/features/orders/domain/entities/order_item_entity.dart';
import 'package:Dukan/features/orders/domain/entities/payment_method.dart';
import 'package:Dukan/features/orders/domain/repositories/orders_repository.dart';
import 'package:Dukan/features/orders/domain/usecases/cancel_order_use_case.dart';
import 'package:Dukan/features/orders/domain/usecases/get_orders_use_case.dart';
import 'package:Dukan/features/orders/presentation/cubit/orders_cubit.dart';
import 'package:Dukan/features/orders/presentation/cubit/orders_state.dart';
import 'package:Dukan/features/orders/presentation/views/orders_screen.dart';
import 'package:Dukan/features/orders/presentation/widgets/order_card.dart';
import 'package:Dukan/features/orders/presentation/widgets/orders_activity_header.dart';
import 'package:Dukan/features/orders/presentation/widgets/orders_empty_view.dart';
import 'package:Dukan/features/orders/presentation/widgets/orders_filter_tab_bar.dart';
import 'package:Dukan/features/orders/presentation/widgets/orders_search_bar.dart';

class MockGetOrdersUseCase implements GetOrdersUseCase {
  Either<Failure, List<OrderEntity>>? resultToReturn;
  bool called = false;

  @override
  OrdersRepository get repository => throw UnimplementedError();

  @override
  Future<Either<Failure, List<OrderEntity>>> call(NoParams params) async {
    called = true;
    return resultToReturn ?? const Right([]);
  }
}

class MockCancelOrderUseCase implements CancelOrderUseCase {
  Either<Failure, OrderEntity>? resultToReturn;
  bool called = false;

  @override
  OrdersRepository get repository => throw UnimplementedError();

  @override
  Future<Either<Failure, OrderEntity>> call(int id) async {
    called = true;
    if (resultToReturn != null) return resultToReturn!;
    throw UnimplementedError();
  }
}

class MockCartRepository implements CartRepository {
  @override
  Future<Either<Failure, int>> clearCart() async => const Right(1);

  @override
  Future<Either<Failure, CartEntity>> getCart() async =>
      const Right(CartEntity(id: 1, items: [], totalPrice: 0.0));

  @override
  Future<Either<Failure, CartItemEntity>> addToCart({
    required int productId,
    required int quantity,
  }) => throw UnimplementedError();

  @override
  Future<Either<Failure, CartItemEntity>> deleteCartItem({
    required String cartId,
    required String productId,
  }) => throw UnimplementedError();

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
}

void main() {
  late MockGetOrdersUseCase mockGetOrdersUseCase;
  late MockCancelOrderUseCase mockCancelOrderUseCase;
  late MockCartRepository mockCartRepository;
  late OrdersCubit ordersCubit;
  late CartCubit cartCubit;

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
    items: const [
      OrderItemEntity(quantity: 1, product: tProduct1),
      OrderItemEntity(quantity: 2, product: tProduct2),
    ],
  );

  setUp(() {
    mockGetOrdersUseCase = MockGetOrdersUseCase();
    mockCancelOrderUseCase = MockCancelOrderUseCase();
    mockCartRepository = MockCartRepository();

    ordersCubit = OrdersCubit(
      getOrdersUseCase: mockGetOrdersUseCase,
      cancelOrderUseCase: mockCancelOrderUseCase,
    );

    cartCubit = CartCubit(
      getCartUseCase: GetCartUseCase(mockCartRepository),
      addToCartUseCase: AddToCartUseCase(mockCartRepository),
      updateCartItemUseCase: UpdateCartItemUseCase(mockCartRepository),
      deleteCartItemUseCase: DeleteCartItemUseCase(mockCartRepository),
      clearCartUseCase: ClearCartUseCase(mockCartRepository),
      getCartItemUseCase: GetCartItemUseCase(mockCartRepository),
    );
  });

  tearDown(() {
    ordersCubit.close();
    cartCubit.close();
  });

  void setupPortrait(WidgetTester tester) {
    tester.view.physicalSize = const Size(1125, 2436);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
  }

  void setupLandscape(WidgetTester tester) {
    tester.view.physicalSize = const Size(1624, 750);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
  }

  Widget buildTestWidget({bool isLandscape = false, GoRouter? customRouter}) {
    final effectiveRouter =
        customRouter ??
        GoRouter(
          initialLocation: '/',
          routes: [
            GoRoute(
              path: '/',
              builder: (context, state) => const OrdersScreen(),
            ),
            GoRoute(
              path: '/order-details/:id',
              builder: (context, state) =>
                  const Scaffold(body: Center(child: Text('Order Details'))),
            ),
          ],
        );

    return ScreenUtilInit(
      designSize: isLandscape
          ? AppConstants.designSizeLandscape
          : AppConstants.designSizePortrait,
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) => MultiBlocProvider(
        providers: [
          BlocProvider<OrdersCubit>.value(value: ordersCubit),
          BlocProvider<CartCubit>.value(value: cartCubit),
        ],
        child: MaterialApp.router(
          theme: AppTheme.lightTheme,
          routerConfig: effectiveRouter,
        ),
      ),
    );
  }

  group('OrdersScreen Portrait Layout', () {
    testWidgets('renders empty view when there are no orders', (tester) async {
      setupPortrait(tester);

      ordersCubit.emit(
        const OrdersState(status: OrdersStatus.success, orders: []),
      );

      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(OrdersEmptyView), findsOneWidget);
      expect(find.text('No Orders Yet'), findsOneWidget);
      expect(find.byType(OrdersActivityHeader), findsOneWidget);
      expect(find.byType(OrdersSearchBar), findsOneWidget);
      expect(find.byType(OrdersFilterTabBar), findsOneWidget);
      final navBarFinder = find.byType(HomeBottomNavBar);
      expect(navBarFinder, findsOneWidget);
      final navBar = tester.widget<HomeBottomNavBar>(navBarFinder);
      expect(navBar.selectedIndex, 2);
      expect(find.text('Browse'), findsNothing);
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Cart'), findsOneWidget);
      expect(find.text('Orders'), findsOneWidget);
    });

    testWidgets('renders list of OrderCards and active shipment badge', (
      tester,
    ) async {
      setupPortrait(tester);

      ordersCubit.emit(
        OrdersState(
          status: OrdersStatus.success,
          orders: [tOrderPending, tOrderDelivered],
        ),
      );

      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(OrderCard), findsNWidgets(2));
      expect(find.text('#DK-8740'), findsOneWidget);
      expect(find.text('#DK-8921'), findsOneWidget);
      expect(find.text('1 active shipment'), findsOneWidget);
    });

    testWidgets('filtering by Delivered shows only delivered orders', (
      tester,
    ) async {
      setupPortrait(tester);

      ordersCubit.emit(
        OrdersState(
          status: OrdersStatus.success,
          orders: [tOrderPending, tOrderDelivered],
        ),
      );

      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(OrderCard), findsNWidgets(2));

      // Ensure Delivered tab is visible in the scrollable tab bar, then tap
      final deliveredTab = find.descendant(
        of: find.byType(OrdersFilterTabBar),
        matching: find.text('Delivered'),
      );
      await tester.ensureVisible(deliveredTab);
      await tester.pumpAndSettle();
      await tester.tap(deliveredTab);
      await tester.pumpAndSettle();

      expect(find.byType(OrderCard), findsOneWidget);
      expect(find.text('#DK-8921'), findsOneWidget);
      expect(find.text('#DK-8740'), findsNothing);
    });

    testWidgets('searching by text filters orders list', (tester) async {
      setupPortrait(tester);

      ordersCubit.emit(
        OrdersState(
          status: OrdersStatus.success,
          orders: [tOrderPending, tOrderDelivered],
        ),
      );

      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      // Enter search text
      await tester.enterText(find.byType(TextField), 'Stoneware');
      await tester.pumpAndSettle();

      expect(find.byType(OrderCard), findsOneWidget);
      expect(find.text('#DK-8921'), findsOneWidget);
      expect(find.text('#DK-8740'), findsNothing);
    });

    testWidgets('shows failure snackbar when status is failure', (
      tester,
    ) async {
      setupPortrait(tester);

      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      ordersCubit.emit(
        const OrdersState(
          status: OrdersStatus.failure,
          errorMessage: 'Server timeout',
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(SnackBar), findsOneWidget);
      expect(
        find.descendant(
          of: find.byType(SnackBar),
          matching: find.text('Server timeout'),
        ),
        findsOneWidget,
      );
    });

    testWidgets('tapping View Details triggers navigation without errors', (
      tester,
    ) async {
      setupPortrait(tester);

      ordersCubit.emit(
        OrdersState(status: OrdersStatus.success, orders: [tOrderPending]),
      );

      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      final viewDetailsFinder = find.text('View Details');
      expect(viewDetailsFinder, findsOneWidget);
      await tester.tap(viewDetailsFinder);
      await tester.pumpAndSettle();

      expect(find.text('Order Details'), findsOneWidget);
    });
  });

  group('OrdersScreen Landscape Layout', () {
    testWidgets(
      'renders dual-pane layout with zero RenderFlex overflow on Size(1624, 750)',
      (tester) async {
        setupLandscape(tester);

        ordersCubit.emit(
          OrdersState(
            status: OrdersStatus.success,
            orders: [tOrderPending, tOrderDelivered],
          ),
        );

        await tester.pumpWidget(buildTestWidget(isLandscape: true));
        await tester.pumpAndSettle();

        // Zero overflow assertion
        expect(tester.takeException(), isNull);

        // Verify Dual Pane Layout presence
        // Left column components
        expect(find.byType(OrdersActivityHeader), findsOneWidget);
        expect(find.byType(OrdersSearchBar), findsOneWidget);
        expect(find.byType(OrdersFilterTabBar), findsOneWidget);

        // Divider
        expect(find.byType(VerticalDivider), findsOneWidget);

        // Right column order cards
        expect(find.byType(OrderCard), findsWidgets);
        expect(find.text('#DK-8740'), findsOneWidget);
      },
    );
  });
}
