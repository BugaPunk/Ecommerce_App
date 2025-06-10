class Payment {
  final int id;
  final String fechaPago;
  final double monto;
  final String estado;
  final String metodoPago;
  final int pedidoId;
  final String referenciaPago;

  Payment({
    required this.id,
    required this.fechaPago,
    required this.monto,
    required this.estado,
    required this.metodoPago,
    required this.pedidoId,
    required this.referenciaPago,
  });

  // Factory constructor to create a Payment from API JSON
  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      id: json['id'],
      fechaPago: json['fechaPago'],
      monto: json['monto'].toDouble(),
      estado: json['estado'],
      metodoPago: json['metodoPago'],
      pedidoId: json['pedidoId'],
      referenciaPago: json['referenciaPago'],
    );
  }

  // Convert Payment to JSON for API requests
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fechaPago': fechaPago,
      'monto': monto,
      'estado': estado,
      'metodoPago': metodoPago,
      'pedidoId': pedidoId,
      'referenciaPago': referenciaPago,
    };
  }

  // Create a copy of this Payment with the given fields replaced with new values
  Payment copyWith({
    int? id,
    String? fechaPago,
    double? monto,
    String? estado,
    String? metodoPago,
    int? pedidoId,
    String? referenciaPago,
  }) {
    return Payment(
      id: id ?? this.id,
      fechaPago: fechaPago ?? this.fechaPago,
      monto: monto ?? this.monto,
      estado: estado ?? this.estado,
      metodoPago: metodoPago ?? this.metodoPago,
      pedidoId: pedidoId ?? this.pedidoId,
      referenciaPago: referenciaPago ?? this.referenciaPago,
    );
  }
}

// Demo payment for testing
Payment demoPayment = Payment(
  id: 1,
  fechaPago: "2023-06-15T16:00:00",
  monto: 1999.97,
  estado: "PAGADO",
  metodoPago: "TARJETA",
  pedidoId: 1,
  referenciaPago: "PAY-123456789",
);