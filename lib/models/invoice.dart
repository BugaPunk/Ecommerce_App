class Invoice {
  final int id;
  final String numero;
  final String fechaEmision;
  final double montoTotal;
  final int pagoId;

  Invoice({
    required this.id,
    required this.numero,
    required this.fechaEmision,
    required this.montoTotal,
    required this.pagoId,
  });

  // Factory constructor to create an Invoice from API JSON
  factory Invoice.fromJson(Map<String, dynamic> json) {
    return Invoice(
      id: json['id'],
      numero: json['numero'],
      fechaEmision: json['fechaEmision'],
      montoTotal: json['montoTotal'].toDouble(),
      pagoId: json['pagoId'],
    );
  }

  // Convert Invoice to JSON for API requests
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'numero': numero,
      'fechaEmision': fechaEmision,
      'montoTotal': montoTotal,
      'pagoId': pagoId,
    };
  }

  // Create a copy of this Invoice with the given fields replaced with new values
  Invoice copyWith({
    int? id,
    String? numero,
    String? fechaEmision,
    double? montoTotal,
    int? pagoId,
  }) {
    return Invoice(
      id: id ?? this.id,
      numero: numero ?? this.numero,
      fechaEmision: fechaEmision ?? this.fechaEmision,
      montoTotal: montoTotal ?? this.montoTotal,
      pagoId: pagoId ?? this.pagoId,
    );
  }
}

// Demo invoice for testing
Invoice demoInvoice = Invoice(
  id: 1,
  numero: "F-12345678",
  fechaEmision: "2023-06-15T16:05:00",
  montoTotal: 1999.97,
  pagoId: 1,
);