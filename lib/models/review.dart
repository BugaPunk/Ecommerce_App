abstract class Review {
  final int id;
  final int usuarioId;
  final int calificacion;
  final String comentario;
  final String fechaCreacion;
  final String? nombreUsuario;

  Review({
    required this.id,
    required this.usuarioId,
    required this.calificacion,
    required this.comentario,
    required this.fechaCreacion,
    this.nombreUsuario,
  });

  Map<String, dynamic> toJson();
}

class ProductReview extends Review {
  final int productoId;

  ProductReview({
    required int id,
    required this.productoId,
    required int usuarioId,
    required int calificacion,
    required String comentario,
    required String fechaCreacion,
    String? nombreUsuario,
  }) : super(
          id: id,
          usuarioId: usuarioId,
          calificacion: calificacion,
          comentario: comentario,
          fechaCreacion: fechaCreacion,
          nombreUsuario: nombreUsuario,
        );

  // Factory constructor to create a ProductReview from API JSON
  factory ProductReview.fromJson(Map<String, dynamic> json) {
    return ProductReview(
      id: json['id'],
      productoId: json['productoId'],
      usuarioId: json['usuarioId'],
      calificacion: json['calificacion'],
      comentario: json['comentario'],
      fechaCreacion: json['fechaCreacion'],
      nombreUsuario: json['nombreUsuario'],
    );
  }

  // Convert ProductReview to JSON for API requests
  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productoId': productoId,
      'usuarioId': usuarioId,
      'calificacion': calificacion,
      'comentario': comentario,
    };
  }

  // Create a copy of this ProductReview with the given fields replaced with new values
  ProductReview copyWith({
    int? id,
    int? productoId,
    int? usuarioId,
    int? calificacion,
    String? comentario,
    String? fechaCreacion,
    String? nombreUsuario,
  }) {
    return ProductReview(
      id: id ?? this.id,
      productoId: productoId ?? this.productoId,
      usuarioId: usuarioId ?? this.usuarioId,
      calificacion: calificacion ?? this.calificacion,
      comentario: comentario ?? this.comentario,
      fechaCreacion: fechaCreacion ?? this.fechaCreacion,
      nombreUsuario: nombreUsuario ?? this.nombreUsuario,
    );
  }
}

class StoreReview extends Review {
  final int tiendaId;

  StoreReview({
    required int id,
    required this.tiendaId,
    required int usuarioId,
    required int calificacion,
    required String comentario,
    required String fechaCreacion,
    String? nombreUsuario,
  }) : super(
          id: id,
          usuarioId: usuarioId,
          calificacion: calificacion,
          comentario: comentario,
          fechaCreacion: fechaCreacion,
          nombreUsuario: nombreUsuario,
        );

  // Factory constructor to create a StoreReview from API JSON
  factory StoreReview.fromJson(Map<String, dynamic> json) {
    return StoreReview(
      id: json['id'],
      tiendaId: json['tiendaId'],
      usuarioId: json['usuarioId'],
      calificacion: json['calificacion'],
      comentario: json['comentario'],
      fechaCreacion: json['fechaCreacion'],
      nombreUsuario: json['nombreUsuario'],
    );
  }

  // Convert StoreReview to JSON for API requests
  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tiendaId': tiendaId,
      'usuarioId': usuarioId,
      'calificacion': calificacion,
      'comentario': comentario,
    };
  }

  // Create a copy of this StoreReview with the given fields replaced with new values
  StoreReview copyWith({
    int? id,
    int? tiendaId,
    int? usuarioId,
    int? calificacion,
    String? comentario,
    String? fechaCreacion,
    String? nombreUsuario,
  }) {
    return StoreReview(
      id: id ?? this.id,
      tiendaId: tiendaId ?? this.tiendaId,
      usuarioId: usuarioId ?? this.usuarioId,
      calificacion: calificacion ?? this.calificacion,
      comentario: comentario ?? this.comentario,
      fechaCreacion: fechaCreacion ?? this.fechaCreacion,
      nombreUsuario: nombreUsuario ?? this.nombreUsuario,
    );
  }
}

// Demo product review for testing
ProductReview demoProductReview = ProductReview(
  id: 1,
  productoId: 1,
  usuarioId: 1,
  calificacion: 4,
  comentario: "Muy buen producto, lo recomiendo.",
  fechaCreacion: "2023-06-16T10:00:00",
  nombreUsuario: "Usuario 1",
);

// Demo store review for testing
StoreReview demoStoreReview = StoreReview(
  id: 1,
  tiendaId: 1,
  usuarioId: 1,
  calificacion: 4,
  comentario: "Buena tienda, envío rápido.",
  fechaCreacion: "2023-06-16T10:00:00",
  nombreUsuario: "Usuario 1",
);