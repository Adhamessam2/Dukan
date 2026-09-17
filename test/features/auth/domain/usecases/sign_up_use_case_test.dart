import 'package:fpdart/fpdart.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:Dukan/core/errors/failure.dart';
import 'package:Dukan/features/auth/domain/entities/login_params.dart';
import 'package:Dukan/features/auth/domain/entities/sign_up_params.dart';
import 'package:Dukan/features/auth/domain/repositories/auth_repository.dart';
import 'package:Dukan/features/auth/domain/usecases/sign_up_use_case.dart';

class MockAuthRepository implements AuthRepository {
  Either<Failure, String>? resultToReturn;

  @override
  Future<Either<Failure, String>> signUp(SignUpParams params) async {
    return resultToReturn!;
  }

  @override
  Future<Either<Failure, String>> login(LoginParams params) => throw UnimplementedError();
}

void main() {
  late SignUpUseCase useCase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = SignUpUseCase(mockRepository);
  });

  final tParams = SignUpParams(
    username: 'testuser',
    email: 'test@example.com',
    password: 'password123',
    confirmPassword: 'password123',
    birthDate: DateTime(2000, 1, 1),
    phoneNumber: '1234567890',
  );

  test('should return success message from the repository on success', () async {
    const tSuccessMessage = 'Email sent successfully';
    mockRepository.resultToReturn = const Right(tSuccessMessage);

    final result = await useCase(tParams);

    expect(result, const Right(tSuccessMessage));
  });

  test('should return Failure from the repository on failure', () async {
    const tFailure = ServerFailure(message: 'Sign up failed');
    mockRepository.resultToReturn = const Left(tFailure);

    final result = await useCase(tParams);

    expect(result, const Left(tFailure));
  });
}
