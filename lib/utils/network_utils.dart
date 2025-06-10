import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkUtils {
  // Singleton instance
  static final NetworkUtils _instance = NetworkUtils._internal();
  factory NetworkUtils() => _instance;
  NetworkUtils._internal();

  // Check if the device has internet connectivity
  Future<bool> hasInternetConnection() async {
    try {
      // First, check connectivity status
      final connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        return false;
      }

      // Even if we have connectivity, we should verify we can actually reach the internet
      try {
        // Try to resolve a reliable domain
        final result = await InternetAddress.lookup('google.com');
        return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
      } on SocketException catch (_) {
        return false;
      }
    } catch (e) {
      // If any error occurs during connectivity check, assume no connection
      return false;
    }
  }

  // Get a user-friendly error message for network-related exceptions
  String getNetworkErrorMessage(Exception error) {
    if (error is SocketException) {
      if (error.message.contains('Failed host lookup')) {
        return 'No se pudo conectar al servidor. Por favor, verifica tu conexión a internet y vuelve a intentarlo.';
      }
      return 'Error de conexión: ${error.message}';
    } else if (error is HttpException) {
      return 'Error HTTP: ${error.message}';
    } else if (error is FormatException) {
      return 'Respuesta del servidor inválida';
    } else {
      return 'Error de red: ${error.toString()}';
    }
  }
}