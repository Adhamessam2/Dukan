import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failure.dart';
import '../entities/category_entity.dart';
import '../entities/product_entity.dart';

/// Contract for Home feature data operations
abstract class HomeRepository {
  Future<Either<Failure, List<CategoryEntity>>> getCategories();
  Future<Either<Failure, List<ProductEntity>>> getProducts();
  Future<Either<Failure, CategoryEntity>> getCategoryById(int id);
  Future<Either<Failure, ProductEntity>> getProductById(int id);
}
