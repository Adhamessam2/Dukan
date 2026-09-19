import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../home/domain/entities/product_entity.dart';
import '../repositories/product_details_repository.dart';

/// Use case for fetching a single product by ID
class GetProductByIdUseCase implements UseCase<ProductEntity, int> {
  final ProductDetailsRepository repository;

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
