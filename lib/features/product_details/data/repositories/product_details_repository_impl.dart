import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/error_mapper.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/network/network_info.dart';
import '../../../home/domain/entities/product_entity.dart';
import '../../domain/repositories/product_details_repository.dart';
import '../datasources/product_details_remote_data_source.dart';

/// Concrete implementation of ProductDetailsRepository
class ProductDetailsRepositoryImpl implements ProductDetailsRepository {
  final ProductDetailsRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  ProductDetailsRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, ProductEntity>> getProductById(int id) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final product = await remoteDataSource.getProductById(id);
      return Right(product);
    } catch (e) {
      return Left(mapExceptionToFailure(e));
    }
  }
}
