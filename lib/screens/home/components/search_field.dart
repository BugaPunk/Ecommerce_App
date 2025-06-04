import 'package:flutter/material.dart';

import '../../../utils/constants.dart';
import '../../../utils/responsive_layout.dart';
import '../../../utils/size_config.dart';

class SearchField extends StatelessWidget {
  const SearchField({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // Determinar si estamos en escritorio o móvil
    final isDesktop = ResponsiveLayout.isDesktop(context);
    final isTablet = ResponsiveLayout.isTablet(context);
    
    // Ajustar tamaños según el dispositivo
    final double borderRadius = isDesktop 
        ? 12.0 
        : 15.0;
    
    final double horizontalPadding = isDesktop 
        ? 12.0 
        : getProportionateScreenWidth(15);
    
    final double verticalPadding = isDesktop 
        ? 8.0 
        : getProportionateScreenWidth(9);
    
    final double iconSize = isDesktop 
        ? 20.0 
        : 24.0;
    
    final double fontSize = isDesktop 
        ? 14.0 
        : 16.0;
    
    // Colores adaptados al tema
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode 
        ? Theme.of(context).colorScheme.surfaceVariant 
        : FSecondaryColor.withOpacity(0.1);
    final textColor = isDarkMode 
        ? Theme.of(context).colorScheme.onSurface 
        : Colors.black87;
    final hintColor = isDarkMode 
        ? Theme.of(context).colorScheme.onSurface.withOpacity(0.5) 
        : Colors.black54;
    
    return Container(
      // Eliminamos el ancho fijo para que sea flexible
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          if (isDesktop || isTablet)
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
        ],
      ),
      child: TextField(
        onChanged: (value){
          //Valor de busqueda
        },
        style: TextStyle(
          color: textColor,
          fontSize: fontSize,
        ),
        decoration: InputDecoration(
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          hintText: "Buscar Producto",
          hintStyle: TextStyle(
            color: hintColor,
            fontSize: fontSize,
          ),
          prefixIcon: Padding(
            padding: EdgeInsets.only(left: 4, right: 4),
            child: Icon(
              Icons.search, 
              color: hintColor,
              size: iconSize,
            ),
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: verticalPadding,
          ),
          isDense: isDesktop, // Hacer el campo más compacto en escritorio
        ),
      ),
    );
  }
}