class PaymentInfo {
  final String cardNumber;
  final String cardHolderName;
  final String expiryDate;
  final String cvv;

  PaymentInfo({
    required this.cardNumber,
    required this.cardHolderName,
    required this.expiryDate,
    required this.cvv,
  });

  // Método para validar la información de la tarjeta
  bool isValid() {
    // Validar número de tarjeta (debe tener 16 dígitos)
    if (cardNumber.replaceAll(' ', '').length != 16) {
      return false;
    }

    // Validar nombre del titular (no debe estar vacío)
    if (cardHolderName.trim().isEmpty) {
      return false;
    }

    // Validar fecha de expiración (formato MM/YY)
    final RegExp expiryRegex = RegExp(r'^\d{2}/\d{2}$');
    if (!expiryRegex.hasMatch(expiryDate)) {
      return false;
    }

    // Validar CVV (debe tener 3 o 4 dígitos)
    if (cvv.length < 3 || cvv.length > 4) {
      return false;
    }

    return true;
  }

  // Método para obtener una versión enmascarada del número de tarjeta
  String get maskedCardNumber {
    final String cleanNumber = cardNumber.replaceAll(' ', '');
    if (cleanNumber.length < 4) {
      return cleanNumber;
    }
    
    final String lastFour = cleanNumber.substring(cleanNumber.length - 4);
    return '•••• •••• •••• $lastFour';
  }

  // Método para formatear el número de tarjeta con espacios cada 4 dígitos
  static String formatCardNumber(String input) {
    final String cleanInput = input.replaceAll(' ', '');
    final StringBuffer buffer = StringBuffer();
    
    for (int i = 0; i < cleanInput.length; i++) {
      if (i > 0 && i % 4 == 0) {
        buffer.write(' ');
      }
      buffer.write(cleanInput[i]);
    }
    
    return buffer.toString();
  }
}