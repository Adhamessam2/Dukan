import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/product_entity.dart';
import '../repositories/home_repository.dart';

/// Use case for fetching a single product by ID
class GetProductByIdUseCase implements UseCase<ProductEntity, int> {
  final HomeRepository repository;

  GetProductByIdUseCase(this.repository);

  @override
  Future<Either<Failure, ProductEntity>> call(int params) {
    if (params <= 0) {
      return Future.value(
        const Left(ValidationFailure(message: 'Invalid product ID')),
      );
    }
    return repository.getProductById(params);
  }
}
