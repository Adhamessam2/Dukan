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
import 'package:Dukan/features/home/presentation/views/home_screen.dart';
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

void main() {
  late MockGetCategoriesUseCase mockGetCategoriesUseCase;
  late MockGetProductsUseCase mockGetProductsUseCase;
  late HomeCubit cubit;

  const tCategory1 = CategoryEntity(id: 1, categoryName: 'Electronics');
  const tCategory2 = CategoryEntity(id: 2, categoryName: 'Fashion');
  const tProduct1 = ProductEntity(
    id: 10,
    productName: 'iPhone 14 Pro',
    price: 999.0,
    avgRating: 4.8,
    category: tCategory1,
  );
  const tProduct2 = ProductEntity(
    id: 20,
    productName: 'Leather Boots',
    price: 150.0,
    avgRating: 4.2,
    category: tCategory2,
  );

  setUp(() {
    mockGetCategoriesUseCase = MockGetCategoriesUseCase();
    mockGetProductsUseCase = MockGetProductsUseCase();
    cubit = HomeCubit(
      getCategoriesUseCase: mockGetCategoriesUseCase,
      getProductsUseCase: mockGetProductsUseCase,
    );
  });

  tearDown(() {
    cubit.close();
  });

  Widget buildTestWidget() {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) => MaterialApp(
        theme: AppTheme.lightTheme,
        home: BlocProvider<HomeCubit>.value(
          value: cubit,
          child: const HomeScreen(),
        ),
      ),
    );
  }

  testWidgets('HomeScreen renders all primary sections', (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    mockGetCategoriesUseCase.resultToReturn = const Right([tCategory1, tCategory2]);
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

    mockGetCategoriesUseCase.resultToReturn = const Right([tCategory1, tCategory2]);
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

    mockGetCategoriesUseCase.resultToReturn = const Right([tCategory1, tCategory2]);
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

    expect(find.text('Added iPhone 14 Pro to your bag'), findsOneWidget);
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

  testWidgets('Displays empty state message when no products match', (tester) async {
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

    mockGetCategoriesUseCase.resultToReturn =
        const Left(ServerFailure(message: 'Failed to load catalog'));
    mockGetProductsUseCase.resultToReturn = const Right([]);

    await tester.pumpWidget(buildTestWidget());
    await cubit.loadHomeData();
    await tester.pumpAndSettle();

    expect(find.text('Failed to load catalog'), findsOneWidget);
  });

  testWidgets('Tapping sort button opens sort options bottom sheet', (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    mockGetCategoriesUseCase.resultToReturn = const Right([]);
    mockGetProductsUseCase.resultToReturn = const Right([]);

    await tester.pumpWidget(buildTestWidget());
    await cubit.loadHomeData();
    await tester.pumpAndSettle();

    expect(find.text('Sort by: Curated'), findsOneWidget);
    await tester.tap(find.text('Sort by: Curated'));
    await tester.pumpAndSettle();

    expect(find.text('Sort Products'), findsOneWidget);
    expect(find.text('Price: Low to High'), findsOneWidget);
    expect(find.text('Price: High to Low'), findsOneWidget);
    expect(find.text('Top Rated'), findsOneWidget);
  });
}
