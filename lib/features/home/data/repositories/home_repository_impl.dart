import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/error_mapper.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/home_repository.dart';
import '../datasources/home_remote_data_source.dart';

/// Implementation of [HomeRepository] coordinating remote operations and error mapping
class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  HomeRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<CategoryEntity>>> getCategories() async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final response = await remoteDataSource.getCategories();
      if (!response.success) {
        return Left(
          ServerFailure(
            message: response.message ?? 'Failed to fetch categories',
            code: response.statusCode,
          ),
        );
      }
      return Right(List<CategoryEntity>.unmodifiable(response.data));
    } catch (e) {
      return Left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, List<ProductEntity>>> getProducts() async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final response = await remoteDataSource.getProducts();
      if (!response.success) {
        return Left(
          ServerFailure(
            message: response.message ?? 'Failed to fetch products',
            code: response.statusCode,
          ),
        );
      }
      return Right(List<ProductEntity>.unmodifiable(response.data));
    } catch (e) {
      return Left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, CategoryEntity>> getCategoryById(int id) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final category = await remoteDataSource.getCategoryById(id);
      return Right(category);
    } catch (e) {
      return Left(mapExceptionToFailure(e));
    }
  }
}
