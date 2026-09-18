import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:Dukan/core/errors/failure.dart';
import 'package:Dukan/features/home/domain/entities/category_entity.dart';
import 'package:Dukan/features/home/domain/entities/product_entity.dart';
import 'package:Dukan/features/home/domain/repositories/home_repository.dart';
import 'package:Dukan/features/home/domain/usecases/get_category_by_id_use_case.dart';

class MockHomeRepository implements HomeRepository {
  Either<Failure, CategoryEntity>? categoryResult;

  @override
  Future<Either<Failure, List<CategoryEntity>>> getCategories() =>
      throw UnimplementedError();

  @override
  Future<Either<Failure, List<ProductEntity>>> getProducts() =>
      throw UnimplementedError();

  @override
  Future<Either<Failure, CategoryEntity>> getCategoryById(int id) async {
    return categoryResult!;
  }

  @override
  Future<Either<Failure, ProductEntity>> getProductById(int id) =>
      throw UnimplementedError();
}

void main() {
  late GetCategoryByIdUseCase useCase;
  late MockHomeRepository mockRepository;

  setUp(() {
    mockRepository = MockHomeRepository();
    useCase = GetCategoryByIdUseCase(mockRepository);
  });

  const tCategoryId = 1;
  const tCategory = CategoryEntity(
    id: tCategoryId,
    categoryName: 'Electronics',
  );

  test('should return CategoryEntity from repository', () async {
    mockRepository.categoryResult = const Right(tCategory);

    final result = await useCase(tCategoryId);

    expect(result, const Right(tCategory));
  });

  test('should return Failure when repository fails', () async {
    mockRepository.categoryResult =
        const Left(ServerFailure(message: 'Category not found', code: 404));

    final result = await useCase(tCategoryId);

    expect(
      result,
      const Left(ServerFailure(message: 'Category not found', code: 404)),
    );
  });

  test('should return ValidationFailure when category ID is <= 0', () async {
    final result = await useCase(0);

    expect(
      result,
      const Left(ValidationFailure(message: 'Invalid category ID')),
    );
  });
}
