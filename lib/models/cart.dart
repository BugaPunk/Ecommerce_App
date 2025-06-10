import 'cart_item.dart';

class Cart {
  final int id;
  final int usuarioId;
  final List<CartItem> items;

  Cart({
    required this.id,
    required this.usuarioId,
    required this.items,
  });

  // Factory constructor to create a Cart from API JSON
  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      id: json['id'],
      usuarioId: json['usuarioId'],
      items: (json['items'] as List)
          .map((item) => CartItem.fromJson(item))
          .toList(),
    );
  }

  // Convert Cart to JSON for API requests
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'usuarioId': usuarioId,
      'items': items.map((item) => item.toJson()).toList(),
    };
  }

  // Calculate the total price of all items in the cart
  double get total => items.fold(0, (sum, item) => sum + item.total);

  // Get the total number of items in the cart
  int get itemCount => items.fold(0, (sum, item) => sum + item.cantidad);

  // Create a copy of this Cart with the given fields replaced with new values
  Cart copyWith({
    int? id,
    int? usuarioId,
    List<CartItem>? items,
  }) {
    return Cart(
      id: id ?? this.id,
      usuarioId: usuarioId ?? this.usuarioId,
      items: items ?? this.items,
    );
  }
}

// Demo cart for testing
Cart demoCart = Cart(
  id: 1,
  usuarioId: 1,
  items: [
    CartItem(
      id: 1,
      productoId: 1,
      nombreProducto: "Samsung Galaxy S21",
      cantidad: 2,
      precioUnitario: 799.99,
    ),
    CartItem(
      id: 2,
      productoId: 3,
      nombreProducto: "Apple Watch Series 7",
      cantidad: 1,
      precioUnitario: 399.99,
    ),
  ],
);