import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// API Interceptor for handling requests, responses, and errors
/// Provides centralized logging and error handling
class ApiInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      debugPrint('📤 REQUEST[${options.method}] => PATH: ${options.path}');
      debugPrint('Headers: ${options.headers}');
      debugPrint('Query Parameters: ${options.queryParameters}');
      debugPrint('Body: ${options.data}');
      debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    }

    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      debugPrint(
        '📥 RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}',
      );
      debugPrint('Data: ${response.data}');
      debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    }

    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      debugPrint(
        '❌ ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}',
      );
      debugPrint('Message: ${err.message}');
      debugPrint('Response: ${err.response?.data}');
      debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    }

    super.onError(err, handler);
  }
}

/// Authentication Interceptor
/// Automatically adds authentication token to requests and refreshes expired tokens on 401.
class AuthInterceptor extends Interceptor {
  final Future<String?> Function() getToken;
  final Future<String?> Function()? refreshToken;
  final Future<void> Function()? onSessionExpired;
  final Dio? dio;

  AuthInterceptor({
    required this.getToken,
    this.refreshToken,
    this.onSessionExpired,
    this.dio,
  });

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await getToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final isAlreadyRetried = err.requestOptions.extra['authRetry'] == true;

    if (err.response?.statusCode == 401 &&
        !isAlreadyRetried &&
        refreshToken != null &&
        dio != null) {
      final path = err.requestOptions.path;
      // Do not attempt refresh on auth or refresh endpoints to avoid infinite loops
      if (!path.contains('/auth/sign-in') &&
          !path.contains('/auth/sign-up') &&
          !path.contains('/auth/refresh')) {
        try {
          final newToken = await refreshToken!();
          if (newToken != null && newToken.isNotEmpty) {
            final options = err.requestOptions;
            options.headers['Authorization'] = 'Bearer $newToken';
            options.extra['authRetry'] = true;
            final retryResponse = await dio!.fetch(options);
            return handler.resolve(retryResponse);
          }
        } on DioException catch (refreshErr) {
          // If the refresh request itself is explicitly rejected with 401/403, credentials are invalid/revoked
          final refreshStatus = refreshErr.response?.statusCode;
          if (refreshStatus == 401 || refreshStatus == 403) {
            await onSessionExpired?.call();
          }
          // For timeouts/network connection errors (transientFailure), do NOT clear session.
        } catch (_) {
          // Keep tokenless / other exceptions without wiping session automatically
        }
      }
    }

    super.onError(err, handler);
  }
}
