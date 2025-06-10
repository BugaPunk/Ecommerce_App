class CartItem {
  final int id;
  final int productoId;
  final String nombreProducto;
  final int cantidad;
  final double precioUnitario;

  CartItem({
    required this.id,
    required this.productoId,
    required this.nombreProducto,
    required this.cantidad,
    required this.precioUnitario,
  });

  // Factory constructor to create a CartItem from API JSON
  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'],
      productoId: json['productoId'],
      nombreProducto: json['nombreProducto'],
      cantidad: json['cantidad'],
      precioUnitario: json['precioUnitario'].toDouble(),
    );
  }

  // Convert CartItem to JSON for API requests
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productoId': productoId,
      'nombreProducto': nombreProducto,
      'cantidad': cantidad,
      'precioUnitario': precioUnitario,
    };
  }

  // Calculate the total price for this item
  double get total => cantidad * precioUnitario;

  // Create a copy of this CartItem with the given fields replaced with new values
  CartItem copyWith({
    int? id,
    int? productoId,
    String? nombreProducto,
    int? cantidad,
    double? precioUnitario,
  }) {
    return CartItem(
      id: id ?? this.id,
      productoId: productoId ?? this.productoId,
      nombreProducto: nombreProducto ?? this.nombreProducto,
      cantidad: cantidad ?? this.cantidad,
      precioUnitario: precioUnitario ?? this.precioUnitario,
    );
  }
}