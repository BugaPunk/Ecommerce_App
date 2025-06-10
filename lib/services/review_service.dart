import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../models/review.dart';
import '../utils/api_config.dart';
import '../utils/auth_utils.dart';
import 'api_constants.dart';

class ReviewService {
  final http.Client _client = http.Client();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  final String baseUrl = ApiConfig.baseUrl;

  // ==================== PRODUCT REVIEWS ====================

  // Crear reseña de producto
  Future<Review> createProductReview(int productId, Review review) async {
    try {
      final token = await AuthUtils.getToken();
      if (token == null) {
        throw Exception('No hay token de autenticación');
      }

      final response = await http.post(
        Uri.parse('$baseUrl/api/productos/$productId/resenias'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(review.toJson()),
      );

      if (response.statusCode == 201) {
        return Review.fromJson(json.decode(response.body));
      } else {
        throw Exception('Error al crear la reseña: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error al crear la reseña: $e');
    }
  }

  // Obtener reseñas de producto
  Future<List<Review>> getProductReviews(int productId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/productos/$productId/resenias'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Review.fromJson(json)).toList();
      } else {
        throw Exception('Error al obtener las reseñas: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error al obtener las reseñas: $e');
    }
  }

  // Actualizar reseña de producto
  Future<Review> updateProductReview(int productId, int reviewId, Review review) async {
    try {
      final token = await AuthUtils.getToken();
      if (token == null) {
        throw Exception('No hay token de autenticación');
      }

      final response = await http.put(
        Uri.parse('$baseUrl/api/productos/$productId/resenias/$reviewId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(review.toJson()),
      );

      if (response.statusCode == 200) {
        return Review.fromJson(json.decode(response.body));
      } else {
        throw Exception('Error al actualizar la reseña: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error al actualizar la reseña: $e');
    }
  }

  // Eliminar reseña de producto
  Future<void> deleteProductReview(int productId, int reviewId) async {
    try {
      final token = await AuthUtils.getToken();
      if (token == null) {
        throw Exception('No hay token de autenticación');
      }

      final response = await http.delete(
        Uri.parse('$baseUrl/api/productos/$productId/resenias/$reviewId'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode != 204) {
        throw Exception('Error al eliminar la reseña: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error al eliminar la reseña: $e');
    }
  }

  // ==================== STORE REVIEWS ====================

  // Obtener reseñas de tienda
  Future<List<Review>> getStoreReviews(int storeId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/tiendas/$storeId/resenias'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Review.fromJson(json)).toList();
      } else {
        throw Exception('Error al obtener las reseñas: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error al obtener las reseñas: $e');
    }
  }

  // Crear reseña de tienda
  Future<Review> createStoreReview(int storeId, Review review) async {
    try {
      final token = await AuthUtils.getToken();
      if (token == null) {
        throw Exception('No hay token de autenticación');
      }

      final response = await http.post(
        Uri.parse('$baseUrl/api/tiendas/$storeId/resenias'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(review.toJson()),
      );

      if (response.statusCode == 201) {
        return Review.fromJson(json.decode(response.body));
      } else {
        throw Exception('Error al crear la reseña: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error al crear la reseña: $e');
    }
  }

  // Actualizar reseña de tienda
  Future<Review> updateStoreReview(int storeId, int reviewId, Review review) async {
    try {
      final token = await AuthUtils.getToken();
      if (token == null) {
        throw Exception('No hay token de autenticación');
      }

      final response = await http.put(
        Uri.parse('$baseUrl/api/tiendas/$storeId/resenias/$reviewId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(review.toJson()),
      );

      if (response.statusCode == 200) {
        return Review.fromJson(json.decode(response.body));
      } else {
        throw Exception('Error al actualizar la reseña: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error al actualizar la reseña: $e');
    }
  }

  // Eliminar reseña de tienda
  Future<void> deleteStoreReview(int storeId, int reviewId) async {
    try {
      final token = await AuthUtils.getToken();
      if (token == null) {
        throw Exception('No hay token de autenticación');
      }

      final response = await http.delete(
        Uri.parse('$baseUrl/api/tiendas/$storeId/resenias/$reviewId'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode != 204) {
        throw Exception('Error al eliminar la reseña: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error al eliminar la reseña: $e');
    }
  }
}