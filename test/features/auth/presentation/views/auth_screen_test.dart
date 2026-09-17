import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:Dukan/core/errors/failure.dart';
import 'package:Dukan/features/auth/domain/entities/login_params.dart';
import 'package:Dukan/features/auth/domain/entities/sign_up_params.dart';
import 'package:Dukan/features/auth/presentation/cubit/login_cubit.dart';
import 'package:Dukan/features/auth/presentation/cubit/sign_up_cubit.dart';
import 'package:Dukan/features/auth/presentation/views/auth_screen.dart';
import 'package:Dukan/features/auth/domain/usecases/login_use_case.dart';
import 'package:Dukan/features/auth/domain/usecases/sign_up_use_case.dart';
import 'package:Dukan/features/auth/domain/repositories/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class MockAuthRepo implements AuthRepository {
  @override
  Future<Either<Failure, String>> login(LoginParams params) async => const Right('OK');
  @override
  Future<Either<Failure, String>> signUp(SignUpParams params) async => const Right('OK');
}

void main() {
  testWidgets('AuthScreen switches between tabs smoothly without overflow', (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    final authRepo = MockAuthRepo();
    final loginCubit = LoginCubit(loginUseCase: LoginUseCase(authRepo));
    final signUpCubit = SignUpCubit(signUpUseCase: SignUpUseCase(authRepo));

    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(375, 812),
        builder: (context, child) => MaterialApp(
          home: MultiBlocProvider(
            providers: [
              BlocProvider.value(value: loginCubit),
              BlocProvider.value(value: signUpCubit),
            ],
            child: const AuthScreen(initialTab: AuthTab.signIn),
          ),
        ),
      ),
    );

    expect(find.text('Sign In to Dukaan'), findsOneWidget);
    expect(find.text('Sign In'), findsWidgets);
    expect(find.text('Create Account'), findsWidgets);

    // Tap Create Account
    await tester.tap(find.text('Create Account').first);
    await tester.pumpAndSettle();

    expect(find.text('Username'), findsOneWidget);
    expect(find.text('Date of Birth'), findsOneWidget);
  });
}
