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
import 'package:Dukan/features/home/domain/entities/category_entity.dart';
import 'package:Dukan/features/home/domain/entities/product_entity.dart';
import 'package:Dukan/features/home/domain/entities/product_image_entity.dart';
import 'package:Dukan/features/product_details/domain/repositories/product_details_repository.dart';
import 'package:Dukan/features/product_details/domain/usecases/get_product_by_id_use_case.dart';
import 'package:Dukan/features/product_details/presentation/cubit/product_details_cubit.dart';
import 'package:Dukan/features/product_details/presentation/views/product_details_screen.dart';
import 'package:Dukan/features/product_details/presentation/widgets/product_details_bottom_bar.dart';
import 'package:Dukan/features/product_details/presentation/widgets/product_details_header.dart';
import 'package:Dukan/features/product_details/presentation/widgets/product_image_gallery.dart';
import 'package:Dukan/features/product_details/presentation/widgets/product_info_section.dart';

class MockProductDetailsRepository implements ProductDetailsRepository {
  Either<Failure, ProductEntity>? productResult;

  @override
  Future<Either<Failure, ProductEntity>> getProductById(int id) async {
    return productResult!;
  }
}

class MockCartRepository implements CartRepository {
  Either<Failure, CartItemEntity>? cartResult;

  @override
  Future<Either<Failure, CartItemEntity>> addToCart({
    required int productId,
    required int quantity,
  }) async {
    return cartResult ??
        const Right(
          CartItemEntity(
            cartId: 1,
            productId: 1,
            quantity: 1,
            isDeleted: false,
          ),
        );
  }

  @override
  Future<Either<Failure, CartEntity>> getCart() async {
    return const Right(CartEntity(id: 1, items: [], totalPrice: 0));
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
  late ProductDetailsCubit cubit;
  late MockProductDetailsRepository mockRepository;
  late GetProductByIdUseCase getProductByIdUseCase;
  late CartCubit cartCubit;
  late MockCartRepository mockCartRepository;
  late AddToCartUseCase addToCartUseCase;

  const tCategory = CategoryEntity(
    id: 4,
    categoryName: 'Smartphones & 5G Tablets',
    parent: CategoryEntity(id: 1, categoryName: 'Electronics & Smart Devices'),
  );

  const tImages = [
    ProductImageEntity(
      id: 'img1',
      productId: 1,
      url: 'https://example.com/front.jpg',
      isPrimary: true,
    ),
    ProductImageEntity(
      id: 'img2',
      productId: 1,
      url: 'https://example.com/back.jpg',
      isPrimary: false,
    ),
  ];

  const tProduct = ProductEntity(
    id: 1,
    productName: 'Refurbished iPhone 14 Pro - 128GB (DEEP PURPLE)',
    productDescription:
        'Condition: Like New! Contains <b>minor micro-scratches</b> on bezel.\nIncludes charging cable & 1-year seller warranty.',
    sku: 'SKU-IPH14P-128-PURPLE#01',
    stockQuantity: 3,
    price: 999.99,
    avgRating: 4.5,
    totalReviews: 2,
    category: tCategory,
    productImages: tImages,
  );

  setUp(() {
    mockRepository = MockProductDetailsRepository();
    getProductByIdUseCase = GetProductByIdUseCase(mockRepository);
    cubit = ProductDetailsCubit(getProductByIdUseCase: getProductByIdUseCase);

    mockCartRepository = MockCartRepository();
    addToCartUseCase = AddToCartUseCase(mockCartRepository);
    final getCartUseCase = GetCartUseCase(mockCartRepository);
    final getCartItemUseCase = GetCartItemUseCase(mockCartRepository);
    final updateCartItemUseCase = UpdateCartItemUseCase(mockCartRepository);
    final deleteCartItemUseCase = DeleteCartItemUseCase(mockCartRepository);
    final clearCartUseCase = ClearCartUseCase(mockCartRepository);
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
            BlocProvider<ProductDetailsCubit>.value(value: cubit),
            BlocProvider<CartCubit>.value(value: cartCubit),
          ],
          child: const ProductDetailsScreen(),
        ),
      ),
    );
  }

  testWidgets('renders all product details and sections on success', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    mockRepository.productResult = const Right(tProduct);

    await tester.pumpWidget(buildTestWidget());
    await cubit.loadProductDetails(1, initialProduct: tProduct);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.byType(ProductDetailsHeader), findsOneWidget);
    expect(find.byType(ProductImageGallery), findsOneWidget);
    expect(find.byType(ProductInfoSection), findsOneWidget);
    expect(find.byType(ProductDetailsBottomBar), findsOneWidget);

    expect(find.text('Product Details'), findsOneWidget);
    expect(
      find.text('Refurbished iPhone 14 Pro - 128GB (DEEP PURPLE)'),
      findsOneWidget,
    );
    expect(
      find.text('Electronics & Smart Devices > Smartphones & 5G Tablets'),
      findsOneWidget,
    );
    expect(find.text('SKU: SKU-IPH14P-128-PURPLE#01'), findsOneWidget);
    expect(find.text('\$999.99'), findsOneWidget);
    expect(find.text('In Stock (3 left)'), findsOneWidget);
    expect(find.text('4.5'), findsOneWidget);
    expect(find.text('(2 reviews)'), findsOneWidget);
    expect(find.text('Add to Bag • \$999.99'), findsOneWidget);
  });

  testWidgets(
    'quantity stepper increments and decrements quantity and updates total price',
    (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      mockRepository.productResult = const Right(tProduct);

      await tester.pumpWidget(buildTestWidget());
      await cubit.loadProductDetails(1, initialProduct: tProduct);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('1'), findsOneWidget);
      expect(find.text('Add to Bag • \$999.99'), findsOneWidget);

      // Tap + to increment
      await tester.tap(find.byIcon(Icons.add_rounded));
      await tester.pump();

      expect(find.text('2'), findsOneWidget);
      expect(find.text('Add to Bag • \$1999.98'), findsOneWidget);

      // Tap - to decrement
      await tester.tap(find.byIcon(Icons.remove_rounded));
      await tester.pump();

      expect(find.text('1'), findsOneWidget);
      expect(find.text('Add to Bag • \$999.99'), findsOneWidget);
    },
  );

  testWidgets('tapping Add to Bag triggers snackbar', (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    mockRepository.productResult = const Right(tProduct);

    await tester.pumpWidget(buildTestWidget());
    await cubit.loadProductDetails(1, initialProduct: tProduct);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    final addButton = find.text('Add to Bag • \$999.99');
    await tester.tap(addButton);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('Added to your bag'), findsOneWidget);
  });

  testWidgets('displays error view on failure when product is null', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    mockRepository.productResult = const Left(
      ServerFailure(message: 'Product not found', code: 404),
    );

    await tester.pumpWidget(buildTestWidget());
    await cubit.loadProductDetails(1);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('Product not found'), findsNWidgets(2));
    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('Go Back'), findsOneWidget);
  });
}
