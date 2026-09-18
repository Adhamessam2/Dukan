import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:Dukan/core/errors/failure.dart';
import 'package:Dukan/core/usecases/usecase.dart';
import 'package:Dukan/features/home/domain/entities/category_entity.dart';
import 'package:Dukan/features/home/domain/entities/product_entity.dart';
import 'package:Dukan/features/home/domain/repositories/home_repository.dart';
import 'package:Dukan/features/home/domain/usecases/get_products_use_case.dart';

class MockHomeRepository implements HomeRepository {
  Either<Failure, List<CategoryEntity>>? categoriesResult;
  Either<Failure, List<ProductEntity>>? productsResult;

  @override
  Future<Either<Failure, List<CategoryEntity>>> getCategories() async {
    return categoriesResult!;
  }

  @override
  Future<Either<Failure, List<ProductEntity>>> getProducts() async {
    return productsResult!;
  }

  @override
  Future<Either<Failure, CategoryEntity>> getCategoryById(int id) =>
      throw UnimplementedError();

  @override
  Future<Either<Failure, ProductEntity>> getProductById(int id) =>
      throw UnimplementedError();
}

void main() {
  late GetProductsUseCase useCase;
  late MockHomeRepository mockRepository;

  setUp(() {
    mockRepository = MockHomeRepository();
    useCase = GetProductsUseCase(mockRepository);
  });

  const tProduct = ProductEntity(
    id: 1,
    productName: 'iPhone 14 Pro',
    price: 999.99,
  );

  test('should return list of ProductEntity on success', () async {
    mockRepository.productsResult = const Right([tProduct]);

    final result = await useCase(const NoParams());

    expect(result, const Right([tProduct]));
  });

  test('should return ServerFailure when repository fails', () async {
    const tFailure = ServerFailure(
      message: 'Failed to fetch products',
      code: 500,
    );
    mockRepository.productsResult = const Left(tFailure);

    final result = await useCase(const NoParams());

    expect(result, const Left(tFailure));
  });
}
