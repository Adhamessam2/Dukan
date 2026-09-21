import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:Dukan/core/errors/failure.dart';
import 'package:Dukan/core/theme/app_theme.dart';
import 'package:Dukan/core/usecases/usecase.dart';
import 'package:Dukan/features/home/domain/entities/category_entity.dart';
import 'package:Dukan/features/home/domain/entities/product_entity.dart';
import 'package:Dukan/features/home/domain/repositories/home_repository.dart';
import 'package:Dukan/features/home/domain/usecases/get_categories_use_case.dart';
import 'package:Dukan/features/home/domain/usecases/get_products_use_case.dart';
import 'package:Dukan/features/home/presentation/cubit/home_cubit.dart';
import 'package:Dukan/features/home/presentation/cubit/home_state.dart';
import 'package:Dukan/features/home/presentation/views/home_screen.dart';
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
import 'package:Dukan/features/home/presentation/widgets/home_bottom_nav_bar.dart';
import 'package:Dukan/features/home/presentation/widgets/home_category_chips.dart';
import 'package:Dukan/features/home/presentation/widgets/home_craftsmanship_card.dart';
import 'package:Dukan/features/home/presentation/widgets/home_header.dart';
import 'package:Dukan/features/home/presentation/widgets/home_products_grid.dart';
import 'package:Dukan/features/home/presentation/widgets/home_search_bar.dart';
import 'package:Dukan/features/home/presentation/widgets/home_section_header.dart';
import 'package:Dukan/features/home/presentation/widgets/home_spotlight_banner.dart';

class MockGetCategoriesUseCase implements GetCategoriesUseCase {
  Either<Failure, List<CategoryEntity>>? resultToReturn;

  @override
  HomeRepository get repository => throw UnimplementedError();

  @override
  Future<Either<Failure, List<CategoryEntity>>> call(NoParams params) async {
    return resultToReturn!;
  }
}

class MockGetProductsUseCase implements GetProductsUseCase {
  Either<Failure, List<ProductEntity>>? resultToReturn;

  @override
  HomeRepository get repository => throw UnimplementedError();

  @override
  Future<Either<Failure, List<ProductEntity>>> call(NoParams params) async {
    return resultToReturn!;
  }
}

class MockCartRepository implements CartRepository {
  Either<Failure, CartItemEntity>? cartResult;
  Either<Failure, CartEntity>? getCartResult;
  Completer<Either<Failure, CartItemEntity>>? completer;

  @override
  Future<Either<Failure, CartItemEntity>> addToCart({
    required int productId,
    required int quantity,
  }) async {
    if (completer != null) {
      return completer!.future;
    }
    return cartResult ??
        const Right(
          CartItemEntity(
            cartId: 1,
            productId: 10,
            quantity: 1,
            isDeleted: false,
          ),
        );
  }

  @override
  Future<Either<Failure, CartEntity>> getCart() async {
    return getCartResult ??
        const Right(CartEntity(id: 1, items: [], totalPrice: 0));
  }

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
  late MockGetCategoriesUseCase mockGetCategoriesUseCase;
  late MockGetProductsUseCase mockGetProductsUseCase;
  late HomeCubit cubit;
  late MockCartRepository mockCartRepository;
  late AddToCartUseCase addToCartUseCase;
  late GetCartUseCase getCartUseCase;
  late GetCartItemUseCase getCartItemUseCase;
  late UpdateCartItemUseCase updateCartItemUseCase;
  late DeleteCartItemUseCase deleteCartItemUseCase;
  late ClearCartUseCase clearCartUseCase;
  late CartCubit cartCubit;

  const tCategory1 = CategoryEntity(id: 1, categoryName: 'Electronics');
  const tCategory2 = CategoryEntity(id: 2, categoryName: 'Fashion');
  const tProduct1 = ProductEntity(
    id: 10,
    productName: 'iPhone 14 Pro',
    price: 999.0,
    avgRating: 4.8,
    category: tCategory1,
    stockQuantity: 10,
  );
  const tProduct2 = ProductEntity(
    id: 20,
    productName: 'Leather Boots',
    price: 150.0,
    avgRating: 4.2,
    category: tCategory2,
    stockQuantity: 10,
  );

  setUp(() {
    mockGetCategoriesUseCase = MockGetCategoriesUseCase();
    mockGetProductsUseCase = MockGetProductsUseCase();
    cubit = HomeCubit(
      getCategoriesUseCase: mockGetCategoriesUseCase,
      getProductsUseCase: mockGetProductsUseCase,
    );
    mockCartRepository = MockCartRepository();
    addToCartUseCase = AddToCartUseCase(mockCartRepository);
    getCartUseCase = GetCartUseCase(mockCartRepository);
    getCartItemUseCase = GetCartItemUseCase(mockCartRepository);
    updateCartItemUseCase = UpdateCartItemUseCase(mockCartRepository);
    deleteCartItemUseCase = DeleteCartItemUseCase(mockCartRepository);
    clearCartUseCase = ClearCartUseCase(mockCartRepository);
    cartCubit = CartCubit(
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
    cartCubit.close();
  });

  Widget buildTestWidget() {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) => MaterialApp(
        theme: AppTheme.lightTheme,
        home: MultiBlocProvider(
          providers: [
            BlocProvider<HomeCubit>.value(value: cubit),
            BlocProvider<CartCubit>.value(value: cartCubit),
          ],
          child: const HomeScreen(),
        ),
      ),
    );
  }

  testWidgets('HomeScreen renders all primary sections', (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    mockGetCategoriesUseCase.resultToReturn = const Right([
      tCategory1,
      tCategory2,
    ]);
    mockGetProductsUseCase.resultToReturn = const Right([tProduct1, tProduct2]);

    await tester.pumpWidget(buildTestWidget());
    await cubit.loadHomeData();
    await tester.pumpAndSettle();

    expect(find.byType(HomeHeader), findsOneWidget);
    expect(find.byType(HomeSearchBar), findsOneWidget);
    expect(find.byType(HomeCategoryChips), findsOneWidget);
    expect(find.byType(HomeSpotlightBanner), findsOneWidget);
    expect(find.byType(HomeSectionHeader), findsOneWidget);
    expect(find.byType(HomeProductsGrid), findsOneWidget);
    expect(find.byType(HomeCraftsmanshipCard), findsOneWidget);
    expect(find.byType(HomeBottomNavBar), findsOneWidget);

    expect(find.text('iPhone 14 Pro'), findsOneWidget);
    expect(find.text('Leather Boots'), findsOneWidget);
    expect(find.text('\$999.00'), findsOneWidget);
    expect(find.text('\$150.00'), findsOneWidget);
  });

  testWidgets('Category chips filter products when tapped', (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    mockGetCategoriesUseCase.resultToReturn = const Right([
      tCategory1,
      tCategory2,
    ]);
    mockGetProductsUseCase.resultToReturn = const Right([tProduct1, tProduct2]);

    await tester.pumpWidget(buildTestWidget());
    await cubit.loadHomeData();
    await tester.pumpAndSettle();

    expect(find.text('iPhone 14 Pro'), findsOneWidget);
    expect(find.text('Leather Boots'), findsOneWidget);

    // Tap 'Fashion' category chip
    final fashionChip = find.descendant(
      of: find.byType(HomeCategoryChips),
      matching: find.text('Fashion'),
    );
    await tester.tap(fashionChip);
    await tester.pumpAndSettle();

    expect(find.text('Leather Boots'), findsOneWidget);
    expect(find.text('iPhone 14 Pro'), findsNothing);

    // Tap 'All' chip to reset
    final allChip = find.descendant(
      of: find.byType(HomeCategoryChips),
      matching: find.text('All'),
    );
    await tester.tap(allChip);
    await tester.pumpAndSettle();

    expect(find.text('iPhone 14 Pro'), findsOneWidget);
    expect(find.text('Leather Boots'), findsOneWidget);
  });

  testWidgets('Search query filters product list dynamically', (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    mockGetCategoriesUseCase.resultToReturn = const Right([
      tCategory1,
      tCategory2,
    ]);
    mockGetProductsUseCase.resultToReturn = const Right([tProduct1, tProduct2]);

    await tester.pumpWidget(buildTestWidget());
    await cubit.loadHomeData();
    await tester.pumpAndSettle();

    // Enter search query
    await tester.enterText(find.byType(TextField), 'Boots');
    await tester.pumpAndSettle();

    expect(find.text('Leather Boots'), findsOneWidget);
    expect(find.text('iPhone 14 Pro'), findsNothing);
  });

  testWidgets('Add to bag button triggers snackbar', (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    mockGetCategoriesUseCase.resultToReturn = const Right([tCategory1]);
    mockGetProductsUseCase.resultToReturn = const Right([tProduct1]);

    await tester.pumpWidget(buildTestWidget());
    await cubit.loadHomeData();
    await tester.pumpAndSettle();

    final addButton = find.byIcon(Icons.add_rounded).first;
    await tester.tap(addButton);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('Added to your bag'), findsOneWidget);
  });

  testWidgets(
    'HomeProductCard shows micro-spinner when product is being added to cart',
    (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      mockGetCategoriesUseCase.resultToReturn = const Right([tCategory1]);
      mockGetProductsUseCase.resultToReturn = const Right([tProduct1]);

      final completer = Completer<Either<Failure, CartItemEntity>>();
      mockCartRepository.completer = completer;

      await tester.pumpWidget(buildTestWidget());
      await cubit.loadHomeData();
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.add_rounded), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);

      // Tap Add to Cart
      final addButton = find.byIcon(Icons.add_rounded).first;
      await tester.tap(addButton);
      await tester.pump();

      // Verify micro-spinner appears and add icon disappears while in-flight
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.byIcon(Icons.add_rounded), findsNothing);

      // Complete the cart addition
      completer.complete(
        const Right(
          CartItemEntity(
            cartId: 1,
            productId: 10,
            quantity: 1,
            isDeleted: false,
          ),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // Verify button resets and snackbar appears
      expect(find.byIcon(Icons.add_rounded), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.text('Added to your bag'), findsOneWidget);
    },
  );

  testWidgets('Shows error SnackBar when cart addition fails', (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    mockGetCategoriesUseCase.resultToReturn = const Right([tCategory1]);
    mockGetProductsUseCase.resultToReturn = const Right([tProduct1]);
    mockCartRepository.cartResult = const Left(
      ServerFailure(message: 'Failed to add item to bag'),
    );

    await tester.pumpWidget(buildTestWidget());
    await cubit.loadHomeData();
    await tester.pumpAndSettle();

    final addButton = find.byIcon(Icons.add_rounded).first;
    await tester.tap(addButton);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('Failed to add item to bag'), findsOneWidget);
  });

  testWidgets('Bottom nav bar switches tab when tapped', (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    mockGetCategoriesUseCase.resultToReturn = const Right([]);
    mockGetProductsUseCase.resultToReturn = const Right([]);

    await tester.pumpWidget(buildTestWidget());
    await cubit.loadHomeData();
    await tester.pumpAndSettle();

    expect(find.text('Browse'), findsOneWidget);
    await tester.tap(find.text('Browse'));
    await tester.pumpAndSettle();
  });

  testWidgets('Displays empty state message when no products match', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    mockGetCategoriesUseCase.resultToReturn = const Right([]);
    mockGetProductsUseCase.resultToReturn = const Right([]);

    await tester.pumpWidget(buildTestWidget());
    await cubit.loadHomeData();
    await tester.pumpAndSettle();

    expect(find.text('No products found'), findsOneWidget);
  });

  testWidgets('Shows error SnackBar when an error occurs', (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    mockGetCategoriesUseCase.resultToReturn = const Left(
      ServerFailure(message: 'Failed to load catalog'),
    );
    mockGetProductsUseCase.resultToReturn = const Right([]);

    await tester.pumpWidget(buildTestWidget());
    await cubit.loadHomeData();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('Failed to load catalog'), findsOneWidget);
  });

  testWidgets(
    'Tapping sort button opens bottom sheet and updates sort option',
    (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      mockGetCategoriesUseCase.resultToReturn = const Right([
        tCategory1,
        tCategory2,
      ]);
      mockGetProductsUseCase.resultToReturn = const Right([
        tProduct1,
        tProduct2,
      ]);

      await tester.pumpWidget(buildTestWidget());
      await cubit.loadHomeData();
      await tester.pumpAndSettle();

      expect(find.text('Sort by: Curated'), findsOneWidget);

      // Tap sort button
      await tester.tap(find.text('Sort by: Curated'));
      await tester.pumpAndSettle();

      // Verify bottom sheet content
      expect(find.text('Sort Products'), findsOneWidget);
      expect(find.text('Price: Low to High'), findsOneWidget);
      expect(find.text('Price: High to Low'), findsOneWidget);
      expect(find.text('Top Rated'), findsOneWidget);

      // Tap 'Price: Low to High'
      await tester.tap(find.text('Price: Low to High'));
      await tester.pumpAndSettle();

      // Verify sort state updated
      expect(cubit.state.sortOption, ProductSortOption.priceLowToHigh);
      expect(find.text('Price: Low to High'), findsOneWidget);
    },
  );
}
