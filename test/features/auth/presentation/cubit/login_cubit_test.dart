import 'package:fpdart/fpdart.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:Dukan/core/errors/failure.dart';
import 'package:Dukan/features/auth/domain/entities/login_params.dart';
import 'package:Dukan/features/auth/domain/entities/sign_up_params.dart';
import 'package:Dukan/features/auth/domain/repositories/auth_repository.dart';
import 'package:Dukan/features/auth/domain/usecases/login_use_case.dart';
import 'package:Dukan/features/auth/presentation/cubit/login_cubit.dart';
import 'package:Dukan/features/auth/presentation/cubit/login_state.dart';

class MockAuthRepository implements AuthRepository {
  Either<Failure, String>? loginResult;

  @override
  Future<Either<Failure, String>> login(LoginParams params) async => loginResult!;

  @override
  Future<Either<Failure, String>> signUp(SignUpParams params) => throw UnimplementedError();
}

void main() {
  late LoginCubit cubit;
  late MockAuthRepository mockRepository;
  late LoginUseCase useCase;

  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = LoginUseCase(mockRepository);
    cubit = LoginCubit(loginUseCase: useCase);
  });

  tearDown(() {
    cubit.close();
  });

  const tParams = LoginParams(
    email: 'user@example.com',
    password: 'password123',
  );

  test('initial state should be LoginInitial', () {
    expect(cubit.state, const LoginInitial());
  });

  test('emits [LoginLoading, LoginSuccess] when login succeeds', () async {
    mockRepository.loginResult = const Right('Logged in successfully');

    final expectedStates = [
      const LoginLoading(),
      const LoginSuccess('Logged in successfully'),
    ];

    expectLater(cubit.stream, emitsInOrder(expectedStates));

    await cubit.login(tParams);
  });

  test('emits [LoginLoading, LoginFailure] when login fails', () async {
    mockRepository.loginResult = const Left(ServerFailure(message: 'Invalid credentials'));

    final expectedStates = [
      const LoginLoading(),
      const LoginFailure('Invalid credentials'),
    ];

    expectLater(cubit.stream, emitsInOrder(expectedStates));

    await cubit.login(tParams);
  });

  test('emits [LoginLoading, LoginFailure] with errors map when ValidationFailure occurs', () async {
    mockRepository.loginResult = const Left(
      ValidationFailure(
        message: 'Validation failed',
        errors: {'email': 'Invalid email'},
      ),
    );

    final expectedStates = [
      const LoginLoading(),
      const LoginFailure(
        'Validation failed',
        errors: {'email': 'Invalid email'},
      ),
    ];

    expectLater(cubit.stream, emitsInOrder(expectedStates));

    await cubit.login(tParams);
  });
}
