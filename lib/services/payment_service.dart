import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/payment.dart';
import '../utils/api_config.dart';
import '../utils/auth_utils.dart';

class PaymentService {
  final String baseUrl = ApiConfig.baseUrl;

  // Procesar un pago
  Future<Payment> processPayment(Payment payment) async {
    try {
      final token = await AuthUtils.getToken();
      if (token == null) {
        throw Exception('No hay token de autenticación');
      }

      final response = await http.post(
        Uri.parse('$baseUrl/api/pagos'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(payment.toJson()),
      );

      if (response.statusCode == 201) {
        return Payment.fromJson(json.decode(response.body));
      } else {
        throw Exception('Error al procesar el pago: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error al procesar el pago: $e');
    }
  }

  // Obtener un pago por ID
  Future<Payment> getPaymentById(int id) async {
    try {
      final token = await AuthUtils.getToken();
      if (token == null) {
        throw Exception('No hay token de autenticación');
      }

      final response = await http.get(
        Uri.parse('$baseUrl/api/pagos/$id'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return Payment.fromJson(json.decode(response.body));
      } else {
        throw Exception('Error al obtener el pago: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error al obtener el pago: $e');
    }
  }

  // Obtener pagos por usuario
  Future<List<Payment>> getUserPayments(int userId) async {
    try {
      final token = await AuthUtils.getToken();
      if (token == null) {
        throw Exception('No hay token de autenticación');
      }

      final response = await http.get(
        Uri.parse('$baseUrl/api/pagos/usuario/$userId'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Payment.fromJson(json)).toList();
      } else {
        throw Exception('Error al obtener los pagos: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error al obtener los pagos: $e');
    }
  }
}