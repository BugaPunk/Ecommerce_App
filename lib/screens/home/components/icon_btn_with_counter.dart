import 'package:flutter/material.dart';

import '../../../utils/constants.dart';
import '../../../utils/responsive_layout.dart';
import '../../../utils/size_config.dart';

class IconBtnWithCounter extends StatelessWidget {
  const IconBtnWithCounter({
    super.key, 
    required this.icon, 
    this.numOfItems = 0, 
    required this.press,
  });

  final IconData icon;
  final int numOfItems;
  final GestureTapCallback press;

  @override
  Widget build(BuildContext context) {
    // Determinar si estamos en escritorio o móvil
    final isDesktop = ResponsiveLayout.isDesktop(context);
    final isTablet = ResponsiveLayout.isTablet(context);
    
    // Ajustar tamaños según el dispositivo
    final double containerSize = isDesktop 
        ? 40.0 
        : isTablet 
            ? 42.0 
            : getProportionateScreenWidth(46);
    
    final double paddingSize = isDesktop 
        ? 10.0 
        : isTablet 
            ? 11.0 
            : getProportionateScreenWidth(12);
    
    final double badgeSize = isDesktop 
        ? 14.0 
        : isTablet 
            ? 15.0 
            : getProportionateScreenWidth(16);
    
    final double badgeFontSize = isDesktop 
        ? 9.0 
        : isTablet 
            ? 9.5 
            : getProportionateScreenWidth(10);
    
    final double iconSize = isDesktop 
        ? 20.0 
        : isTablet 
            ? 22.0 
            : 24.0;
    
    // Colores adaptados al tema
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode 
        ? Theme.of(context).colorScheme.surfaceVariant 
        : FSecondaryColor.withOpacity(0.1);
    final iconColor = isDarkMode 
        ? Theme.of(context).colorScheme.onSurface 
        : Colors.black87;
    
    return InkWell(
      //aqui define que hacer si hay una notificacion
      onTap: press,
      borderRadius: BorderRadius.circular(50),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            padding: EdgeInsets.all(paddingSize),
            height: containerSize,
            width: containerSize,
            decoration: BoxDecoration(
              color: backgroundColor,
              shape: BoxShape.circle,
              boxShadow: [
                if (isDesktop || isTablet)
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
              ],
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: iconSize,
            ),
          ),
          if (numOfItems != 0)
            Positioned(
              top: -3,
              right: 0,
              child: Container(
                height: badgeSize,
                width: badgeSize,
                decoration: BoxDecoration(
                  color: const Color(0xFFFF4848),
                  shape: BoxShape.circle,
                  border: Border.all(width: 1.5, color: Colors.white),
                  boxShadow: [
                    if (isDesktop || isTablet)
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 2,
                        offset: const Offset(0, 1),
                      ),
                  ],
                ),
                child: Center(
                  child: Text(
                    "$numOfItems",
                    style: TextStyle(
                      fontSize: badgeFontSize,
                      height: 1,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            )
        ],
      ),
    );
  }
}