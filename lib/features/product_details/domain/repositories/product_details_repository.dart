import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failure.dart';
import '../../../home/domain/entities/product_entity.dart';

/// Contract for Product Details repository operations
abstract class ProductDetailsRepository {
  Future<Either<Failure, ProductEntity>> getProductById(int id);
}
