import 'package:flutter_test/flutter_test.dart';
import 'package:Dukan/features/auth/data/models/login_request_model.dart';
import 'package:Dukan/features/auth/data/models/login_response_model.dart';
import 'package:Dukan/features/auth/domain/entities/login_params.dart';

void main() {
  group('LoginRequestModel', () {
    test('toJson produces correct map', () {
      const params = LoginParams(
        email: 'user@example.com',
        password: 'password123',
      );

      final model = LoginRequestModel.fromEntity(params);
      final json = model.toJson();

      expect(json, {
        'email': 'user@example.com',
        'password': 'password123',
      });
    });
  });

  group('LoginResponseModel', () {
    test('fromJson parses nested access_token correctly', () {
      final json = {
        'success': true,
        'statusCode': 201,
        'data': {
          'access_token': 'test_token_123',
        },
      };

      final model = LoginResponseModel.fromJson(json);

      expect(model.success, true);
      expect(model.statusCode, 201);
      expect(model.accessToken, 'test_token_123');
    });

    test('fromJson handles optional message if present', () {
      final json = {
        'success': true,
        'statusCode': 200,
        'data': {
          'access_token': 'test_token_123',
          'message': 'Welcome back',
        },
      };

      final model = LoginResponseModel.fromJson(json);

      expect(model.message, 'Welcome back');
    });
  });
}
