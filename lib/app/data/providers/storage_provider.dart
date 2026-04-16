import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../utils/constants.dart';
import '../models/rider_model.dart';

class StorageProvider {
  static final StorageProvider _instance = StorageProvider._internal();
  factory StorageProvider() => _instance;
  StorageProvider._internal();

  final _storage = const FlutterSecureStorage();

  Future<void> saveToken(String token) =>
      _storage.write(key: StorageKeys.riderToken, value: token);

  Future<String?> getToken() =>
      _storage.read(key: StorageKeys.riderToken);

  Future<void> clearToken() =>
      _storage.delete(key: StorageKeys.riderToken);

  Future<void> saveRider(RiderModel rider) =>
      _storage.write(key: StorageKeys.riderData, value: jsonEncode(rider.toJson()));

  Future<RiderModel?> getRider() async {
    final data = await _storage.read(key: StorageKeys.riderData);
    if (data == null) return null;
    return RiderModel.fromJson(jsonDecode(data) as Map<String, dynamic>);
  }

  Future<void> clearAll() => _storage.deleteAll();

  Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }
}
