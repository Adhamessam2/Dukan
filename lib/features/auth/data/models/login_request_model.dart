import '../../domain/entities/login_params.dart';

class LoginRequestModel extends LoginParams {
  const LoginRequestModel({required super.email, required super.password});

  factory LoginRequestModel.fromEntity(LoginParams params) {
    return LoginRequestModel(email: params.email, password: params.password);
  }

  Map<String, dynamic> toJson() {
    return {'email': email, 'password': password};
  }
}
