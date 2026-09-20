import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:Dukan/core/api/server_strings.dart';
import 'package:Dukan/core/errors/error_mapper.dart';
import 'package:Dukan/core/errors/exceptions.dart';
import 'package:Dukan/core/errors/failure.dart';

void main() {
  group('handleDioException', () {
    test(
      'should throw UnauthorizedException (401) when status is 404 with "Invalid Credintials"',
      () {
        final dioException = DioException(
          requestOptions: RequestOptions(path: ServerStrings.login),
          response: Response(
            requestOptions: RequestOptions(path: ServerStrings.login),
            statusCode: 404,
            data: {
              'message': 'Invalid Credintials',
              'error': 'Not Found',
              'statusCode': 404,
            },
          ),
          type: DioExceptionType.badResponse,
        );

        expect(
          () => handleDioException(dioException),
          throwsA(
            isA<UnauthorizedException>()
                .having((e) => e.statusCode, 'statusCode', equals(401))
                .having(
                  (e) => e.message,
                  'message',
                  equals('Invalid Credintials'),
                ),
          ),
        );
      },
    );

    test(
      'should throw NotFoundException when status is 404 for non-auth paths with generic message',
      () {
        final dioException = DioException(
          requestOptions: RequestOptions(path: '/some-other-resource'),
          response: Response(
            requestOptions: RequestOptions(path: '/some-other-resource'),
            statusCode: 404,
            data: {
              'message': 'Resource not found',
              'error': 'Not Found',
              'statusCode': 404,
            },
          ),
          type: DioExceptionType.badResponse,
        );

        expect(
          () => handleDioException(dioException),
          throwsA(
            isA<NotFoundException>().having(
              (e) => e.statusCode,
              'statusCode',
              equals(404),
            ),
          ),
        );
      },
    );
  });

  group('mapExceptionToFailure', () {
    test(
      'should map NotFoundException with "Invalid Credintials" to UnauthorizedFailure (code 401)',
      () {
        final exception = NotFoundException(message: 'Invalid Credintials');
        final failure = mapExceptionToFailure(exception);

        expect(failure, isA<UnauthorizedFailure>());
        expect(failure.code, equals(401));
        expect(failure.message, equals('Invalid Credintials'));
      },
    );

    test(
      'should map standard NotFoundException to NotFoundFailure (code 404)',
      () {
        final exception = NotFoundException(message: 'Item not found');
        final failure = mapExceptionToFailure(exception);

        expect(failure, isA<NotFoundFailure>());
        expect(failure.code, equals(404));
      },
    );
  });
}
