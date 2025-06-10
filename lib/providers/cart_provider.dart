import 'package:flutter/foundation.dart';
import '../models/product.dart';

class CartProvider with ChangeNotifier {
  final Map<int, int> _items = {};

  Map<int, int> get items => {..._items};

  int get itemCount => _items.length;

  double get totalAmount {
    double total = 0.0;
    _items.forEach((productId, quantity) {
      // TODO: Implementar cálculo del total cuando tengamos los productos
    });
    return total;
  }

  void addItem(int productId) {
    if (_items.containsKey(productId)) {
      _items[productId] = (_items[productId] ?? 0) + 1;
    } else {
      _items[productId] = 1;
    }
    notifyListeners();
  }

  void removeItem(int productId) {
    if (!_items.containsKey(productId)) {
      return;
    }
    if (_items[productId]! > 1) {
      _items[productId] = (_items[productId] ?? 0) - 1;
    } else {
      _items.remove(productId);
    }
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
} 