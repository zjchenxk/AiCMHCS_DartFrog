import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/user.dart';

/// 后端 API 异常（message 直接展示给用户）。
class ApiException implements Exception {
  const ApiException(this.message, {this.statusCode});

  final String message;
  final int? statusCode;

  @override
  String toString() => message;
}

/// 认证 API 客户端。
///
/// 后端地址通过编译参数覆盖：
///   flutter run -d chrome --dart-define=AICMHCS_API_BASE=http://host:8080
class AuthApi {
  AuthApi({http.Client? client})
      : _client = client ?? http.Client();

  static const String baseUrl = String.fromEnvironment(
    'AICMHCS_API_BASE',
    defaultValue: 'http://localhost:8080',
  );

  final http.Client _client;

  static const _timeout = Duration(seconds: 15);

  /// POST /api/auth/login
  Future<LoginResult> login(String username, String password) async {
    Map<String, dynamic> body;
    try {
      final response = await _client
          .post(
            Uri.parse('$baseUrl/api/auth/login'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'username': username, 'password': password}),
          )
          .timeout(_timeout);
      body = _decode(response);
    } on ApiException {
      rethrow;
    } catch (_) {
      throw const ApiException('无法连接服务器，请确认后端已启动');
    }
    if (body['code'] != 0) {
      throw ApiException(body['message'] as String? ?? '登录失败');
    }
    return LoginResult.fromJson(body['data'] as Map<String, dynamic>);
  }

  /// GET /api/auth/me
  Future<User> me(String token) async {
    Map<String, dynamic> body;
    try {
      final response = await _client
          .get(
            Uri.parse('$baseUrl/api/auth/me'),
            headers: {'Authorization': 'Bearer $token'},
          )
          .timeout(_timeout);
      body = _decode(response);
    } on ApiException {
      rethrow;
    } catch (_) {
      throw const ApiException('无法连接服务器，请确认后端已启动');
    }
    if (body['code'] != 0) {
      throw ApiException(body['message'] as String? ?? '获取用户信息失败');
    }
    return User.fromJson(body['data'] as Map<String, dynamic>);
  }

  Map<String, dynamic> _decode(http.Response response) {
    Map<String, dynamic> body;
    try {
      body = jsonDecode(response.body) as Map<String, dynamic>;
    } catch (_) {
      throw const ApiException('服务器响应格式异常');
    }
    if (response.statusCode >= 400 && body['code'] == null) {
      throw ApiException('请求失败（HTTP ${response.statusCode}）',
          statusCode: response.statusCode);
    }
    return body;
  }
}
