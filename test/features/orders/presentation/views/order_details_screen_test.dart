import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:go_router/go_router.dart';
import 'package:Dukan/core/errors/failure.dart';
import 'package:Dukan/core/routes/routes.dart';
import 'package:Dukan/core/theme/app_theme.dart';
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
import 'package:Dukan/features/orders/domain/entities/order_entity.dart';
import 'package:Dukan/features/orders/domain/entities/order_item_entity.dart';
import 'package:Dukan/features/orders/domain/entities/order_payment_status_entity.dart';
import 'package:Dukan/features/orders/domain/entities/payment_info_entity.dart';
import 'package:Dukan/features/orders/domain/entities/payment_method.dart';
import 'package:Dukan/features/orders/domain/entities/payment_transaction_entity.dart';
import 'package:Dukan/features/orders/domain/repositories/orders_repository.dart';
import 'package:Dukan/features/orders/domain/usecases/cancel_order_use_case.dart';
import 'package:Dukan/features/orders/domain/usecases/get_order_by_id_use_case.dart';
import 'package:Dukan/features/orders/domain/usecases/get_order_payment_status_use_case.dart';
import 'package:Dukan/features/orders/presentation/cubit/order_details_cubit.dart';
import 'package:Dukan/features/orders/presentation/views/order_details_screen.dart';
import 'package:Dukan/features/orders/presentation/widgets/order_delivery_address_card.dart';
import 'package:Dukan/features/orders/presentation/widgets/order_details_bottom_bar.dart';
import 'package:Dukan/features/orders/presentation/widgets/order_details_header.dart';
import 'package:Dukan/features/orders/presentation/widgets/order_details_summary_card.dart';
import 'package:Dukan/features/orders/presentation/widgets/order_fulfillment_card.dart';
import 'package:Dukan/features/orders/presentation/widgets/order_items_card.dart';
import 'package:Dukan/features/orders/presentation/widgets/order_payment_details_card.dart';

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
  late MockGetOrderByIdUseCase mockGetOrderByIdUseCase;
  late MockGetOrderPaymentStatusUseCase mockGetOrderPaymentStatusUseCase;
  late MockCancelOrderUseCase mockCancelOrderUseCase;
  late MockCartRepository mockCartRepository;
  late OrderDetailsCubit orderDetailsCubit;
  late CartCubit cartCubit;

  const tProduct1 = ProductEntity(
    id: 101,
    productName: 'Premium Wireless Headphones',
    price: 199.99,
  );

  const tProduct2 = ProductEntity(
    id: 102,
    productName: 'Ergonomic Mouse',
    price: 49.99,
  );

  final tOrder = OrderEntity(
    id: 8740,
    userId: 1,
    shippingCity: 'Cairo',
    shippingStreet: '26th of July Corridor',
    shippingBuilding: 'Building 14, Apt 4B',
    orderStatus: 'DELIVERED',
    totalAmount: 249.98,
    paymentMethod: PaymentMethod.creditCard,
    createdAt: DateTime(2024, 10, 24, 14, 30),
    updatedAt: DateTime(2024, 10, 26, 11, 0),
    items: const [
      OrderItemEntity(
        product: tProduct1,
        quantity: 1,
      ),
      OrderItemEntity(
        product: tProduct2,
        quantity: 1,
      ),
    ],
  );

  final tPaymentStatus = OrderPaymentStatusEntity(
    id: 8740,
    orderStatus: 'DELIVERED',
    totalAmount: 249.98,
    payments: [
      PaymentTransactionEntity(
        id: '991',
        status: 'PAID',
        provider: 'Stripe',
        updatedAt: DateTime(2024, 10, 24, 14, 31),
      ),
    ],
  );

  setUp(() {
    mockGetOrderByIdUseCase = MockGetOrderByIdUseCase();
    mockGetOrderPaymentStatusUseCase = MockGetOrderPaymentStatusUseCase();
    mockCancelOrderUseCase = MockCancelOrderUseCase();
    mockCartRepository = MockCartRepository();

    orderDetailsCubit = OrderDetailsCubit(
      getOrderByIdUseCase: mockGetOrderByIdUseCase,
      getOrderPaymentStatusUseCase: mockGetOrderPaymentStatusUseCase,
      cancelOrderUseCase: mockCancelOrderUseCase,
    );

    cartCubit = CartCubit(
      addToCartUseCase: AddToCartUseCase(mockCartRepository),
      getCartUseCase: GetCartUseCase(mockCartRepository),
      getCartItemUseCase: GetCartItemUseCase(mockCartRepository),
      updateCartItemUseCase: UpdateCartItemUseCase(mockCartRepository),
      deleteCartItemUseCase: DeleteCartItemUseCase(mockCartRepository),
      clearCartUseCase: ClearCartUseCase(mockCartRepository),
    );
  });

  tearDown(() {
    orderDetailsCubit.close();
    cartCubit.close();
  });

  void setupLandscape(WidgetTester tester) {
    tester.view.physicalSize = const Size(1624, 750);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
  }

  Widget buildTestWidget({
    int orderId = 8740,
    GoRouter? router,
    bool isLandscape = false,
  }) {
    final defaultRouter = GoRouter(
      initialLocation: '/order-details/$orderId',
      routes: [
        GoRoute(
          path: '/order-details/:id',
          builder: (context, state) => MultiBlocProvider(
            providers: [
              BlocProvider<OrderDetailsCubit>.value(value: orderDetailsCubit),
              BlocProvider<CartCubit>.value(value: cartCubit),
            ],
            child: OrderDetailsScreen(orderId: orderId),
          ),
        ),
        GoRoute(
          path: Routes.cart,
          builder: (context, state) => const Scaffold(
            body: Center(child: Text('Cart Screen Target')),
          ),
        ),
        GoRoute(
          path: Routes.paymentWebView,
          builder: (context, state) => const Scaffold(
            body: Center(child: Text('Payment WebView Target')),
          ),
        ),
      ],
    );

    return ScreenUtilInit(
      designSize: isLandscape
          ? AppConstants.designSizeLandscape
          : AppConstants.designSizePortrait,
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) => MaterialApp.router(
        theme: AppTheme.lightTheme,
        routerConfig: router ?? defaultRouter,
      ),
    );
  }

  group('OrderDetailsScreen Widget Tests', () {
    testWidgets('shows loading state when status is loading', (tester) async {
      mockGetOrderByIdUseCase.resultToReturn = Right(tOrder);
      mockGetOrderPaymentStatusUseCase.resultToReturn = Right(tPaymentStatus);

      await tester.pumpWidget(buildTestWidget());
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows failure state with error message and retry button', (
      tester,
    ) async {
      mockGetOrderByIdUseCase.resultToReturn = const Left(
        ServerFailure(message: 'Failed to fetch order details'),
      );
      mockGetOrderPaymentStatusUseCase.resultToReturn = const Left(
        ServerFailure(message: 'Payment status error'),
      );

      await tester.pumpWidget(buildTestWidget());
      await orderDetailsCubit.loadOrderDetails(8740);
      await tester.pumpAndSettle();

      expect(find.text('Failed to fetch order details'), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);

      // Verify retry calls loadOrderDetails again
      mockGetOrderByIdUseCase.resultToReturn = Right(tOrder);
      mockGetOrderPaymentStatusUseCase.resultToReturn = Right(tPaymentStatus);

      await tester.tap(find.text('Retry'));
      await tester.pumpAndSettle();

      expect(find.text('#DK-8740'), findsOneWidget);
    });

    testWidgets('shows success state with all cards and bottom bar', (
      tester,
    ) async {
      mockGetOrderByIdUseCase.resultToReturn = Right(tOrder);
      mockGetOrderPaymentStatusUseCase.resultToReturn = Right(tPaymentStatus);

      await tester.pumpWidget(buildTestWidget());
      await orderDetailsCubit.loadOrderDetails(8740);
      await tester.pumpAndSettle();

      // App bar
      expect(find.text('Order Detail'), findsOneWidget);

      // Header card
      expect(find.byType(OrderDetailsHeader), findsOneWidget);
      expect(find.text('#DK-8740'), findsOneWidget);
      expect(find.text('Invoice'), findsOneWidget);

      // Fulfillment card
      expect(find.byType(OrderFulfillmentCard), findsOneWidget);
      expect(find.text('FULFILLMENT STATUS'), findsOneWidget);

      // Items card
      expect(find.byType(OrderItemsCard), findsOneWidget);
      expect(find.text('Items in Order'), findsOneWidget);
      expect(find.text('Premium Wireless Headphones'), findsOneWidget);
      expect(find.text('Ergonomic Mouse'), findsOneWidget);

      // Delivery Address card
      expect(find.byType(OrderDeliveryAddressCard), findsOneWidget);
      expect(find.text('Delivery Address'), findsOneWidget);
      expect(find.text('Building Building 14, Apt 4B'), findsOneWidget);
      expect(find.text('26th of July Corridor'), findsOneWidget);
      expect(find.text('Cairo'), findsOneWidget);

      // Payment Details card
      expect(find.byType(OrderPaymentDetailsCard), findsOneWidget);
      expect(find.text('Payment Details'), findsOneWidget);
      expect(find.text('Stripe'), findsOneWidget);

      // Summary card
      expect(find.byType(OrderDetailsSummaryCard), findsOneWidget);
      expect(find.text('Order Summary'), findsOneWidget);
      expect(find.text('\$249.98'), findsWidgets);

      // Bottom bar
      expect(find.byType(OrderDetailsBottomBar), findsOneWidget);
      expect(find.text('Reorder All Items'), findsOneWidget);
      expect(find.text('Need Help with this Order?'), findsOneWidget);
    });

    testWidgets('tapping Buy Again calls CartCubit.addToCart and navigates to cart', (
      tester,
    ) async {
      mockGetOrderByIdUseCase.resultToReturn = Right(tOrder);
      mockGetOrderPaymentStatusUseCase.resultToReturn = Right(tPaymentStatus);

      await tester.pumpWidget(buildTestWidget());
      await orderDetailsCubit.loadOrderDetails(8740);
      await tester.pumpAndSettle();

      // Find first "Buy Again" button
      final buyAgainButtons = find.text('Buy Again');
      expect(buyAgainButtons, findsNWidgets(2));

      await tester.tap(buyAgainButtons.first);
      await tester.pumpAndSettle();

      // Verify item was added to CartCubit
      expect(mockCartRepository.addedItems.length, 1);
      expect(mockCartRepository.addedItems.first['productId'], 101);
      expect(mockCartRepository.addedItems.first['quantity'], 1);

      // Verify navigation to cart screen
      expect(find.text('Cart Screen Target'), findsOneWidget);
    });

    testWidgets('tapping Reorder All Items triggers cubit and navigates to cart', (
      tester,
    ) async {
      mockGetOrderByIdUseCase.resultToReturn = Right(tOrder);
      mockGetOrderPaymentStatusUseCase.resultToReturn = Right(tPaymentStatus);

      await tester.pumpWidget(buildTestWidget());
      await orderDetailsCubit.loadOrderDetails(8740);
      await tester.pumpAndSettle();

      final reorderButton = find.text('Reorder All Items');
      expect(reorderButton, findsOneWidget);

      await tester.tap(reorderButton);
      await tester.pumpAndSettle();

      // Both items added
      expect(mockCartRepository.addedItems.length, 2);
      expect(mockCartRepository.addedItems[0]['productId'], 101);
      expect(mockCartRepository.addedItems[1]['productId'], 102);

      // Verify navigation to cart screen
      expect(find.text('Cart Screen Target'), findsOneWidget);
    });

    testWidgets('pull to refresh calls cubit.loadOrderDetails', (tester) async {
      mockGetOrderByIdUseCase.resultToReturn = Right(tOrder);
      mockGetOrderPaymentStatusUseCase.resultToReturn = Right(tPaymentStatus);

      await tester.pumpWidget(buildTestWidget());
      await orderDetailsCubit.loadOrderDetails(8740);
      await tester.pumpAndSettle();

      expect(find.byType(RefreshIndicator), findsOneWidget);

      // Perform fling/drag to trigger refresh
      await tester.fling(find.byType(RefreshIndicator), const Offset(0, 300), 1000);
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));
      await tester.pumpAndSettle();

      expect(mockGetOrderByIdUseCase.capturedId, 8740);
    });

    testWidgets('tapping Need Help shows snackbar or info', (tester) async {
      mockGetOrderByIdUseCase.resultToReturn = Right(tOrder);
      mockGetOrderPaymentStatusUseCase.resultToReturn = Right(tPaymentStatus);

      await tester.pumpWidget(buildTestWidget());
      await orderDetailsCubit.loadOrderDetails(8740);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Need Help with this Order?'));
      await tester.pumpAndSettle();

      expect(find.byType(SnackBar), findsOneWidget);
    });

    testWidgets(
      'renders single scroll view in landscape with zero RenderFlex overflow on Size(1624, 750)',
      (tester) async {
        setupLandscape(tester);

        mockGetOrderByIdUseCase.resultToReturn = Right(tOrder);
        mockGetOrderPaymentStatusUseCase.resultToReturn = Right(tPaymentStatus);

        await tester.pumpWidget(buildTestWidget(isLandscape: true));
        await orderDetailsCubit.loadOrderDetails(8740);
        await tester.pumpAndSettle();

        // Zero overflow assertion
        expect(tester.takeException(), isNull);

        // Verify single scroll view with max width constraints
        expect(find.byType(SingleChildScrollView), findsWidgets);
        expect(find.text('#DK-8740'), findsOneWidget);
        expect(find.text('Delivered on Oct 26, 2024'), findsOneWidget);
        expect(find.text('Premium Wireless Headphones'), findsOneWidget);
        expect(find.text('Order Summary'), findsOneWidget);
        expect(find.text('Reorder All Items'), findsOneWidget);
      },
    );

    testWidgets(
      'renders Pay Now and Cancel Order for pending credit card order and navigates on Pay Now',
      (tester) async {
        final pendingOrder = tOrder.copyWith(
          orderStatus: 'PENDING',
          paymentMethod: PaymentMethod.creditCard,
          payment: const PaymentInfoEntity(
            checkoutUrl: 'https://checkout.stripe.com/pay/cs_test_123',
            clientSecret: 'secret_123',
          ),
        );
        final pendingPaymentStatus = OrderPaymentStatusEntity(
          id: 8740,
          orderStatus: 'PENDING',
          totalAmount: 249.98,
          payments: const [],
        );

        mockGetOrderByIdUseCase.resultToReturn = Right(pendingOrder);
        mockGetOrderPaymentStatusUseCase.resultToReturn =
            Right(pendingPaymentStatus);

        await tester.pumpWidget(buildTestWidget());
        await orderDetailsCubit.loadOrderDetails(8740);
        await tester.pumpAndSettle();

        expect(find.text('Pay Now • \$249.98'), findsOneWidget);
        expect(find.text('Cancel Order'), findsOneWidget);
        expect(find.text('Reorder All Items'), findsNothing);

        await tester.tap(find.text('Pay Now • \$249.98'));
        await tester.pumpAndSettle();

        expect(find.text('Payment WebView Target'), findsOneWidget);
      },
    );

    testWidgets(
      'tapping Cancel Order shows confirmation dialog and cancels order on confirm',
      (tester) async {
        final pendingOrder = tOrder.copyWith(
          orderStatus: 'PENDING',
          paymentMethod: PaymentMethod.creditCard,
          payment: const PaymentInfoEntity(
            checkoutUrl: 'https://checkout.stripe.com/pay/cs_test_123',
            clientSecret: 'secret_123',
          ),
        );
        final pendingPaymentStatus = OrderPaymentStatusEntity(
          id: 8740,
          orderStatus: 'PENDING',
          totalAmount: 249.98,
          payments: const [],
        );
        final cancelledOrder = pendingOrder.copyWith(orderStatus: 'CANCELLED');

        mockGetOrderByIdUseCase.resultToReturn = Right(pendingOrder);
        mockGetOrderPaymentStatusUseCase.resultToReturn =
            Right(pendingPaymentStatus);
        mockCancelOrderUseCase.resultToReturn = Right(cancelledOrder);

        await tester.pumpWidget(buildTestWidget());
        await orderDetailsCubit.loadOrderDetails(8740);
        await tester.pumpAndSettle();

        await tester.tap(find.text('Cancel Order'));
        await tester.pumpAndSettle();

        // Confirmation dialog shown
        expect(find.text('Cancel Order?'), findsOneWidget);
        expect(find.text('Keep Order'), findsOneWidget);

        // Tap confirm "Cancel Order" in dialog
        final confirmButton = find.widgetWithText(FilledButton, 'Cancel Order');
        expect(confirmButton, findsOneWidget);
        await tester.tap(confirmButton);
        await tester.pumpAndSettle();

        expect(mockCancelOrderUseCase.capturedId, 8740);
        expect(find.text('Order #DK-8740 was cancelled.'), findsOneWidget);
      },
    );
  });
}
