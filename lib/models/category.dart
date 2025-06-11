class Category {
  final int id;
  final String nombre;
  final String descripcion;
  final int tiendaId;

  Category({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.tiendaId,
  });

  // Factory constructor to create a Category from API JSON
  factory Category.fromJson(Map<String, dynamic> json) {
    // Función para convertir valores a enteros de forma segura
    int safeParseInt(dynamic value) {
      if (value == null) return 0;
      if (value is int) return value;
      if (value is String) {
        try {
          return int.parse(value);
        } catch (e) {
          print('[DEBUG_LOG] Error parsing int: $e');
          return 0;
        }
      }
      return 0;
    }
    
    // Función para convertir valores a strings de forma segura
    String safeParseString(dynamic value) {
      if (value == null) return '';
      if (value is String) return value;
      return value.toString();
    }
    
    return Category(
      id: safeParseInt(json['id']),
      nombre: safeParseString(json['nombre']),
      descripcion: safeParseString(json['descripcion']),
      tiendaId: safeParseInt(json['tiendaId']),
    );
  }

  // Convert Category to JSON for API requests
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'descripcion': descripcion,
      'tiendaId': tiendaId,
    };
  }

  // Create a copy of this Category with the given fields replaced with new values
  Category copyWith({
    int? id,
    String? nombre,
    String? descripcion,
    int? tiendaId,
  }) {
    return Category(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      descripcion: descripcion ?? this.descripcion,
      tiendaId: tiendaId ?? this.tiendaId,
    );
  }
}

// Lista de categorías de demostración
List<Category> demoCategories = [
  Category(
    id: 1,
    nombre: "Electrónicos",
    descripcion: "Productos electrónicos",
    tiendaId: 1,
  ),
  Category(
    id: 2,
    nombre: "Moda",
    descripcion: "Ropa y accesorios",
    tiendaId: 2,
  ),
  Category(
    id: 3,
    nombre: "Accesorios",
    descripcion: "Accesorios para dispositivos",
    tiendaId: 1,
  ),
];