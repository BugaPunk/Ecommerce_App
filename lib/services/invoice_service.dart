import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../models/invoice.dart';
import 'api_constants.dart';

class InvoiceService {
  final http.Client _client = http.Client();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  // Generar factura
  Future<Invoice> generateInvoice(int paymentId) async {
    try {
      final token = await _secureStorage.read(key: ApiConstants.tokenKey);

      if (token == null) {
        throw Exception('No authentication token found');
      }

      print('[DEBUG_LOG] Generating invoice');
      final url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.invoicesEndpoint}');
      print('[DEBUG_LOG] API URL: $url');

      final requestBody = jsonEncode({
        'pagoId': paymentId,
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

      print('[DEBUG_LOG] Generate invoice response status code: ${response.statusCode}');
      print('[DEBUG_LOG] Generate invoice response body: ${response.body}');

      if (response.statusCode == 200) {
        return Invoice.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 400) {
        final errorBody = jsonDecode(response.body);
        throw Exception(errorBody['message'] ?? 'Invalid data provided');
      } else if (response.statusCode == 401) {
        throw Exception('Session expired. Please login again.');
      } else if (response.statusCode == 403) {
        throw Exception('You do not have permission to generate this invoice.');
      } else if (response.statusCode == 404) {
        throw Exception('Payment not found with ID: $paymentId');
      } else {
        throw Exception('Failed to generate invoice: ${response.statusCode}');
      }
    } catch (e) {
      print('[DEBUG_LOG] Error generating invoice: $e');
      throw Exception('Error generating invoice: ${e.toString()}');
    }
  }

  // Obtener factura por ID
  Future<Invoice> getInvoiceById(int invoiceId) async {
    try {
      final token = await _secureStorage.read(key: ApiConstants.tokenKey);

      if (token == null) {
        throw Exception('No authentication token found');
      }

      print('[DEBUG_LOG] Getting invoice by ID');
      final url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.invoicesEndpoint}/$invoiceId');
      print('[DEBUG_LOG] API URL: $url');

      final response = await _client.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('[DEBUG_LOG] Get invoice by ID response status code: ${response.statusCode}');
      print('[DEBUG_LOG] Get invoice by ID response body: ${response.body}');

      if (response.statusCode == 200) {
        return Invoice.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 401) {
        throw Exception('Session expired. Please login again.');
      } else if (response.statusCode == 403) {
        throw Exception('You do not have permission to access this invoice.');
      } else if (response.statusCode == 404) {
        throw Exception('Invoice not found with ID: $invoiceId');
      } else {
        throw Exception('Failed to get invoice by ID: ${response.statusCode}');
      }
    } catch (e) {
      print('[DEBUG_LOG] Error getting invoice by ID: $e');
      throw Exception('Error getting invoice by ID: ${e.toString()}');
    }
  }

  // Listar facturas por usuario
  Future<List<Invoice>> getInvoicesByUser(int userId) async {
    try {
      final token = await _secureStorage.read(key: ApiConstants.tokenKey);

      if (token == null) {
        throw Exception('No authentication token found');
      }

      print('[DEBUG_LOG] Getting invoices by user');
      final url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.invoicesEndpoint}/usuario/$userId');
      print('[DEBUG_LOG] API URL: $url');

      final response = await _client.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('[DEBUG_LOG] Get invoices by user response status code: ${response.statusCode}');
      print('[DEBUG_LOG] Get invoices by user response body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> invoicesJson = jsonDecode(response.body);
        return invoicesJson.map((json) => Invoice.fromJson(json)).toList();
      } else if (response.statusCode == 401) {
        throw Exception('Session expired. Please login again.');
      } else if (response.statusCode == 403) {
        throw Exception('You do not have permission to access these invoices.');
      } else if (response.statusCode == 404) {
        throw Exception('User not found with ID: $userId');
      } else {
        throw Exception('Failed to get invoices by user: ${response.statusCode}');
      }
    } catch (e) {
      print('[DEBUG_LOG] Error getting invoices by user: $e');
      throw Exception('Error getting invoices by user: ${e.toString()}');
    }
  }
}