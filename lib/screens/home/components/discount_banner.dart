import 'package:flutter/material.dart';

import '../../../utils/responsive_layout.dart';
import '../../../utils/size_config.dart';

//  Baner de descuento
class DiscountBanner extends StatelessWidget {
  const DiscountBanner({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // Determinar si estamos en escritorio o móvil
    final isDesktop = ResponsiveLayout.isDesktop(context);
    final isTablet = ResponsiveLayout.isTablet(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final isLargeDesktop = screenWidth > 1400;
    final isExtraLargeDesktop = screenWidth > 1800;
    
    // Ajustar dimensiones según el dispositivo
    final double horizontalMargin = isDesktop || isTablet 
        ? 0.0 
        : getProportionateScreenWidth(20);
    
    final double horizontalPadding = isDesktop 
        ? 30.0 
        : isTablet 
            ? 25.0 
            : getProportionateScreenWidth(20);
    
    final double verticalPadding = isDesktop 
        ? 25.0 
        : isTablet 
            ? 20.0 
            : getProportionateScreenWidth(15);
    
    final double titleFontSize = isDesktop 
        ? 18.0 
        : isTablet 
            ? 16.0 
            : getProportionateScreenWidth(14);
    
    final double discountFontSize = isDesktop 
        ? 32.0 
        : isTablet 
            ? 28.0 
            : getProportionateScreenWidth(24);
    
    // Determinar si mostrar el banner con imagen o solo texto
    final bool showImageBanner = isDesktop && isLargeDesktop;
    
    if (showImageBanner) {
      return _buildImageBanner(
        context, 
        horizontalMargin, 
        horizontalPadding, 
        verticalPadding, 
        titleFontSize, 
        discountFontSize
      );
    } else {
      return _buildSimpleBanner(
        context, 
        horizontalMargin, 
        horizontalPadding, 
        verticalPadding, 
        titleFontSize, 
        discountFontSize
      );
    }
  }
  
  // Banner simple con fondo de color
  Widget _buildSimpleBanner(
    BuildContext context, 
    double horizontalMargin, 
    double horizontalPadding, 
    double verticalPadding, 
    double titleFontSize, 
    double discountFontSize
  ) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: horizontalMargin),
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF4A3298),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Text.rich(
        TextSpan(
          text: "Una Sorpresa Invernal\n",
          style: TextStyle(
            color: Colors.white,
            fontSize: titleFontSize,
          ),
          children: [
            TextSpan(
              text: "Descuento 30%",
              style: TextStyle(
                fontSize: discountFontSize,
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(
                    offset: const Offset(1, 1),
                    blurRadius: 2,
                    color: Colors.black.withOpacity(0.3),
                  ),
                ],
              )
            )
          ],
        )
      ),
    );
  }
  
  // Banner con imagen de fondo para escritorio grande
  Widget _buildImageBanner(
    BuildContext context, 
    double horizontalMargin, 
    double horizontalPadding, 
    double verticalPadding, 
    double titleFontSize, 
    double discountFontSize
  ) {
    // Ajustar la altura para evitar desbordamiento
    final double bannerHeight = 200.0;
    
    return Container(
      margin: EdgeInsets.symmetric(horizontal: horizontalMargin),
      width: double.infinity,
      height: bannerHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            // Imagen de fondo
            Positioned.fill(
              child: Image.asset(
                "assets/images/banner_bg.jpg",
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: const Color(0xFF4A3298),
                  );
                },
              ),
            ),
            // Overlay para mejorar legibilidad
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      const Color(0xFF4A3298).withOpacity(0.9),
                      const Color(0xFF4A3298).withOpacity(0.6),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            // Contenido del banner
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: verticalPadding,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min, // Usar el mínimo espacio necesario
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Una Sorpresa Invernal",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: titleFontSize + 4,
                      fontWeight: FontWeight.w500,
                      shadows: [
                        Shadow(
                          offset: const Offset(1, 1),
                          blurRadius: 2,
                          color: Colors.black.withOpacity(0.5),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8), // Reducir el espaciado
                  Text(
                    "Descuento 30%",
                    style: TextStyle(
                      fontSize: discountFontSize + 4,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          offset: const Offset(1, 1),
                          blurRadius: 3,
                          color: Colors.black.withOpacity(0.5),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12), // Reducir el espaciado
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF4A3298),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8), // Reducir el padding vertical
                      minimumSize: const Size(120, 36), // Tamaño mínimo para el botón
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      "Comprar Ahora",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14, // Tamaño de fuente más pequeño
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}