import 'package:flutter/material.dart';
import '../../../utils/constants.dart';
import '../../../utils/size_config.dart';

class SplashContent extends StatelessWidget {
  const SplashContent({super.key, required this.text, required this.image});
  final String text, image;
  
  @override
  Widget build(BuildContext context) {
    // Determinar si estamos en modo desktop o móvil
    final isDesktop = MediaQuery.of(context).size.width >= 1024;
    final isTablet = MediaQuery.of(context).size.width >= 768 && MediaQuery.of(context).size.width < 1024;
    
    // Ajustar tamaños según el dispositivo
    final double titleFontSize = isDesktop 
        ? 48 
        : isTablet 
            ? 42 
            : getProportionateScreenWidth(36);
            
    final double textFontSize = isDesktop 
        ? 20 
        : isTablet 
            ? 18 
            : 16;
            
    final double imageHeight = isDesktop 
        ? 350 
        : isTablet 
            ? 300 
            : getProportionateScreenHeight(265);
            
    final double imageWidth = isDesktop 
        ? 350 
        : isTablet 
            ? 300 
            : getProportionateScreenWidth(235);
    
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Spacer(),
        Text(
          "ECOSHOPPING",
          style: TextStyle(
            fontSize: titleFontSize,
            color: Theme.of(context).brightness == Brightness.dark 
                ? Theme.of(context).colorScheme.primary 
                : FPrimaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: textFontSize,
            height: 1.5,
          ),
        ),
        Spacer(flex: 2), //Espacio
        Flexible(
          child: Image.asset(
            image,
            height: imageHeight,
            width: imageWidth,
            fit: BoxFit.contain,
          ),
        ),
      ],
    );
  }
}