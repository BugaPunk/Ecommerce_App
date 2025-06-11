import 'package:flutter/foundation.dart';
import '../models/cart_item.dart';
import '../models/product.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';

class CartProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  final AuthService _authService = AuthService();
  List<CartItem> _items = [];
  bool _isLoading = false;
  String? _error;
  String? _token;

  CartProvider() {
    _initToken();
  }
  
  Future<void> _initToken() async {
    _token = await _authService.getToken();
  }

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
      // Asegurarse de tener el token actualizado
      if (_token == null) {
        await _initToken();
      }
      
      // Intentar cargar los items del carrito desde la API
      try {
        print('[DEBUG_LOG] Loading cart items from API...');
        print('[DEBUG_LOG] Using token: ${_token != null ? 'Yes' : 'No'}');
        final response = await _apiService.get('/api/carrito', token: _token);
        if (response != null) {
          print('[DEBUG_LOG] Cart items loaded successfully: $response');
          
          // La respuesta puede ser un objeto con una lista de items o directamente una lista
          List<dynamic> data;
          if (response is List) {
            data = response;
          } else if (response is Map && response['items'] != null) {
            data = response['items'] as List<dynamic>;
          } else {
            print('[DEBUG_LOG] Unexpected response format: $response');
            data = [];
          }
          
          _items = data.map((item) => CartItem.fromJson(item)).toList();
          print('[DEBUG_LOG] Cart items parsed: ${_items.length} items');
          return;
        }
      } catch (apiError) {
        print('[DEBUG_LOG] Error loading cart from API: $apiError');
        // No cargar datos de demostración, simplemente usar el carrito local
      }
      
      // Si no hay datos en el carrito local y no se pudo cargar desde la API,
      // simplemente dejamos el carrito vacío
      if (_items.isEmpty) {
        print('[DEBUG_LOG] Cart is empty, no items to display');
        // Verificar si hay datos guardados localmente (en una implementación real
        // aquí cargaríamos de SharedPreferences o similar)
        // Por ahora, dejamos el carrito vacío para que solo muestre lo que el usuario agrega
      }
    } catch (e) {
      print('[DEBUG_LOG] General error loading cart: $e');
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
      print('[DEBUG_LOG] Adding product to cart: ${product.nombre}, ID: ${product.id}, Quantity: $quantity');
      
      // Asegurarse de tener el token actualizado
      if (_token == null) {
        await _initToken();
      }
      
      // Verificar si el producto ya está en el carrito
      final existingItemIndex = _items.indexWhere((item) => item.productId == product.id);

      if (existingItemIndex >= 0) {
        // Si ya existe, aumentar la cantidad
        print('[DEBUG_LOG] Product already in cart, increasing quantity');
        _items[existingItemIndex].quantity += quantity;
        
        // Intentar enviar los cambios a la API
        try {
          print('[DEBUG_LOG] Updating product quantity in API');
          await _apiService.put('/api/carrito/actualizar/${product.id}', {
            'cantidad': _items[existingItemIndex].quantity,
          }, token: _token);
          print('[DEBUG_LOG] Product quantity updated successfully in API');
        } catch (apiError) {
          print('[DEBUG_LOG] Error updating product quantity in API: $apiError');
          // Continuar con la operación local si falla la API
        }
      } else {
        // Si no existe, agregar nuevo item
        print('[DEBUG_LOG] Product not in cart, adding new item');
        _items.add(
          CartItem(
            id: DateTime.now().millisecondsSinceEpoch, // ID temporal
            productId: product.id,
            name: product.nombre,
            price: product.precio,
            quantity: quantity,
            imageUrl: product.imagenUrl ?? 'https://via.placeholder.com/150',
          ),
        );
        
        // Intentar enviar los cambios a la API
        try {
          print('[DEBUG_LOG] Adding product to cart in API');
          await _apiService.post('/api/carrito/agregar', {
            'productoId': product.id,
            'cantidad': quantity,
          }, token: _token);
          print('[DEBUG_LOG] Product added successfully to cart in API');
        } catch (apiError) {
          print('[DEBUG_LOG] Error adding product to cart in API: $apiError');
          // Continuar con la operación local si falla la API
        }
      }
    } catch (e) {
      print('[DEBUG_LOG] General error adding product to cart: $e');
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
      print('[DEBUG_LOG] Removing item from cart, ID: $itemId');
      
      // Asegurarse de tener el token actualizado
      if (_token == null) {
        await _initToken();
      }
      
      // Obtener el producto ID antes de eliminar el item
      final item = _items.firstWhere(
        (item) => item.id == itemId, 
        orElse: () => CartItem(
          id: 0,
          productId: 0,
          name: '',
          price: 0,
          quantity: 0,
          imageUrl: '',
        )
      );
      
      final productId = item.productId;
      
      if (productId > 0) {
        print('[DEBUG_LOG] Found product ID: $productId for cart item ID: $itemId');
        
        // Eliminar el item del carrito local
        _items.removeWhere((item) => item.id == itemId);
        
        // Intentar enviar los cambios a la API
        try {
          print('[DEBUG_LOG] Removing product from cart in API, Product ID: $productId');
          await _apiService.delete('/api/carrito/quitar/$productId', token: _token);
          print('[DEBUG_LOG] Product removed successfully from cart in API');
        } catch (apiError) {
          print('[DEBUG_LOG] Error removing product from cart in API: $apiError');
          // Continuar con la operación local si falla la API
        }
      } else {
        print('[DEBUG_LOG] Product ID not found for cart item ID: $itemId');
        // Eliminar el item del carrito local de todos modos
        _items.removeWhere((item) => item.id == itemId);
      }
    } catch (e) {
      print('[DEBUG_LOG] General error removing item from cart: $e');
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
      print('[DEBUG_LOG] Increasing quantity for cart item ID: $itemId');
      
      // Asegurarse de tener el token actualizado
      if (_token == null) {
        await _initToken();
      }
      
      final itemIndex = _items.indexWhere((item) => item.id == itemId);
      if (itemIndex >= 0) {
        _items[itemIndex].quantity += 1;
        final productId = _items[itemIndex].productId;
        final newQuantity = _items[itemIndex].quantity;
        
        print('[DEBUG_LOG] New quantity: $newQuantity for product ID: $productId');

        // Intentar enviar los cambios a la API
        try {
          print('[DEBUG_LOG] Updating product quantity in API');
          await _apiService.put('/api/carrito/actualizar/$productId', {
            'cantidad': newQuantity,
          }, token: _token);
          print('[DEBUG_LOG] Product quantity updated successfully in API');
        } catch (apiError) {
          print('[DEBUG_LOG] Error updating product quantity in API: $apiError');
          // Continuar con la operación local si falla la API
        }
      } else {
        print('[DEBUG_LOG] Item not found in cart, ID: $itemId');
      }
    } catch (e) {
      print('[DEBUG_LOG] General error increasing quantity: $e');
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
      print('[DEBUG_LOG] Decreasing quantity for cart item ID: $itemId');
      
      // Asegurarse de tener el token actualizado
      if (_token == null) {
        await _initToken();
      }
      
      final itemIndex = _items.indexWhere((item) => item.id == itemId);
      if (itemIndex >= 0) {
        if (_items[itemIndex].quantity > 1) {
          _items[itemIndex].quantity -= 1;
          final productId = _items[itemIndex].productId;
          final newQuantity = _items[itemIndex].quantity;
          
          print('[DEBUG_LOG] New quantity: $newQuantity for product ID: $productId');

          // Intentar enviar los cambios a la API
          try {
            print('[DEBUG_LOG] Updating product quantity in API');
            await _apiService.put('/api/carrito/actualizar/$productId', {
              'cantidad': newQuantity,
            }, token: _token);
            print('[DEBUG_LOG] Product quantity updated successfully in API');
          } catch (apiError) {
            print('[DEBUG_LOG] Error updating product quantity in API: $apiError');
            // Continuar con la operación local si falla la API
          }
        } else {
          // Si la cantidad es 1, eliminar el item
          print('[DEBUG_LOG] Quantity is 1, removing item from cart');
          await removeFromCart(itemId);
          return;
        }
      } else {
        print('[DEBUG_LOG] Item not found in cart, ID: $itemId');
      }
    } catch (e) {
      print('[DEBUG_LOG] General error decreasing quantity: $e');
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
      print('[DEBUG_LOG] Clearing cart');
      
      // Asegurarse de tener el token actualizado
      if (_token == null) {
        await _initToken();
      }
      
      _items.clear();

      // Intentar enviar los cambios a la API
      try {
        print('[DEBUG_LOG] Clearing cart in API');
        await _apiService.delete('/api/carrito/vaciar', token: _token);
        print('[DEBUG_LOG] Cart cleared successfully in API');
      } catch (apiError) {
        print('[DEBUG_LOG] Error clearing cart in API: $apiError');
        // Continuar con la operación local si falla la API
      }
    } catch (e) {
      print('[DEBUG_LOG] General error clearing cart: $e');
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}