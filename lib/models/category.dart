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
    return Category(
      id: json['id'],
      nombre: json['nombre'],
      descripcion: json['descripcion'],
      tiendaId: json['tiendaId'],
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