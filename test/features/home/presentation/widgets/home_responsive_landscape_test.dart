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

  Widget buildLandscapeTestWidget(Widget child) {
    return OrientationBuilder(
      builder: (context, orientation) {
        return ScreenUtilInit(
          designSize: orientation == Orientation.landscape
              ? const Size(812, 375)
              : const Size(375, 812),
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (context, _) => MaterialApp(
            theme: AppTheme.lightTheme,
            home: Scaffold(body: child),
          ),
        );
      },
    );
  }

  testWidgets('HomeBottomNavBar renders without overflow in landscape orientation', (tester) async {
    // Landscape physical size (e.g. 812x375 logical pixels)
    tester.view.physicalSize = const Size(1624, 750);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(
      buildLandscapeTestWidget(
        const HomeBottomNavBar(
          selectedIndex: 0,
          cartItemCount: 2,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Browse'), findsOneWidget);
    expect(find.text('Cart'), findsOneWidget);
    expect(find.text('Orders'), findsOneWidget);
  });

  testWidgets('HomeCategoryChips renders without vertical clipping in landscape orientation', (tester) async {
    tester.view.physicalSize = const Size(1624, 750);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    mockGetCategoriesUseCase.resultToReturn = const Right([tCategory1, tCategory2]);
    mockGetProductsUseCase.resultToReturn = const Right([tProduct1]);

    await tester.pumpWidget(
      buildLandscapeTestWidget(
        BlocProvider<HomeCubit>.value(
          value: cubit,
          child: const HomeCategoryChips(),
        ),
      ),
    );
    await cubit.loadHomeData();
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('All'), findsOneWidget);
    expect(find.text('Electronics'), findsOneWidget);
    expect(find.text('Fashion'), findsOneWidget);
  });

  testWidgets('HomeScreen renders entire screen without overflow in landscape orientation', (tester) async {
    tester.view.physicalSize = const Size(1624, 750);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    mockGetCategoriesUseCase.resultToReturn = const Right([tCategory1, tCategory2]);
    mockGetProductsUseCase.resultToReturn = const Right([tProduct1]);

    await tester.pumpWidget(
      buildLandscapeTestWidget(
        BlocProvider<HomeCubit>.value(
          value: cubit,
          child: const HomeScreen(),
        ),
      ),
    );
    await cubit.loadHomeData();
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('Dukaan'), findsOneWidget);
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Browse'), findsOneWidget);
    expect(find.text('Cart'), findsOneWidget);
    expect(find.text('Orders'), findsOneWidget);
  });
}
