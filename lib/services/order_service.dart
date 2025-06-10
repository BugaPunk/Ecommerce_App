import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../models/order.dart';
import '../utils/api_config.dart';
import '../utils/auth_utils.dart';
import 'api_constants.dart';

class OrderService {
  final http.Client _client = http.Client();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  final String baseUrl = ApiConfig.baseUrl;

  // Procesar un nuevo pedido
  Future<Order> processOrder() async {
    try {
      final token = await AuthUtils.getToken();
      if (token == null) {
        throw Exception('No hay token de autenticación');
      }

      final response = await http.post(
        Uri.parse('$baseUrl/api/pedidos'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 201) {
        return Order.fromJson(json.decode(response.body));
      } else {
        throw Exception('Error al procesar el pedido: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error al procesar el pedido: $e');
    }
  }

  // Obtener un pedido por ID
  Future<Order> getOrderById(int id) async {
    try {
      final token = await AuthUtils.getToken();
      if (token == null) {
        throw Exception('No hay token de autenticación');
      }

      final response = await http.get(
        Uri.parse('$baseUrl/api/pedidos/$id'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return Order.fromJson(json.decode(response.body));
      } else {
        throw Exception('Error al obtener el pedido: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error al obtener el pedido: $e');
    }
  }

  // Obtener todos los pedidos del usuario
  Future<List<Order>> getUserOrders() async {
    try {
      final token = await AuthUtils.getToken();
      if (token == null) {
        throw Exception('No hay token de autenticación');
      }

      final response = await http.get(
        Uri.parse('$baseUrl/api/pedidos'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Order.fromJson(json)).toList();
      } else {
        throw Exception('Error al obtener los pedidos: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error al obtener los pedidos: $e');
    }
  }

  // Actualizar el estado de un pedido
  Future<Order> updateOrderStatus(int id, String status) async {
    try {
      final token = await AuthUtils.getToken();
      if (token == null) {
        throw Exception('No hay token de autenticación');
      }

      final response = await http.patch(
        Uri.parse('$baseUrl/api/pedidos/$id/estado?estado=$status'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return Order.fromJson(json.decode(response.body));
      } else {
        throw Exception('Error al actualizar el estado del pedido: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error al actualizar el estado del pedido: $e');
    }
  }
}