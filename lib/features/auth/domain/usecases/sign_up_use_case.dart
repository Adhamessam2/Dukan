import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/sign_up_params.dart';
import '../repositories/auth_repository.dart';

class SignUpUseCase implements UseCase<String, SignUpParams> {
  final AuthRepository repository;

  SignUpUseCase(this.repository);

  @override
  Future<Either<Failure, String>> call(SignUpParams params) async {
    return await repository.signUp(params);
  }
}
