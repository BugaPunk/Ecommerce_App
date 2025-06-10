import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../models/store.dart';
import 'api_constants.dart';

class StoreService {
  final http.Client _client = http.Client();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  // Obtener todas las tiendas
  Future<List<Store>> getAllStores() async {
    try {
      print('[DEBUG_LOG] Getting all stores');
      final url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.storesEndpoint}');
      print('[DEBUG_LOG] API URL: $url');

      final response = await _client.get(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      print('[DEBUG_LOG] Get all stores response status code: ${response.statusCode}');
      print('[DEBUG_LOG] Get all stores response body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> storesJson = jsonDecode(response.body);
        return storesJson.map((json) => Store.fromJson(json)).toList();
      } else {
        throw Exception('Failed to get all stores: ${response.statusCode}');
      }
    } catch (e) {
      print('[DEBUG_LOG] Error getting all stores: $e');
      throw Exception('Error getting all stores: ${e.toString()}');
    }
  }

  // Obtener tienda por ID
  Future<Store> getStoreById(int storeId) async {
    try {
      print('[DEBUG_LOG] Getting store by ID');
      final url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.storesEndpoint}/$storeId');
      print('[DEBUG_LOG] API URL: $url');

      final response = await _client.get(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      print('[DEBUG_LOG] Get store by ID response status code: ${response.statusCode}');
      print('[DEBUG_LOG] Get store by ID response body: ${response.body}');

      if (response.statusCode == 200) {
        return Store.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 404) {
        throw Exception('Store not found with ID: $storeId');
      } else {
        throw Exception('Failed to get store by ID: ${response.statusCode}');
      }
    } catch (e) {
      print('[DEBUG_LOG] Error getting store by ID: $e');
      throw Exception('Error getting store by ID: ${e.toString()}');
    }
  }

  // Crear tienda
  Future<Store> createStore(Store store) async {
    try {
      final token = await _secureStorage.read(key: ApiConstants.tokenKey);

      if (token == null) {
        throw Exception('No authentication token found');
      }

      print('[DEBUG_LOG] Creating store');
      final url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.storesEndpoint}');
      print('[DEBUG_LOG] API URL: $url');

      final requestBody = jsonEncode(store.toJson());
      print('[DEBUG_LOG] Request body: $requestBody');

      final response = await _client.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: requestBody,
      );

      print('[DEBUG_LOG] Create store response status code: ${response.statusCode}');
      print('[DEBUG_LOG] Create store response body: ${response.body}');

      if (response.statusCode == 200) {
        return Store.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 401) {
        throw Exception('Session expired. Please login again.');
      } else if (response.statusCode == 403) {
        throw Exception('You do not have permission to create stores.');
      } else {
        throw Exception('Failed to create store: ${response.statusCode}');
      }
    } catch (e) {
      print('[DEBUG_LOG] Error creating store: $e');
      throw Exception('Error creating store: ${e.toString()}');
    }
  }

  // Actualizar tienda
  Future<Store> updateStore(int storeId, Store store) async {
    try {
      final token = await _secureStorage.read(key: ApiConstants.tokenKey);

      if (token == null) {
        throw Exception('No authentication token found');
      }

      print('[DEBUG_LOG] Updating store');
      final url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.storesEndpoint}/$storeId');
      print('[DEBUG_LOG] API URL: $url');

      final requestBody = jsonEncode(store.toJson());
      print('[DEBUG_LOG] Request body: $requestBody');

      final response = await _client.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: requestBody,
      );

      print('[DEBUG_LOG] Update store response status code: ${response.statusCode}');
      print('[DEBUG_LOG] Update store response body: ${response.body}');

      if (response.statusCode == 200) {
        return Store.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 401) {
        throw Exception('Session expired. Please login again.');
      } else if (response.statusCode == 403) {
        throw Exception('You do not have permission to update stores.');
      } else if (response.statusCode == 404) {
        throw Exception('Store not found with ID: $storeId');
      } else {
        throw Exception('Failed to update store: ${response.statusCode}');
      }
    } catch (e) {
      print('[DEBUG_LOG] Error updating store: $e');
      throw Exception('Error updating store: ${e.toString()}');
    }
  }

  // Eliminar tienda
  Future<void> deleteStore(int storeId) async {
    try {
      final token = await _secureStorage.read(key: ApiConstants.tokenKey);

      if (token == null) {
        throw Exception('No authentication token found');
      }

      print('[DEBUG_LOG] Deleting store');
      final url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.storesEndpoint}/$storeId');
      print('[DEBUG_LOG] API URL: $url');

      final response = await _client.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('[DEBUG_LOG] Delete store response status code: ${response.statusCode}');

      if (response.statusCode == 204) {
        return;
      } else if (response.statusCode == 401) {
        throw Exception('Session expired. Please login again.');
      } else if (response.statusCode == 403) {
        throw Exception('You do not have permission to delete stores.');
      } else if (response.statusCode == 404) {
        throw Exception('Store not found with ID: $storeId');
      } else {
        throw Exception('Failed to delete store: ${response.statusCode}');
      }
    } catch (e) {
      print('[DEBUG_LOG] Error deleting store: $e');
      throw Exception('Error deleting store: ${e.toString()}');
    }
  }
}