class Store {
  final int id;
  final String nombre;
  final String descripcion;
  final String direccion;
  final String telefono;
  final String email;
  final int usuarioId;

  Store({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.direccion,
    required this.telefono,
    required this.email,
    required this.usuarioId,
  });

  // Factory constructor to create a Store from API JSON
  factory Store.fromJson(Map<String, dynamic> json) {
    return Store(
      id: json['id'],
      nombre: json['nombre'],
      descripcion: json['descripcion'],
      direccion: json['direccion'],
      telefono: json['telefono'],
      email: json['email'],
      usuarioId: json['usuarioId'],
    );
  }

  // Convert Store to JSON for API requests
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'descripcion': descripcion,
      'direccion': direccion,
      'telefono': telefono,
      'email': email,
      'usuarioId': usuarioId,
    };
  }

  // Create a copy of this Store with the given fields replaced with new values
  Store copyWith({
    int? id,
    String? nombre,
    String? descripcion,
    String? direccion,
    String? telefono,
    String? email,
    int? usuarioId,
  }) {
    return Store(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      descripcion: descripcion ?? this.descripcion,
      direccion: direccion ?? this.direccion,
      telefono: telefono ?? this.telefono,
      email: email ?? this.email,
      usuarioId: usuarioId ?? this.usuarioId,
    );
  }
}

// Lista de tiendas de demostración
List<Store> demoStores = [
  Store(
    id: 1,
    nombre: "Tienda Electrónica",
    descripcion: "Tienda de productos electrónicos",
    direccion: "Calle Principal 123",
    telefono: "123-456-7890",
    email: "tienda1@example.com",
    usuarioId: 2,
  ),
  Store(
    id: 2,
    nombre: "Tienda de Moda",
    descripcion: "Tienda de ropa y accesorios",
    direccion: "Avenida Central 456",
    telefono: "987-654-3210",
    email: "tienda2@example.com",
    usuarioId: 3,
  ),
];