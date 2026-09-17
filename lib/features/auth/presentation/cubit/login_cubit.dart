import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/login_params.dart';
import '../../domain/usecases/login_use_case.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginUseCase loginUseCase;

  LoginCubit({required this.loginUseCase}) : super(const LoginInitial());

  Future<void> login(LoginParams params) async {
    emit(const LoginLoading());
    final result = await loginUseCase(params);
    if (isClosed) return;
    result.fold(
      (failure) => emit(LoginFailure(failure.message, errors: failure.errors)),
      (message) => emit(LoginSuccess(message)),
    );
  }
}
