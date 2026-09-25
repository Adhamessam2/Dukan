import 'dart:io';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CookieManager & Token Refresh Integration', () {
    test('refreshDio with CookieManager sends stored cookies to refresh endpoint', () async {
      final cookieJar = CookieJar();
      final baseUrl = 'http://localhost:3000/api/v1';

      // 1. Simulate saving a cookie from login
      await cookieJar.saveFromResponse(
        Uri.parse('$baseUrl/auth/refresh'),
        [Cookie('refreshToken', 'mock_refresh_token_123')],
      );

      // 2. Set up refreshDio with CookieManager
      String? sentCookieHeader;
      final refreshDio = Dio(
        BaseOptions(
          baseUrl: baseUrl,
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );
      refreshDio.interceptors.add(CookieManager(cookieJar));
      refreshDio.httpClientAdapter = _MockHttpClientAdapter((options) {
        sentCookieHeader = options.headers[HttpHeaders.cookieHeader]?.toString();
        return ResponseBody.fromString(
          '{"success": true, "statusCode": 200, "data": {"accessToken": "new_token_456"}}',
          200,
          headers: {
            Headers.contentTypeHeader: [Headers.jsonContentType],
          },
        );
      });

      // 3. Make GET request to /auth/refresh
      final response = await refreshDio.get('/auth/refresh');

      // 4. Verify cookie was attached and response succeeded
      expect(sentCookieHeader, contains('refreshToken=mock_refresh_token_123'));
      expect(response.statusCode, 200);
      expect(response.data['data']['accessToken'], 'new_token_456');
    });

    test('CookieJar deleteAll clears all session cookies', () async {
      final cookieJar = CookieJar();
      final uri = Uri.parse('http://localhost:3000/api/v1/auth/refresh');

      await cookieJar.saveFromResponse(uri, [
        Cookie('refreshToken', 'mock_token'),
      ]);

      var cookies = await cookieJar.loadForRequest(uri);
      expect(cookies.length, 1);

      await cookieJar.deleteAll();

      cookies = await cookieJar.loadForRequest(uri);
      expect(cookies.isEmpty, isTrue);
    });
  });
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
