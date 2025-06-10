import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/invoice.dart';
import '../utils/api_config.dart';
import '../utils/auth_utils.dart';

class InvoiceService {
  final String baseUrl = ApiConfig.baseUrl;

  // Generar una factura
  Future<Invoice> generateInvoice(int paymentId) async {
    try {
      final token = await AuthUtils.getToken();
      if (token == null) {
        throw Exception('No hay token de autenticación');
      }

      final response = await http.post(
        Uri.parse('$baseUrl/api/facturas'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({'pagoId': paymentId}),
      );

      if (response.statusCode == 201) {
        return Invoice.fromJson(json.decode(response.body));
      } else {
        throw Exception('Error al generar la factura: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error al generar la factura: $e');
    }
  }

  // Obtener una factura por ID
  Future<Invoice> getInvoiceById(int id) async {
    try {
      final token = await AuthUtils.getToken();
      if (token == null) {
        throw Exception('No hay token de autenticación');
      }

      final response = await http.get(
        Uri.parse('$baseUrl/api/facturas/$id'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return Invoice.fromJson(json.decode(response.body));
      } else {
        throw Exception('Error al obtener la factura: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error al obtener la factura: $e');
    }
  }

  // Obtener facturas por usuario
  Future<List<Invoice>> getUserInvoices(int userId) async {
    try {
      final token = await AuthUtils.getToken();
      if (token == null) {
        throw Exception('No hay token de autenticación');
      }

      final response = await http.get(
        Uri.parse('$baseUrl/api/facturas/usuario/$userId'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Invoice.fromJson(json)).toList();
      } else {
        throw Exception('Error al obtener las facturas: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error al obtener las facturas: $e');
    }
  }
}