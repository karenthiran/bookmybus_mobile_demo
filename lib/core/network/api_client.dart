import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

import '../config/api_config.dart';
import 'api_exception.dart';

/// Thin wrapper around [http] that:
///  - points every request at [ApiConfig.baseUrl]
///  - attaches the signed-in Firebase user's ID token as
///    `Authorization: Bearer <token>` (the backend's
///    `verifyFirebaseTokenRequired` middleware expects exactly this)
///  - decodes JSON responses and turns non-2xx responses into [ApiException]
class ApiClient {
  ApiClient._();

  static final ApiClient instance = ApiClient._();

  static const Duration _timeout = Duration(seconds: 20);

  Future<Map<String, String>> _headers({required bool auth}) async {
    final headers = <String, String>{'Content-Type': 'application/json'};

    if (auth) {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw ApiException('You need to be signed in to do this.');
      }
      final token = await user.getIdToken();
      headers['Authorization'] = 'Bearer $token';
    }

    return headers;
  }

  Uri _uri(String path, [Map<String, dynamic>? query]) {
    final cleanPath = path.startsWith('/') ? path : '/$path';
    final base = Uri.parse('${ApiConfig.baseUrl}$cleanPath');
    if (query == null || query.isEmpty) return base;
    return base.replace(
      queryParameters: query.map((k, v) => MapEntry(k, '$v')),
    );
  }

  Future<dynamic> get(
    String path, {
    Map<String, dynamic>? query,
    bool auth = true,
  }) async {
    final res = await http
        .get(_uri(path, query), headers: await _headers(auth: auth))
        .timeout(_timeout);
    return _handle(res);
  }

  Future<dynamic> post(
    String path, {
    Object? body,
    bool auth = true,
  }) async {
    final res = await http
        .post(
          _uri(path),
          headers: await _headers(auth: auth),
          body: body == null ? null : jsonEncode(body),
        )
        .timeout(_timeout);
    return _handle(res);
  }

  Future<dynamic> put(
    String path, {
    Object? body,
    bool auth = true,
  }) async {
    final res = await http
        .put(
          _uri(path),
          headers: await _headers(auth: auth),
          body: body == null ? null : jsonEncode(body),
        )
        .timeout(_timeout);
    return _handle(res);
  }

  Future<dynamic> delete(String path, {bool auth = true}) async {
    final res = await http
        .delete(_uri(path), headers: await _headers(auth: auth))
        .timeout(_timeout);
    return _handle(res);
  }

  dynamic _handle(http.Response res) {
    dynamic decoded;
    if (res.body.isNotEmpty) {
      try {
        decoded = jsonDecode(res.body);
      } catch (_) {
        decoded = null;
      }
    }

    if (res.statusCode >= 200 && res.statusCode < 300) {
      return decoded;
    }

    final message = (decoded is Map && decoded['message'] != null)
        ? decoded['message'].toString()
        : 'Something went wrong (${res.statusCode}). Please try again.';
    throw ApiException(message, statusCode: res.statusCode);
  }
}
