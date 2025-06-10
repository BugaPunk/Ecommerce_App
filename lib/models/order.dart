import 'cart_item.dart';

class Order {
  final int id;
  final String fechaCreacion;
  final String estado;
  final double total;
  final int usuarioId;
  final List<CartItem> items;

  Order({
    required this.id,
    required this.fechaCreacion,
    required this.estado,
    required this.total,
    required this.usuarioId,
    required this.items,
  });

  // Factory constructor to create an Order from API JSON
  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      fechaCreacion: json['fechaCreacion'],
      estado: json['estado'],
      total: json['total'].toDouble(),
      usuarioId: json['usuarioId'],
      items: (json['items'] as List)
          .map((item) => CartItem.fromJson(item))
          .toList(),
    );
  }

  // Convert Order to JSON for API requests
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fechaCreacion': fechaCreacion,
      'estado': estado,
      'total': total,
      'usuarioId': usuarioId,
      'items': items.map((item) => item.toJson()).toList(),
    };
  }

  // Get the total number of items in the order
  int get itemCount => items.fold(0, (sum, item) => sum + item.cantidad);

  // Create a copy of this Order with the given fields replaced with new values
  Order copyWith({
    int? id,
    String? fechaCreacion,
    String? estado,
    double? total,
    int? usuarioId,
    List<CartItem>? items,
  }) {
    return Order(
      id: id ?? this.id,
      fechaCreacion: fechaCreacion ?? this.fechaCreacion,
      estado: estado ?? this.estado,
      total: total ?? this.total,
      usuarioId: usuarioId ?? this.usuarioId,
      items: items ?? this.items,
    );
  }
}

// Demo order for testing
Order demoOrder = Order(
  id: 1,
  fechaCreacion: "2023-06-15T15:30:00",
  estado: "PENDIENTE",
  total: 1999.97,
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