import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../network/api_endpoints.dart';

class ApiResponse<T> {
  final bool success;
  final String message;
  final T? data;
  final int statusCode;

  ApiResponse({
    required this.success,
    required this.message,
    this.data,
    this.statusCode = 200,
  });
}

class AuthService {
  // Singleton pattern
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  static const String _tokenKey = 'aayup_auth_token';
  static const String _userKey = 'aayup_user_data';

  UserModel? _currentUser;
  String? _authToken;

  UserModel? get currentUser => _currentUser;
  String? get token => _authToken;
  bool get isAuthenticated => _authToken != null && _authToken!.isNotEmpty;

  /// Initialize and restore session from local SharedPreferences
  Future<bool> tryAutoLogin() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedToken = prefs.getString(_tokenKey);
      final savedUserJson = prefs.getString(_userKey);

      if (savedToken != null && savedToken.isNotEmpty && savedUserJson != null) {
        _authToken = savedToken;
        _currentUser = UserModel.fromJson(jsonDecode(savedUserJson));
        return true;
      }
    } catch (_) {}
    return false;
  }

  /// Perform corporate login with admin-issued ID/Email & Password
  Future<ApiResponse<UserModel>> login({
    required String empId,
    required String password,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse(ApiEndpoints.login),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'empId': empId.trim(),
              'email': empId.trim(),
              'password': password.trim(),
            }),
          )
          .timeout(const Duration(seconds: 10));

      final jsonMap = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200 && jsonMap['success'] == true) {
        final user = UserModel.fromJson(jsonMap['user'] as Map<String, dynamic>);
        _currentUser = user;
        _authToken = jsonMap['token'] as String?;

        // Persist session to local storage
        try {
          final prefs = await SharedPreferences.getInstance();
          if (_authToken != null) {
            await prefs.setString(_tokenKey, _authToken!);
          }
          await prefs.setString(_userKey, jsonEncode(user.toJson()));
        } catch (_) {}

        return ApiResponse(
          success: true,
          message: jsonMap['message'] as String? ?? 'Logged in successfully',
          data: user,
          statusCode: response.statusCode,
        );
      } else {
        return ApiResponse(
          success: false,
          message: jsonMap['message'] as String? ?? 'Invalid Employee ID/Email or Password.',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      return ApiResponse(
        success: false,
        message: 'Could not connect to backend server: $e',
        statusCode: 500,
      );
    }
  }

  Future<void> updateUser(UserModel updatedUser) async {
    _currentUser = updatedUser;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_userKey, jsonEncode(updatedUser.toJson()));
    } catch (_) {}
  }

  Future<void> logout() async {
    _currentUser = null;
    _authToken = null;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_tokenKey);
      await prefs.remove(_userKey);
    } catch (_) {}
  }
}
