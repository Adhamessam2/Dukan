import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:Dukan/core/cache/secure_storage.dart';
import 'package:Dukan/core/di/injection_container.dart' as di;
import 'package:Dukan/core/routes/routes.dart';
import 'package:Dukan/features/splash/splash_screen.dart';

class MockSecureStorageService implements SecureStorageService {
  bool activeSession;

  MockSecureStorageService({this.activeSession = false});

  @override
  Future<bool> hasActiveSession() async => activeSession;

  @override
  Future<void> clearAll() => throw UnimplementedError();
  @override
  Future<void> clearSession() => throw UnimplementedError();
  @override
  Future<void> deleteAuthToken() => throw UnimplementedError();
  @override
  Future<void> deleteCustom(String key) => throw UnimplementedError();
  @override
  Future<void> deleteRefreshToken() => throw UnimplementedError();
  @override
  Future<String?> getAuthProvider() => throw UnimplementedError();
  @override
  Future<String?> getAuthToken() => throw UnimplementedError();
  @override
  Future<String?> getRefreshToken() => throw UnimplementedError();
  @override
  Future<Map<String, dynamic>?> getUserData() => throw UnimplementedError();
  @override
  Future<String?> getUserEmail() => throw UnimplementedError();
  @override
  Future<String?> getUserId() => throw UnimplementedError();
  @override
  Future<String?> readCustom(String key) => throw UnimplementedError();
  @override
  Future<void> saveAuthProvider(String provider) => throw UnimplementedError();
  @override
  Future<void> saveAuthToken(String token) => throw UnimplementedError();
  @override
  Future<void> saveCustom(String key, String value) => throw UnimplementedError();
  @override
  Future<void> saveRefreshToken(String token) => throw UnimplementedError();
  @override
  Future<void> saveSession({
    required String authToken,
    required String refreshToken,
    required String userId,
    String? userEmail,
  }) => throw UnimplementedError();
  @override
  Future<void> saveUserData(Map<String, dynamic> data) => throw UnimplementedError();
  @override
  Future<void> saveUserEmail(String email) => throw UnimplementedError();
  @override
  Future<void> saveUserId(String id) => throw UnimplementedError();
}

void main() {
  setUp(() {
    di.sl.reset();
  });

  tearDown(() {
    di.sl.reset();
  });

  testWidgets('SplashScreen navigates to login when hasActiveSession is false', (
    tester,
  ) async {
    final mockStorage = MockSecureStorageService(activeSession: false);
    di.sl.registerLazySingleton<SecureStorageService>(() => mockStorage);

    String? navigatedRoute;

    final testRouter = GoRouter(
      initialLocation: Routes.splash,
      routes: [
        GoRoute(
          path: Routes.splash,
          builder: (context, state) => const SplashScreen(),
        ),
        GoRoute(
          path: Routes.login,
          builder: (context, state) {
            navigatedRoute = Routes.login;
            return const Scaffold(body: Text('Login Screen'));
          },
        ),
        GoRoute(
          path: Routes.home,
          builder: (context, state) {
            navigatedRoute = Routes.home;
            return const Scaffold(body: Text('Home Screen'));
          },
        ),
      ],
    );

    await tester.pumpWidget(MaterialApp.router(routerConfig: testRouter));
    await tester.pump();

    // Fast-forward animation and 3-second timer
    await tester.pump(const Duration(seconds: 4));
    await tester.pumpAndSettle();

    expect(navigatedRoute, Routes.login);
  });

  testWidgets('SplashScreen navigates to home when hasActiveSession is true', (
    tester,
  ) async {
    final mockStorage = MockSecureStorageService(activeSession: true);
    di.sl.registerLazySingleton<SecureStorageService>(() => mockStorage);

    String? navigatedRoute;

    final testRouter = GoRouter(
      initialLocation: Routes.splash,
      routes: [
        GoRoute(
          path: Routes.splash,
          builder: (context, state) => const SplashScreen(),
        ),
        GoRoute(
          path: Routes.login,
          builder: (context, state) {
            navigatedRoute = Routes.login;
            return const Scaffold(body: Text('Login Screen'));
          },
        ),
        GoRoute(
          path: Routes.home,
          builder: (context, state) {
            navigatedRoute = Routes.home;
            return const Scaffold(body: Text('Home Screen'));
          },
        ),
      ],
    );

    await tester.pumpWidget(MaterialApp.router(routerConfig: testRouter));
    await tester.pump();

    // Fast-forward animation and 3-second timer
    await tester.pump(const Duration(seconds: 4));
    await tester.pumpAndSettle();

    expect(navigatedRoute, Routes.home);
  });
}
