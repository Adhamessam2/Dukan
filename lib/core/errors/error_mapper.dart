import 'package:Dukan/core/errors/exceptions.dart';
import 'package:Dukan/core/errors/failure.dart';

Failure mapExceptionToFailure(Object e) {
  if (e is ValidationException) {
    return ValidationFailure(
      message: e.message,
      errors: e.errors,
      code: e.statusCode,
    );
  }
  if (e is UnauthorizedException) {
    return UnauthorizedFailure(message: e.message, code: e.statusCode);
  }
  if (e is ForbiddenException) {
    return ForbiddenFailure(message: e.message, code: e.statusCode);
  }
  if (e is NotFoundException) {
    if (e.message.toLowerCase().contains('invalid cred')) {
      return UnauthorizedFailure(message: e.message, code: 401);
    }
    return NotFoundFailure(message: e.message, code: e.statusCode);
  }
  if (e is NetworkException) return NetworkFailure(message: e.message);

  // Base server exception fallback
  if (e is ServerException) {
    return ServerFailure(message: e.message, code: e.statusCode);
  }

  if (e is CancelledException) return const CancelledFailure();
  if (e is ParseException) return ParseFailure(message: e.message);
  if (e is CacheException) return CacheFailure(message: e.message);
  if (e is AppException) {
    return ServerFailure(message: e.message, code: e.statusCode);
  }
  return const UnknownFailure();
}
