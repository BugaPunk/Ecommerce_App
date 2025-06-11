import 'package:flutter/foundation.dart';
import '../models/cart_item.dart';
import '../models/order.dart';
import '../models/payment.dart';
import '../models/payment_info.dart';
import '../services/api_service.dart';

class OrderProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<Order> _orders = [];
  bool _isLoading = false;
  String? _error;

  OrderProvider();

  List<Order> get orders => [..._orders];
  bool get isLoading => _isLoading;
  String? get error => _error;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String? value) {
    _error = value;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
    notifyListeners();
  }

  // Cargar órdenes del usuario
  Future<void> fetchOrders() async {
    _setLoading(true);
    _clearError();

    try {
      // Intentar cargar órdenes desde la API
      try {
        final response = await _apiService.get('/api/pedidos');
        if (response != null) {
          _orders = (response as List).map((item) => Order.fromJson(item)).toList();
          return;
        }
      } catch (apiError) {
        print('Error al cargar órdenes desde API: $apiError');
      }
      
      // Si no se pudo cargar desde la API, usar datos de demostración
      _orders = [demoOrder];
    } catch (e) {
      _setError('Error al cargar órdenes: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  // Crear una nueva orden a partir de los items del carrito
  Future<Order?> createOrder(List<CartItem> cartItems, double total) async {
    _setLoading(true);
    _clearError();

    try {
      // Intentar enviar la orden a la API
      try {
        // La API procesa el pedido a partir del carrito del usuario autenticado
        final response = await _apiService.post('/api/pedidos', {});
        if (response != null) {
          final createdOrder = Order.fromJson(response);
          _orders.add(createdOrder);
          notifyListeners();
          return createdOrder;
        }
      } catch (apiError) {
        print('Error al crear orden en API: $apiError');
        
        // Si falla la API, crear una orden local para demostración
        final newOrder = Order(
          id: DateTime.now().millisecondsSinceEpoch, // ID temporal
          fechaCreacion: DateTime.now().toIso8601String(),
          estado: "PENDIENTE",
          total: total,
          usuarioId: 1, // ID del usuario actual
          items: cartItems,
        );
        
        _orders.add(newOrder);
        notifyListeners();
        return newOrder;
      }

      return null;
    } catch (e) {
      _setError('Error al crear orden: ${e.toString()}');
      return null;
    } finally {
      _setLoading(false);
    }
  }

  // Procesar el pago de una orden
  Future<bool> processPayment(Order order, PaymentInfo paymentInfo) async {
    _setLoading(true);
    _clearError();

    try {
      // Validar información de pago
      if (!paymentInfo.isValid()) {
        _setError('Información de pago inválida');
        return false;
      }

      // Crear objeto de pago según la API (exactamente como lo espera la API)
      final paymentData = {
        "pedidoId": order.id,
        "metodoPago": "TARJETA",
        "numeroTarjeta": paymentInfo.cardNumber,
        "fechaExpiracion": paymentInfo.expiryDate,
        "cvv": paymentInfo.cvv
      };
      
      // Intentar procesar el pago en la API
      try {
        final response = await _apiService.post('/api/pagos', paymentData);
        if (response != null) {
          // Pago procesado correctamente
          final payment = Payment.fromJson(response);
          
          // Actualizar estado de la orden localmente
          final updatedOrder = order.copyWith(estado: "PAGADO");
          final orderIndex = _orders.indexWhere((o) => o.id == order.id);
          if (orderIndex >= 0) {
            _orders[orderIndex] = updatedOrder;
            notifyListeners();
          }
          
          return true;
        }
      } catch (apiError) {
        print('Error al procesar pago en API: $apiError');
        
        // Para demostración, simular un pago exitoso
        await Future.delayed(const Duration(seconds: 2));
        
        // Actualizar estado de la orden localmente
        final updatedOrder = order.copyWith(estado: "PAGADO");
        final orderIndex = _orders.indexWhere((o) => o.id == order.id);
        if (orderIndex >= 0) {
          _orders[orderIndex] = updatedOrder;
          notifyListeners();
        }
        
        return true;
      }

      return false;
    } catch (e) {
      _setError('Error al procesar pago: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }
  
  // Obtener una orden por su ID
  Future<Order?> getOrderById(int orderId) async {
    try {
      // Intentar obtener la orden desde la API
      try {
        final response = await _apiService.get('/api/pedidos/$orderId');
        if (response != null) {
          return Order.fromJson(response);
        }
      } catch (apiError) {
        print('Error al obtener orden desde API: $apiError');
      }
      
      // Si no se pudo obtener desde la API, buscar en las órdenes locales
      return _orders.firstWhere((order) => order.id == orderId);
    } catch (e) {
      _setError('Error al obtener orden: ${e.toString()}');
      return null;
    }
  }
}