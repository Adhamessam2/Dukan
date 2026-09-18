import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:Dukan/core/errors/failure.dart';
import 'package:Dukan/core/usecases/usecase.dart';
import 'package:Dukan/features/home/domain/entities/category_entity.dart';
import 'package:Dukan/features/home/domain/entities/product_entity.dart';
import 'package:Dukan/features/home/domain/repositories/home_repository.dart';
import 'package:Dukan/features/home/domain/usecases/get_categories_use_case.dart';

class MockHomeRepository implements HomeRepository {
  Either<Failure, List<CategoryEntity>>? resultToReturn;

  @override
  Future<Either<Failure, List<CategoryEntity>>> getCategories() async {
    return resultToReturn!;
  }

  @override
  Future<Either<Failure, List<ProductEntity>>> getProducts() =>
      throw UnimplementedError();

  @override
  Future<Either<Failure, CategoryEntity>> getCategoryById(int id) =>
      throw UnimplementedError();

  @override
  Future<Either<Failure, ProductEntity>> getProductById(int id) =>
      throw UnimplementedError();
}

void main() {
  late GetCategoriesUseCase useCase;
  late MockHomeRepository mockRepository;

  setUp(() {
    mockRepository = MockHomeRepository();
    useCase = GetCategoriesUseCase(mockRepository);
  });

  const tCategory = CategoryEntity(
    id: 1,
    categoryName: 'Electronics & Smart Devices 🎧',
    parentId: null,
    subCategories: [],
  );

  test('should return list of CategoryEntity on success', () async {
    mockRepository.resultToReturn = const Right([tCategory]);

    final result = await useCase(const NoParams());

    expect(result, const Right([tCategory]));
  });

  test('should return ServerFailure when repository fails', () async {
    const tFailure = ServerFailure(
      message: 'Failed to fetch categories',
      code: 500,
    );
    mockRepository.resultToReturn = const Left(tFailure);

    final result = await useCase(const NoParams());

    expect(result, const Left(tFailure));
  });
}
