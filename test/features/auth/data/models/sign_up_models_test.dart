import 'package:flutter_test/flutter_test.dart';
import 'package:Dukan/features/auth/data/models/sign_up_request_model.dart';
import 'package:Dukan/features/auth/data/models/sign_up_response_model.dart';
import 'package:Dukan/features/auth/domain/entities/sign_up_params.dart';

void main() {
  group('SignUpRequestModel', () {
    test('toJson produces correct snake_case and formatted birth_date', () {
      final params = SignUpParams(
        username: 'john_doe',
        email: 'john@example.com',
        password: 'secretPassword123',
        confirmPassword: 'secretPassword123',
        birthDate: DateTime(1995, 5, 20),
        phoneNumber: '+1234567890',
      );

      final model = SignUpRequestModel.fromEntity(params);
      final json = model.toJson();

      expect(json, {
        'username': 'john_doe',
        'email': 'john@example.com',
        'password': 'secretPassword123',
        'confirm_password': 'secretPassword123',
        'birth_date': '1995-05-20',
        'phone_number': '+1234567890',
      });
    });
  });

  group('SignUpResponseModel', () {
    test('fromJson parses nested data message correctly', () {
      final json = {
        'success': true,
        'statusCode': 201,
        'data': {'success': true, 'message': 'Email sent successfully'},
      };

      final model = SignUpResponseModel.fromJson(json);

      expect(model.success, true);
      expect(model.statusCode, 201);
      expect(model.message, 'Email sent successfully');
    });

    test('fromJson falls back to top-level message if data is null', () {
      final json = {
        'success': true,
        'statusCode': 201,
        'message': 'Top level message',
      };

      final model = SignUpResponseModel.fromJson(json);

      expect(model.message, 'Top level message');
    });
  });
}
