import 'package:dio/dio.dart';
import '../api/server_strings.dart';

/// Base Exception class for all custom exceptions
abstract class AppException implements Exception {
  final String message;
  final int? statusCode;

  AppException({required this.message, this.statusCode});

  @override
  String toString() => message;
}

/// Thrown when there's an error from the server (4xx/5xx with a real response)
class ServerException extends AppException {
  ServerException({required super.message, super.statusCode});
}

/// Thrown when there's no internet / the request never reached the server
class NetworkException extends AppException {
  NetworkException({
    super.message = 'No internet connection. Please check your network.',
  });
}

class ConnectionTimeoutException extends NetworkException {
  ConnectionTimeoutException({super.message = 'Connection timeout.'});
}

class SendTimeoutException extends NetworkException {
  SendTimeoutException({super.message = 'Send timeout.'});
}

class ReceiveTimeoutException extends NetworkException {
  ReceiveTimeoutException({super.message = 'Receive timeout.'});
}

class BadCertificateException extends NetworkException {
  BadCertificateException({super.message = 'Bad certificate.'});
}

class ConnectionErrorException extends NetworkException {
  ConnectionErrorException({
    super.message = 'Connection error - check your internet.',
  });
}

class CancelledException extends AppException {
  CancelledException({super.message = 'Request cancelled.'});
}

/// Cache Exception
class CacheException extends AppException {
  CacheException({required super.message});
}

/// Unauthorized Exception (401)
class UnauthorizedException extends ServerException {
  UnauthorizedException({
    super.message = 'Unauthorized access. Please login again.',
  }) : super(statusCode: 401);
}

/// Forbidden Exception (403)
class ForbiddenException extends ServerException {
  ForbiddenException({
    super.message = 'Access forbidden. You don\'t have permission.',
  }) : super(statusCode: 403);
}

/// Not Found Exception (404)
class NotFoundException extends ServerException {
  NotFoundException({super.message = 'Resource not found.'})
    : super(statusCode: 404);
}

/// Conflict Exception (409) — renamed from the typo'd "CofficientException"
class ConflictException extends ServerException {
  ConflictException({super.message = 'Conflict with current state.'})
    : super(statusCode: 409);
}

/// Validation Exception (422) — keeps the field-level error map
class ValidationException extends ServerException {
  final Map<String, dynamic>? errors;

  ValidationException({super.message = 'Validation failed.', this.errors})
    : super(statusCode: 422);
}

/// Rate Limit Exception (429)
class RateLimitException extends ServerException {
  RateLimitException({
    super.message = 'Too many attempts. Please wait a moment and try again.',
  }) : super(statusCode: 429);
}

/// Gateway Timeout (504)
class GatewayTimeoutException extends ServerException {
  GatewayTimeoutException({super.message = 'Gateway timeout.'})
    : super(statusCode: 504);
}

class TransformTimeoutException extends NetworkException {
  TransformTimeoutException({
    super.message = 'Response processing took too long. Please try again.',
  });
}

/// Parse Exception
/// Thrown when JSON parsing fails
class ParseException extends AppException {
  ParseException({super.message = 'Failed to parse response data.'});
}

/// Fallback for anything unrecognized
class UnknownException extends AppException {
  UnknownException({super.message = 'Unknown error', super.statusCode});
}

/// Maps a [DioException] to the appropriate [AppException] subtype,
/// parsing the backend's real error body where available.
Never handleDioException(DioException e) {
  String extractMessage() {
    final data = e.response?.data;
    if (data is Map<String, dynamic>) {
      // Adjust the key(s) to match your backend's error payload shape.
      return (data['message'] ??
              data['error'] ??
              e.message ??
              'Unexpected error')
          .toString();
    }
    return e.message ?? 'Unexpected error';
  }

  switch (e.type) {
    case DioExceptionType.connectionTimeout:
      throw ConnectionTimeoutException();
    case DioExceptionType.sendTimeout:
      throw SendTimeoutException();
    case DioExceptionType.receiveTimeout:
      throw ReceiveTimeoutException();
    case DioExceptionType.transformTimeout:
      throw TransformTimeoutException();
    case DioExceptionType.badCertificate:
      throw BadCertificateException();
    case DioExceptionType.connectionError:
      throw ConnectionErrorException();
    case DioExceptionType.cancel:
      throw CancelledException();
    case DioExceptionType.unknown:
      throw UnknownException(message: e.message ?? 'Unknown error');
    case DioExceptionType.badResponse:
      final statusCode = e.response?.statusCode;
      final message = extractMessage();
      switch (statusCode) {
        case 401:
          throw UnauthorizedException(
            message: 'Incorrect email or password. Please try again.',
          );
        case 403:
          throw ForbiddenException(message: message);
        case 404:
          if (message.toLowerCase().contains('invalid cred') ||
              e.requestOptions.path.contains(ServerStrings.login)) {
            throw UnauthorizedException(message: message);
          }
          throw NotFoundException(message: message);
        case 409:
          throw ConflictException(message: message);
        case 422:
          final responseData = e.response?.data;
          final errors =
              responseData is Map<String, dynamic> &&
                  responseData['errors'] is Map<String, dynamic>
              ? responseData['errors'] as Map<String, dynamic>
              : null;
          throw ValidationException(message: extractMessage(), errors: errors);
        case 429:
          throw RateLimitException();
        case 504:
          throw GatewayTimeoutException();
        default:
          throw ServerException(
            message: extractMessage(),
            statusCode: statusCode ?? 500,
          );
      }
  }
}
