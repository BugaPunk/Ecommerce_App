import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../models/cart.dart';
import 'api_constants.dart';

class CartService {
  final http.Client _client = http.Client();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  // Obtener carrito del usuario
  Future<Cart> getUserCart(int userId) async {
    try {
      final token = await _secureStorage.read(key: ApiConstants.tokenKey);

      if (token == null) {
        throw Exception('No authentication token found');
      }

      print('[DEBUG_LOG] Getting user cart');
      final url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.cartEndpoint}/$userId');
      print('[DEBUG_LOG] API URL: $url');

      final response = await _client.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('[DEBUG_LOG] Get user cart response status code: ${response.statusCode}');
      print('[DEBUG_LOG] Get user cart response body: ${response.body}');

      if (response.statusCode == 200) {
        return Cart.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 401) {
        throw Exception('Session expired. Please login again.');
      } else if (response.statusCode == 403) {
        throw Exception('You do not have permission to access this cart.');
      } else if (response.statusCode == 404) {
        throw Exception('Cart not found for user with ID: $userId');
      } else {
        throw Exception('Failed to get user cart: ${response.statusCode}');
      }
    } catch (e) {
      print('[DEBUG_LOG] Error getting user cart: $e');
      throw Exception('Error getting user cart: ${e.toString()}');
    }
  }

  // Agregar producto al carrito
  Future<void> addProductToCart(int userId, int productId, int quantity) async {
    try {
      final token = await _secureStorage.read(key: ApiConstants.tokenKey);

      if (token == null) {
        throw Exception('No authentication token found');
      }

      print('[DEBUG_LOG] Adding product to cart');
      final url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.cartEndpoint}/$userId/agregar');
      print('[DEBUG_LOG] API URL: $url');

      final requestBody = jsonEncode({
        'productoId': productId,
        'cantidad': quantity,
      });
      print('[DEBUG_LOG] Request body: $requestBody');

      final response = await _client.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: requestBody,
      );

      print('[DEBUG_LOG] Add product to cart response status code: ${response.statusCode}');

      if (response.statusCode == 200) {
        return;
      } else if (response.statusCode == 400) {
        final errorBody = jsonDecode(response.body);
        throw Exception(errorBody['message'] ?? 'Invalid data provided');
      } else if (response.statusCode == 401) {
        throw Exception('Session expired. Please login again.');
      } else if (response.statusCode == 403) {
        throw Exception('You do not have permission to modify this cart.');
      } else if (response.statusCode == 404) {
        throw Exception('Product not found with ID: $productId');
      } else {
        throw Exception('Failed to add product to cart: ${response.statusCode}');
      }
    } catch (e) {
      print('[DEBUG_LOG] Error adding product to cart: $e');
      throw Exception('Error adding product to cart: ${e.toString()}');
    }
  }

  // Quitar producto del carrito
  Future<void> removeProductFromCart(int userId, int productId) async {
    try {
      final token = await _secureStorage.read(key: ApiConstants.tokenKey);

      if (token == null) {
        throw Exception('No authentication token found');
      }

      print('[DEBUG_LOG] Removing product from cart');
      final url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.cartEndpoint}/$userId/quitar/$productId');
      print('[DEBUG_LOG] API URL: $url');

      final response = await _client.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('[DEBUG_LOG] Remove product from cart response status code: ${response.statusCode}');

      if (response.statusCode == 200) {
        return;
      } else if (response.statusCode == 401) {
        throw Exception('Session expired. Please login again.');
      } else if (response.statusCode == 403) {
        throw Exception('You do not have permission to modify this cart.');
      } else if (response.statusCode == 404) {
        throw Exception('Product not found in cart with ID: $productId');
      } else {
        throw Exception('Failed to remove product from cart: ${response.statusCode}');
      }
    } catch (e) {
      print('[DEBUG_LOG] Error removing product from cart: $e');
      throw Exception('Error removing product from cart: ${e.toString()}');
    }
  }

  // Vaciar carrito
  Future<void> emptyCart(int userId) async {
    try {
      final token = await _secureStorage.read(key: ApiConstants.tokenKey);

      if (token == null) {
        throw Exception('No authentication token found');
      }

      print('[DEBUG_LOG] Emptying cart');
      final url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.cartEndpoint}/$userId/vaciar');
      print('[DEBUG_LOG] API URL: $url');

      final response = await _client.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('[DEBUG_LOG] Empty cart response status code: ${response.statusCode}');

      if (response.statusCode == 204) {
        return;
      } else if (response.statusCode == 401) {
        throw Exception('Session expired. Please login again.');
      } else if (response.statusCode == 403) {
        throw Exception('You do not have permission to modify this cart.');
      } else {
        throw Exception('Failed to empty cart: ${response.statusCode}');
      }
    } catch (e) {
      print('[DEBUG_LOG] Error emptying cart: $e');
      throw Exception('Error emptying cart: ${e.toString()}');
    }
  }
}