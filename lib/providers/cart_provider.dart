import 'package:flutter/foundation.dart';
import '../models/cart_item.dart';
import '../models/product.dart';
import '../services/api_service.dart';

class CartProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<CartItem> _items = [];
  bool _isLoading = false;
  String? _error;

  CartProvider();

  List<CartItem> get items => [..._items];
  bool get isLoading => _isLoading;
  String? get error => _error;
  
  int get itemCount => _items.length;
  
  double get totalAmount {
    return _items.fold(0, (sum, item) => sum + (item.price * item.quantity));
  }

  Future<void> loadCartItems() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Intentar cargar los items del carrito desde la API
      try {
        final response = await _apiService.get('/api/cart');
        if (response != null && response['items'] != null) {
          final List<dynamic> data = response['items'];
          _items = data.map((item) => CartItem.fromJson(item)).toList();
          return;
        }
      } catch (apiError) {
        print('Error al cargar carrito desde API: $apiError');
        // No cargar datos de demostración, simplemente usar el carrito local
      }
      
      // Si no hay datos en el carrito local y no se pudo cargar desde la API,
      // simplemente dejamos el carrito vacío
      if (_items.isEmpty) {
        // Verificar si hay datos guardados localmente (en una implementación real
        // aquí cargaríamos de SharedPreferences o similar)
        // Por ahora, dejamos el carrito vacío para que solo muestre lo que el usuario agrega
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addToCart(Product product, {int quantity = 1}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Verificar si el producto ya está en el carrito
      final existingItemIndex = _items.indexWhere((item) => item.productId == product.id);

      if (existingItemIndex >= 0) {
        // Si ya existe, aumentar la cantidad
        _items[existingItemIndex].quantity += quantity;
      } else {
        // Si no existe, agregar nuevo item
        _items.add(
          CartItem(
            id: DateTime.now().millisecondsSinceEpoch, // ID temporal
            productId: product.id,
            name: product.nombre,
            price: product.precio,
            quantity: quantity,
            imageUrl: product.imagenUrl ?? 'assets/images/placeholder.png',
          ),
        );
      }

      // Intentar enviar los cambios a la API
      try {
        await _apiService.post('/api/cart/add', {
          'productId': product.id,
          'quantity': quantity,
        });
      } catch (apiError) {
        print('Error al agregar al carrito en API: $apiError');
        // Continuar con la operación local si falla la API
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> removeFromCart(int itemId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _items.removeWhere((item) => item.id == itemId);

      // Intentar enviar los cambios a la API
      try {
        await _apiService.delete('/api/cart/item/$itemId');
      } catch (apiError) {
        print('Error al eliminar del carrito en API: $apiError');
        // Continuar con la operación local si falla la API
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> increaseQuantity(int itemId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final itemIndex = _items.indexWhere((item) => item.id == itemId);
      if (itemIndex >= 0) {
        _items[itemIndex].quantity += 1;

        // Intentar enviar los cambios a la API
        try {
          await _apiService.put('/api/cart/item/$itemId', {
            'quantity': _items[itemIndex].quantity,
          });
        } catch (apiError) {
          print('Error al actualizar cantidad en API: $apiError');
          // Continuar con la operación local si falla la API
        }
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> decreaseQuantity(int itemId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final itemIndex = _items.indexWhere((item) => item.id == itemId);
      if (itemIndex >= 0) {
        if (_items[itemIndex].quantity > 1) {
          _items[itemIndex].quantity -= 1;

          // Intentar enviar los cambios a la API
          try {
            await _apiService.put('/api/cart/item/$itemId', {
              'quantity': _items[itemIndex].quantity,
            });
          } catch (apiError) {
            print('Error al actualizar cantidad en API: $apiError');
            // Continuar con la operación local si falla la API
          }
        } else {
          // Si la cantidad es 1, eliminar el item
          await removeFromCart(itemId);
          return;
        }
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> clearCart() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _items.clear();

      // Intentar enviar los cambios a la API
      try {
        await _apiService.delete('/api/cart');
      } catch (apiError) {
        print('Error al vaciar carrito en API: $apiError');
        // Continuar con la operación local si falla la API
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}