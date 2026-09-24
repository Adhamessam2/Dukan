import 'package:equatable/equatable.dart';
import '../../../../core/api/api_keys.dart';

class LoginResponseModel extends Equatable {
  final bool success;
  final int statusCode;
  final String accessToken;
  final String? message;

  const LoginResponseModel({
    required this.success,
    required this.statusCode,
    required this.accessToken,
    this.message,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json[ApiKeys.data] as Map<String, dynamic>?;
    return LoginResponseModel(
      success: json[ApiKeys.success] as bool? ?? false,
      statusCode: json[ApiKeys.statusCode] as int? ?? 200,
      accessToken:
          data?[ApiKeys.accessToken] as String? ??
          data?[ApiKeys.accessTokenSnake] as String? ??
          json[ApiKeys.accessToken] as String? ??
          json[ApiKeys.accessTokenSnake] as String? ??
          '',
      message: data?[ApiKeys.message] as String? ?? json[ApiKeys.message] as String?,
    );
  }

  @override
  List<Object?> get props => [success, statusCode, accessToken, message];
}
