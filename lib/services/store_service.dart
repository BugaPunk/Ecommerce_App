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
      final token = await _secureStorage.read(key: ApiConstants.tokenKey);
      
      if (token == null) {
        throw Exception('No authentication token found');
      }

      final url = Uri.parse('${ApiConstants.baseUrl}/api/tiendas');

      final response = await _client.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> storesJson = jsonDecode(response.body);
        return storesJson.map((json) => Store.fromJson(json)).toList();
      } else if (response.statusCode == 401) {
        throw Exception('Session expired. Please login again.');
      } else if (response.statusCode == 403) {
        throw Exception('You do not have permission to view stores.');
      } else {
        throw Exception('Failed to get stores: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error getting stores: ${e.toString()}');
    }
  }

  // Mantener compatibilidad con el método anterior
  Future<List<Store>> getStores() async {
    return getAllStores();
  }

  // Obtener una tienda por ID
  Future<Store> getStoreById(int id) async {
    try {
      final token = await _secureStorage.read(key: ApiConstants.tokenKey);
      
      if (token == null) {
        throw Exception('No authentication token found');
      }

      final url = Uri.parse('${ApiConstants.baseUrl}/api/tiendas/$id');

      final response = await _client.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return Store.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 401) {
        throw Exception('Session expired. Please login again.');
      } else if (response.statusCode == 404) {
        throw Exception('Store not found.');
      } else {
        throw Exception('Failed to get store: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error getting store: ${e.toString()}');
    }
  }

  // Crear una nueva tienda
  Future<Store> createStore(StoreRequest storeRequest) async {
    try {
      final token = await _secureStorage.read(key: ApiConstants.tokenKey);
      
      if (token == null) {
        throw Exception('No authentication token found');
      }

      final url = Uri.parse('${ApiConstants.baseUrl}/api/tiendas');
      final requestBody = jsonEncode(storeRequest.toJson());

      final response = await _client.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: requestBody,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return Store.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 401) {
        throw Exception('Session expired. Please login again.');
      } else if (response.statusCode == 403) {
        throw Exception('You do not have permission to create stores.');
      } else if (response.statusCode == 400) {
        final errorBody = jsonDecode(response.body);
        throw Exception('Validation error: ${errorBody['message'] ?? 'Invalid data'}');
      } else {
        throw Exception('Failed to create store: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error creating store: ${e.toString()}');
    }
  }

  // Actualizar una tienda existente
  Future<Store> updateStore(int id, StoreUpdateRequest storeUpdateRequest) async {
    try {
      final token = await _secureStorage.read(key: ApiConstants.tokenKey);
      
      if (token == null) {
        throw Exception('No authentication token found');
      }

      final url = Uri.parse('${ApiConstants.baseUrl}/api/tiendas/$id');
      final requestBody = jsonEncode(storeUpdateRequest.toJson());

      final response = await _client.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: requestBody,
      );

      if (response.statusCode == 200) {
        return Store.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 401) {
        throw Exception('Session expired. Please login again.');
      } else if (response.statusCode == 403) {
        throw Exception('You do not have permission to update stores.');
      } else if (response.statusCode == 404) {
        throw Exception('Store not found.');
      } else if (response.statusCode == 400) {
        final errorBody = jsonDecode(response.body);
        throw Exception('Validation error: ${errorBody['message'] ?? 'Invalid data'}');
      } else {
        throw Exception('Failed to update store: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error updating store: ${e.toString()}');
    }
  }

  // Eliminar una tienda
  Future<void> deleteStore(int id) async {
    try {
      final token = await _secureStorage.read(key: ApiConstants.tokenKey);
      
      if (token == null) {
        throw Exception('No authentication token found');
      }

      final url = Uri.parse('${ApiConstants.baseUrl}/api/tiendas/$id');

      final response = await _client.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 204 || response.statusCode == 200) {
        // Eliminación exitosa
        return;
      } else if (response.statusCode == 401) {
        throw Exception('Session expired. Please login again.');
      } else if (response.statusCode == 403) {
        throw Exception('You do not have permission to delete stores.');
      } else if (response.statusCode == 404) {
        throw Exception('Store not found.');
      } else {
        throw Exception('Failed to delete store: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error deleting store: ${e.toString()}');
    }
  }

  // Limpiar recursos
  void dispose() {
    _client.close();
  }
}