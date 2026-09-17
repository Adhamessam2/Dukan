import 'package:equatable/equatable.dart';

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
    final data = json['data'] as Map<String, dynamic>?;
    return LoginResponseModel(
      success: json['success'] as bool? ?? false,
      statusCode: json['statusCode'] as int? ?? 200,
      accessToken:
          data?['access_token'] as String? ??
          json['access_token'] as String? ??
          '',
      message: data?['message'] as String? ?? json['message'] as String?,
    );
  }

  @override
  List<Object?> get props => [success, statusCode, accessToken, message];
}
