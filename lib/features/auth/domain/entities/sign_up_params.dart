import 'package:equatable/equatable.dart';

class SignUpParams extends Equatable {
  final String username;
  final String email;
  final String password;
  final String confirmPassword;
  final DateTime birthDate;
  final String phoneNumber;

  const SignUpParams({
    required this.username,
    required this.email,
    required this.password,
    required this.confirmPassword,
    required this.birthDate,
    required this.phoneNumber,
  });

  @override
  List<Object?> get props => [
    username,
    email,
    password,
    confirmPassword,
    birthDate,
    phoneNumber,
  ];
}
