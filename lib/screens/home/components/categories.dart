import 'package:flutter/material.dart';

import '../../../utils/constants.dart';
import '../../../utils/responsive_layout.dart';
import '../../../utils/size_config.dart';

class Categories extends StatelessWidget {
  const Categories({super.key});

  @override
  Widget build(BuildContext context) {
    //Lista de las categorías con iconos de Material Design
    List<Map<String, dynamic>> categories = [
      {"icon": Icons.smartphone_outlined, "text": "Celulares"},
      {"icon": Icons.restaurant_outlined, "text": "Comida"},
      {"icon": Icons.videogame_asset_outlined, "text": "Juegos"},
      {"icon": Icons.blender_outlined, "text": "Cocina"},
      {"icon": Icons.cleaning_services_outlined, "text": "Aseo"},
      {"icon": Icons.computer_outlined, "text": "Computadoras"},
      {"icon": Icons.headset_outlined, "text": "Audio"},
      {"icon": Icons.watch_outlined, "text": "Relojes"},
    ];
    
    // Determinar si estamos en escritorio o móvil
    final isDesktop = ResponsiveLayout.isDesktop(context);
    final isTablet = ResponsiveLayout.isTablet(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final isLargeDesktop = screenWidth > 1400;
    
    // Ajustar el padding según el dispositivo
    final double horizontalPadding = isDesktop || isTablet 
        ? 0.0 
        : getProportionateScreenWidth(20);
    
    // En escritorio, mostrar categorías en grid
    if (isDesktop && isLargeDesktop) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
        child: _buildCategoriesGrid(context, categories),
      );
    }
    
    // En tablet o móvil, mostrar categorías en fila con scroll
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...List.generate(
              categories.length,
              (index) => Padding(
                padding: EdgeInsets.only(right: isDesktop ? 20 : getProportionateScreenWidth(15)),
                child: CategoryCard(
                  icon: categories[index]["icon"],
                  text: categories[index]["text"],
                  press: (){},
                ),
              )
            )
          ],
        ),
      ),
    );
  }
  
  // Grid de categorías para escritorio grande
  Widget _buildCategoriesGrid(BuildContext context, List<Map<String, dynamic>> categories) {
    // Determinar si estamos en escritorio o móvil
    final isDesktop = ResponsiveLayout.isDesktop(context);
    final isTablet = ResponsiveLayout.isTablet(context);
    final isMobile = ResponsiveLayout.isMobile(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final isLargeDesktop = screenWidth > 1400;
    
    // Ajustar el número de columnas según el ancho disponible
    final int crossAxisCount = isLargeDesktop ? 4 : 2;
    
    // Definir tamaños para las tarjetas (similar a CategoryCard)
    final double cardWidth = isLargeDesktop 
        ? 60 
        : isDesktop 
            ? 55 
            : isTablet 
                ? 50 
                : 45;
    
    final double fontSize = isLargeDesktop 
        ? 11 
        : isDesktop 
            ? 10 
            : isTablet 
                ? 9 
                : 8;
    
    // Calcular la proporción de aspecto basada en el tamaño de la tarjeta
    final double iconContainerSize = cardWidth * 0.8;
    final double cardHeight = iconContainerSize + (fontSize * 1.2) + 4; // Altura estimada de la tarjeta
    final double childAspectRatio = cardWidth / cardHeight; // Proporción ancho/alto
    
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: childAspectRatio, // Proporción calculada dinámicamente
        crossAxisSpacing: 8, // Reducir espaciado
        mainAxisSpacing: 8, // Reducir espaciado
      ),
      itemCount: categories.length > 8 ? 8 : categories.length, // Limitar a 8 categorías máximo
      itemBuilder: (context, index) {
        return CategoryCard(
          icon: categories[index]["icon"],
          text: categories[index]["text"],
          press: (){},
        );
      },
    );
  }
}

class CategoryCard extends StatelessWidget {
  const CategoryCard({
    super.key, 
    required this.icon, 
    required this.text, 
    required this.press,
  });

  final IconData icon;
  final String text;
  final GestureTapCallback press;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode 
        ? Theme.of(context).colorScheme.surfaceVariant 
        : const Color(0xFFFFECDF);
    final textColor = isDarkMode 
        ? Theme.of(context).colorScheme.onSurface 
        : Colors.black;
    final iconColor = isDarkMode 
        ? Theme.of(context).colorScheme.primary 
        : FPrimaryColor;
    
    // Determinar si estamos en escritorio o móvil
    final isDesktop = ResponsiveLayout.isDesktop(context);
    final isTablet = ResponsiveLayout.isTablet(context);
    final isMobile = ResponsiveLayout.isMobile(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final isLargeDesktop = screenWidth > 1400;
    
    // Ajustar tamaños según el dispositivo para evitar desbordamiento
    final double cardWidth = isLargeDesktop 
        ? 60 
        : isDesktop 
            ? 55 
            : isTablet 
                ? 50 
                : getProportionateScreenWidth(45);
    
    final double iconSize = isLargeDesktop 
        ? 22 
        : isDesktop 
            ? 20 
            : isTablet 
                ? 18 
                : 16;
    
    final double fontSize = isLargeDesktop 
        ? 11 
        : isDesktop 
            ? 10 
            : isTablet 
                ? 9 
                : 8;
    
    // Calcular el tamaño del contenedor del icono (más pequeño para evitar desbordamiento)
    final double iconContainerSize = cardWidth * 0.8;
    
    // Calcular la altura total necesaria para evitar desbordamiento
    final double totalHeight = iconContainerSize + fontSize * 1.2 + 2;
    
    return GestureDetector(
      onTap: press,
      child: SizedBox(
        width: cardWidth,
        height: totalHeight, // Altura calculada dinámicamente
        child: Column(
          mainAxisSize: MainAxisSize.min, // Usar el mínimo espacio necesario
          mainAxisAlignment: MainAxisAlignment.center, // Centrar verticalmente
          children: [
            // Contenedor del icono
            Container(
              width: iconContainerSize,
              height: iconContainerSize,
              padding: EdgeInsets.all(iconContainerSize * 0.15), // Padding reducido
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(8) // Bordes más pequeños
              ),
              child: FittedBox( // Usar FittedBox para asegurar que el icono se ajuste
                fit: BoxFit.contain,
                child: Icon(
                  icon,
                  color: iconColor,
                  size: iconSize,
                ),
              ),
            ),
            
            // Espacio mínimo entre icono y texto
            const SizedBox(height: 2),
            
            // Texto con altura controlada
            SizedBox(
              height: fontSize * 1.2, // Altura fija para el texto
              child: Text(
                text, 
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: textColor,
                  fontSize: fontSize,
                  height: 1.0, // Altura de línea reducida
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}