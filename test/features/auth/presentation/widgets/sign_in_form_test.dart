import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:Dukan/core/errors/failure.dart';
import 'package:Dukan/features/auth/domain/entities/login_params.dart';
import 'package:Dukan/features/auth/domain/entities/sign_up_params.dart';
import 'package:Dukan/features/auth/presentation/cubit/login_cubit.dart';
import 'package:Dukan/features/auth/presentation/widgets/sign_in_form.dart';
import 'package:Dukan/features/auth/domain/usecases/login_use_case.dart';
import 'package:Dukan/features/auth/domain/repositories/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class MockAuthRepository implements AuthRepository {
  @override
  Future<Either<Failure, String>> login(LoginParams params) async =>
      const Right('OK');
  @override
  Future<Either<Failure, String>> signUp(SignUpParams params) async =>
      const Right('OK');
}

void main() {
  testWidgets('SignInForm triggers validation on empty submit', (tester) async {
    final cubit = LoginCubit(loginUseCase: LoginUseCase(MockAuthRepository()));
    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(375, 812),
        builder: (context, child) => MaterialApp(
          home: Scaffold(
            body: BlocProvider.value(
              value: cubit,
              child: SignInForm(emailController: TextEditingController()),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Sign In to Dukaan'));
    await tester.pumpAndSettle();

    expect(find.text('Email is required'), findsOneWidget);
    expect(find.text('Password is required'), findsOneWidget);
  });
}
