import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:Dukan/core/api/api_interceptors.dart';

void main() {
  group('AuthInterceptor', () {
    test('onRequest adds Authorization header when token is present', () async {
      final interceptor = AuthInterceptor(
        getToken: () async => 'saved_jwt_token',
      );

      final options = RequestOptions(path: '/user/profile');
      final handler = RequestInterceptorHandler();

      await Future<void>(() => interceptor.onRequest(options, handler));

      expect(options.headers['Authorization'], 'Bearer saved_jwt_token');
    });

    test('onRequest does not add Authorization header when token is empty or null', () async {
      final interceptor = AuthInterceptor(
        getToken: () async => null,
      );

      final options = RequestOptions(path: '/user/profile');
      final handler = RequestInterceptorHandler();

      await Future<void>(() => interceptor.onRequest(options, handler));

      expect(options.headers.containsKey('Authorization'), false);
    });

    test('onError calls refreshToken on 401 and retries original request', () async {
      bool refreshCalled = false;
      final mockDio = Dio();
      // Intercept adapter to respond to retried request
      mockDio.httpClientAdapter = _MockHttpClientAdapter((options) {
        return ResponseBody.fromString(
          '{"success": true}',
          200,
          headers: {
            Headers.contentTypeHeader: [Headers.jsonContentType],
          },
        );
      });

      final interceptor = AuthInterceptor(
        dio: mockDio,
        getToken: () async => 'old_token',
        refreshToken: () async {
          refreshCalled = true;
          return 'new_refreshed_token';
        },
      );

      final requestOptions = RequestOptions(path: '/user/profile');
      final err = DioException(
        requestOptions: requestOptions,
        response: Response(
          requestOptions: requestOptions,
          statusCode: 401,
        ),
      );

      Response? resolvedResponse;
      final handler = _TestErrorInterceptorHandler(
        onResolve: (response) => resolvedResponse = response,
      );

      interceptor.onError(err, handler);

      // Allow async execution
      await Future<void>.delayed(const Duration(milliseconds: 50));

      expect(refreshCalled, isTrue);
      expect(resolvedResponse, isNotNull);
      expect(resolvedResponse?.statusCode, 200);
      expect(requestOptions.headers['Authorization'], 'Bearer new_refreshed_token');
    });

    test('onError calls onSessionExpired if refresh fails', () async {
      bool sessionExpiredCalled = false;
      final mockDio = Dio();

      final interceptor = AuthInterceptor(
        dio: mockDio,
        getToken: () async => 'old_token',
        refreshToken: () async {
          throw Exception('Refresh failed');
        },
        onSessionExpired: () async {
          sessionExpiredCalled = true;
        },
      );

      final requestOptions = RequestOptions(path: '/user/profile');
      final err = DioException(
        requestOptions: requestOptions,
        response: Response(
          requestOptions: requestOptions,
          statusCode: 401,
        ),
      );

      final handler = _TestErrorInterceptorHandler();

      interceptor.onError(err, handler);

      await Future<void>.delayed(const Duration(milliseconds: 50));

      expect(sessionExpiredCalled, isTrue);
    });

    test('onError does not refresh when error is on /auth/refresh or /auth/sign-in', () async {
      bool refreshCalled = false;
      final mockDio = Dio();

      final interceptor = AuthInterceptor(
        dio: mockDio,
        getToken: () async => 'old_token',
        refreshToken: () async {
          refreshCalled = true;
          return 'new_token';
        },
      );

      final requestOptions = RequestOptions(path: '/auth/refresh');
      final err = DioException(
        requestOptions: requestOptions,
        response: Response(
          requestOptions: requestOptions,
          statusCode: 401,
        ),
      );

      final handler = _TestErrorInterceptorHandler();

      interceptor.onError(err, handler);

      await Future<void>.delayed(const Duration(milliseconds: 50));

      expect(refreshCalled, isFalse);
    });
  });
}

class _TestErrorInterceptorHandler extends ErrorInterceptorHandler {
  final void Function(Response)? onResolve;

  _TestErrorInterceptorHandler({this.onResolve});

  @override
  void resolve(Response response) {
    onResolve?.call(response);
  }

  @override
  void next(DioException err) {}

  @override
  void reject(DioException err, [bool? callHandler]) {}
}

class _MockHttpClientAdapter implements HttpClientAdapter {
  final ResponseBody Function(RequestOptions options) handler;

  _MockHttpClientAdapter(this.handler);

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<List<int>>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    return handler(options);
  }

  @override
  void close({bool force = false}) {}
}
