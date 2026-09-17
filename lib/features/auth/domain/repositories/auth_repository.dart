import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failure.dart';
import '../entities/login_params.dart';
import '../entities/sign_up_params.dart';

abstract class AuthRepository {
  Future<Either<Failure, String>> signUp(SignUpParams params);
  Future<Either<Failure, String>> login(LoginParams params);
}
