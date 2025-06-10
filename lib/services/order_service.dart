import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../models/order.dart';
import 'api_constants.dart';

class OrderService {
  final http.Client _client = http.Client();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  // Procesar pedido
  Future<Order> processOrder(int userId) async {
    try {
      final token = await _secureStorage.read(key: ApiConstants.tokenKey);

      if (token == null) {
        throw Exception('No authentication token found');
      }

      print('[DEBUG_LOG] Processing order');
      final url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.ordersEndpoint}/$userId');
      print('[DEBUG_LOG] API URL: $url');

      final response = await _client.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('[DEBUG_LOG] Process order response status code: ${response.statusCode}');
      print('[DEBUG_LOG] Process order response body: ${response.body}');

      if (response.statusCode == 200) {
        return Order.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 400) {
        final errorBody = jsonDecode(response.body);
        throw Exception(errorBody['message'] ?? 'Invalid data provided');
      } else if (response.statusCode == 401) {
        throw Exception('Session expired. Please login again.');
      } else if (response.statusCode == 403) {
        throw Exception('You do not have permission to process this order.');
      } else if (response.statusCode == 404) {
        throw Exception('Cart not found for user with ID: $userId');
      } else {
        throw Exception('Failed to process order: ${response.statusCode}');
      }
    } catch (e) {
      print('[DEBUG_LOG] Error processing order: $e');
      throw Exception('Error processing order: ${e.toString()}');
    }
  }

  // Obtener pedido por ID
  Future<Order> getOrderById(int orderId) async {
    try {
      final token = await _secureStorage.read(key: ApiConstants.tokenKey);

      if (token == null) {
        throw Exception('No authentication token found');
      }

      print('[DEBUG_LOG] Getting order by ID');
      final url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.ordersEndpoint}/$orderId');
      print('[DEBUG_LOG] API URL: $url');

      final response = await _client.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('[DEBUG_LOG] Get order by ID response status code: ${response.statusCode}');
      print('[DEBUG_LOG] Get order by ID response body: ${response.body}');

      if (response.statusCode == 200) {
        return Order.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 401) {
        throw Exception('Session expired. Please login again.');
      } else if (response.statusCode == 403) {
        throw Exception('You do not have permission to access this order.');
      } else if (response.statusCode == 404) {
        throw Exception('Order not found with ID: $orderId');
      } else {
        throw Exception('Failed to get order by ID: ${response.statusCode}');
      }
    } catch (e) {
      print('[DEBUG_LOG] Error getting order by ID: $e');
      throw Exception('Error getting order by ID: ${e.toString()}');
    }
  }

  // Listar pedidos por usuario
  Future<List<Order>> getOrdersByUser(int userId) async {
    try {
      final token = await _secureStorage.read(key: ApiConstants.tokenKey);

      if (token == null) {
        throw Exception('No authentication token found');
      }

      print('[DEBUG_LOG] Getting orders by user');
      final url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.ordersEndpoint}/usuario/$userId');
      print('[DEBUG_LOG] API URL: $url');

      final response = await _client.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('[DEBUG_LOG] Get orders by user response status code: ${response.statusCode}');
      print('[DEBUG_LOG] Get orders by user response body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> ordersJson = jsonDecode(response.body);
        return ordersJson.map((json) => Order.fromJson(json)).toList();
      } else if (response.statusCode == 401) {
        throw Exception('Session expired. Please login again.');
      } else if (response.statusCode == 403) {
        throw Exception('You do not have permission to access these orders.');
      } else if (response.statusCode == 404) {
        throw Exception('User not found with ID: $userId');
      } else {
        throw Exception('Failed to get orders by user: ${response.statusCode}');
      }
    } catch (e) {
      print('[DEBUG_LOG] Error getting orders by user: $e');
      throw Exception('Error getting orders by user: ${e.toString()}');
    }
  }

  // Actualizar estado de pedido
  Future<Order> updateOrderStatus(int orderId, String status) async {
    try {
      final token = await _secureStorage.read(key: ApiConstants.tokenKey);

      if (token == null) {
        throw Exception('No authentication token found');
      }

      // Validar que el estado sea uno de los permitidos
      final validStatuses = ['PENDIENTE', 'PAGADO', 'EN_PREPARACION', 'ENVIADO', 'ENTREGADO', 'CANCELADO'];
      if (!validStatuses.contains(status)) {
        throw Exception('Invalid order status. Must be one of: ${validStatuses.join(', ')}');
      }

      print('[DEBUG_LOG] Updating order status');
      final url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.ordersEndpoint}/$orderId/estado?estado=$status');
      print('[DEBUG_LOG] API URL: $url');

      final response = await _client.patch(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('[DEBUG_LOG] Update order status response status code: ${response.statusCode}');
      print('[DEBUG_LOG] Update order status response body: ${response.body}');

      if (response.statusCode == 200) {
        return Order.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 400) {
        final errorBody = jsonDecode(response.body);
        throw Exception(errorBody['message'] ?? 'Invalid data provided');
      } else if (response.statusCode == 401) {
        throw Exception('Session expired. Please login again.');
      } else if (response.statusCode == 403) {
        throw Exception('You do not have permission to update this order.');
      } else if (response.statusCode == 404) {
        throw Exception('Order not found with ID: $orderId');
      } else {
        throw Exception('Failed to update order status: ${response.statusCode}');
      }
    } catch (e) {
      print('[DEBUG_LOG] Error updating order status: $e');
      throw Exception('Error updating order status: ${e.toString()}');
    }
  }
}