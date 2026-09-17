import '../../../../core/errors/error_mapper.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/network/network_info.dart';
import '../../../../core/cache/secure_storage.dart';
import '../../domain/entities/login_params.dart';
import '../../domain/entities/sign_up_params.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';
import '../models/login_request_model.dart';
import '../models/sign_up_request_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;
  final SecureStorageService secureStorageService;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
    required this.secureStorageService,
  });

  @override
  Future<Either<Failure, String>> signUp(SignUpParams params) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final requestModel = SignUpRequestModel.fromEntity(params);
      final response = await remoteDataSource.signUp(requestModel);
      if (!response.success) {
        return Left(
          ServerFailure(message: response.message, code: response.statusCode),
        );
      }
      return Right(response.message);
    } catch (e) {
      return Left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, String>> login(LoginParams params) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final requestModel = LoginRequestModel.fromEntity(params);
      final response = await remoteDataSource.login(requestModel);
      if (!response.success) {
        return Left(
          ServerFailure(
            message: response.message ?? 'Login failed',
            code: response.statusCode,
          ),
        );
      }
      if (response.accessToken.isEmpty) {
        return const Left(
          ServerFailure(message: 'Authentication token is missing.'),
        );
      }
      await secureStorageService.saveAuthToken(response.accessToken);
      return Right(response.message ?? 'Logged in successfully');
    } catch (e) {
      return Left(mapExceptionToFailure(e));
    }
  }
}
