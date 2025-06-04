import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../utils/size_config.dart';
import '../utils/responsive_layout.dart';

//Boton
class DefaultButton extends StatelessWidget {
  const DefaultButton({
    super.key,
    required this.text,
    required this.press,
  });

  final String text;
  final VoidCallback press; // Mejor tipo para funciones sin parámetros

  @override
  Widget build(BuildContext context) {
    // Determinar si estamos en modo desktop, tablet o móvil
    final deviceType = ResponsiveLayout.getDeviceType(context);
    
    // Ajustar altura y tamaño de fuente según el dispositivo
    double buttonHeight;
    double fontSize;
    
    switch (deviceType) {
      case DeviceType.desktop:
        buttonHeight = 60;
        fontSize = 20;
        break;
      case DeviceType.tablet:
        buttonHeight = 58;
        fontSize = 19;
        break;
      case DeviceType.mobile:
      default:
        buttonHeight = getProportionateScreenHeight(56);
        fontSize = getProportionateScreenWidth(18);
        break;
    }
    
    return SizedBox(
      width: double.infinity,
      height: buttonHeight,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          // Usar el color primario del tema actual o FPrimaryColor
          backgroundColor: Theme.of(context).brightness == Brightness.dark 
              ? Theme.of(context).colorScheme.primary 
              : FPrimaryColor,
          foregroundColor: Colors.white, // Color del texto
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16), // Ajuste de padding
          elevation: 2, // Sombra sutil
        ),
        onPressed: press,
        child: Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}