import 'package:Dukan/core/api/api_keys.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ApiKeys Unit Tests', () {
    test('Verify common envelope keys', () {
      expect(ApiKeys.success, equals('success'));
      expect(ApiKeys.statusCode, equals('statusCode'));
      expect(ApiKeys.message, equals('message'));
      expect(ApiKeys.data, equals('data'));
      expect(ApiKeys.error, equals('error'));
      expect(ApiKeys.errors, equals('errors'));
    });

    test('Verify auth keys', () {
      expect(ApiKeys.accessToken, equals('accessToken'));
      expect(ApiKeys.accessTokenSnake, equals('access_token'));
      expect(ApiKeys.refreshToken, equals('refreshToken'));
      expect(ApiKeys.refreshTokenSnake, equals('refresh_token'));
      expect(ApiKeys.username, equals('username'));
      expect(ApiKeys.email, equals('email'));
      expect(ApiKeys.password, equals('password'));
      expect(ApiKeys.confirmPassword, equals('confirm_password'));
      expect(ApiKeys.birthDate, equals('birth_date'));
      expect(ApiKeys.phoneNumber, equals('phone_number'));
    });

    test('Verify product and category keys', () {
      expect(ApiKeys.productName, equals('productName'));
      expect(ApiKeys.price, equals('price'));
      expect(ApiKeys.stock, equals('stock'));
      expect(ApiKeys.category, equals('category'));
      expect(ApiKeys.productImages, equals('productImages'));
    });

    test('Verify order and cart keys', () {
      expect(ApiKeys.cartId, equals('cartId'));
      expect(ApiKeys.quantity, equals('quantity'));
      expect(ApiKeys.shippingCity, equals('shippingCity'));
      expect(ApiKeys.paymentMethod, equals('paymentMethod'));
      expect(ApiKeys.checkoutUrl, equals('checkoutUrl'));
    });
  });
}
