import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../models/review.dart';
import 'api_constants.dart';

class ReviewService {
  final http.Client _client = http.Client();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  // ==================== PRODUCT REVIEWS ====================

  // Crear reseña de producto
  Future<ProductReview> createProductReview({
    required int productId,
    required int rating,
    required String comment,
  }) async {
    try {
      final token = await _secureStorage.read(key: ApiConstants.tokenKey);

      if (token == null) {
        throw Exception('No authentication token found');
      }

      // Validar calificación
      if (rating < 1 || rating > 5) {
        throw Exception('Rating must be between 1 and 5');
      }

      print('[DEBUG_LOG] Creating product review');
      final url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.productReviewsEndpoint}');
      print('[DEBUG_LOG] API URL: $url');

      final requestBody = jsonEncode({
        'productoId': productId,
        'calificacion': rating,
        'comentario': comment,
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

      print('[DEBUG_LOG] Create product review response status code: ${response.statusCode}');
      print('[DEBUG_LOG] Create product review response body: ${response.body}');

      if (response.statusCode == 200) {
        return ProductReview.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 400) {
        final errorBody = jsonDecode(response.body);
        throw Exception(errorBody['message'] ?? 'Invalid data provided');
      } else if (response.statusCode == 401) {
        throw Exception('Session expired. Please login again.');
      } else if (response.statusCode == 403) {
        throw Exception('You do not have permission to create this review.');
      } else if (response.statusCode == 404) {
        throw Exception('Product not found with ID: $productId');
      } else {
        throw Exception('Failed to create product review: ${response.statusCode}');
      }
    } catch (e) {
      print('[DEBUG_LOG] Error creating product review: $e');
      throw Exception('Error creating product review: ${e.toString()}');
    }
  }

  // Obtener reseñas por producto
  Future<List<ProductReview>> getReviewsByProduct(int productId) async {
    try {
      print('[DEBUG_LOG] Getting reviews by product');
      final url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.productReviewsEndpoint}/producto/$productId');
      print('[DEBUG_LOG] API URL: $url');

      final response = await _client.get(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      print('[DEBUG_LOG] Get reviews by product response status code: ${response.statusCode}');
      print('[DEBUG_LOG] Get reviews by product response body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> reviewsJson = jsonDecode(response.body);
        return reviewsJson.map((json) => ProductReview.fromJson(json)).toList();
      } else if (response.statusCode == 404) {
        throw Exception('Product not found with ID: $productId');
      } else {
        throw Exception('Failed to get reviews by product: ${response.statusCode}');
      }
    } catch (e) {
      print('[DEBUG_LOG] Error getting reviews by product: $e');
      throw Exception('Error getting reviews by product: ${e.toString()}');
    }
  }

  // Actualizar reseña de producto
  Future<ProductReview> updateProductReview({
    required int reviewId,
    required int rating,
    required String comment,
  }) async {
    try {
      final token = await _secureStorage.read(key: ApiConstants.tokenKey);

      if (token == null) {
        throw Exception('No authentication token found');
      }

      // Validar calificación
      if (rating < 1 || rating > 5) {
        throw Exception('Rating must be between 1 and 5');
      }

      print('[DEBUG_LOG] Updating product review');
      final url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.productReviewsEndpoint}/$reviewId');
      print('[DEBUG_LOG] API URL: $url');

      final requestBody = jsonEncode({
        'calificacion': rating,
        'comentario': comment,
      });
      print('[DEBUG_LOG] Request body: $requestBody');

      final response = await _client.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: requestBody,
      );

      print('[DEBUG_LOG] Update product review response status code: ${response.statusCode}');
      print('[DEBUG_LOG] Update product review response body: ${response.body}');

      if (response.statusCode == 200) {
        return ProductReview.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 400) {
        final errorBody = jsonDecode(response.body);
        throw Exception(errorBody['message'] ?? 'Invalid data provided');
      } else if (response.statusCode == 401) {
        throw Exception('Session expired. Please login again.');
      } else if (response.statusCode == 403) {
        throw Exception('You do not have permission to update this review.');
      } else if (response.statusCode == 404) {
        throw Exception('Review not found with ID: $reviewId');
      } else {
        throw Exception('Failed to update product review: ${response.statusCode}');
      }
    } catch (e) {
      print('[DEBUG_LOG] Error updating product review: $e');
      throw Exception('Error updating product review: ${e.toString()}');
    }
  }

  // Eliminar reseña de producto
  Future<void> deleteProductReview(int reviewId) async {
    try {
      final token = await _secureStorage.read(key: ApiConstants.tokenKey);

      if (token == null) {
        throw Exception('No authentication token found');
      }

      print('[DEBUG_LOG] Deleting product review');
      final url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.productReviewsEndpoint}/$reviewId');
      print('[DEBUG_LOG] API URL: $url');

      final response = await _client.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('[DEBUG_LOG] Delete product review response status code: ${response.statusCode}');

      if (response.statusCode == 204) {
        return;
      } else if (response.statusCode == 401) {
        throw Exception('Session expired. Please login again.');
      } else if (response.statusCode == 403) {
        throw Exception('You do not have permission to delete this review.');
      } else if (response.statusCode == 404) {
        throw Exception('Review not found with ID: $reviewId');
      } else {
        throw Exception('Failed to delete product review: ${response.statusCode}');
      }
    } catch (e) {
      print('[DEBUG_LOG] Error deleting product review: $e');
      throw Exception('Error deleting product review: ${e.toString()}');
    }
  }

  // ==================== STORE REVIEWS ====================

  // Obtener reseñas por tienda
  Future<List<StoreReview>> getReviewsByStore(int storeId) async {
    try {
      print('[DEBUG_LOG] Getting reviews by store');
      final url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.storeReviewsEndpoint}/$storeId/resenias');
      print('[DEBUG_LOG] API URL: $url');

      final response = await _client.get(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      print('[DEBUG_LOG] Get reviews by store response status code: ${response.statusCode}');
      print('[DEBUG_LOG] Get reviews by store response body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> reviewsJson = jsonDecode(response.body);
        return reviewsJson.map((json) => StoreReview.fromJson(json)).toList();
      } else if (response.statusCode == 404) {
        throw Exception('Store not found with ID: $storeId');
      } else {
        throw Exception('Failed to get reviews by store: ${response.statusCode}');
      }
    } catch (e) {
      print('[DEBUG_LOG] Error getting reviews by store: $e');
      throw Exception('Error getting reviews by store: ${e.toString()}');
    }
  }

  // Crear reseña de tienda
  Future<StoreReview> createStoreReview({
    required int storeId,
    required int rating,
    required String comment,
  }) async {
    try {
      final token = await _secureStorage.read(key: ApiConstants.tokenKey);

      if (token == null) {
        throw Exception('No authentication token found');
      }

      // Validar calificación
      if (rating < 1 || rating > 5) {
        throw Exception('Rating must be between 1 and 5');
      }

      print('[DEBUG_LOG] Creating store review');
      final url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.storeReviewsEndpoint}/$storeId/resenias');
      print('[DEBUG_LOG] API URL: $url');

      final requestBody = jsonEncode({
        'calificacion': rating,
        'comentario': comment,
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

      print('[DEBUG_LOG] Create store review response status code: ${response.statusCode}');
      print('[DEBUG_LOG] Create store review response body: ${response.body}');

      if (response.statusCode == 200) {
        return StoreReview.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 400) {
        final errorBody = jsonDecode(response.body);
        throw Exception(errorBody['message'] ?? 'Invalid data provided');
      } else if (response.statusCode == 401) {
        throw Exception('Session expired. Please login again.');
      } else if (response.statusCode == 403) {
        throw Exception('You do not have permission to create this review.');
      } else if (response.statusCode == 404) {
        throw Exception('Store not found with ID: $storeId');
      } else {
        throw Exception('Failed to create store review: ${response.statusCode}');
      }
    } catch (e) {
      print('[DEBUG_LOG] Error creating store review: $e');
      throw Exception('Error creating store review: ${e.toString()}');
    }
  }

  // Actualizar reseña de tienda
  Future<StoreReview> updateStoreReview({
    required int storeId,
    required int reviewId,
    required int rating,
    required String comment,
  }) async {
    try {
      final token = await _secureStorage.read(key: ApiConstants.tokenKey);

      if (token == null) {
        throw Exception('No authentication token found');
      }

      // Validar calificación
      if (rating < 1 || rating > 5) {
        throw Exception('Rating must be between 1 and 5');
      }

      print('[DEBUG_LOG] Updating store review');
      final url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.storeReviewsEndpoint}/$storeId/resenias/$reviewId');
      print('[DEBUG_LOG] API URL: $url');

      final requestBody = jsonEncode({
        'calificacion': rating,
        'comentario': comment,
      });
      print('[DEBUG_LOG] Request body: $requestBody');

      final response = await _client.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: requestBody,
      );

      print('[DEBUG_LOG] Update store review response status code: ${response.statusCode}');
      print('[DEBUG_LOG] Update store review response body: ${response.body}');

      if (response.statusCode == 200) {
        return StoreReview.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 400) {
        final errorBody = jsonDecode(response.body);
        throw Exception(errorBody['message'] ?? 'Invalid data provided');
      } else if (response.statusCode == 401) {
        throw Exception('Session expired. Please login again.');
      } else if (response.statusCode == 403) {
        throw Exception('You do not have permission to update this review.');
      } else if (response.statusCode == 404) {
        throw Exception('Review not found with ID: $reviewId for store with ID: $storeId');
      } else {
        throw Exception('Failed to update store review: ${response.statusCode}');
      }
    } catch (e) {
      print('[DEBUG_LOG] Error updating store review: $e');
      throw Exception('Error updating store review: ${e.toString()}');
    }
  }

  // Eliminar reseña de tienda
  Future<void> deleteStoreReview(int storeId, int reviewId) async {
    try {
      final token = await _secureStorage.read(key: ApiConstants.tokenKey);

      if (token == null) {
        throw Exception('No authentication token found');
      }

      print('[DEBUG_LOG] Deleting store review');
      final url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.storeReviewsEndpoint}/$storeId/resenias/$reviewId');
      print('[DEBUG_LOG] API URL: $url');

      final response = await _client.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('[DEBUG_LOG] Delete store review response status code: ${response.statusCode}');

      if (response.statusCode == 204) {
        return;
      } else if (response.statusCode == 401) {
        throw Exception('Session expired. Please login again.');
      } else if (response.statusCode == 403) {
        throw Exception('You do not have permission to delete this review.');
      } else if (response.statusCode == 404) {
        throw Exception('Review not found with ID: $reviewId for store with ID: $storeId');
      } else {
        throw Exception('Failed to delete store review: ${response.statusCode}');
      }
    } catch (e) {
      print('[DEBUG_LOG] Error deleting store review: $e');
      throw Exception('Error deleting store review: ${e.toString()}');
    }
  }
}