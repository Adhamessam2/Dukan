import '../../../../core/api/api_consumer.dart';
import '../../../../core/api/server_strings.dart';
import '../models/login_request_model.dart';
import '../models/login_response_model.dart';
import '../models/sign_up_request_model.dart';
import '../models/sign_up_response_model.dart';

abstract class AuthRemoteDataSource {
  Future<SignUpResponseModel> signUp(SignUpRequestModel requestModel);
  Future<LoginResponseModel> login(LoginRequestModel requestModel);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiConsumer apiConsumer;

  AuthRemoteDataSourceImpl({required this.apiConsumer});

  @override
  Future<SignUpResponseModel> signUp(SignUpRequestModel requestModel) async {
    final response = await apiConsumer.post(
      ServerStrings.register,
      body: requestModel.toJson(),
    );
    return SignUpResponseModel.fromJson(response as Map<String, dynamic>);
  }

  @override
  Future<LoginResponseModel> login(LoginRequestModel requestModel) async {
    final response = await apiConsumer.post(
      ServerStrings.login,
      body: requestModel.toJson(),
    );
    return LoginResponseModel.fromJson(response as Map<String, dynamic>);
  }
}
