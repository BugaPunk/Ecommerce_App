import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../models/category.dart';
import 'api_constants.dart';

class CategoryService {
  final http.Client _client = http.Client();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  // Obtener todas las categorías
  Future<List<Category>> getAllCategories() async {
    try {
      print('[DEBUG_LOG] Getting all categories');
      final url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.categoriesEndpoint}');
      print('[DEBUG_LOG] API URL: $url');

      final response = await _client.get(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      print('[DEBUG_LOG] Get all categories response status code: ${response.statusCode}');
      print('[DEBUG_LOG] Get all categories response body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> categoriesJson = jsonDecode(response.body);
        return categoriesJson.map((json) => Category.fromJson(json)).toList();
      } else {
        throw Exception('Failed to get all categories: ${response.statusCode}');
      }
    } catch (e) {
      print('[DEBUG_LOG] Error getting all categories: $e');
      throw Exception('Error getting all categories: ${e.toString()}');
    }
  }

  // Obtener categoría por ID
  Future<Category> getCategoryById(int categoryId) async {
    try {
      print('[DEBUG_LOG] Getting category by ID');
      final url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.categoriesEndpoint}/$categoryId');
      print('[DEBUG_LOG] API URL: $url');

      final response = await _client.get(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      print('[DEBUG_LOG] Get category by ID response status code: ${response.statusCode}');
      print('[DEBUG_LOG] Get category by ID response body: ${response.body}');

      if (response.statusCode == 200) {
        return Category.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 404) {
        throw Exception('Category not found with ID: $categoryId');
      } else {
        throw Exception('Failed to get category by ID: ${response.statusCode}');
      }
    } catch (e) {
      print('[DEBUG_LOG] Error getting category by ID: $e');
      throw Exception('Error getting category by ID: ${e.toString()}');
    }
  }

  // Obtener categorías por tienda
  Future<List<Category>> getCategoriesByStore(int storeId) async {
    try {
      print('[DEBUG_LOG] Getting categories by store');
      final url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.categoriesByStoreEndpoint}/$storeId');
      print('[DEBUG_LOG] API URL: $url');

      final response = await _client.get(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      print('[DEBUG_LOG] Get categories by store response status code: ${response.statusCode}');
      print('[DEBUG_LOG] Get categories by store response body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> categoriesJson = jsonDecode(response.body);
        return categoriesJson.map((json) => Category.fromJson(json)).toList();
      } else if (response.statusCode == 404) {
        throw Exception('Store not found with ID: $storeId');
      } else {
        throw Exception('Failed to get categories by store: ${response.statusCode}');
      }
    } catch (e) {
      print('[DEBUG_LOG] Error getting categories by store: $e');
      throw Exception('Error getting categories by store: ${e.toString()}');
    }
  }

  // Crear categoría
  Future<Category> createCategory(Category category) async {
    try {
      final token = await _secureStorage.read(key: ApiConstants.tokenKey);

      if (token == null) {
        throw Exception('No authentication token found');
      }

      print('[DEBUG_LOG] Creating category');
      final url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.categoriesEndpoint}');
      print('[DEBUG_LOG] API URL: $url');

      final requestBody = jsonEncode(category.toJson());
      print('[DEBUG_LOG] Request body: $requestBody');

      final response = await _client.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: requestBody,
      );

      print('[DEBUG_LOG] Create category response status code: ${response.statusCode}');
      print('[DEBUG_LOG] Create category response body: ${response.body}');

      if (response.statusCode == 200) {
        return Category.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 401) {
        throw Exception('Session expired. Please login again.');
      } else if (response.statusCode == 403) {
        throw Exception('You do not have permission to create categories.');
      } else {
        throw Exception('Failed to create category: ${response.statusCode}');
      }
    } catch (e) {
      print('[DEBUG_LOG] Error creating category: $e');
      throw Exception('Error creating category: ${e.toString()}');
    }
  }

  // Actualizar categoría
  Future<Category> updateCategory(int categoryId, Category category) async {
    try {
      final token = await _secureStorage.read(key: ApiConstants.tokenKey);

      if (token == null) {
        throw Exception('No authentication token found');
      }

      print('[DEBUG_LOG] Updating category');
      final url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.categoriesEndpoint}/$categoryId');
      print('[DEBUG_LOG] API URL: $url');

      final requestBody = jsonEncode(category.toJson());
      print('[DEBUG_LOG] Request body: $requestBody');

      final response = await _client.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: requestBody,
      );

      print('[DEBUG_LOG] Update category response status code: ${response.statusCode}');
      print('[DEBUG_LOG] Update category response body: ${response.body}');

      if (response.statusCode == 200) {
        return Category.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 401) {
        throw Exception('Session expired. Please login again.');
      } else if (response.statusCode == 403) {
        throw Exception('You do not have permission to update categories.');
      } else if (response.statusCode == 404) {
        throw Exception('Category not found with ID: $categoryId');
      } else {
        throw Exception('Failed to update category: ${response.statusCode}');
      }
    } catch (e) {
      print('[DEBUG_LOG] Error updating category: $e');
      throw Exception('Error updating category: ${e.toString()}');
    }
  }

  // Eliminar categoría
  Future<void> deleteCategory(int categoryId) async {
    try {
      final token = await _secureStorage.read(key: ApiConstants.tokenKey);

      if (token == null) {
        throw Exception('No authentication token found');
      }

      print('[DEBUG_LOG] Deleting category');
      final url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.categoriesEndpoint}/$categoryId');
      print('[DEBUG_LOG] API URL: $url');

      final response = await _client.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('[DEBUG_LOG] Delete category response status code: ${response.statusCode}');

      if (response.statusCode == 204) {
        return;
      } else if (response.statusCode == 401) {
        throw Exception('Session expired. Please login again.');
      } else if (response.statusCode == 403) {
        throw Exception('You do not have permission to delete categories.');
      } else if (response.statusCode == 404) {
        throw Exception('Category not found with ID: $categoryId');
      } else {
        throw Exception('Failed to delete category: ${response.statusCode}');
      }
    } catch (e) {
      print('[DEBUG_LOG] Error deleting category: $e');
      throw Exception('Error deleting category: ${e.toString()}');
    }
  }
}