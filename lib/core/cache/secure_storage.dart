import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../errors/exceptions.dart';

/// Abstract Secure Storage Interface
abstract class SecureStorageService {
  Future<void> saveAuthToken(String token);
  Future<String?> getAuthToken();
  Future<void> deleteAuthToken();
  Future<void> saveRefreshToken(String token);
  Future<String?> getRefreshToken();
  Future<void> deleteRefreshToken();

  Future<void> saveUserId(String userId);
  Future<String?> getUserId();
  Future<void> saveUserEmail(String email);
  Future<String?> getUserEmail();
  Future<void> saveAuthProvider(String provider);
  Future<String?> getAuthProvider();

  Future<void> saveUserData(Map<String, dynamic> jsonData);
  Future<Map<String, dynamic>?> getUserData();

  Future<void> saveCustom(String key, String value);
  Future<String?> readCustom(String key);
  Future<void> deleteCustom(String key);

  Future<void> saveSession({
    required String authToken,
    required String refreshToken,
    required String userId,
    String? userEmail,
  });
  Future<bool> hasActiveSession();
  Future<void> clearSession();
  Future<void> clearAll();
}

/// Concrete implementation wrapping [FlutterSecureStorage]
class SecureStorageServiceImpl implements SecureStorageService {
  final FlutterSecureStorage storage;

  SecureStorageServiceImpl({FlutterSecureStorage? storage})
    : storage =
          storage ??
          const FlutterSecureStorage(
            aOptions: AndroidOptions(),
            iOptions: IOSOptions(
              accessibility: KeychainAccessibility.first_unlock_this_device,
            ),
          );

  static const _keyAuthToken = 'auth_token';
  static const _keyRefreshToken = 'refresh_token';
  static const _keyUserId = 'user_id';
  static const _keyUserEmail = 'user_email';
  static const _keyUserData = 'user_data';
  static const _keyAuthProvider = 'auth_provider';

  @override
  Future<void> saveAuthToken(String token) => _write(_keyAuthToken, token);

  @override
  Future<String?> getAuthToken() => _read(_keyAuthToken);

  @override
  Future<void> deleteAuthToken() => _delete(_keyAuthToken);

  @override
  Future<void> saveRefreshToken(String token) =>
      _write(_keyRefreshToken, token);

  @override
  Future<String?> getRefreshToken() => _read(_keyRefreshToken);

  @override
  Future<void> deleteRefreshToken() => _delete(_keyRefreshToken);

  @override
  Future<void> saveUserId(String userId) => _write(_keyUserId, userId);

  @override
  Future<String?> getUserId() => _read(_keyUserId);

  @override
  Future<void> saveUserEmail(String email) => _write(_keyUserEmail, email);

  @override
  Future<String?> getUserEmail() => _read(_keyUserEmail);

  @override
  Future<void> saveAuthProvider(String provider) =>
      _write(_keyAuthProvider, provider);

  @override
  Future<String?> getAuthProvider() => _read(_keyAuthProvider);

  @override
  Future<void> saveUserData(Map<String, dynamic> jsonData) =>
      _write(_keyUserData, jsonEncode(jsonData));

  @override
  Future<Map<String, dynamic>?> getUserData() async {
    final jsonString = await _read(_keyUserData);
    if (jsonString == null || jsonString.isEmpty) {
      return null;
    }
    try {
      return jsonDecode(jsonString) as Map<String, dynamic>;
    } catch (e) {
      throw CacheException(message: 'Failed to decode user data: $e');
    }
  }

  @override
  Future<void> saveCustom(String key, String value) => _write(key, value);

  @override
  Future<String?> readCustom(String key) => _read(key);

  @override
  Future<void> deleteCustom(String key) => _delete(key);

  @override
  Future<void> saveSession({
    required String authToken,
    required String refreshToken,
    required String userId,
    String? userEmail,
  }) async {
    await Future.wait([
      saveAuthToken(authToken),
      saveRefreshToken(refreshToken),
      saveUserId(userId),
      if (userEmail != null) saveUserEmail(userEmail),
    ]);
  }

  @override
  Future<bool> hasActiveSession() async {
    final token = await getAuthToken();
    return token != null && token.isNotEmpty;
  }

  @override
  Future<void> clearSession() async {
    await Future.wait([
      deleteAuthToken(),
      deleteRefreshToken(),
      _delete(_keyUserId),
      _delete(_keyUserEmail),
      _delete(_keyUserData),
      _delete(_keyAuthProvider),
    ]);
  }

  @override
  Future<void> clearAll() => storage.deleteAll();

  Future<void> _write(String key, String value) async {
    try {
      await storage.write(key: key, value: value);
    } catch (e) {
      throw CacheException(message: 'Failed to write key "$key": $e');
    }
  }

  Future<String?> _read(String key) async {
    try {
      return await storage.read(key: key);
    } catch (e) {
      throw CacheException(message: 'Failed to read key "$key": $e');
    }
  }

  Future<void> _delete(String key) async {
    try {
      await storage.delete(key: key);
    } catch (e) {
      throw CacheException(message: 'Failed to delete key "$key": $e');
    }
  }
}
