import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:Dukan/core/errors/failure.dart';
import 'package:Dukan/core/theme/app_theme.dart';
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
import 'package:Dukan/features/cart/presentation/widgets/cart_empty_view.dart';
import 'package:Dukan/features/cart/presentation/widgets/cart_item_card.dart';
import 'package:Dukan/features/cart/presentation/widgets/cart_order_summary_card.dart';
import 'package:Dukan/features/cart/presentation/widgets/cart_sticky_checkout_bar.dart';
import 'package:Dukan/features/cart/presentation/widgets/cart_trust_badges.dart';
import 'package:Dukan/features/home/domain/entities/product_entity.dart';

class MockCartRepository implements CartRepository {
  Either<Failure, CartEntity>? getCartResult;
  bool getCartCalled = false;

  Either<Failure, int>? clearCartResult;
  bool clearCartCalled = false;

  Either<Failure, CartItemEntity>? updateCartItemResult;
  Completer<Either<Failure, CartItemEntity>>? updateCartItemCompleter;
  int updateCartItemCallCount = 0;
  String? updateCartIdCalled;
  String? updateProductIdCalled;
  int? updateQuantityCalled;

  Either<Failure, CartItemEntity>? deleteCartItemResult;
  Future<Either<Failure, CartItemEntity>> Function()? deleteCartItemHandler;
  int deleteCartItemCallCount = 0;
  String? deleteCartIdCalled;
  String? deleteProductIdCalled;

  @override
  Future<Either<Failure, CartEntity>> getCart() async {
    getCartCalled = true;
    return getCartResult ??
        const Right(CartEntity(id: 1, items: [], totalPrice: 0.0));
  }

  @override
  Future<Either<Failure, int>> clearCart() async {
    clearCartCalled = true;
    return clearCartResult ?? const Right(1);
  }

  @override
  Future<Either<Failure, CartItemEntity>> updateCartItem({
    required String cartId,
    required String productId,
    required int quantity,
  }) async {
    updateCartItemCallCount++;
    updateCartIdCalled = cartId;
    updateProductIdCalled = productId;
    updateQuantityCalled = quantity;
    if (updateCartItemCompleter != null) {
      return updateCartItemCompleter!.future;
    }
    return updateCartItemResult ??
        Right(
          CartItemEntity(
            cartId: int.tryParse(cartId),
            productId: int.tryParse(productId) ?? 0,
            quantity: quantity,
            isDeleted: false,
          ),
        );
  }

  @override
  Future<Either<Failure, CartItemEntity>> deleteCartItem({
    required String cartId,
    required String productId,
  }) async {
    deleteCartItemCallCount++;
    deleteCartIdCalled = cartId;
    deleteProductIdCalled = productId;
    if (deleteCartItemHandler != null) {
      return deleteCartItemHandler!();
    }
    return deleteCartItemResult ??
        Right(
          CartItemEntity(
            cartId: int.tryParse(cartId),
            productId: int.tryParse(productId) ?? 0,
            quantity: 1,
            isDeleted: true,
          ),
        );
  }

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

  const tProduct1 = ProductEntity(
    id: 1,
    productName: 'Nordic Ceramic Mug',
    price: 28.0,
  );
  const tProduct2 = ProductEntity(
    id: 2,
    productName: 'Raw Linen Overshirt',
    price: 84.0,
  );

  const tItem1 = CartItemEntity(
    cartId: 1,
    productId: 1,
    quantity: 2,
    product: tProduct1,
  );
  const tItem2 = CartItemEntity(
    cartId: 1,
    productId: 2,
    quantity: 1,
    product: tProduct2,
  );

  const tCart = CartEntity(id: 1, items: [tItem1, tItem2], totalPrice: 140.0);

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

  Widget buildTestWidget() {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) => MaterialApp(
        theme: AppTheme.lightTheme,
        home: BlocProvider<CartCubit>.value(
          value: cartCubit,
          child: const CartScreen(),
        ),
      ),
    );
  }

  testWidgets(
    'shows loading indicator when getCart is loading and cart is null',
    (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      mockRepository.getCartResult = const Right(tCart);
      await tester.pumpWidget(buildTestWidget());

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      await tester.pumpAndSettle();
    },
  );

  testWidgets('shows error state when getCart fails and cart is null', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    mockRepository.getCartResult = const Left(
      ServerFailure(message: 'Server error', code: 500),
    );
    await tester.pumpWidget(buildTestWidget());
    await tester.pumpAndSettle();

    expect(find.widgetWithText(ElevatedButton, 'Try Again'), findsOneWidget);
  });

  testWidgets('shows CartEmptyView when cart items list is empty', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    mockRepository.getCartResult = const Right(
      CartEntity(id: 1, items: [], totalPrice: 0.0),
    );
    await tester.pumpWidget(buildTestWidget());
    await tester.pumpAndSettle();

    expect(find.byType(CartEmptyView), findsOneWidget);
    expect(find.text('Your Bag is Empty'), findsOneWidget);
    expect(find.text('Start Shopping'), findsOneWidget);
  });

  testWidgets(
    'renders populated cart with items, summary, badges, and sticky bar',
    (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      mockRepository.getCartResult = const Right(tCart);
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('Your Bag'), findsOneWidget);
      expect(find.text('2 items'), findsOneWidget);
      expect(find.text('Clear all'), findsOneWidget);

      expect(find.byType(CartItemCard), findsNWidgets(2));
      expect(find.text('Nordic Ceramic Mug'), findsOneWidget);
      expect(find.text('Raw Linen Overshirt'), findsOneWidget);

      expect(find.byType(CartOrderSummaryCard), findsOneWidget);
      expect(find.text('Order Summary'), findsOneWidget);

      expect(find.byType(CartTrustBadges), findsOneWidget);
      expect(find.text('Secure 256-bit Checkout'), findsOneWidget);

      expect(find.byType(CartStickyCheckoutBar), findsOneWidget);
      expect(find.text('Proceed to Checkout'), findsOneWidget);
    },
  );

  testWidgets(
    'tapping Clear all invokes cubit.clearCart() after confirmation',
    (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      mockRepository.getCartResult = const Right(tCart);
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Clear all'));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsOneWidget);
      await tester.tap(
        find.descendant(
          of: find.byType(AlertDialog),
          matching: find.text('Clear all'),
        ),
      );
      await tester.pump();

      expect(mockRepository.clearCartCalled, isTrue);
    },
  );

  testWidgets(
    'tapping stepper + invokes cubit.updateCartItem() with quantity + 1',
    (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      mockRepository.getCartResult = const Right(tCart);
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      // First item has quantity 2
      final addButtons = find.byIcon(Icons.add_rounded);
      await tester.tap(addButtons.first);
      await tester.pump();

      expect(mockRepository.updateCartIdCalled, equals('1'));
      expect(mockRepository.updateProductIdCalled, equals('1'));
      expect(mockRepository.updateQuantityCalled, equals(3));
    },
  );

  testWidgets(
    'tapping stepper - when quantity > 1 invokes cubit.updateCartItem() with quantity - 1',
    (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      mockRepository.getCartResult = const Right(tCart);
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      // First item has quantity 2
      final removeButtons = find.byIcon(Icons.remove_rounded);
      await tester.tap(removeButtons.first);
      await tester.pump();

      expect(mockRepository.updateCartIdCalled, equals('1'));
      expect(mockRepository.updateProductIdCalled, equals('1'));
      expect(mockRepository.updateQuantityCalled, equals(1));
    },
  );

  testWidgets(
    'tapping stepper - when quantity == 1 invokes cubit.deleteCartItem()',
    (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      mockRepository.getCartResult = const Right(tCart);
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      // Second item has quantity 1
      final removeButtons = find.byIcon(Icons.remove_rounded);
      await tester.tap(removeButtons.at(1));
      await tester.pump();

      expect(mockRepository.deleteCartIdCalled, equals('1'));
      expect(mockRepository.deleteProductIdCalled, equals('2'));
    },
  );

  testWidgets('tapping remove X button invokes cubit.deleteCartItem()', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    mockRepository.getCartResult = const Right(tCart);
    await tester.pumpWidget(buildTestWidget());
    await tester.pumpAndSettle();

    final closeButtons = find.byIcon(Icons.close_rounded);
    await tester.tap(closeButtons.first);
    await tester.pump();

    expect(mockRepository.deleteCartIdCalled, equals('1'));
    expect(mockRepository.deleteProductIdCalled, equals('1'));
  });

  testWidgets(
    'tapping remove X button on multi-quantity item deletes until completely removed',
    (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      mockRepository.getCartResult = const Right(tCart);
      var calls = 0;
      mockRepository.deleteCartItemHandler = () async {
        calls++;
        if (calls == 1) {
          // First delete decrements to quantity 1, not yet deleted
          return const Right(
            CartItemEntity(
              cartId: 1,
              productId: 1,
              quantity: 1,
              isDeleted: false,
            ),
          );
        } else {
          // Second delete removes the item completely
          return const Right(
            CartItemEntity(
              cartId: 1,
              productId: 1,
              quantity: 0,
              isDeleted: true,
            ),
          );
        }
      };

      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      // First item in tCart has quantity 2
      final closeButtons = find.byIcon(Icons.close_rounded);
      await tester.tap(closeButtons.first);
      await tester.pump();
      await tester.pumpAndSettle();

      // Verified: called twice to remove all 2 units of product 1
      expect(mockRepository.deleteCartItemCallCount, equals(2));
      expect(find.text('Item removed from your bag'), findsOneWidget);
    },
  );

  testWidgets(
    'disables item controls while mutation is in progress, preventing overlapping requests',
    (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      final completer = Completer<Either<Failure, CartItemEntity>>();
      mockRepository.updateCartItemCompleter = completer;

      mockRepository.getCartResult = const Right(tCart);
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      final addButtons = find.byIcon(Icons.add_rounded);
      await tester.tap(addButtons.first);
      await tester.pump();

      expect(mockRepository.updateCartItemCallCount, equals(1));

      // Attempt second tap while in-flight
      await tester.tap(addButtons.first);
      await tester.pump();

      // Call count remains 1 because controls are disabled
      expect(mockRepository.updateCartItemCallCount, equals(1));

      completer.complete(
        const Right(CartItemEntity(cartId: 1, productId: 1, quantity: 3)),
      );
      await tester.pump();
      await tester.pumpAndSettle();
    },
  );
}
