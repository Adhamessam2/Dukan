import 'package:fpdart/fpdart.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:Dukan/core/errors/exceptions.dart';
import 'package:Dukan/core/errors/failure.dart';
import 'package:Dukan/core/network/network_info.dart';
import 'package:Dukan/core/cache/secure_storage.dart';
import 'package:Dukan/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:Dukan/features/auth/data/models/login_request_model.dart';
import 'package:Dukan/features/auth/data/models/login_response_model.dart';
import 'package:Dukan/features/auth/data/models/sign_up_request_model.dart';
import 'package:Dukan/features/auth/data/models/sign_up_response_model.dart';
import 'package:Dukan/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:Dukan/features/auth/domain/entities/login_params.dart';
import 'package:Dukan/features/auth/domain/entities/sign_up_params.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class MockRemoteDataSource implements AuthRemoteDataSource {
  SignUpResponseModel? responseToReturn;
  Object? exceptionToThrow;
  LoginResponseModel? loginResponseToReturn;
  Object? loginExceptionToThrow;

  @override
  Future<SignUpResponseModel> signUp(SignUpRequestModel requestModel) async {
    if (exceptionToThrow != null) throw exceptionToThrow!;
    return responseToReturn!;
  }

  @override
  Future<LoginResponseModel> login(LoginRequestModel requestModel) async {
    if (loginExceptionToThrow != null) throw loginExceptionToThrow!;
    return loginResponseToReturn!;
  }
}

class MockSecureStorageService implements SecureStorageService {
  String? savedToken;

  @override
  Future<void> saveAuthToken(String token) async {
    savedToken = token;
  }

  @override
  Future<void> clearAll() => throw UnimplementedError();
  @override
  Future<void> clearSession() => throw UnimplementedError();
  @override
  Future<void> deleteAuthToken() => throw UnimplementedError();
  @override
  Future<void> deleteCustom(String key) => throw UnimplementedError();
  @override
  Future<void> deleteRefreshToken() => throw UnimplementedError();
  @override
  Future<String?> getAuthProvider() => throw UnimplementedError();
  @override
  Future<String?> getAuthToken() => throw UnimplementedError();
  @override
  Future<String?> getRefreshToken() => throw UnimplementedError();
  @override
  Future<Map<String, dynamic>?> getUserData() => throw UnimplementedError();
  @override
  Future<String?> getUserEmail() => throw UnimplementedError();
  @override
  Future<String?> getUserId() => throw UnimplementedError();
  @override
  Future<bool> hasActiveSession() => throw UnimplementedError();
  @override
  Future<String?> readCustom(String key) => throw UnimplementedError();
  @override
  Future<void> saveAuthProvider(String provider) => throw UnimplementedError();
  @override
  Future<void> saveCustom(String key, String value) =>
      throw UnimplementedError();
  @override
  Future<void> saveRefreshToken(String token) => throw UnimplementedError();
  @override
  Future<void> saveSession({
    required String authToken,
    required String refreshToken,
    required String userId,
    String? userEmail,
  }) => throw UnimplementedError();
  @override
  Future<void> saveUserData(Map<String, dynamic> jsonData) =>
      throw UnimplementedError();
  @override
  Future<void> saveUserEmail(String email) => throw UnimplementedError();
  @override
  Future<void> saveUserId(String userId) => throw UnimplementedError();
}

class MockNetworkInfo implements NetworkInfo {
  bool isConnectedValue = true;

  @override
  Future<bool> get isConnected async => isConnectedValue;

  @override
  Stream<InternetStatus> get onStatusChange => throw UnimplementedError();
}

void main() {
  late AuthRepositoryImpl repository;
  late MockRemoteDataSource mockRemoteDataSource;
  late MockNetworkInfo mockNetworkInfo;
  late MockSecureStorageService mockSecureStorageService;

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    mockNetworkInfo = MockNetworkInfo();
    mockSecureStorageService = MockSecureStorageService();
    repository = AuthRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      networkInfo: mockNetworkInfo,
      secureStorageService: mockSecureStorageService,
    );
  });

  final tParams = SignUpParams(
    username: 'user',
    email: 'user@example.com',
    password: 'pwd',
    confirmPassword: 'pwd',
    birthDate: DateTime(2000, 1, 1),
    phoneNumber: '1234567890',
  );

  test('should return NetworkFailure when device has no internet', () async {
    mockNetworkInfo.isConnectedValue = false;

    final result = await repository.signUp(tParams);

    expect(result, const Left(NetworkFailure()));
  });

  test(
    'should return Right(message) when remote data source call is successful',
    () async {
      mockNetworkInfo.isConnectedValue = true;
      mockRemoteDataSource.responseToReturn = const SignUpResponseModel(
        success: true,
        statusCode: 201,
        message: 'Email sent successfully',
      );

      final result = await repository.signUp(tParams);

      expect(result, const Right('Email sent successfully'));
    },
  );

  test(
    'should return Left(ServerFailure) when remote data source throws ServerException',
    () async {
      mockNetworkInfo.isConnectedValue = true;
      mockRemoteDataSource.exceptionToThrow = ServerException(
        message: 'Email already exists',
        statusCode: 409,
      );

      final result = await repository.signUp(tParams);

      expect(
        result,
        const Left(ServerFailure(message: 'Email already exists', code: 409)),
      );
    },
  );

  test(
    'should return Left(ValidationFailure) when remote data source throws ValidationException',
    () async {
      mockNetworkInfo.isConnectedValue = true;
      mockRemoteDataSource.exceptionToThrow = ValidationException(
        message: 'Invalid email',
        errors: {'email': 'already taken'},
      );

      final result = await repository.signUp(tParams);

      expect(
        result,
        const Left(
          ValidationFailure(
            message: 'Invalid email',
            errors: {'email': 'already taken'},
            code: 422,
          ),
        ),
      );
    },
  );

  test(
    'should return Left(ServerFailure) when response.success is false',
    () async {
      mockNetworkInfo.isConnectedValue = true;
      mockRemoteDataSource.responseToReturn = const SignUpResponseModel(
        success: false,
        statusCode: 200,
        message: 'Email already registered',
      );

      final result = await repository.signUp(tParams);

      expect(
        result,
        const Left(
          ServerFailure(message: 'Email already registered', code: 200),
        ),
      );
    },
  );

  test(
    'should return Left(NetworkFailure) when remote data source throws NetworkException',
    () async {
      mockNetworkInfo.isConnectedValue = true;
      mockRemoteDataSource.exceptionToThrow = NetworkException(
        message: 'No internet connection',
      );

      final result = await repository.signUp(tParams);

      expect(
        result,
        const Left(NetworkFailure(message: 'No internet connection')),
      );
    },
  );

  test(
    'should return Left(UnknownFailure) when unexpected exception is thrown',
    () async {
      mockNetworkInfo.isConnectedValue = true;
      mockRemoteDataSource.exceptionToThrow = Exception('Crash');

      final result = await repository.signUp(tParams);

      expect(result, const Left(UnknownFailure()));
    },
  );

  group('login', () {
    const tLoginParams = LoginParams(
      email: 'user@example.com',
      password: 'password123',
    );

    test(
      'should save auth token and return success message on successful login',
      () async {
        mockNetworkInfo.isConnectedValue = true;
        mockRemoteDataSource.loginResponseToReturn = const LoginResponseModel(
          success: true,
          statusCode: 201,
          accessToken: 'saved_jwt_token',
        );

        final result = await repository.login(tLoginParams);

        expect(mockSecureStorageService.savedToken, 'saved_jwt_token');
        expect(result, const Right('Logged in successfully'));
      },
    );

    test(
      'should return NetworkFailure when device is offline during login',
      () async {
        mockNetworkInfo.isConnectedValue = false;

        final result = await repository.login(tLoginParams);

        expect(result, const Left(NetworkFailure()));
      },
    );

    test(
      'should return ServerFailure when login response success is false',
      () async {
        mockNetworkInfo.isConnectedValue = true;
        mockRemoteDataSource.loginResponseToReturn = const LoginResponseModel(
          success: false,
          statusCode: 401,
          accessToken: '',
          message: 'Invalid email or password',
        );

        final result = await repository.login(tLoginParams);

        expect(
          result,
          const Left(
            ServerFailure(message: 'Invalid email or password', code: 401),
          ),
        );
      },
    );

    test(
      'should return ValidationFailure when remote data source throws ValidationException during login',
      () async {
        mockNetworkInfo.isConnectedValue = true;
        mockRemoteDataSource.loginExceptionToThrow = ValidationException(
          message: 'Validation failed',
          errors: {'email': 'Invalid email format'},
        );

        final result = await repository.login(tLoginParams);

        expect(
          result,
          const Left(
            ValidationFailure(
              message: 'Validation failed',
              errors: {'email': 'Invalid email format'},
              code: 422,
            ),
          ),
        );
      },
    );

    test(
      'should return ServerFailure when login response has empty access_token',
      () async {
        mockNetworkInfo.isConnectedValue = true;
        mockRemoteDataSource.loginResponseToReturn = const LoginResponseModel(
          success: true,
          statusCode: 201,
          accessToken: '',
        );

        final result = await repository.login(tLoginParams);

        expect(
          result,
          const Left(
            ServerFailure(message: 'Authentication token is missing.'),
          ),
        );
        expect(mockSecureStorageService.savedToken, isNull);
      },
    );
  });
}
