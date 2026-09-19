import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:Dukan/core/errors/failure.dart';
import 'package:Dukan/core/usecases/usecase.dart';
import 'package:Dukan/features/home/domain/entities/category_entity.dart';
import 'package:Dukan/features/home/domain/entities/product_entity.dart';
import 'package:Dukan/features/home/domain/repositories/home_repository.dart';
import 'package:Dukan/features/home/domain/usecases/get_categories_use_case.dart';
import 'package:Dukan/features/home/domain/usecases/get_products_use_case.dart';
import 'package:Dukan/features/home/presentation/cubit/home_cubit.dart';
import 'package:Dukan/features/home/presentation/cubit/home_state.dart';

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
  late HomeCubit cubit;
  late MockGetCategoriesUseCase mockGetCategoriesUseCase;
  late MockGetProductsUseCase mockGetProductsUseCase;

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

  const tCategory = CategoryEntity(id: 1, categoryName: 'Electronics');
  const tProduct = ProductEntity(
    id: 10,
    productName: 'iPhone 14',
    price: 999.0,
    category: tCategory,
  );

  test('initial state is correct', () {
    expect(cubit.state, const HomeState());
  });

  test('loadHomeData loads categories and products successfully', () async {
    mockGetCategoriesUseCase.resultToReturn = const Right([tCategory]);
    mockGetProductsUseCase.resultToReturn = const Right([tProduct]);

    await cubit.loadHomeData();

    expect(cubit.state.categoriesStatus, HomeStatus.success);
    expect(cubit.state.productsStatus, HomeStatus.success);
    expect(cubit.state.categories, [tCategory]);
    expect(cubit.state.products, [tProduct]);
  });

  test('loadHomeData handles failures properly', () async {
    mockGetCategoriesUseCase.resultToReturn =
        const Left(ServerFailure(message: 'Server error'));
    mockGetProductsUseCase.resultToReturn =
        const Left(NetworkFailure(message: 'No internet'));

    await cubit.loadHomeData();

    expect(cubit.state.categoriesStatus, HomeStatus.failure);
    expect(cubit.state.productsStatus, HomeStatus.failure);
  });

  test('selectCategory updates selectedCategoryId and filteredProducts', () async {
    mockGetCategoriesUseCase.resultToReturn = const Right([tCategory]);
    mockGetProductsUseCase.resultToReturn = const Right([tProduct]);

    await cubit.loadHomeData();

    cubit.selectCategory(1);
    expect(cubit.state.selectedCategoryId, 1);
    expect(cubit.state.filteredProducts, [tProduct]);

    cubit.selectCategory(999);
    expect(cubit.state.selectedCategoryId, 999);
    expect(cubit.state.filteredProducts, isEmpty);

    cubit.selectCategory(null);
    expect(cubit.state.selectedCategoryId, isNull);
    expect(cubit.state.filteredProducts, [tProduct]);
  });

  test('updateSearchQuery filters products by query', () async {
    mockGetCategoriesUseCase.resultToReturn = const Right([tCategory]);
    mockGetProductsUseCase.resultToReturn = const Right([tProduct]);

    await cubit.loadHomeData();

    cubit.updateSearchQuery('iphone');
    expect(cubit.state.filteredProducts.length, 1);

    cubit.updateSearchQuery('samsung');
    expect(cubit.state.filteredProducts.length, 0);
  });

  test('selectSortOption reorders products properly', () async {
    const p1 = ProductEntity(
      id: 1,
      productName: 'Cheap Phone',
      price: 100.0,
      avgRating: 3.5,
    );
    const p2 = ProductEntity(
      id: 2,
      productName: 'Mid Phone',
      price: 500.0,
      avgRating: 4.8,
    );
    const p3 = ProductEntity(
      id: 3,
      productName: 'Expensive Phone',
      price: 1200.0,
      avgRating: 4.2,
    );

    mockGetCategoriesUseCase.resultToReturn = const Right([]);
    mockGetProductsUseCase.resultToReturn = const Right([p2, p3, p1]);

    await cubit.loadHomeData();

    // Default curated order
    expect(cubit.state.sortOption, ProductSortOption.curated);
    expect(cubit.state.filteredProducts.map((p) => p.id).toList(), [2, 3, 1]);

    // Price: Low to High
    cubit.selectSortOption(ProductSortOption.priceLowToHigh);
    expect(cubit.state.sortOption, ProductSortOption.priceLowToHigh);
    expect(cubit.state.filteredProducts.map((p) => p.id).toList(), [1, 2, 3]);

    // Price: High to Low
    cubit.selectSortOption(ProductSortOption.priceHighToLow);
    expect(cubit.state.sortOption, ProductSortOption.priceHighToLow);
    expect(cubit.state.filteredProducts.map((p) => p.id).toList(), [3, 2, 1]);

    // Top Rated
    cubit.selectSortOption(ProductSortOption.topRated);
    expect(cubit.state.sortOption, ProductSortOption.topRated);
    expect(cubit.state.filteredProducts.map((p) => p.id).toList(), [2, 3, 1]);

    // Return to Curated
    cubit.selectSortOption(ProductSortOption.curated);
    expect(cubit.state.sortOption, ProductSortOption.curated);
    expect(cubit.state.filteredProducts.map((p) => p.id).toList(), [2, 3, 1]);
  });
}
