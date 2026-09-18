import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:Dukan/core/errors/exceptions.dart';
import 'package:Dukan/core/errors/failure.dart';
import 'package:Dukan/core/network/network_info.dart';
import 'package:Dukan/features/home/data/datasources/home_remote_data_source.dart';
import 'package:Dukan/features/home/data/models/categories_response_model.dart';
import 'package:Dukan/features/home/data/models/category_model.dart';
import 'package:Dukan/features/home/data/models/products_response_model.dart';
import 'package:Dukan/features/home/data/models/product_model.dart';
import 'package:Dukan/features/home/data/repositories/home_repository_impl.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class MockHomeRemoteDataSource implements HomeRemoteDataSource {
  CategoriesResponseModel? responseToReturn;
  Exception? exceptionToThrow;
  ProductsResponseModel? productsResponseToReturn;
  Exception? productsExceptionToThrow;
  CategoryModel? singleCategoryToReturn;
  Exception? singleCategoryExceptionToThrow;
  ProductModel? singleProductToReturn;
  Exception? singleProductExceptionToThrow;

  @override
  Future<CategoriesResponseModel> getCategories() async {
    if (exceptionToThrow != null) throw exceptionToThrow!;
    return responseToReturn!;
  }

  @override
  Future<ProductsResponseModel> getProducts() async {
    if (productsExceptionToThrow != null) throw productsExceptionToThrow!;
    return productsResponseToReturn!;
  }

  @override
  Future<CategoryModel> getCategoryById(int id) async {
    if (singleCategoryExceptionToThrow != null) {
      throw singleCategoryExceptionToThrow!;
    }
    return singleCategoryToReturn!;
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
  late HomeRepositoryImpl repository;
  late MockHomeRemoteDataSource mockRemoteDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockHomeRemoteDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = HomeRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  const tCategoryModel = CategoryModel(
    id: 1,
    categoryName: 'Electronics & Smart Devices 🎧',
    parentId: null,
    subCategories: [],
  );

  test('should return NetworkFailure when offline', () async {
    mockNetworkInfo.isConnectedValue = false;

    final result = await repository.getCategories();

    expect(result, const Left(NetworkFailure()));
  });

  test('should return list of categories when request is successful', () async {
    mockNetworkInfo.isConnectedValue = true;
    mockRemoteDataSource.responseToReturn = const CategoriesResponseModel(
      success: true,
      statusCode: 200,
      data: [tCategoryModel],
    );

    final result = await repository.getCategories();

    expect(result.isRight(), isTrue);
    result.fold(
      (failure) => fail('Expected Right but got $failure'),
      (categories) => expect(categories, [tCategoryModel]),
    );
  });

  test(
    'should return ServerFailure when remote response success is false',
    () async {
      mockNetworkInfo.isConnectedValue = true;
      mockRemoteDataSource.responseToReturn = const CategoriesResponseModel(
        success: false,
        statusCode: 400,
        data: [],
        message: 'Bad Request',
      );

      final result = await repository.getCategories();

      expect(
        result,
        const Left(ServerFailure(message: 'Bad Request', code: 400)),
      );
    },
  );

  test(
    'should return ServerFailure when remoteDataSource throws ServerException',
    () async {
      mockNetworkInfo.isConnectedValue = true;
      mockRemoteDataSource.exceptionToThrow = ServerException(
        message: 'Server error',
        statusCode: 500,
      );

      final result = await repository.getCategories();

      expect(
        result,
        const Left(ServerFailure(message: 'Server error', code: 500)),
      );
    },
  );

  test(
    'should return ParseFailure when remoteDataSource throws ParseException',
    () async {
      mockNetworkInfo.isConnectedValue = true;
      mockRemoteDataSource.exceptionToThrow = ParseException(
        message: 'Invalid response format',
      );

      final result = await repository.getCategories();

      expect(
        result,
        const Left(ParseFailure(message: 'Invalid response format')),
      );
    },
  );

  group('getProducts', () {
    const tProductModel = ProductModel(
      id: 1,
      productName: 'iPhone 14 Pro',
      price: 999.99,
    );

    test('should return NetworkFailure when offline', () async {
      mockNetworkInfo.isConnectedValue = false;

      final result = await repository.getProducts();

      expect(result, const Left(NetworkFailure()));
    });

    test('should return list of products when request is successful', () async {
      mockNetworkInfo.isConnectedValue = true;
      mockRemoteDataSource.productsResponseToReturn =
          const ProductsResponseModel(
            success: true,
            statusCode: 200,
            data: [tProductModel],
          );

      final result = await repository.getProducts();

      expect(result.isRight(), isTrue);
      result.fold(
        (failure) => fail('Expected Right but got $failure'),
        (products) => expect(products, [tProductModel]),
      );
    });

    test(
      'should return ServerFailure when remote response success is false',
      () async {
        mockNetworkInfo.isConnectedValue = true;
        mockRemoteDataSource.productsResponseToReturn =
            const ProductsResponseModel(
              success: false,
              statusCode: 400,
              data: [],
              message: 'Bad Request',
            );

        final result = await repository.getProducts();

        expect(
          result,
          const Left(ServerFailure(message: 'Bad Request', code: 400)),
        );
      },
    );

    test(
      'should return ServerFailure when remoteDataSource throws ServerException',
      () async {
        mockNetworkInfo.isConnectedValue = true;
        mockRemoteDataSource.productsExceptionToThrow = ServerException(
          message: 'Server error',
          statusCode: 500,
        );

        final result = await repository.getProducts();

        expect(
          result,
          const Left(ServerFailure(message: 'Server error', code: 500)),
        );
      },
    );
  });

  group('getCategoryById', () {
    const tCategoryId = 1;
    const tCategoryModel = CategoryModel(
      id: tCategoryId,
      categoryName: 'Electronics',
    );

    test('should return NetworkFailure when device is offline', () async {
      mockNetworkInfo.isConnectedValue = false;

      final result = await repository.getCategoryById(tCategoryId);

      expect(result, const Left(NetworkFailure()));
    });

    test(
      'should return CategoryEntity when remoteDataSource returns successfully',
      () async {
        mockNetworkInfo.isConnectedValue = true;
        mockRemoteDataSource.singleCategoryToReturn = tCategoryModel;

        final result = await repository.getCategoryById(tCategoryId);

        expect(result, const Right(tCategoryModel));
      },
    );

    test(
      'should return ServerFailure when remoteDataSource throws ServerException',
      () async {
        mockNetworkInfo.isConnectedValue = true;
        mockRemoteDataSource.singleCategoryExceptionToThrow = ServerException(
          message: 'Category not found',
          statusCode: 404,
        );

        final result = await repository.getCategoryById(tCategoryId);

        expect(
          result,
          const Left(ServerFailure(message: 'Category not found', code: 404)),
        );
      },
    );
  });

}
