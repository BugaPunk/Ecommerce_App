import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants.dart';

class ApiService {
  final String baseUrl;
  final Map<String, String> headers;

  ApiService({
    this.baseUrl = kBaseUrl,
    Map<String, String>? headers,
  }) : headers = headers ?? {'Content-Type': 'application/json'};

  Future<dynamic> get(String endpoint, {Map<String, String>? queryParams, String? token}) async {
    final uri = Uri.parse('$baseUrl$endpoint').replace(
      queryParameters: queryParams,
    );

    final Map<String, String> requestHeaders = {...headers};
    if (token != null) {
      requestHeaders['Authorization'] = 'Bearer $token';
    }

    final response = await http.get(uri, headers: requestHeaders);
    return _processResponse(response);
  }

  Future<dynamic> post(String endpoint, dynamic data, {String? token}) async {
    final uri = Uri.parse('$baseUrl$endpoint');
    
    final Map<String, String> requestHeaders = {...headers};
    if (token != null) {
      requestHeaders['Authorization'] = 'Bearer $token';
    }

    final response = await http.post(
      uri,
      headers: requestHeaders,
      body: json.encode(data),
    );
    return _processResponse(response);
  }

  Future<dynamic> put(String endpoint, dynamic data, {String? token}) async {
    final uri = Uri.parse('$baseUrl$endpoint');
    
    final Map<String, String> requestHeaders = {...headers};
    if (token != null) {
      requestHeaders['Authorization'] = 'Bearer $token';
    }

    final response = await http.put(
      uri,
      headers: requestHeaders,
      body: json.encode(data),
    );
    return _processResponse(response);
  }

  Future<dynamic> delete(String endpoint, {String? token}) async {
    final uri = Uri.parse('$baseUrl$endpoint');
    
    final Map<String, String> requestHeaders = {...headers};
    if (token != null) {
      requestHeaders['Authorization'] = 'Bearer $token';
    }

    final response = await http.delete(uri, headers: requestHeaders);
    return _processResponse(response);
  }

  dynamic _processResponse(http.Response response) {
    print('[DEBUG_LOG] API Response - Status: ${response.statusCode}, URL: ${response.request?.url}');
    
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) {
        print('[DEBUG_LOG] API Response - Empty body');
        return null;
      }
      
      try {
        final decodedBody = json.decode(response.body);
        print('[DEBUG_LOG] API Response - Success: ${decodedBody is List ? '${decodedBody.length} items' : 'Object'}');
        return decodedBody;
      } catch (e) {
        print('[DEBUG_LOG] API Response - JSON decode error: $e');
        print('[DEBUG_LOG] API Response - Raw body: ${response.body.substring(0, response.body.length > 100 ? 100 : response.body.length)}...');
        throw Exception('Error al procesar la respuesta: ${e.toString()}');
      }
    } else {
      print('[DEBUG_LOG] API Response - Error status: ${response.statusCode}');
      
      try {
        if (response.body.isNotEmpty) {
          final errorBody = json.decode(response.body);
          final errorMessage = errorBody['message'] ?? 'Error desconocido';
          print('[DEBUG_LOG] API Response - Error message: $errorMessage');
          throw Exception('Error ${response.statusCode}: $errorMessage');
        } else {
          print('[DEBUG_LOG] API Response - Empty error body');
          throw Exception('Error ${response.statusCode}: Sin mensaje de error');
        }
      } catch (e) {
        if (e is Exception) {
          throw e;
        } else {
          print('[DEBUG_LOG] API Response - Error parsing error body: $e');
          print('[DEBUG_LOG] API Response - Raw error body: ${response.body.substring(0, response.body.length > 100 ? 100 : response.body.length)}...');
          throw Exception('Error ${response.statusCode}: No se pudo procesar el mensaje de error');
        }
      }
    }
  }
}