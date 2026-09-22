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
import 'package:Dukan/core/widgets/custom_app_bar.dart';
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
import 'package:Dukan/features/orders/domain/entities/create_order_params.dart';
import 'package:Dukan/features/orders/domain/entities/order_entity.dart';
import 'package:Dukan/features/orders/domain/entities/payment_info_entity.dart';
import 'package:Dukan/features/orders/domain/entities/payment_method.dart';
import 'package:Dukan/features/orders/domain/repositories/orders_repository.dart';
import 'package:Dukan/features/orders/domain/usecases/create_order_use_case.dart';
import 'package:Dukan/features/orders/presentation/cubit/checkout_cubit.dart';
import 'package:Dukan/features/orders/presentation/cubit/checkout_state.dart';
import 'package:Dukan/features/orders/presentation/views/checkout_screen.dart';
import 'package:Dukan/features/orders/presentation/views/payment_webview_args.dart';
import 'package:Dukan/features/orders/presentation/widgets/checkout_order_summary_card.dart';
import 'package:Dukan/features/orders/presentation/widgets/checkout_step_indicator.dart';
import 'package:Dukan/features/orders/presentation/widgets/checkout_sticky_bottom_bar.dart';
import 'package:Dukan/features/orders/presentation/widgets/order_success_dialog.dart';
import 'package:Dukan/features/orders/presentation/widgets/payment_method_card.dart';
import 'package:Dukan/features/orders/presentation/widgets/shipping_information_card.dart';

class MockCreateOrderUseCase implements CreateOrderUseCase {
  CreateOrderParams? capturedParams;
  Either<Failure, OrderEntity>? resultToReturn;
  bool called = false;

  @override
  OrdersRepository get repository => throw UnimplementedError();

  @override
  Future<Either<Failure, OrderEntity>> call(CreateOrderParams params) async {
    called = true;
    capturedParams = params;
    return resultToReturn ??
        Right(
          OrderEntity(
            id: 101,
            userId: 1,
            shippingCity: params.address.city,
            shippingStreet: params.address.street,
            shippingBuilding: params.address.building,
            orderStatus: 'PENDING',
            totalAmount: 101.0,
            paymentMethod: params.paymentMethod,
            createdAt: DateTime(2026, 9, 21),
          ),
        );
  }
}

class MockCartRepository implements CartRepository {
  bool clearCartCalled = false;

  @override
  Future<Either<Failure, int>> clearCart() async {
    clearCartCalled = true;
    return const Right(1);
  }

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
  late MockCreateOrderUseCase mockCreateOrderUseCase;
  late MockCartRepository mockCartRepository;
  late CheckoutCubit checkoutCubit;
  late CartCubit cartCubit;

  const tProduct1 = ProductEntity(
    id: 1,
    productName: 'Nordic Ceramic Mug',
    price: 28.0,
  );
  const tProduct2 = ProductEntity(
    id: 2,
    productName: 'Minimalist Desk Lamp',
    price: 45.0,
  );

  const tCart = CartEntity(
    id: 1,
    items: [
      CartItemEntity(cartId: 1, productId: 1, quantity: 2, product: tProduct1),
      CartItemEntity(cartId: 1, productId: 2, quantity: 1, product: tProduct2),
    ],
    totalPrice: 101.0,
  );

  setUp(() {
    mockCreateOrderUseCase = MockCreateOrderUseCase();
    mockCartRepository = MockCartRepository();
    checkoutCubit = CheckoutCubit(createOrderUseCase: mockCreateOrderUseCase);
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
    checkoutCubit.close();
    cartCubit.close();
  });

  void setupPortrait(WidgetTester tester) {
    tester.view.physicalSize = const Size(750, 1624);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(() => tester.view.resetPhysicalSize());
  }

  void setupLandscape(WidgetTester tester) {
    tester.view.physicalSize = const Size(1624, 750);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(() => tester.view.resetPhysicalSize());
  }

  Widget buildTestWidget({CartEntity? cart, GoRouter? customRouter}) {
    final effectiveRouter = customRouter ??
        GoRouter(
          initialLocation: Routes.checkout,
          routes: [
            GoRoute(
              path: Routes.checkout,
              builder: (context, state) => CheckoutScreen(cart: cart ?? tCart),
            ),
            GoRoute(
              path: Routes.home,
              builder: (context, state) =>
                  const Scaffold(body: Center(child: Text('Home Screen Target'))),
            ),
            GoRoute(
              path: Routes.orders,
              builder: (context, state) =>
                  const Scaffold(body: Center(child: Text('Orders Screen Target'))),
            ),
            GoRoute(
              path: Routes.paymentWebView,
              builder: (context, state) {
                final args = state.extra as PaymentWebViewArgs;
                return Scaffold(
                  body: Column(
                    children: [
                      const Text('Payment WebView Screen'),
                      Text('URL: ${args.url}'),
                      Text('Order ID: ${args.order.id}'),
                    ],
                  ),
                );
              },
            ),
          ],
        );

    return OrientationBuilder(
      builder: (context, orientation) {
        return ScreenUtilInit(
          designSize: orientation == Orientation.landscape
              ? AppConstants.designSizeLandscape
              : AppConstants.designSizePortrait,
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (context, child) => MultiBlocProvider(
            providers: [
              BlocProvider<CheckoutCubit>.value(value: checkoutCubit),
              BlocProvider<CartCubit>.value(value: cartCubit),
            ],
            child: MaterialApp.router(
              theme: AppTheme.lightTheme,
              routerConfig: effectiveRouter,
            ),
          ),
        );
      },
    );
  }

  group('CheckoutScreen Portrait', () {
    testWidgets('renders all essential sections and app bar', (tester) async {
      setupPortrait(tester);

      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      // CustomAppBar
      expect(find.byType(CustomAppBar), findsOneWidget);
      expect(find.text('Checkout'), findsOneWidget);

      // CheckoutStepIndicator
      expect(find.byType(CheckoutStepIndicator), findsOneWidget);
      expect(find.text('Final Step'), findsOneWidget);
      expect(find.text('Step 2 of 2'), findsOneWidget);

      // ShippingInformationCard
      expect(find.byType(ShippingInformationCard), findsOneWidget);
      expect(find.text('Shipping Information'), findsOneWidget);

      // Sticky bottom bar
      expect(find.byType(CheckoutStickyBottomBar), findsOneWidget);
      expect(find.text('Pay with Cash – \$101.00'), findsOneWidget);

      // Scroll to view remaining sections in sliver list
      await tester.drag(find.byType(CustomScrollView), const Offset(0, -400));
      await tester.pumpAndSettle();
      expect(find.byType(CheckoutOrderSummaryCard), findsOneWidget);
      expect(find.text('Order Summary'), findsOneWidget);

      await tester.drag(find.byType(CustomScrollView), const Offset(0, -400));
      await tester.pumpAndSettle();
      expect(find.byType(PaymentMethodCard), findsOneWidget);
      expect(find.text('Payment Method'), findsOneWidget);
    });

    testWidgets(
      'validation fails and does not submit when required address fields are empty',
      (tester) async {
        setupPortrait(tester);

        await tester.pumpWidget(buildTestWidget());
        await tester.pumpAndSettle();

        // Tap Pay button in sticky bottom bar
        final payButton = find.text('Pay with Cash – \$101.00');
        await tester.tap(payButton);
        await tester.pumpAndSettle();

        // Check validation error texts
        expect(find.text('Street address is required'), findsOneWidget);
        expect(find.text('Building / Apartment is required'), findsOneWidget);
        expect(find.text('City is required'), findsOneWidget);

        // submitOrder must not have been invoked
        expect(mockCreateOrderUseCase.called, isFalse);
      },
    );

    testWidgets(
      'validation passes and submitOrder is called when fields are filled',
      (tester) async {
        setupPortrait(tester);

        await tester.pumpWidget(buildTestWidget());
        await tester.pumpAndSettle();

        // Enter shipping details
        final textFields = find.byType(TextField);
        await tester.enterText(textFields.at(0), 'John Doe');
        await tester.enterText(textFields.at(1), '1234567890');
        await tester.enterText(textFields.at(2), 'El-Tahrir Street');
        await tester.enterText(textFields.at(3), 'Building 4B');
        await tester.enterText(textFields.at(4), 'Cairo');
        await tester.pumpAndSettle();

        // Tap Pay button
        final payButton = find.text('Pay with Cash – \$101.00');
        await tester.tap(payButton);
        await tester.pump();

        expect(mockCreateOrderUseCase.called, isTrue);
        expect(
          mockCreateOrderUseCase.capturedParams?.address.city,
          equals('Cairo'),
        );
        expect(
          mockCreateOrderUseCase.capturedParams?.address.street,
          equals('El-Tahrir Street'),
        );
        expect(
          mockCreateOrderUseCase.capturedParams?.address.building,
          equals('Building 4B'),
        );
      },
    );

    testWidgets(
      'payment method selection toggles payment method and updates CTA text',
      (tester) async {
        setupPortrait(tester);

        await tester.pumpWidget(buildTestWidget());
        await tester.pumpAndSettle();

        expect(find.text('Pay with Cash – \$101.00'), findsOneWidget);

        // Scroll to and select Visa
        await tester.drag(find.byType(CustomScrollView), const Offset(0, -600));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Visa'));
        await tester.pumpAndSettle();

        expect(find.text('Pay with Card – \$101.00'), findsOneWidget);
      },
    );

    testWidgets(
      'order with cash payment displays OrderSuccessDialog and clears cart',
      (tester) async {
        setupPortrait(tester);

        await tester.pumpWidget(buildTestWidget());
        await tester.pumpAndSettle();

        final createdOrder = OrderEntity(
          id: 777,
          userId: 1,
          shippingCity: 'Alexandria',
          shippingStreet: 'Corniche',
          shippingBuilding: '12',
          orderStatus: 'PENDING',
          totalAmount: 101.0,
          paymentMethod: PaymentMethod.cash,
          createdAt: DateTime(2026, 9, 21),
        );

        // Trigger success state
        checkoutCubit.emit(
          CheckoutState(
            status: CheckoutStatus.success,
            createdOrder: createdOrder,
          ),
        );
        await tester.pumpAndSettle();

        // Verify cart clear was called
        expect(mockCartRepository.clearCartCalled, isTrue);

        // Verify OrderSuccessDialog is shown
        expect(find.byType(OrderSuccessDialog), findsOneWidget);
        expect(find.text('Order Placed Successfully!'), findsOneWidget);
        expect(find.text('#777'), findsOneWidget);
      },
    );

    testWidgets(
      'order with creditCard and checkoutUrl pushes to paymentWebView route with PaymentWebViewArgs',
      (tester) async {
        setupPortrait(tester);

        await tester.pumpWidget(buildTestWidget());
        await tester.pumpAndSettle();

        final createdOrder = OrderEntity(
          id: 888,
          userId: 1,
          shippingCity: 'Cairo',
          shippingStreet: 'Tahrir',
          shippingBuilding: '10',
          orderStatus: 'PENDING',
          totalAmount: 101.0,
          paymentMethod: PaymentMethod.creditCard,
          payment: const PaymentInfoEntity(
            checkoutUrl: 'https://checkout.stripe.com/pay/cs_test_123',
            clientSecret: 'secret_123',
          ),
          createdAt: DateTime(2026, 9, 21),
        );

        // Trigger success state
        checkoutCubit.emit(
          CheckoutState(
            status: CheckoutStatus.success,
            createdOrder: createdOrder,
          ),
        );
        await tester.pumpAndSettle();

        // Verify cart clear was called
        expect(mockCartRepository.clearCartCalled, isTrue);

        // Verify OrderSuccessDialog is NOT shown
        expect(find.byType(OrderSuccessDialog), findsNothing);

        // Verify navigation pushed to paymentWebView route with args
        expect(find.text('Payment WebView Screen'), findsOneWidget);
        expect(
          find.text('URL: https://checkout.stripe.com/pay/cs_test_123'),
          findsOneWidget,
        );
        expect(find.text('Order ID: 888'), findsOneWidget);
      },
    );

    testWidgets(
      'order with creditCard but null or empty checkoutUrl displays OrderSuccessDialog',
      (tester) async {
        setupPortrait(tester);

        await tester.pumpWidget(buildTestWidget());
        await tester.pumpAndSettle();

        final createdOrder = OrderEntity(
          id: 889,
          userId: 1,
          shippingCity: 'Cairo',
          shippingStreet: 'Tahrir',
          shippingBuilding: '10',
          orderStatus: 'PENDING',
          totalAmount: 101.0,
          paymentMethod: PaymentMethod.creditCard,
          payment: null,
          createdAt: DateTime(2026, 9, 21),
        );

        checkoutCubit.emit(
          CheckoutState(
            status: CheckoutStatus.success,
            createdOrder: createdOrder,
          ),
        );
        await tester.pumpAndSettle();

        // Verify cart clear was called
        expect(mockCartRepository.clearCartCalled, isTrue);

        // Fallback to OrderSuccessDialog
        expect(find.byType(OrderSuccessDialog), findsOneWidget);
        expect(find.text('#889'), findsOneWidget);
        expect(find.text('Payment WebView Screen'), findsNothing);
      },
    );

    testWidgets('failure listener displays error snackbar', (tester) async {
      setupPortrait(tester);

      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      checkoutCubit.emit(
        const CheckoutState(
          status: CheckoutStatus.failure,
          errorMessage: 'Payment gateway timeout',
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Payment gateway timeout'), findsOneWidget);
    });
  });

  group('CheckoutScreen Landscape Layout', () {
    testWidgets(
      'renders dual-pane layout cleanly with zero RenderFlex overflow on Size(1624, 750)',
      (tester) async {
        setupLandscape(tester);

        await tester.pumpWidget(buildTestWidget());
        await tester.pumpAndSettle();

        // Verify zero overflow exceptions
        expect(tester.takeException(), isNull);

        // Verify Dual Pane Layout presence
        // Left Column elements
        expect(find.byType(CheckoutStepIndicator), findsOneWidget);
        expect(find.byType(ShippingInformationCard), findsOneWidget);
        expect(find.byType(PaymentMethodCard), findsOneWidget);

        // Divider
        expect(find.byType(VerticalDivider), findsOneWidget);

        // Right Column elements
        expect(find.byType(CheckoutOrderSummaryCard), findsOneWidget);
        expect(find.byType(CheckoutStickyBottomBar), findsOneWidget);

        // Verify elements are visible and interactive
        expect(find.text('Pay with Cash – \$101.00'), findsOneWidget);
      },
    );
  });
}
