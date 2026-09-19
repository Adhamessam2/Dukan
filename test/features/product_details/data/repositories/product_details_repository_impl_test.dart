import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:Dukan/core/errors/exceptions.dart';
import 'package:Dukan/core/errors/failure.dart';
import 'package:Dukan/core/network/network_info.dart';
import 'package:Dukan/features/home/data/models/product_model.dart';
import 'package:Dukan/features/product_details/data/datasources/product_details_remote_data_source.dart';
import 'package:Dukan/features/product_details/data/repositories/product_details_repository_impl.dart';

class MockProductDetailsRemoteDataSource
    implements ProductDetailsRemoteDataSource {
  ProductModel? productToReturn;
  Exception? exceptionToThrow;

  @override
  Future<ProductModel> getProductById(int id) async {
    if (exceptionToThrow != null) {
      throw exceptionToThrow!;
    }
    return productToReturn!;
  }
}

class MockNetworkInfo implements NetworkInfo {
  bool isConnectedValue = true;

  @override
  Future<bool> get isConnected async => isConnectedValue;

  @override
  Stream<InternetStatus> get onStatusChange => throw UnimplementedError();
}

void main() {
  late ProductDetailsRepositoryImpl repository;
  late MockProductDetailsRemoteDataSource mockRemoteDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockProductDetailsRemoteDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = ProductDetailsRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  group('getProductById', () {
    const tProductId = 10;
    const tProductModel = ProductModel(
      id: tProductId,
      productName: 'iPhone 14',
      price: 999.0,
    );

    test('should return NetworkFailure when device is offline', () async {
      mockNetworkInfo.isConnectedValue = false;

      final result = await repository.getProductById(tProductId);

      expect(result, const Left(NetworkFailure()));
    });

    test(
      'should return ProductEntity when remoteDataSource returns successfully',
      () async {
        mockNetworkInfo.isConnectedValue = true;
        mockRemoteDataSource.productToReturn = tProductModel;

        final result = await repository.getProductById(tProductId);

        expect(result, const Right(tProductModel));
      },
    );

    test(
      'should return ServerFailure when remoteDataSource throws ServerException',
      () async {
        mockNetworkInfo.isConnectedValue = true;
        mockRemoteDataSource.exceptionToThrow = ServerException(
          message: 'Product not found',
          statusCode: 404,
        );

        final result = await repository.getProductById(tProductId);

        expect(
          result,
          const Left(ServerFailure(message: 'Product not found', code: 404)),
        );
      },
    );
  });
}
