class ChangePasswordRequest {
  final String currentPassword;
  final String newPassword;
  final String confirmPassword;

  ChangePasswordRequest({
    required this.currentPassword,
    required this.newPassword,
    required this.confirmPassword,
  });

  Map<String, dynamic> toJson() {
    return {
      'currentPassword': currentPassword,
      'newPassword': newPassword,
      'confirmPassword': confirmPassword,
    };
  }

  bool get isValid {
    return currentPassword.isNotEmpty &&
           newPassword.isNotEmpty &&
           confirmPassword.isNotEmpty &&
           newPassword == confirmPassword &&
           newPassword.length >= 6;
  }

  String? get validationError {
    if (currentPassword.isEmpty) {
      return 'La contraseña actual es requerida';
    }
    if (newPassword.isEmpty) {
      return 'La nueva contraseña es requerida';
    }
    if (confirmPassword.isEmpty) {
      return 'La confirmación de contraseña es requerida';
    }
    if (newPassword.length < 6) {
      return 'La nueva contraseña debe tener al menos 6 caracteres';
    }
    if (newPassword != confirmPassword) {
      return 'Las contraseñas no coinciden';
    }
    return null;
  }
}
