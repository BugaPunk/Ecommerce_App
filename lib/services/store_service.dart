import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/store.dart';
import '../utils/api_config.dart';
import '../utils/auth_utils.dart';

class StoreService {
  final String baseUrl = ApiConfig.baseUrl;

  // Obtener todas las tiendas
  Future<List<Store>> getStores() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/api/tiendas'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Store.fromJson(json)).toList();
      } else {
        throw Exception('Error al obtener las tiendas: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error al obtener las tiendas: $e');
    }
  }

  // Obtener una tienda por ID
  Future<Store> getStoreById(int id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/api/tiendas/$id'));

      if (response.statusCode == 200) {
        return Store.fromJson(json.decode(response.body));
      } else {
        throw Exception('Error al obtener la tienda: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error al obtener la tienda: $e');
    }
  }

  // Crear una nueva tienda
  Future<Store> createStore(Store store) async {
    try {
      final token = await AuthUtils.getToken();
      if (token == null) {
        throw Exception('No hay token de autenticación');
      }

      final response = await http.post(
        Uri.parse('$baseUrl/api/tiendas'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(store.toJson()),
      );

      if (response.statusCode == 201) {
        return Store.fromJson(json.decode(response.body));
      } else {
        throw Exception('Error al crear la tienda: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error al crear la tienda: $e');
    }
  }

  // Actualizar una tienda existente
  Future<Store> updateStore(int id, Store store) async {
    try {
      final token = await AuthUtils.getToken();
      if (token == null) {
        throw Exception('No hay token de autenticación');
      }

      final response = await http.put(
        Uri.parse('$baseUrl/api/tiendas/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(store.toJson()),
      );

      if (response.statusCode == 200) {
        return Store.fromJson(json.decode(response.body));
      } else {
        throw Exception('Error al actualizar la tienda: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error al actualizar la tienda: $e');
    }
  }

  // Eliminar una tienda
  Future<void> deleteStore(int id) async {
    try {
      final token = await AuthUtils.getToken();
      if (token == null) {
        throw Exception('No hay token de autenticación');
      }

      final response = await http.delete(
        Uri.parse('$baseUrl/api/tiendas/$id'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode != 204) {
        throw Exception('Error al eliminar la tienda: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error al eliminar la tienda: $e');
    }
  }
}