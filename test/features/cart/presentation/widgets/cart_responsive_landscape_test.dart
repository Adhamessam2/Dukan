import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:fpdart/fpdart.dart';
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
import 'package:Dukan/features/cart/presentation/views/cart_screen.dart';
import 'package:Dukan/features/cart/presentation/widgets/cart_sticky_checkout_bar.dart';
import 'package:Dukan/features/home/domain/entities/product_entity.dart';
import 'package:Dukan/features/home/presentation/widgets/home_bottom_nav_bar.dart';

class MockCartRepository implements CartRepository {
  Either<Failure, CartEntity>? getCartResult;

  @override
  Future<Either<Failure, CartEntity>> getCart() async {
    return getCartResult ??
        const Right(CartEntity(id: 1, items: [], totalPrice: 0.0));
  }

  @override
  Future<Either<Failure, int>> clearCart() async => const Right(1);

  @override
  Future<Either<Failure, CartItemEntity>> updateCartItem({
    required String cartId,
    required String productId,
    required int quantity,
  }) async => throw UnimplementedError();

  @override
  Future<Either<Failure, CartItemEntity>> deleteCartItem({
    required String cartId,
    required String productId,
  }) async => throw UnimplementedError();

  @override
  Future<Either<Failure, CartItemEntity>> addToCart({
    required int productId,
    required int quantity,
  }) => throw UnimplementedError();

  @override
  Future<Either<Failure, ProductEntity>> getCartItem({
    required String cartId,
    required String productId,
  }) => throw UnimplementedError();
}

void main() {
  late MockCartRepository mockRepository;
  late CartCubit cartCubit;

  setUp(() {
    mockRepository = MockCartRepository();
    cartCubit = CartCubit(
      addToCartUseCase: AddToCartUseCase(mockRepository),
      getCartUseCase: GetCartUseCase(mockRepository),
      getCartItemUseCase: GetCartItemUseCase(mockRepository),
      updateCartItemUseCase: UpdateCartItemUseCase(mockRepository),
      deleteCartItemUseCase: DeleteCartItemUseCase(mockRepository),
      clearCartUseCase: ClearCartUseCase(mockRepository),
    );
  });

  tearDown(() {
    cartCubit.close();
  });

  Widget buildLandscapeTestWidget(Widget child) {
    final router = GoRouter(
      initialLocation: Routes.cart,
      routes: [
        GoRoute(path: Routes.cart, builder: (context, state) => child),
        GoRoute(
          path: Routes.checkout,
          builder: (context, state) =>
              const Scaffold(body: Text('Checkout Route Reached')),
        ),
        GoRoute(
          path: Routes.home,
          builder: (context, state) =>
              const Scaffold(body: Text('Home Route Reached')),
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
          builder: (context, _) => MaterialApp.router(
            theme: AppTheme.lightTheme,
            routerConfig: router,
          ),
        );
      },
    );
  }

  testWidgets(
    'CartScreen renders empty cart without overflow in landscape orientation',
    (tester) async {
      tester.view.physicalSize = const Size(1624, 750);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      mockRepository.getCartResult = const Right(
        CartEntity(id: 1, items: [], totalPrice: 0.0),
      );

      await tester.pumpWidget(
        buildLandscapeTestWidget(
          BlocProvider<CartCubit>.value(
            value: cartCubit,
            child: const CartScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('Your Bag is Empty'), findsOneWidget);
      expect(find.text('Start Shopping'), findsOneWidget);
      final navBarFinder = find.byType(HomeBottomNavBar);
      expect(navBarFinder, findsOneWidget);
      final navBar = tester.widget<HomeBottomNavBar>(navBarFinder);
      expect(navBar.selectedIndex, 1);
      expect(find.text('Browse'), findsNothing);
    },
  );

  testWidgets(
    'CartScreen renders populated cart dual-pane layout without overflow in landscape orientation',
    (tester) async {
      tester.view.physicalSize = const Size(1624, 750);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      mockRepository.getCartResult = const Right(
        CartEntity(
          id: 1,
          items: [
            CartItemEntity(
              cartId: 1,
              productId: 1,
              quantity: 2,
              product: ProductEntity(
                id: 1,
                productName: 'Nordic Ceramic Mug',
                price: 28.0,
              ),
            ),
          ],
          totalPrice: 56.0,
        ),
      );

      await tester.pumpWidget(
        buildLandscapeTestWidget(
          BlocProvider<CartCubit>.value(
            value: cartCubit,
            child: const CartScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);

      // Left Pane elements
      expect(find.text('Your Bag'), findsOneWidget);
      expect(find.text('1 item'), findsOneWidget);
      expect(find.text('Clear all'), findsOneWidget);
      expect(find.text('Nordic Ceramic Mug'), findsOneWidget);

      // Right Pane elements
      expect(find.text('Order Summary'), findsOneWidget);
      expect(find.text('Proceed to Checkout'), findsOneWidget);
      expect(find.text('Secure 256-bit Checkout'), findsOneWidget);

      // Bottom Navigation Bar is present
      final navBarFinder = find.byType(HomeBottomNavBar);
      expect(navBarFinder, findsOneWidget);
      final navBar = tester.widget<HomeBottomNavBar>(navBarFinder);
      expect(navBar.selectedIndex, 1);
      expect(find.text('Browse'), findsNothing);

      // In landscape, the floating bottom CartStickyCheckoutBar is omitted
      // because checkout is integrated into the right pane
      expect(find.byType(CartStickyCheckoutBar), findsNothing);
    },
  );

  testWidgets(
    'tapping Proceed to Checkout in landscape navigates to checkout screen',
    (tester) async {
      tester.view.physicalSize = const Size(1624, 750);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      mockRepository.getCartResult = const Right(
        CartEntity(
          id: 1,
          items: [
            CartItemEntity(
              cartId: 1,
              productId: 1,
              quantity: 1,
              product: ProductEntity(
                id: 1,
                productName: 'Nordic Ceramic Mug',
                price: 28.0,
              ),
            ),
          ],
          totalPrice: 28.0,
        ),
      );

      await tester.pumpWidget(
        buildLandscapeTestWidget(
          BlocProvider<CartCubit>.value(
            value: cartCubit,
            child: const CartScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final checkoutBtn = find.text('Proceed to Checkout');
      expect(checkoutBtn, findsOneWidget);
      await tester.tap(checkoutBtn);
      await tester.pumpAndSettle();

      expect(find.text('Checkout Route Reached'), findsOneWidget);
    },
  );

  testWidgets(
    'CartScreen right pane renders compact order summary and anchored checkout button without scrolling on short landscape viewport',
    (tester) async {
      tester.view.physicalSize = const Size(1624, 750); // 812x375 logical
      tester.view.devicePixelRatio = 2.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      mockRepository.getCartResult = const Right(
        CartEntity(
          id: 1,
          items: [
            CartItemEntity(
              cartId: 1,
              productId: 1,
              quantity: 1,
              product: ProductEntity(
                id: 1,
                productName: 'Nordic Ceramic Mug',
                price: 28.0,
              ),
            ),
          ],
          totalPrice: 28.0,
        ),
      );

      await tester.pumpWidget(
        buildLandscapeTestWidget(
          BlocProvider<CartCubit>.value(
            value: cartCubit,
            child: const CartScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);

      // Compact Order Summary elements
      expect(find.text('Order Summary'), findsOneWidget);
      expect(find.text('Shipping & Tax'), findsOneWidget);
      expect(find.text('FREE • Incl.'), findsOneWidget);

      // Anchored checkout CTA is visible in the viewport without needing to scroll
      final checkoutBtn = find.text('Proceed to Checkout');
      expect(checkoutBtn, findsOneWidget);
      final checkoutCenter = tester.getCenter(checkoutBtn);
      expect(checkoutCenter.dy, greaterThan(0));
      expect(checkoutCenter.dy, lessThan(375));
    },
  );
}
