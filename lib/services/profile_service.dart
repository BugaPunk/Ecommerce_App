import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../models/user_profile_response.dart';
import '../models/update_profile_request.dart';
import '../models/change_password_request.dart';
import 'api_constants.dart';

class ProfileService {
  final http.Client _client = http.Client();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  // Get user profile
  Future<UserProfileResponse> getUserProfile() async {
    try {
      final token = await _secureStorage.read(key: ApiConstants.tokenKey);

      if (token == null) {
        throw Exception('No authentication token found');
      }

      final response = await _client.get(
        Uri.parse(ApiConstants.baseUrl + ApiConstants.profileEndpoint),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return UserProfileResponse.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 401) {
        throw Exception('Session expired. Please login again.');
      } else if (response.statusCode == 404) {
        throw Exception('User profile not found');
      } else {
        throw Exception('Failed to get profile: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Profile error: ${e.toString()}');
    }
  }

  // Update user profile
  Future<UserProfileResponse> updateProfile(UpdateProfileRequest request) async {
    try {
      final token = await _secureStorage.read(key: ApiConstants.tokenKey);

      if (token == null) {
        throw Exception('No authentication token found');
      }

      if (request.isEmpty) {
        throw Exception('No changes to update');
      }

      print('[DEBUG_LOG] Updating user profile');
      print('[DEBUG_LOG] API URL: ${ApiConstants.baseUrl + ApiConstants.profileEndpoint}');

      final requestBody = jsonEncode(request.toJson());
      print('[DEBUG_LOG] Request body: $requestBody');

      final response = await _client.put(
        Uri.parse(ApiConstants.baseUrl + ApiConstants.profileEndpoint),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: requestBody,
      );

      print('[DEBUG_LOG] Update profile response status code: ${response.statusCode}');
      print('[DEBUG_LOG] Update profile response body: ${response.body}');

      if (response.statusCode == 200) {
        return UserProfileResponse.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 400) {
        final errorBody = jsonDecode(response.body);
        throw Exception(errorBody['message'] ?? 'Invalid data provided');
      } else if (response.statusCode == 401) {
        throw Exception('Session expired. Please login again.');
      } else {
        throw Exception('Failed to update profile: ${response.statusCode}');
      }
    } catch (e) {
      print('[DEBUG_LOG] Error updating profile: $e');
      throw Exception('Update error: ${e.toString()}');
    }
  }

  // Change password
  Future<String> changePassword(ChangePasswordRequest request) async {
    try {
      final token = await _secureStorage.read(key: ApiConstants.tokenKey);

      if (token == null) {
        throw Exception('No authentication token found');
      }

      if (!request.isValid) {
        throw Exception(request.validationError ?? 'Invalid password data');
      }

      print('[DEBUG_LOG] Changing user password');
      print('[DEBUG_LOG] API URL: ${ApiConstants.baseUrl + ApiConstants.changePasswordEndpoint}');

      final requestBody = jsonEncode(request.toJson());
      print('[DEBUG_LOG] Request body: $requestBody');

      final response = await _client.post(
        Uri.parse(ApiConstants.baseUrl + ApiConstants.changePasswordEndpoint),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: requestBody,
      );

      print('[DEBUG_LOG] Change password response status code: ${response.statusCode}');
      print('[DEBUG_LOG] Change password response body: ${response.body}');

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        return responseBody['message'] ?? 'Password changed successfully';
      } else if (response.statusCode == 400) {
        final errorBody = jsonDecode(response.body);
        throw Exception(errorBody['message'] ?? 'Invalid password data');
      } else if (response.statusCode == 401) {
        throw Exception('Session expired. Please login again.');
      } else {
        throw Exception('Failed to change password: ${response.statusCode}');
      }
    } catch (e) {
      print('[DEBUG_LOG] Error changing password: $e');
      throw Exception('Password change error: ${e.toString()}');
    }
  }
}
