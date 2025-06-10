class Product {
  final int id;
  final String nombre;
  final String descripcion;
  final double precio;
  final int stock;
  final String estado;
  final String fechaRegistro;
  final int categoriaId;
  final List<String> imagenes;

  // UI-specific properties
  final List<String> images;
  final double rating;
  final bool isFavourite;
  final bool isPopular;

  Product({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.precio,
    required this.stock,
    required this.estado,
    required this.fechaRegistro,
    required this.categoriaId,
    this.imagenes = const [],
    this.images = const [],
    this.rating = 0.0,
    this.isFavourite = false,
    this.isPopular = false,
  }) {
    // Validaciones
    if (nombre.isEmpty) {
      throw ArgumentError('El nombre del producto no puede estar vacío');
    }
    if (descripcion.isEmpty) {
      throw ArgumentError('La descripción del producto no puede estar vacía');
    }
    if (precio < 0) {
      throw ArgumentError('El precio no puede ser negativo');
    }
    if (stock < 0) {
      throw ArgumentError('El stock no puede ser negativo');
    }
    if (!['ACTIVO', 'INACTIVO', 'AGOTADO'].contains(estado)) {
      throw ArgumentError('Estado de producto inválido');
    }
  }

  // Factory constructor to create a Product from API JSON
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      nombre: json['nombre'],
      descripcion: json['descripcion'],
      precio: json['precio'].toDouble(),
      stock: json['stock'],
      estado: json['estado'],
      fechaRegistro: json['fechaRegistro'],
      categoriaId: json['categoriaId'],
      imagenes: List<String>.from(json['imagenes'] ?? []),
    );
  }

  // Convert Product to JSON for API requests
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'descripcion': descripcion,
      'precio': precio,
      'stock': stock,
      'estado': estado,
      'fechaRegistro': fechaRegistro,
      'categoriaId': categoriaId,
      'imagenes': imagenes,
    };
  }

  // Create a copy of this Product with the given fields replaced with new values
  Product copyWith({
    int? id,
    String? nombre,
    String? descripcion,
    double? precio,
    int? stock,
    String? estado,
    String? fechaRegistro,
    int? categoriaId,
    List<String>? imagenes,
    List<String>? images,
    double? rating,
    bool? isFavourite,
    bool? isPopular,
  }) {
    return Product(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      descripcion: descripcion ?? this.descripcion,
      precio: precio ?? this.precio,
      stock: stock ?? this.stock,
      estado: estado ?? this.estado,
      fechaRegistro: fechaRegistro ?? this.fechaRegistro,
      categoriaId: categoriaId ?? this.categoriaId,
      imagenes: imagenes ?? this.imagenes,
      images: images ?? this.images,
      rating: rating ?? this.rating,
      isFavourite: isFavourite ?? this.isFavourite,
      isPopular: isPopular ?? this.isPopular,
    );
  }

  // Método para verificar si el producto está disponible
  bool get isAvailable => estado == 'ACTIVO' && stock > 0;

  // Método para obtener el precio formateado
  String get formattedPrice => '\$${precio.toStringAsFixed(2)}';

  // Método para obtener el estado en español
  String get estadoEnEspanol {
    switch (estado) {
      case 'ACTIVO':
        return 'Disponible';
      case 'INACTIVO':
        return 'No disponible';
      case 'AGOTADO':
        return 'Agotado';
      default:
        return estado;
    }
  }

  // Método para verificar si el producto está en stock
  bool get hasStock => stock > 0;

  // Método para obtener el nivel de stock
  String get stockLevel {
    if (stock <= 0) return 'Agotado';
    if (stock < 10) return 'Últimas unidades';
    if (stock < 50) return 'Stock limitado';
    return 'En stock';
  }

  @override
  String toString() {
    return 'Product(id: $id, nombre: $nombre, precio: $precio, stock: $stock, estado: $estado)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Product &&
        other.id == id &&
        other.nombre == nombre &&
        other.precio == precio &&
        other.stock == stock &&
        other.estado == estado;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        nombre.hashCode ^
        precio.hashCode ^
        stock.hashCode ^
        estado.hashCode;
  }
}

// Lista de productos de demostración
List<Product> demoProducts = [
  Product(
    id: 1,
    nombre: "Samsung Galaxy S21",
    descripcion: "El Samsung Galaxy S21 es un teléfono inteligente Android de gama alta fabricado por Samsung Electronics.",
    imagenes: ["assets/images/product_1.png"],
    precio: 799.99,
    stock: 100,
    estado: "ACTIVO",
    fechaRegistro: "2023-01-01T12:00:00",
    categoriaId: 1,
    rating: 4.8,
    isFavourite: true,
    isPopular: true,
  ),
  Product(
    id: 2,
    nombre: "Nike Air Max 270",
    descripcion: "Las zapatillas Nike Air Max 270 ofrecen un estilo llamativo y una gran comodidad.",
    imagenes: ["assets/images/product_2.png"],
    precio: 129.99,
    stock: 50,
    estado: "ACTIVO",
    fechaRegistro: "2023-01-02T12:00:00",
    categoriaId: 2,
    rating: 4.5,
    isPopular: true,
  ),
  Product(
    id: 3,
    nombre: "Apple Watch Series 7",
    descripcion: "El Apple Watch Series 7 tiene la pantalla más grande y avanzada hasta ahora.",
    imagenes: ["assets/images/product_3.png"],
    precio: 399.99,
    stock: 75,
    estado: "ACTIVO",
    fechaRegistro: "2023-01-03T12:00:00",
    categoriaId: 1,
    rating: 4.7,
    isFavourite: true,
  ),
  Product(
    id: 4,
    nombre: "Logitech MX Master 3",
    descripcion: "El ratón inalámbrico avanzado con desplazamiento ultrarrápido.",
    imagenes: ["assets/images/product_4.png"],
    precio: 99.99,
    stock: 120,
    estado: "ACTIVO",
    fechaRegistro: "2023-01-04T12:00:00",
    categoriaId: 3,
    rating: 4.9,
    isPopular: true,
  ),
  Product(
    id: 5,
    nombre: "Sony WH-1000XM4",
    descripcion: "Auriculares inalámbricos con cancelación de ruido líder en la industria.",
    imagenes: ["assets/images/product_5.png"],
    precio: 349.99,
    stock: 60,
    estado: "ACTIVO",
    fechaRegistro: "2023-01-05T12:00:00",
    categoriaId: 1,
    rating: 4.8,
    isFavourite: true,
    isPopular: true,
  ),
];

// Productos populares
List<Product> popularProducts = demoProducts.where((product) => product.isPopular).toList();
