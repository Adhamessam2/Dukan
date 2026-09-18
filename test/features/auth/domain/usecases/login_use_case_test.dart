import 'package:fpdart/fpdart.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:Dukan/core/errors/failure.dart';
import 'package:Dukan/features/auth/domain/entities/login_params.dart';
import 'package:Dukan/features/auth/domain/entities/sign_up_params.dart';
import 'package:Dukan/features/auth/domain/repositories/auth_repository.dart';
import 'package:Dukan/features/auth/domain/usecases/login_use_case.dart';

class MockAuthRepository implements AuthRepository {
  Either<Failure, String>? loginResultToReturn;

  @override
  Future<Either<Failure, String>> login(LoginParams params) async {
    return loginResultToReturn!;
  }

  @override
  Future<Either<Failure, String>> signUp(SignUpParams params) =>
      throw UnimplementedError();
}

void main() {
  late LoginUseCase useCase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = LoginUseCase(mockRepository);
  });

  const tParams = LoginParams(
    email: 'test@example.com',
    password: 'password123',
  );

  test(
    'should return success message from repository on successful login',
    () async {
      const tMessage = 'Logged in successfully';
      mockRepository.loginResultToReturn = const Right(tMessage);

      final result = await useCase(tParams);

      expect(result, const Right(tMessage));
    },
  );

  test('should return Failure from repository when login fails', () async {
    const tFailure = ServerFailure(message: 'Invalid credentials', code: 401);
    mockRepository.loginResultToReturn = const Left(tFailure);

    final result = await useCase(tParams);

    expect(result, const Left(tFailure));
  });
}
