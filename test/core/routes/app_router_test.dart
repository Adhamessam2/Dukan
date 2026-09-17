import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:Dukan/core/routes/app_router.dart';
import 'package:Dukan/core/routes/routes.dart';

void main() {
  test('AppRouter configures login and register routes', () {
    final routePaths = router.configuration.routes
        .whereType<GoRoute>()
        .map((r) => r.path)
        .toList();

    expect(routePaths.contains(Routes.splash), isTrue);
    expect(routePaths.contains(Routes.login), isTrue);
    expect(routePaths.contains(Routes.register), isTrue);
    expect(routePaths.contains(Routes.home), isTrue);
  });
}
