import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/category_entity.dart';
import '../repositories/home_repository.dart';

/// Use case for fetching the category hierarchy
class GetCategoriesUseCase implements UseCase<List<CategoryEntity>, NoParams> {
  final HomeRepository repository;

  GetCategoriesUseCase(this.repository);

  @override
  Future<Either<Failure, List<CategoryEntity>>> call(NoParams params) {
    return repository.getCategories();
  }
}
