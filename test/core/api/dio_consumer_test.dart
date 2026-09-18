import 'package:Dukan/core/api/dio_consumer.dart';
import 'package:Dukan/core/errors/exceptions.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

class MockDio extends Fake implements Dio {
  @override
  Future<Response<T>> post<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    throw DioException(
      requestOptions: RequestOptions(path: path),
      response: Response(
        requestOptions: RequestOptions(path: path),
        statusCode: 422,
        data: {'message': 'Validation failed: Email exists'},
      ),
      type: DioExceptionType.badResponse,
    );
  }
}

void main() {
  test(
    'post should throw ValidationException when status code is 422',
    () async {
      final consumer = DioConsumer(client: MockDio());
      expect(
        () => consumer.post('/test'),
        throwsA(
          isA<ValidationException>().having(
            (e) => e.message,
            'message',
            'Validation failed: Email exists',
          ),
        ),
      );
    },
  );
}
