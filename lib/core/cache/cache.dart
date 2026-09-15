import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// Abstract Cache Interface adhering to DIP & ISP
abstract class CacheService {
  Future<bool> saveData({required String key, required dynamic value});
  dynamic getData({required String key});
  Future<bool> removeData(String key);
  bool containsKey({required String key});
  Future<bool> clearAll();
}

/// Concrete implementation of [CacheService] wrapping [SharedPreferences]
class CacheServiceImpl implements CacheService {
  final SharedPreferences sharedPreferences;

  CacheServiceImpl(this.sharedPreferences);

  @override
  Future<bool> saveData({required String key, required dynamic value}) async {
    if (value is Map<String, dynamic> || value is List<dynamic>) {
      return await sharedPreferences.setString(key, jsonEncode(value));
    }
    if (value is bool) return await sharedPreferences.setBool(key, value);
    if (value is String) return await sharedPreferences.setString(key, value);
    if (value is int) return await sharedPreferences.setInt(key, value);
    if (value is double) return await sharedPreferences.setDouble(key, value);
    if (value is List<String>) {
      return await sharedPreferences.setStringList(key, value);
    }
    return false;
  }

  @override
  dynamic getData({required String key}) {
    final value = sharedPreferences.get(key);
    if (value is String) {
      try {
        return jsonDecode(value);
      } catch (_) {
        return value;
      }
    }
    return value;
  }

  @override
  Future<bool> removeData(String key) async =>
      await sharedPreferences.remove(key);

  @override
  bool containsKey({required String key}) => sharedPreferences.containsKey(key);

  @override
  Future<bool> clearAll() async => await sharedPreferences.clear();
}
