import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failure.dart';
import '../entities/login_params.dart';

abstract class LoginRepository {
  Future<Either<Failure, String>> login(LoginParams params);
}
