class Store {
  final int id;
  final String? codigoTienda;
  final String nombre;
  final String descripcion;
  final String? direccion;
  final String? telefono;
  final String? email;
  final int? usuarioId;
  final double? calificacionPromedio;
  final List<String>? categorias;

  Store({
    required this.id,
    this.codigoTienda,
    required this.nombre,
    required this.descripcion,
    this.direccion,
    this.telefono,
    this.email,
    this.usuarioId,
    this.calificacionPromedio,
    this.categorias,
  });

  // Factory constructor to create a Store from API JSON
  factory Store.fromJson(Map<String, dynamic> json) {
    return Store(
      id: json['id'] ?? 0,
      codigoTienda: json['codigoTienda'],
      nombre: json['nombre'] ?? '',
      descripcion: json['descripcion'] ?? '',
      direccion: json['direccion'],
      telefono: json['telefono'],
      email: json['email'],
      usuarioId: json['usuarioId'],
      calificacionPromedio: json['calificacionPromedio']?.toDouble(),
      categorias: json['categorias'] != null 
          ? List<String>.from(json['categorias'])
          : null,
    );
  }

  // Convert Store to JSON for API requests
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'id': id,
      'nombre': nombre,
      'descripcion': descripcion,
    };
    
    if (codigoTienda != null) data['codigoTienda'] = codigoTienda;
    if (direccion != null) data['direccion'] = direccion;
    if (telefono != null) data['telefono'] = telefono;
    if (email != null) data['email'] = email;
    if (usuarioId != null) data['usuarioId'] = usuarioId;
    if (calificacionPromedio != null) data['calificacionPromedio'] = calificacionPromedio;
    if (categorias != null) data['categorias'] = categorias;
    
    return data;
  }

  // Create a copy of this Store with the given fields replaced with new values
  Store copyWith({
    int? id,
    String? codigoTienda,
    String? nombre,
    String? descripcion,
    String? direccion,
    String? telefono,
    String? email,
    int? usuarioId,
    double? calificacionPromedio,
    List<String>? categorias,
  }) {
    return Store(
      id: id ?? this.id,
      codigoTienda: codigoTienda ?? this.codigoTienda,
      nombre: nombre ?? this.nombre,
      descripcion: descripcion ?? this.descripcion,
      direccion: direccion ?? this.direccion,
      telefono: telefono ?? this.telefono,
      email: email ?? this.email,
      usuarioId: usuarioId ?? this.usuarioId,
      calificacionPromedio: calificacionPromedio ?? this.calificacionPromedio,
      categorias: categorias ?? this.categorias,
    );
  }

  @override
  String toString() {
    return 'Store{id: $id, codigoTienda: $codigoTienda, nombre: $nombre}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Store &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}

// Clase para crear tienda (sin ID)
class StoreRequest {
  final String codigoTienda;
  final String nombre;
  final String descripcion;
  final String? direccion;
  final String? telefono;
  final String? email;

  StoreRequest({
    required this.codigoTienda,
    required this.nombre,
    required this.descripcion,
    this.direccion,
    this.telefono,
    this.email,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'codigoTienda': codigoTienda,
      'nombre': nombre,
      'descripcion': descripcion,
    };
    
    if (direccion != null && direccion!.isNotEmpty) data['direccion'] = direccion;
    if (telefono != null && telefono!.isNotEmpty) data['telefono'] = telefono;
    if (email != null && email!.isNotEmpty) data['email'] = email;
    
    return data;
  }
}

// Clase para actualizar tienda (sin codigoTienda)
class StoreUpdateRequest {
  final String nombre;
  final String descripcion;
  final String? direccion;
  final String? telefono;
  final String? email;

  StoreUpdateRequest({
    required this.nombre,
    required this.descripcion,
    this.direccion,
    this.telefono,
    this.email,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'nombre': nombre,
      'descripcion': descripcion,
    };
    
    if (direccion != null && direccion!.isNotEmpty) data['direccion'] = direccion;
    if (telefono != null && telefono!.isNotEmpty) data['telefono'] = telefono;
    if (email != null && email!.isNotEmpty) data['email'] = email;
    
    return data;
  }
}