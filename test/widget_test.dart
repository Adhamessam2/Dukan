import 'package:flutter_test/flutter_test.dart';
import 'package:Dukan/core/di/injection_container.dart' as di;
import 'package:Dukan/features/auth/presentation/cubit/login_cubit.dart';
import 'package:Dukan/features/auth/presentation/cubit/sign_up_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('DI registers and resolves SignUpCubit and LoginCubit correctly', () async {
    SharedPreferences.setMockInitialValues({});
    await di.init();

    final signUpCubit = di.sl<SignUpCubit>();
    expect(signUpCubit, isNotNull);
    await signUpCubit.close();

    final loginCubit = di.sl<LoginCubit>();
    expect(loginCubit, isNotNull);
    await loginCubit.close();
  });
}
