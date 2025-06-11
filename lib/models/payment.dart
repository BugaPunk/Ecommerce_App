class Payment {
  final int? id;
  final String? fechaPago;
  final double monto;
  final String estado;
  final String metodoPago;
  final int pedidoId;
  final String? referenciaPago;

  Payment({
    this.id,
    this.fechaPago,
    required this.monto,
    required this.estado,
    required this.metodoPago,
    required this.pedidoId,
    this.referenciaPago,
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
}