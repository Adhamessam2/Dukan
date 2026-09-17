import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:Dukan/core/errors/failure.dart';
import 'package:Dukan/features/auth/domain/entities/login_params.dart';
import 'package:Dukan/features/auth/domain/entities/sign_up_params.dart';
import 'package:Dukan/features/auth/presentation/cubit/sign_up_cubit.dart';
import 'package:Dukan/features/auth/presentation/widgets/sign_up_form.dart';
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
  testWidgets('SignUpForm triggers validation on empty submit', (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    final cubit = SignUpCubit(signUpUseCase: SignUpUseCase(MockAuthRepo()));
    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(375, 812),
        builder: (context, child) => MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: BlocProvider.value(
                value: cubit,
                child: const SignUpForm(),
              ),
            ),
          ),
        ),
      ),
    );

    expect(find.text('Username'), findsOneWidget);
    expect(find.text('Date of Birth'), findsOneWidget);
    expect(find.text('Create Account'), findsOneWidget);

    await tester.ensureVisible(find.text('Create Account'));
    await tester.tap(find.text('Create Account'));
    await tester.pumpAndSettle();

    expect(find.text('Username is required'), findsOneWidget);
    expect(find.text('Email is required'), findsOneWidget);
    expect(find.text('Password is required'), findsOneWidget);
  });
}
