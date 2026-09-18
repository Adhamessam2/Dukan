import 'package:fpdart/fpdart.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:Dukan/core/errors/failure.dart';
import 'package:Dukan/features/auth/domain/entities/login_params.dart';
import 'package:Dukan/features/auth/domain/entities/sign_up_params.dart';
import 'package:Dukan/features/auth/domain/repositories/auth_repository.dart';
import 'package:Dukan/features/auth/domain/usecases/sign_up_use_case.dart';
import 'package:Dukan/features/auth/presentation/cubit/sign_up_cubit.dart';
import 'package:Dukan/features/auth/presentation/cubit/sign_up_state.dart';

class MockAuthRepository implements AuthRepository {
  Either<Failure, String>? result;

  @override
  Future<Either<Failure, String>> signUp(SignUpParams params) async => result!;

  @override
  Future<Either<Failure, String>> login(LoginParams params) =>
      throw UnimplementedError();
}

void main() {
  late SignUpCubit cubit;
  late MockAuthRepository mockRepository;
  late SignUpUseCase useCase;

  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = SignUpUseCase(mockRepository);
    cubit = SignUpCubit(signUpUseCase: useCase);
  });

  tearDown(() {
    cubit.close();
  });

  final tParams = SignUpParams(
    username: 'user',
    email: 'user@example.com',
    password: 'pwd',
    confirmPassword: 'pwd',
    birthDate: DateTime(2000, 1, 1),
    phoneNumber: '1234567890',
  );

  test('initial state should be SignUpInitial', () {
    expect(cubit.state, const SignUpInitial());
  });

  test('emits [SignUpLoading, SignUpSuccess] when signUp succeeds', () async {
    mockRepository.result = const Right('Email sent successfully');

    final expectedStates = [
      const SignUpLoading(),
      const SignUpSuccess('Email sent successfully'),
    ];

    final expectation = expectLater(cubit.stream, emitsInOrder(expectedStates));

    await cubit.signUp(tParams);
    await expectation;
  });

  test('emits [SignUpLoading, SignUpFailure] when signUp fails', () async {
    mockRepository.result = const Left(
      ServerFailure(message: 'Error occurred'),
    );

    final expectedStates = [
      const SignUpLoading(),
      const SignUpFailure('Error occurred'),
    ];

    final expectation = expectLater(cubit.stream, emitsInOrder(expectedStates));

    await cubit.signUp(tParams);
    await expectation;
  });

  test(
    'emits [SignUpLoading, SignUpFailure] with errors map when ValidationFailure occurs',
    () async {
      mockRepository.result = const Left(
        ValidationFailure(
          message: 'Validation failed',
          errors: {'email': 'already taken'},
        ),
      );

      final expectedStates = [
        const SignUpLoading(),
        const SignUpFailure(
          'Validation failed',
          errors: {'email': 'already taken'},
        ),
      ];

      final expectation = expectLater(
        cubit.stream,
        emitsInOrder(expectedStates),
      );

      await cubit.signUp(tParams);
      await expectation;
    },
  );
}
