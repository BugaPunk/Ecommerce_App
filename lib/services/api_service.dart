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
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) return null;
      return json.decode(response.body);
    } else {
      final errorBody = json.decode(response.body);
      final errorMessage = errorBody['message'] ?? 'Error desconocido';
      throw Exception('Error ${response.statusCode}: $errorMessage');
    }
  }
}