import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/login_params.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase implements UseCase<String, LoginParams> {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  @override
  Future<Either<Failure, String>> call(LoginParams params) async {
    return await repository.login(params);
  }
}
