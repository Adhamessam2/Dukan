import 'package:flutter_test/flutter_test.dart';
import 'package:Dukan/core/api/api_consumer.dart';
import 'package:Dukan/core/api/server_strings.dart';
import 'package:Dukan/core/errors/exceptions.dart';
import 'package:Dukan/features/home/data/datasources/home_remote_data_source.dart';

class MockApiConsumer implements ApiConsumer {
  String? calledPath;
  dynamic responseToReturn;

  @override
  Future<dynamic> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    calledPath = path;
    return responseToReturn;
  }

  @override
  Future delete(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) => throw UnimplementedError();
  @override
  Future patch(
    String path, {
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) => throw UnimplementedError();
  @override
  Future post(
    String path, {
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) => throw UnimplementedError();
  @override
  Future put(
    String path, {
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) => throw UnimplementedError();
}

void main() {
  test(
    'getCategories calls ApiConsumer.get with ServerStrings.categories and returns CategoriesResponseModel',
    () async {
      final mockApiConsumer = MockApiConsumer();
      final dataSource = HomeRemoteDataSourceImpl(apiConsumer: mockApiConsumer);

      mockApiConsumer.responseToReturn = {
        'success': true,
        'statusCode': 200,
        'data': [
          {
            'id': 1,
            'categoryName': 'Electronics & Smart Devices 🎧',
            'parentId': null,
            'subCategories': [],
          },
        ],
      };

      final result = await dataSource.getCategories();

      expect(mockApiConsumer.calledPath, ServerStrings.categories);
      expect(result.success, true);
      expect(result.data.length, 1);
      expect(result.data.first.id, 1);
    },
  );

  test(
    'getCategories throws ParseException when response is not a Map',
    () async {
      final mockApiConsumer = MockApiConsumer();
      final dataSource = HomeRemoteDataSourceImpl(apiConsumer: mockApiConsumer);

      mockApiConsumer.responseToReturn = 'not a map';

      expect(() => dataSource.getCategories(), throwsA(isA<ParseException>()));
    },
  );

  test(
    'getProducts calls ApiConsumer.get with ServerStrings.products and returns ProductsResponseModel',
    () async {
      final mockApiConsumer = MockApiConsumer();
      final dataSource = HomeRemoteDataSourceImpl(apiConsumer: mockApiConsumer);

      mockApiConsumer.responseToReturn = {
        'success': true,
        'statusCode': 200,
        'data': [
          {'id': 1, 'productName': 'iPhone 14 Pro', 'price': '999.99'},
        ],
      };

      final result = await dataSource.getProducts();

      expect(mockApiConsumer.calledPath, ServerStrings.products);
      expect(result.success, true);
      expect(result.data.length, 1);
      expect(result.data.first.id, 1);
    },
  );

  test(
    'getProducts throws ParseException when response is not a Map',
    () async {
      final mockApiConsumer = MockApiConsumer();
      final dataSource = HomeRemoteDataSourceImpl(apiConsumer: mockApiConsumer);

      mockApiConsumer.responseToReturn = 'not a map';

      expect(() => dataSource.getProducts(), throwsA(isA<ParseException>()));
    },
  );

  test(
    'getCategoryById calls ApiConsumer.get with ServerStrings.categoryById and returns CategoryModel',
    () async {
      final mockApiConsumer = MockApiConsumer();
      final dataSource = HomeRemoteDataSourceImpl(apiConsumer: mockApiConsumer);

      mockApiConsumer.responseToReturn = {
        'success': true,
        'statusCode': 200,
        'data': {'id': 1, 'categoryName': 'Electronics'},
      };

      final result = await dataSource.getCategoryById(1);

      expect(mockApiConsumer.calledPath, ServerStrings.categoryById(1));
      expect(result.id, 1);
      expect(result.categoryName, 'Electronics');
    },
  );

  test(
    'getCategoryById throws NotFoundException when statusCode is 404',
    () async {
      final mockApiConsumer = MockApiConsumer();
      final dataSource = HomeRemoteDataSourceImpl(apiConsumer: mockApiConsumer);

      mockApiConsumer.responseToReturn = {
        'success': false,
        'statusCode': 404,
        'message': 'Category not found',
      };

      expect(
        () => dataSource.getCategoryById(1),
        throwsA(isA<NotFoundException>()),
      );
    },
  );

  test('getCategoryById throws ParseException when data is invalid', () async {
    final mockApiConsumer = MockApiConsumer();
    final dataSource = HomeRemoteDataSourceImpl(apiConsumer: mockApiConsumer);

    mockApiConsumer.responseToReturn = {'success': true, 'data': 'invalid'};

    expect(() => dataSource.getCategoryById(1), throwsA(isA<ParseException>()));
  });
}
