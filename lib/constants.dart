import 'package:flutter/material.dart';

// Colores principales
const kPrimaryColor = Color(0xFF1565C0); // Azul primario
const kPrimaryLightColor = Color(0xFFE3F2FD); // Azul claro
const kSecondaryColor = Color(0xFF979797); // Gris
const kTextColor = Color(0xFF757575); // Gris oscuro
const kErrorColor = Color(0xFFD32F2F); // Rojo
const kSuccessColor = Color(0xFF388E3C); // Verde

// Padding
const kDefaultPadding = 20.0;

// Duración de animaciones
const kDefaultDuration = Duration(milliseconds: 250);

// Form Error
final RegExp emailValidatorRegExp =
    RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
const String kEmailNullError = "Por favor ingresa tu correo electrónico";
const String kInvalidEmailError = "Por favor ingresa un correo electrónico válido";
const String kPassNullError = "Por favor ingresa tu contraseña";
const String kShortPassError = "La contraseña es demasiado corta";
const String kMatchPassError = "Las contraseñas no coinciden";
const String kNameNullError = "Por favor ingresa tu nombre";
const String kPhoneNumberNullError = "Por favor ingresa tu número de teléfono";
const String kAddressNullError = "Por favor ingresa tu dirección";

// API URL
const String kBaseUrl = "https://ecommerce-springboot-backend-xen4.onrender.com"; // URL de la API en Render