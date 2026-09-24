import '../../../../core/api/api_keys.dart';
import '../../domain/entities/sign_up_params.dart';

class SignUpRequestModel extends SignUpParams {
  const SignUpRequestModel({
    required super.username,
    required super.email,
    required super.password,
    required super.confirmPassword,
    required super.birthDate,
    required super.phoneNumber,
  });

  factory SignUpRequestModel.fromEntity(SignUpParams params) {
    return SignUpRequestModel(
      username: params.username,
      email: params.email,
      password: params.password,
      confirmPassword: params.confirmPassword,
      birthDate: params.birthDate,
      phoneNumber: params.phoneNumber,
    );
  }

  String _formatDate(DateTime date) {
    final year = date.year.toString().padLeft(4, '0');
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }

  Map<String, dynamic> toJson() {
    return {
      ApiKeys.username: username,
      ApiKeys.email: email,
      ApiKeys.password: password,
      ApiKeys.confirmPassword: confirmPassword,
      ApiKeys.birthDate: _formatDate(birthDate),
      ApiKeys.phoneNumber: phoneNumber,
    };
  }
}
