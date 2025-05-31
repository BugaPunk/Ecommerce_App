import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user.dart';
import '../models/auth_response.dart';
import '../models/register_request.dart';
import '../models/login_request.dart';
import 'api_constants.dart';

class AuthService {
  final http.Client _client = http.Client();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  // Register a new user
  Future<bool> register(RegisterRequest request) async {
    try {
      print('[DEBUG_LOG] Attempting registration for user: ${request.username}');
      print('[DEBUG_LOG] API URL: ${ApiConstants.baseUrl + ApiConstants.registerEndpoint}');

      final requestBody = jsonEncode(request.toJson());
      print('[DEBUG_LOG] Request body: $requestBody');

      final response = await _client.post(
        Uri.parse(ApiConstants.baseUrl + ApiConstants.registerEndpoint),
        headers: {'Content-Type': 'application/json'},
        body: requestBody,
      );

      print('[DEBUG_LOG] Registration response status code: ${response.statusCode}');
      print('[DEBUG_LOG] Registration response headers: ${response.headers}');
      print('[DEBUG_LOG] Registration response body: ${response.body}');

      if (response.statusCode == 200) {
        return true;
      } else {
        // Handle error response
        String errorMessage = 'Registration failed';

        // Check if response body is not empty and try to parse it
        if (response.body.isNotEmpty) {
          try {
            final errorData = jsonDecode(response.body);
            errorMessage = errorData['message'] ?? errorMessage;
          } catch (e) {
            // If JSON parsing fails, use the raw response body if it's not too long
            if (response.body.length < 100) {
              errorMessage = 'Registration failed: ${response.body}';
            }
          }
        }

        // Include status code in error message for debugging
        throw Exception('$errorMessage (Status code: ${response.statusCode})');
      }
    } catch (e) {
      // If it's already an Exception, rethrow it, otherwise wrap it
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Registration error: ${e.toString()}');
    }
  }

  // Login user and get token
  Future<AuthResponse> login(LoginRequest request) async {
    try {
      print('[DEBUG_LOG] Attempting login for user: ${request.username}');
      print('[DEBUG_LOG] API URL: ${ApiConstants.baseUrl + ApiConstants.loginEndpoint}');

      final requestBody = jsonEncode(request.toJson());
      print('[DEBUG_LOG] Request body: $requestBody');

      final response = await _client.post(
        Uri.parse(ApiConstants.baseUrl + ApiConstants.loginEndpoint),
        headers: {'Content-Type': 'application/json'},
        body: requestBody,
      );

      print('[DEBUG_LOG] Login response status code: ${response.statusCode}');
      print('[DEBUG_LOG] Login response headers: ${response.headers}');
      print('[DEBUG_LOG] Login response body: ${response.body}');

      if (response.statusCode == 200) {
        final authResponse = AuthResponse.fromJson(jsonDecode(response.body));

        // Save token securely
        await _secureStorage.write(
          key: ApiConstants.tokenKey,
          value: authResponse.token,
        );

        // Save user data
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(
          ApiConstants.userKey,
          jsonEncode({
            'id': authResponse.id,
            'username': authResponse.username,
            'email': authResponse.email,
            'firstName': '',
            'lastName': '',
            'roles': authResponse.roles,
            'active': true,
          }),
        );

        return authResponse;
      } else {
        // Handle error response
        String errorMessage = 'Login failed';

        // Check if response body is not empty and try to parse it
        if (response.body.isNotEmpty) {
          try {
            final errorData = jsonDecode(response.body);
            errorMessage = errorData['message'] ?? errorMessage;
          } catch (e) {
            // If JSON parsing fails, use the raw response body if it's not too long
            if (response.body.length < 100) {
              errorMessage = 'Login failed: ${response.body}';
            }
          }
        }

        // Include status code in error message for debugging
        throw Exception('$errorMessage (Status code: ${response.statusCode})');
      }
    } catch (e) {
      // If it's already an Exception, rethrow it, otherwise wrap it
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Login error: ${e.toString()}');
    }
  }

  // Get current session info
  Future<User?> getSessionInfo() async {
    try {
      final token = await _secureStorage.read(key: ApiConstants.tokenKey);

      if (token == null) {
        return null;
      }

      final response = await _client.get(
        Uri.parse(ApiConstants.baseUrl + ApiConstants.sessionInfoEndpoint),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        // Check if response body is not empty before parsing
        if (response.body.isNotEmpty) {
          try {
            final userData = jsonDecode(response.body);
            return User.fromJson(userData);
          } catch (e) {
            // JSON parsing error
            print('Error parsing session info: ${e.toString()}');
            await logout();
            return null;
          }
        } else {
          // Empty response body
          print('Empty response body from session info endpoint');
          await logout();
          return null;
        }
      } else {
        // Token might be expired or invalid
        print('Session info failed with status code: ${response.statusCode}');
        await logout();
        return null;
      }
    } catch (e) {
      // In case of error, clear token and return null
      print('Error getting session info: ${e.toString()}');
      await logout();
      return null;
    }
  }

  // Logout user
  Future<bool> logout() async {
    try {
      final token = await _secureStorage.read(key: ApiConstants.tokenKey);

      if (token != null) {
        // Call logout endpoint
        await _client.post(
          Uri.parse(ApiConstants.baseUrl + ApiConstants.logoutEndpoint),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );
      }

      // Clear token and user data regardless of API response
      await _secureStorage.delete(key: ApiConstants.tokenKey);

      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(ApiConstants.userKey);

      return true;
    } catch (e) {
      // Even if API call fails, clear local data
      await _secureStorage.delete(key: ApiConstants.tokenKey);

      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(ApiConstants.userKey);

      return false;
    }
  }

  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    final token = await _secureStorage.read(key: ApiConstants.tokenKey);
    return token != null;
  }

  // Get current user from shared preferences
  Future<User?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString(ApiConstants.userKey);

    if (userData != null) {
      return User.fromJson(jsonDecode(userData));
    }

    return null;
  }

  // Get auth token
  Future<String?> getToken() async {
    return await _secureStorage.read(key: ApiConstants.tokenKey);
  }

  // Update stored user data
  Future<void> updateStoredUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      ApiConstants.userKey,
      jsonEncode(user.toJson()),
    );
  }
}
