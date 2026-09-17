import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/sign_up_params.dart';
import '../../domain/usecases/sign_up_use_case.dart';
import 'sign_up_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  final SignUpUseCase signUpUseCase;

  SignUpCubit({required this.signUpUseCase}) : super(const SignUpInitial());

  Future<void> signUp(SignUpParams params) async {
    emit(const SignUpLoading());
    final result = await signUpUseCase(params);
    if (isClosed) return;
    result.fold(
      (failure) => emit(SignUpFailure(failure.message, errors: failure.errors)),
      (message) => emit(SignUpSuccess(message)),
    );
  }
}
