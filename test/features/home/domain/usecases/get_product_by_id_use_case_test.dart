import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:Dukan/core/errors/failure.dart';
import 'package:Dukan/features/home/domain/entities/category_entity.dart';
import 'package:Dukan/features/home/domain/entities/product_entity.dart';
import 'package:Dukan/features/home/domain/repositories/home_repository.dart';
import 'package:Dukan/features/home/domain/usecases/get_product_by_id_use_case.dart';

class MockHomeRepository implements HomeRepository {
  Either<Failure, ProductEntity>? productResult;

  @override
  Future<Either<Failure, List<CategoryEntity>>> getCategories() =>
      throw UnimplementedError();

  @override
  Future<Either<Failure, List<ProductEntity>>> getProducts() =>
      throw UnimplementedError();

  @override
  Future<Either<Failure, CategoryEntity>> getCategoryById(int id) =>
      throw UnimplementedError();

  @override
  Future<Either<Failure, ProductEntity>> getProductById(int id) async {
    return productResult!;
  }
}

void main() {
  late GetProductByIdUseCase useCase;
  late MockHomeRepository mockRepository;

  setUp(() {
    mockRepository = MockHomeRepository();
    useCase = GetProductByIdUseCase(mockRepository);
  });

  const tProductId = 10;
  const tProduct = ProductEntity(
    id: tProductId,
    productName: 'iPhone 14',
    price: 999.0,
  );

  test('should return ProductEntity from repository', () async {
    mockRepository.productResult = const Right(tProduct);

    final result = await useCase(tProductId);

    expect(result, const Right(tProduct));
  });

  test('should return Failure when repository fails', () async {
    mockRepository.productResult =
        const Left(ServerFailure(message: 'Product not found', code: 404));

    final result = await useCase(tProductId);

    expect(
      result,
      const Left(ServerFailure(message: 'Product not found', code: 404)),
    );
  });

  test('should return ValidationFailure when product ID is <= 0', () async {
    final result = await useCase(0);

    expect(
      result,
      const Left(ValidationFailure(message: 'Invalid product ID')),
    );
  });
}
