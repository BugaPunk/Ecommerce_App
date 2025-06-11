import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../models/user.dart';
import '../models/create_vendor_request.dart';
import 'api_constants.dart';

class AdminService {
  final http.Client _client = http.Client();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  // Obtener lista de todos los usuarios
  Future<List<User>> getAllUsers() async {
    try {
      final token = await _secureStorage.read(key: ApiConstants.tokenKey);

      if (token == null) {
        throw Exception('No authentication token found');
      }

      print('[DEBUG_LOG] Getting all users list');
      print('[DEBUG_LOG] API URL: ${ApiConstants.baseUrl}/api/admin/usuarios');

      final response = await _client.get(
        Uri.parse('${ApiConstants.baseUrl}/api/admin/usuarios'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('[DEBUG_LOG] Get all users response status code: ${response.statusCode}');
      print('[DEBUG_LOG] Get all users response body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> usersJson = jsonDecode(response.body);
        return usersJson.map((json) => User.fromJson(json)).toList();
      } else if (response.statusCode == 401) {
        throw Exception('Session expired. Please login again.');
      } else if (response.statusCode == 403) {
        throw Exception('You do not have permission to access this resource.');
      } else {
        throw Exception('Failed to get users: ${response.statusCode}');
      }
    } catch (e) {
      print('[DEBUG_LOG] Error getting all users: $e');
      throw Exception('Error getting users: ${e.toString()}');
    }
  }

  // Obtener lista de vendedores
  Future<List<User>> getVendors() async {
    try {
      final token = await _secureStorage.read(key: ApiConstants.tokenKey);

      if (token == null) {
        throw Exception('No authentication token found');
      }

      print('[DEBUG_LOG] Getting vendors list');
      print('[DEBUG_LOG] API URL: ${ApiConstants.baseUrl}/api/admin/usuarios/vendedores');

      final response = await _client.get(
        Uri.parse('${ApiConstants.baseUrl}/api/admin/usuarios/vendedores'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('[DEBUG_LOG] Get vendors response status code: ${response.statusCode}');
      print('[DEBUG_LOG] Get vendors response body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> vendorsJson = jsonDecode(response.body);
        return vendorsJson.map((json) => User.fromJson(json)).toList();
      } else if (response.statusCode == 401) {
        throw Exception('Session expired. Please login again.');
      } else if (response.statusCode == 403) {
        throw Exception('You do not have permission to access this resource.');
      } else {
        throw Exception('Failed to get vendors: ${response.statusCode}');
      }
    } catch (e) {
      print('[DEBUG_LOG] Error getting vendors: $e');
      throw Exception('Error getting vendors: ${e.toString()}');
    }
  }

  // Obtener detalles de un usuario
  Future<User> getUserDetails(int userId) async {
    try {
      final token = await _secureStorage.read(key: ApiConstants.tokenKey);

      if (token == null) {
        throw Exception('No authentication token found');
      }

      print('[DEBUG_LOG] Getting user details');
      print('[DEBUG_LOG] API URL: ${ApiConstants.baseUrl}/api/admin/usuarios/$userId');

      final response = await _client.get(
        Uri.parse('${ApiConstants.baseUrl}/api/admin/usuarios/$userId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('[DEBUG_LOG] Get user details response status code: ${response.statusCode}');
      print('[DEBUG_LOG] Get user details response body: ${response.body}');

      if (response.statusCode == 200) {
        return User.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 401) {
        throw Exception('Session expired. Please login again.');
      } else if (response.statusCode == 403) {
        throw Exception('You do not have permission to access this resource.');
      } else if (response.statusCode == 404) {
        throw Exception('User not found with ID: $userId');
      } else {
        throw Exception('Failed to get user details: ${response.statusCode}');
      }
    } catch (e) {
      print('[DEBUG_LOG] Error getting user details: $e');
      throw Exception('Error getting user details: ${e.toString()}');
    }
  }

  // Crear un nuevo vendedor
  Future<User> createVendor(CreateVendorRequest request) async {
    try {
      final token = await _secureStorage.read(key: ApiConstants.tokenKey);

      if (token == null) {
        throw Exception('No authentication token found');
      }

      print('[DEBUG_LOG] Creating new vendor');
      print('[DEBUG_LOG] API URL: ${ApiConstants.baseUrl}/api/admin/usuarios/vendedores');

      final requestBody = jsonEncode(request.toJson());
      print('[DEBUG_LOG] Request body: $requestBody');

      final response = await _client.post(
        Uri.parse('${ApiConstants.baseUrl}/api/admin/usuarios/vendedores'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: requestBody,
      );

      print('[DEBUG_LOG] Create vendor response status code: ${response.statusCode}');
      print('[DEBUG_LOG] Create vendor response body: ${response.body}');

      if (response.statusCode == 200) {
        return User.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 400) {
        final errorBody = jsonDecode(response.body);
        if (errorBody.containsKey('username')) {
          throw Exception(errorBody['username']);
        } else if (errorBody.containsKey('email')) {
          throw Exception(errorBody['email']);
        } else if (errorBody.containsKey('message')) {
          throw Exception(errorBody['message']);
        } else {
          throw Exception('Invalid data provided');
        }
      } else if (response.statusCode == 401) {
        throw Exception('Session expired. Please login again.');
      } else if (response.statusCode == 403) {
        throw Exception('You do not have permission to access this resource.');
      } else {
        throw Exception('Failed to create vendor: ${response.statusCode}');
      }
    } catch (e) {
      print('[DEBUG_LOG] Error creating vendor: $e');
      throw Exception('Error creating vendor: ${e.toString()}');
    }
  }

  // Activar/Desactivar un usuario
  Future<String> toggleUserStatus(int userId, bool active) async {
    try {
      final token = await _secureStorage.read(key: ApiConstants.tokenKey);

      if (token == null) {
        throw Exception('No authentication token found');
      }

      print('[DEBUG_LOG] Toggling user status');
      print('[DEBUG_LOG] API URL: ${ApiConstants.baseUrl}/api/admin/usuarios/$userId/active?active=$active');

      final response = await _client.patch(
        Uri.parse('${ApiConstants.baseUrl}/api/admin/usuarios/$userId/active?active=$active'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('[DEBUG_LOG] Toggle user status response status code: ${response.statusCode}');
      print('[DEBUG_LOG] Toggle user status response body: ${response.body}');

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        return responseBody['message'] ?? 'User status updated successfully';
      } else if (response.statusCode == 401) {
        throw Exception('Session expired. Please login again.');
      } else if (response.statusCode == 403) {
        throw Exception('You do not have permission to access this resource.');
      } else if (response.statusCode == 404) {
        throw Exception('User not found with ID: $userId');
      } else {
        throw Exception('Failed to update user status: ${response.statusCode}');
      }
    } catch (e) {
      print('[DEBUG_LOG] Error toggling user status: $e');
      throw Exception('Error toggling user status: ${e.toString()}');
    }
  }
}