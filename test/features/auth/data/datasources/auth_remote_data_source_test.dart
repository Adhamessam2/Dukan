import 'package:flutter_test/flutter_test.dart';
import 'package:Dukan/core/api/api_consumer.dart';
import 'package:Dukan/core/api/server_strings.dart';
import 'package:Dukan/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:Dukan/features/auth/data/models/login_request_model.dart';
import 'package:Dukan/features/auth/data/models/sign_up_request_model.dart';
import 'package:Dukan/features/auth/domain/entities/login_params.dart';
import 'package:Dukan/features/auth/domain/entities/sign_up_params.dart';

class MockApiConsumer implements ApiConsumer {
  String? calledPath;
  Map<String, dynamic>? calledBody;
  dynamic responseToReturn;

  @override
  Future<dynamic> post(
    String path, {
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    calledPath = path;
    calledBody = body;
    return responseToReturn;
  }

  @override
  Future delete(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) => throw UnimplementedError();
  @override
  Future get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) => throw UnimplementedError();
  @override
  Future patch(
    String path, {
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) => throw UnimplementedError();
  @override
  Future put(
    String path, {
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) => throw UnimplementedError();
}

void main() {
  test(
    'signUp calls ApiConsumer.post with ServerStrings.register and returns SignUpResponseModel',
    () async {
      final mockApiConsumer = MockApiConsumer();
      final dataSource = AuthRemoteDataSourceImpl(apiConsumer: mockApiConsumer);

      final requestModel = SignUpRequestModel.fromEntity(
        SignUpParams(
          username: 'user',
          email: 'user@example.com',
          password: 'pwd',
          confirmPassword: 'pwd',
          birthDate: DateTime(2000, 1, 1),
          phoneNumber: '123',
        ),
      );

      mockApiConsumer.responseToReturn = {
        'success': true,
        'statusCode': 201,
        'data': {'success': true, 'message': 'Email sent successfully'},
      };

      final result = await dataSource.signUp(requestModel);

      expect(mockApiConsumer.calledPath, ServerStrings.register);
      expect(result.message, 'Email sent successfully');
    },
  );

  test(
    'login calls ApiConsumer.post with ServerStrings.login and returns LoginResponseModel',
    () async {
      final mockApiConsumer = MockApiConsumer();
      final dataSource = AuthRemoteDataSourceImpl(apiConsumer: mockApiConsumer);

      final requestModel = LoginRequestModel.fromEntity(
        const LoginParams(email: 'user@example.com', password: 'password123'),
      );

      mockApiConsumer.responseToReturn = {
        'success': true,
        'statusCode': 201,
        'data': {'access_token': 'jwt_token_abc'},
      };

      final result = await dataSource.login(requestModel);

      expect(mockApiConsumer.calledPath, ServerStrings.login);
      expect(result.accessToken, 'jwt_token_abc');
      expect(result.success, true);
    },
  );
}
