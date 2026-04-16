import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import '../../utils/constants.dart';
import 'storage_provider.dart';

class ApiException implements Exception {
  final String message;
  const ApiException(this.message);
  @override
  String toString() => message;
}

class ApiProvider {
  final StorageProvider _storage = StorageProvider();

  Future<Map<String, String>> _headers({bool auth = true}) async {
    final headers = <String, String>{'Content-Type': 'application/json'};
    if (auth) {
      final token = await _storage.getToken();
      if (token != null) headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  Future<Map<String, dynamic>> get(String endpoint) async {
    try {
      final uri = Uri.parse('${ApiConstants.baseUrl}$endpoint');
      final response = await http.get(uri, headers: await _headers());
      return _handle(response);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(_friendlyError(e));
    }
  }

  Future<Map<String, dynamic>> post(String endpoint,
      {Map<String, dynamic>? body, bool auth = true}) async {
    try {
      final uri = Uri.parse('${ApiConstants.baseUrl}$endpoint');
      final response = await http.post(
        uri,
        headers: await _headers(auth: auth),
        body: body != null ? jsonEncode(body) : null,
      );
      return _handle(response);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(_friendlyError(e));
    }
  }

  Future<Map<String, dynamic>> put(String endpoint,
      {Map<String, dynamic>? body}) async {
    try {
      final uri = Uri.parse('${ApiConstants.baseUrl}$endpoint');
      final response = await http.put(
        uri,
        headers: await _headers(),
        body: body != null ? jsonEncode(body) : null,
      );
      return _handle(response);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(_friendlyError(e));
    }
  }

  Future<Map<String, dynamic>> patch(String endpoint,
      {Map<String, dynamic>? body}) async {
    try {
      final uri = Uri.parse('${ApiConstants.baseUrl}$endpoint');
      final response = await http.patch(
        uri,
        headers: await _headers(),
        body: body != null ? jsonEncode(body) : null,
      );
      return _handle(response);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(_friendlyError(e));
    }
  }

  Map<String, dynamic> _handle(http.Response response) {
    if (kDebugMode) {
      debugPrint('${response.request?.method} ${response.request?.url} → ${response.statusCode}');
    }
    Map<String, dynamic> data = {};
    try {
      data = jsonDecode(response.body) as Map<String, dynamic>;
    } catch (_) {}

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return data;
    }
    if (response.statusCode == 401) {
      // Only force logout if the user had a stored token (expired session)
      _storage.getToken().then((token) {
        if (token != null && token.isNotEmpty) {
          _storage.clearToken();
          Get.offAllNamed('/auth');
        }
      });
    }
    throw ApiException(data['message']?.toString() ?? 'Something went wrong');
  }

  String _friendlyError(dynamic e) {
    if (e is SocketException || e is HttpException) {
      return 'No internet connection. Please check your network.';
    }
    return e.toString();
  }
}
