import 'package:equatable/equatable.dart';

abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object?> get props => [];
}

class LoginInitial extends LoginState {
  const LoginInitial();
}

class LoginLoading extends LoginState {
  const LoginLoading();
}

class LoginSuccess extends LoginState {
  final String message;

  const LoginSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class LoginFailure extends LoginState {
  final String errorMessage;
  final Map<String, dynamic>? errors;

  const LoginFailure(this.errorMessage, {this.errors});

  @override
  List<Object?> get props => [errorMessage, errors];
}
