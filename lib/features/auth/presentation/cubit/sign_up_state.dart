import 'package:equatable/equatable.dart';

abstract class SignUpState extends Equatable {
  const SignUpState();

  @override
  List<Object?> get props => [];
}

class SignUpInitial extends SignUpState {
  const SignUpInitial();
}

class SignUpLoading extends SignUpState {
  const SignUpLoading();
}

class SignUpSuccess extends SignUpState {
  final String message;

  const SignUpSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class SignUpFailure extends SignUpState {
  final String errorMessage;
  final Map<String, dynamic>? errors;

  const SignUpFailure(this.errorMessage, {this.errors});

  @override
  List<Object?> get props => [errorMessage, errors];
}
