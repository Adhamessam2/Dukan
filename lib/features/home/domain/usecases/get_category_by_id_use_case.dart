import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/category_entity.dart';
import '../repositories/home_repository.dart';

/// Use case for fetching a single category by ID
class GetCategoryByIdUseCase implements UseCase<CategoryEntity, int> {
  final HomeRepository repository;

  GetCategoryByIdUseCase(this.repository);

  @override
  Future<Either<Failure, CategoryEntity>> call(int params) {
    if (params <= 0) {
      return Future.value(
        const Left(ValidationFailure(message: 'Invalid category ID')),
      );
    }
    return repository.getCategoryById(params);
  }
}
