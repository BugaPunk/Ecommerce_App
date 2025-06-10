import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../models/payment.dart';
import 'api_constants.dart';

class PaymentService {
  final http.Client _client = http.Client();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  // Procesar pago
  Future<Payment> processPayment({
    required int orderId,
    required String paymentMethod,
    String? cardNumber,
    String? expirationDate,
    String? cvv,
    String? paypalEmail,
  }) async {
    try {
      final token = await _secureStorage.read(key: ApiConstants.tokenKey);

      if (token == null) {
        throw Exception('No authentication token found');
      }

      // Validar método de pago
      final validMethods = ['TARJETA', 'PAYPAL', 'TRANSFERENCIA'];
      if (!validMethods.contains(paymentMethod)) {
        throw Exception('Invalid payment method. Must be one of: ${validMethods.join(', ')}');
      }

      // Validar datos según método de pago
      if (paymentMethod == 'TARJETA' && (cardNumber == null || expirationDate == null || cvv == null)) {
        throw Exception('Card number, expiration date, and CVV are required for card payments');
      }

      if (paymentMethod == 'PAYPAL' && paypalEmail == null) {
        throw Exception('PayPal email is required for PayPal payments');
      }

      print('[DEBUG_LOG] Processing payment');
      final url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.paymentsEndpoint}');
      print('[DEBUG_LOG] API URL: $url');

      // Construir el cuerpo de la solicitud según el método de pago
      final Map<String, dynamic> requestMap = {
        'pedidoId': orderId,
        'metodoPago': paymentMethod,
      };

      if (paymentMethod == 'TARJETA') {
        requestMap['numeroTarjeta'] = cardNumber;
        requestMap['fechaExpiracion'] = expirationDate;
        requestMap['cvv'] = cvv;
      } else if (paymentMethod == 'PAYPAL') {
        requestMap['emailPaypal'] = paypalEmail;
      }

      final requestBody = jsonEncode(requestMap);
      print('[DEBUG_LOG] Request body: $requestBody');

      final response = await _client.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: requestBody,
      );

      print('[DEBUG_LOG] Process payment response status code: ${response.statusCode}');
      print('[DEBUG_LOG] Process payment response body: ${response.body}');

      if (response.statusCode == 200) {
        return Payment.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 400) {
        final errorBody = jsonDecode(response.body);
        throw Exception(errorBody['message'] ?? 'Invalid data provided');
      } else if (response.statusCode == 401) {
        throw Exception('Session expired. Please login again.');
      } else if (response.statusCode == 403) {
        throw Exception('You do not have permission to process this payment.');
      } else if (response.statusCode == 404) {
        throw Exception('Order not found with ID: $orderId');
      } else {
        throw Exception('Failed to process payment: ${response.statusCode}');
      }
    } catch (e) {
      print('[DEBUG_LOG] Error processing payment: $e');
      throw Exception('Error processing payment: ${e.toString()}');
    }
  }

  // Obtener pago por ID
  Future<Payment> getPaymentById(int paymentId) async {
    try {
      final token = await _secureStorage.read(key: ApiConstants.tokenKey);

      if (token == null) {
        throw Exception('No authentication token found');
      }

      print('[DEBUG_LOG] Getting payment by ID');
      final url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.paymentsEndpoint}/$paymentId');
      print('[DEBUG_LOG] API URL: $url');

      final response = await _client.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('[DEBUG_LOG] Get payment by ID response status code: ${response.statusCode}');
      print('[DEBUG_LOG] Get payment by ID response body: ${response.body}');

      if (response.statusCode == 200) {
        return Payment.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 401) {
        throw Exception('Session expired. Please login again.');
      } else if (response.statusCode == 403) {
        throw Exception('You do not have permission to access this payment.');
      } else if (response.statusCode == 404) {
        throw Exception('Payment not found with ID: $paymentId');
      } else {
        throw Exception('Failed to get payment by ID: ${response.statusCode}');
      }
    } catch (e) {
      print('[DEBUG_LOG] Error getting payment by ID: $e');
      throw Exception('Error getting payment by ID: ${e.toString()}');
    }
  }

  // Listar pagos por usuario
  Future<List<Payment>> getPaymentsByUser(int userId) async {
    try {
      final token = await _secureStorage.read(key: ApiConstants.tokenKey);

      if (token == null) {
        throw Exception('No authentication token found');
      }

      print('[DEBUG_LOG] Getting payments by user');
      final url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.paymentsEndpoint}/usuario/$userId');
      print('[DEBUG_LOG] API URL: $url');

      final response = await _client.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('[DEBUG_LOG] Get payments by user response status code: ${response.statusCode}');
      print('[DEBUG_LOG] Get payments by user response body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> paymentsJson = jsonDecode(response.body);
        return paymentsJson.map((json) => Payment.fromJson(json)).toList();
      } else if (response.statusCode == 401) {
        throw Exception('Session expired. Please login again.');
      } else if (response.statusCode == 403) {
        throw Exception('You do not have permission to access these payments.');
      } else if (response.statusCode == 404) {
        throw Exception('User not found with ID: $userId');
      } else {
        throw Exception('Failed to get payments by user: ${response.statusCode}');
      }
    } catch (e) {
      print('[DEBUG_LOG] Error getting payments by user: $e');
      throw Exception('Error getting payments by user: ${e.toString()}');
    }
  }
}