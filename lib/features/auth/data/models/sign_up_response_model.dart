import 'package:equatable/equatable.dart';

class SignUpResponseModel extends Equatable {
  final bool success;
  final int statusCode;
  final String message;

  const SignUpResponseModel({
    required this.success,
    required this.statusCode,
    required this.message,
  });

  factory SignUpResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>?;
    return SignUpResponseModel(
      success: json['success'] as bool? ?? false,
      statusCode: json['statusCode'] as int? ?? 200,
      message: data?['message'] as String? ?? json['message'] as String? ?? '',
    );
  }

  @override
  List<Object?> get props => [success, statusCode, message];
}
