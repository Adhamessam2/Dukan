import 'package:flutter_test/flutter_test.dart';
import 'package:Dukan/core/api/api_consumer.dart';
import 'package:Dukan/core/api/server_strings.dart';
import 'package:Dukan/core/errors/exceptions.dart';
import 'package:Dukan/features/product_details/data/datasources/product_details_remote_data_source.dart';

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
  late MockApiConsumer mockApiConsumer;
  late ProductDetailsRemoteDataSourceImpl dataSource;

  setUp(() {
    mockApiConsumer = MockApiConsumer();
    dataSource = ProductDetailsRemoteDataSourceImpl(
      apiConsumer: mockApiConsumer,
    );
  });

  test(
    'getProductById calls ApiConsumer.get with ServerStrings.productById and returns ProductModel',
    () async {
      mockApiConsumer.responseToReturn = {
        'success': true,
        'statusCode': 200,
        'data': {'id': 10, 'productName': 'iPhone 14 Pro', 'price': '999.99'},
      };

      final result = await dataSource.getProductById(10);

      expect(mockApiConsumer.calledPath, ServerStrings.productById(10));
      expect(result.id, 10);
      expect(result.productName, 'iPhone 14 Pro');
      expect(result.price, 999.99);
    },
  );

  test(
    'getProductById throws NotFoundException when statusCode is 404',
    () async {
      mockApiConsumer.responseToReturn = {
        'success': false,
        'statusCode': 404,
        'message': 'Product not found',
      };

      expect(
        () => dataSource.getProductById(10),
        throwsA(isA<NotFoundException>()),
      );
    },
  );

  test('getProductById throws ParseException when data is invalid', () async {
    mockApiConsumer.responseToReturn = {'success': true, 'data': 'invalid'};

    expect(() => dataSource.getProductById(10), throwsA(isA<ParseException>()));
  });
}
