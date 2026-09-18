import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/product_entity.dart';
import '../repositories/home_repository.dart';

/// Use case for fetching products
class GetProductsUseCase implements UseCase<List<ProductEntity>, NoParams> {
  final HomeRepository repository;

  GetProductsUseCase(this.repository);

  @override
  Future<Either<Failure, List<ProductEntity>>> call(NoParams params) {
    return repository.getProducts();
  }
}
