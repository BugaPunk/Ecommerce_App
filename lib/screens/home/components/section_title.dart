import 'package:flutter/material.dart';

import '../../../utils/responsive_layout.dart';
import '../../../utils/size_config.dart';

//Titulo antes carrusel
class SectionTitle extends StatelessWidget {
  const SectionTitle({
    super.key, 
    required this.text, 
    required this.press,
  });
  
  final String text;
  final GestureTapCallback press;

  @override
  Widget build(BuildContext context) {
    // Determinar si estamos en escritorio o móvil
    final isDesktop = ResponsiveLayout.isDesktop(context);
    final isTablet = ResponsiveLayout.isTablet(context);
    
    // Colores adaptados al tema
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode 
        ? Theme.of(context).colorScheme.onSurface 
        : Colors.black;
    final linkColor = isDarkMode 
        ? Theme.of(context).colorScheme.primary 
        : Colors.blue;
    
    // Ajustar tamaños según el dispositivo
    final double titleFontSize = isDesktop 
        ? 22.0 
        : isTablet 
            ? 20.0 
            : getProportionateScreenWidth(18);
    
    final double linkFontSize = isDesktop 
        ? 16.0 
        : isTablet 
            ? 15.0 
            : getProportionateScreenWidth(14);
    
    final double horizontalPadding = isDesktop || isTablet 
        ? 0.0 
        : getProportionateScreenWidth(20);
    
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Título con Expanded para evitar desbordamiento
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: titleFontSize,
                color: textColor,
                fontWeight: FontWeight.w600,
              ),
              overflow: TextOverflow.ellipsis, // Evitar desbordamiento
            ),
          ),
          
          // Espacio para separar
          SizedBox(width: 10),
          
          // Botón "Ver más"
          GestureDetector(
            onTap: press,
            child: Text(
              "Ver más",
              style: TextStyle(
                color: linkColor,
                fontSize: linkFontSize,
              ),
            ),
          )
        ],
      ),
    );
  }
}