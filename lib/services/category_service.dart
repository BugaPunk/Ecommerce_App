import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../models/category.dart';
import 'api_constants.dart';
import '../utils/api_config.dart';
import '../utils/auth_utils.dart';

class CategoryService {
  final http.Client _client = http.Client();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  final String baseUrl = ApiConfig.baseUrl;

  // Obtener todas las categorías
  Future<List<Category>> getAllCategories() async {
    try {
      final url = Uri.parse('$baseUrl/api/categorias');
      print('[DEBUG_LOG] Getting all categories from URL: $url');

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
      final url = Uri.parse('$baseUrl/api/categorias/$categoryId');
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
      final url = Uri.parse('$baseUrl/api/categorias/tienda/$storeId');
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
      final url = Uri.parse('$baseUrl/api/categorias');
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
      final url = Uri.parse('$baseUrl/api/categorias/$categoryId');
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
      final url = Uri.parse('$baseUrl/api/categorias/$categoryId');
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

  // Este método es usado por la pantalla de inicio y la pantalla de categorías
  Future<List<Category>> getCategories() async {
    try {
      print('[DEBUG_LOG] Getting categories for home screen');
      final url = Uri.parse('$baseUrl/api/categorias');
      print('[DEBUG_LOG] API URL: $url');

      try {
        final response = await http.get(
          url,
          headers: {'Content-Type': 'application/json'},
        ).timeout(const Duration(seconds: 10));

        print('[DEBUG_LOG] Get categories response status code: ${response.statusCode}');
        print('[DEBUG_LOG] Get categories response body: ${response.body}');

        if (response.statusCode == 200) {
          try {
            final List<dynamic> data = json.decode(response.body);
            print('[DEBUG_LOG] Decoded JSON data: $data');
            
            if (data.isEmpty) {
              print('[DEBUG_LOG] API returned empty list, using demo categories');
              return demoCategories;
            }
            
            // Verificar cada elemento del JSON
            for (var i = 0; i < data.length; i++) {
              print('[DEBUG_LOG] Category $i: ${data[i]}');
              try {
                print('[DEBUG_LOG] id: ${data[i]['id']}, type: ${data[i]['id']?.runtimeType}');
                print('[DEBUG_LOG] nombre: ${data[i]['nombre']}, type: ${data[i]['nombre']?.runtimeType}');
                print('[DEBUG_LOG] descripcion: ${data[i]['descripcion']}, type: ${data[i]['descripcion']?.runtimeType}');
                print('[DEBUG_LOG] tiendaId: ${data[i]['tiendaId']}, type: ${data[i]['tiendaId']?.runtimeType}');
              } catch (fieldError) {
                print('[DEBUG_LOG] Error accessing fields for category $i: $fieldError');
              }
            }
            
            try {
              final categories = data.map((json) => Category.fromJson(json)).toList();
              print('[DEBUG_LOG] Converted to Category objects: ${categories.length} items');
              return categories;
            } catch (mappingError) {
              print('[DEBUG_LOG] Error mapping JSON to Category objects: $mappingError');
              print('[DEBUG_LOG] Falling back to demo categories');
              return demoCategories;
            }
          } catch (jsonError) {
            print('[DEBUG_LOG] Error decoding JSON: $jsonError');
            print('[DEBUG_LOG] Falling back to demo categories');
            return demoCategories;
          }
        } else {
          print('[DEBUG_LOG] API returned error status code: ${response.statusCode}');
          print('[DEBUG_LOG] Falling back to demo categories');
          return demoCategories;
        }
      } catch (httpError) {
        print('[DEBUG_LOG] HTTP request error: $httpError');
        print('[DEBUG_LOG] Falling back to demo categories');
        return demoCategories;
      }
    } catch (e) {
      print('[DEBUG_LOG] Error getting categories: $e');
      print('[DEBUG_LOG] Falling back to demo categories');
      return demoCategories;
    }
  }
}