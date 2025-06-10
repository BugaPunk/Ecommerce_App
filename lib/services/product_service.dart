import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../models/product.dart';
import 'api_constants.dart';

class ProductService {
  final http.Client _client = http.Client();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  // Obtener todos los productos (paginados)
  Future<Map<String, dynamic>> getProducts({
    int page = 0,
    int size = 10,
    String sort = "id",
    String direction = "asc",
  }) async {
    try {
      print('[DEBUG_LOG] Getting products (paginated)');
      final url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.productsEndpoint}')
          .replace(queryParameters: {
        'page': page.toString(),
        'size': size.toString(),
        'sort': sort,
        'direction': direction,
      });
      print('[DEBUG_LOG] API URL: $url');

      final response = await _client.get(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      print('[DEBUG_LOG] Get products response status code: ${response.statusCode}');
      print('[DEBUG_LOG] Get products response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final List<dynamic> productsJson = data['content'];
        final List<Product> products = productsJson.map((json) => Product.fromJson(json)).toList();
        
        return {
          'products': products,
          'totalElements': data['totalElements'],
          'totalPages': data['totalPages'],
          'currentPage': data['number'],
          'hasNext': !data['last'],
          'hasPrevious': !data['first'],
        };
      } else {
        throw Exception('Failed to get products: ${response.statusCode}');
      }
    } catch (e) {
      print('[DEBUG_LOG] Error getting products: $e');
      throw Exception('Error getting products: ${e.toString()}');
    }
  }

  // Obtener todos los productos (sin paginación)
  Future<List<Product>> getAllProducts() async {
    try {
      print('[DEBUG_LOG] Getting all products (without pagination)');
      final url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.productsEndpoint}/all');
      print('[DEBUG_LOG] API URL: $url');

      final response = await _client.get(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      print('[DEBUG_LOG] Get all products response status code: ${response.statusCode}');
      print('[DEBUG_LOG] Get all products response body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> productsJson = jsonDecode(response.body);
        return productsJson.map((json) => Product.fromJson(json)).toList();
      } else {
        throw Exception('Failed to get all products: ${response.statusCode}');
      }
    } catch (e) {
      print('[DEBUG_LOG] Error getting all products: $e');
      throw Exception('Error getting all products: ${e.toString()}');
    }
  }

  // Obtener productos por categoría (paginados)
  Future<Map<String, dynamic>> getProductsByCategory(
    int categoryId, {
    int page = 0,
    int size = 10,
    String sort = "id",
    String direction = "asc",
  }) async {
    try {
      print('[DEBUG_LOG] Getting products by category (paginated)');
      final url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.productsByCategoryEndpoint}/$categoryId')
          .replace(queryParameters: {
        'page': page.toString(),
        'size': size.toString(),
        'sort': sort,
        'direction': direction,
      });
      print('[DEBUG_LOG] API URL: $url');

      final response = await _client.get(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      print('[DEBUG_LOG] Get products by category response status code: ${response.statusCode}');
      print('[DEBUG_LOG] Get products by category response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final List<dynamic> productsJson = data['content'];
        final List<Product> products = productsJson.map((json) => Product.fromJson(json)).toList();
        
        return {
          'products': products,
          'totalElements': data['totalElements'],
          'totalPages': data['totalPages'],
          'currentPage': data['number'],
          'hasNext': !data['last'],
          'hasPrevious': !data['first'],
        };
      } else {
        throw Exception('Failed to get products by category: ${response.statusCode}');
      }
    } catch (e) {
      print('[DEBUG_LOG] Error getting products by category: $e');
      throw Exception('Error getting products by category: ${e.toString()}');
    }
  }

  // Obtener productos por categoría (sin paginación)
  Future<List<Product>> getAllProductsByCategory(int categoryId) async {
    try {
      print('[DEBUG_LOG] Getting all products by category (without pagination)');
      final url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.productsByCategoryEndpoint}/$categoryId/all');
      print('[DEBUG_LOG] API URL: $url');

      final response = await _client.get(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      print('[DEBUG_LOG] Get all products by category response status code: ${response.statusCode}');
      print('[DEBUG_LOG] Get all products by category response body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> productsJson = jsonDecode(response.body);
        return productsJson.map((json) => Product.fromJson(json)).toList();
      } else {
        throw Exception('Failed to get all products by category: ${response.statusCode}');
      }
    } catch (e) {
      print('[DEBUG_LOG] Error getting all products by category: $e');
      throw Exception('Error getting all products by category: ${e.toString()}');
    }
  }

  // Obtener productos por tienda (paginados)
  Future<Map<String, dynamic>> getProductsByStore(
    int storeId, {
    int page = 0,
    int size = 10,
    String sort = "id",
    String direction = "asc",
  }) async {
    try {
      print('[DEBUG_LOG] Getting products by store (paginated)');
      final url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.productsByStoreEndpoint}/$storeId')
          .replace(queryParameters: {
        'page': page.toString(),
        'size': size.toString(),
        'sort': sort,
        'direction': direction,
      });
      print('[DEBUG_LOG] API URL: $url');

      final response = await _client.get(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      print('[DEBUG_LOG] Get products by store response status code: ${response.statusCode}');
      print('[DEBUG_LOG] Get products by store response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final List<dynamic> productsJson = data['content'];
        final List<Product> products = productsJson.map((json) => Product.fromJson(json)).toList();
        
        return {
          'products': products,
          'totalElements': data['totalElements'],
          'totalPages': data['totalPages'],
          'currentPage': data['number'],
          'hasNext': !data['last'],
          'hasPrevious': !data['first'],
        };
      } else {
        throw Exception('Failed to get products by store: ${response.statusCode}');
      }
    } catch (e) {
      print('[DEBUG_LOG] Error getting products by store: $e');
      throw Exception('Error getting products by store: ${e.toString()}');
    }
  }

  // Obtener productos por tienda (sin paginación)
  Future<List<Product>> getAllProductsByStore(int storeId) async {
    try {
      print('[DEBUG_LOG] Getting all products by store (without pagination)');
      final url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.productsByStoreEndpoint}/$storeId/all');
      print('[DEBUG_LOG] API URL: $url');

      final response = await _client.get(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      print('[DEBUG_LOG] Get all products by store response status code: ${response.statusCode}');
      print('[DEBUG_LOG] Get all products by store response body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> productsJson = jsonDecode(response.body);
        return productsJson.map((json) => Product.fromJson(json)).toList();
      } else {
        throw Exception('Failed to get all products by store: ${response.statusCode}');
      }
    } catch (e) {
      print('[DEBUG_LOG] Error getting all products by store: $e');
      throw Exception('Error getting all products by store: ${e.toString()}');
    }
  }

  // Crear producto
  Future<Product> createProduct(Product product) async {
    try {
      final token = await _secureStorage.read(key: ApiConstants.tokenKey);

      if (token == null) {
        throw Exception('No authentication token found');
      }

      print('[DEBUG_LOG] Creating product');
      final url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.productsEndpoint}');
      print('[DEBUG_LOG] API URL: $url');

      final requestBody = jsonEncode(product.toJson());
      print('[DEBUG_LOG] Request body: $requestBody');

      final response = await _client.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: requestBody,
      );

      print('[DEBUG_LOG] Create product response status code: ${response.statusCode}');
      print('[DEBUG_LOG] Create product response body: ${response.body}');

      if (response.statusCode == 200) {
        return Product.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 401) {
        throw Exception('Session expired. Please login again.');
      } else if (response.statusCode == 403) {
        throw Exception('You do not have permission to create products.');
      } else {
        throw Exception('Failed to create product: ${response.statusCode}');
      }
    } catch (e) {
      print('[DEBUG_LOG] Error creating product: $e');
      throw Exception('Error creating product: ${e.toString()}');
    }
  }

  // Actualizar producto
  Future<Product> updateProduct(int productId, Product product) async {
    try {
      final token = await _secureStorage.read(key: ApiConstants.tokenKey);

      if (token == null) {
        throw Exception('No authentication token found');
      }

      print('[DEBUG_LOG] Updating product');
      final url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.productsEndpoint}/$productId');
      print('[DEBUG_LOG] API URL: $url');

      final requestBody = jsonEncode(product.toJson());
      print('[DEBUG_LOG] Request body: $requestBody');

      final response = await _client.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: requestBody,
      );

      print('[DEBUG_LOG] Update product response status code: ${response.statusCode}');
      print('[DEBUG_LOG] Update product response body: ${response.body}');

      if (response.statusCode == 200) {
        return Product.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 401) {
        throw Exception('Session expired. Please login again.');
      } else if (response.statusCode == 403) {
        throw Exception('You do not have permission to update products.');
      } else if (response.statusCode == 404) {
        throw Exception('Product not found with ID: $productId');
      } else {
        throw Exception('Failed to update product: ${response.statusCode}');
      }
    } catch (e) {
      print('[DEBUG_LOG] Error updating product: $e');
      throw Exception('Error updating product: ${e.toString()}');
    }
  }

  // Eliminar producto
  Future<void> deleteProduct(int productId) async {
    try {
      final token = await _secureStorage.read(key: ApiConstants.tokenKey);

      if (token == null) {
        throw Exception('No authentication token found');
      }

      print('[DEBUG_LOG] Deleting product');
      final url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.productsEndpoint}/$productId');
      print('[DEBUG_LOG] API URL: $url');

      final response = await _client.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('[DEBUG_LOG] Delete product response status code: ${response.statusCode}');

      if (response.statusCode == 204) {
        return;
      } else if (response.statusCode == 401) {
        throw Exception('Session expired. Please login again.');
      } else if (response.statusCode == 403) {
        throw Exception('You do not have permission to delete products.');
      } else if (response.statusCode == 404) {
        throw Exception('Product not found with ID: $productId');
      } else {
        throw Exception('Failed to delete product: ${response.statusCode}');
      }
    } catch (e) {
      print('[DEBUG_LOG] Error deleting product: $e');
      throw Exception('Error deleting product: ${e.toString()}');
    }
  }
}