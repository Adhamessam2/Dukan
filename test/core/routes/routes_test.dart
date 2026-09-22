import 'package:flutter_test/flutter_test.dart';
import 'package:Dukan/core/routes/routes.dart';

void main() {
  group('Routes', () {
    test('paymentWebView route is defined correctly', () {
      expect(Routes.paymentWebView, '/payment-webview');
    });
  });
}
