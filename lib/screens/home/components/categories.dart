import 'package:flutter/material.dart';

import '../../../utils/constants.dart';
import '../../../utils/size_config.dart';

class Categories extends StatelessWidget {
  const Categories({super.key});

  @override
  Widget build(BuildContext context) {
    //Lista de las categorías
    List<Map<String, dynamic>> categories = [
      {"icon": Icons.phone_android, "text": "Celulares"},
      {"icon": Icons.fastfood, "text": "Comida"},
      {"icon": Icons.sports_esports, "text": "Juegos"},
      {"icon": Icons.kitchen, "text": "Cocina"},
      {"icon": Icons.cleaning_services, "text": "Aseo"},
    ];
    
    return Padding(
      padding:
      EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...List.generate(
              categories.length,
              (index) => Padding(
                padding: EdgeInsets.only(right: getProportionateScreenWidth(15)),
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
    
    // Ajustar tamaño según el dispositivo
    final isDesktop = MediaQuery.of(context).size.width > 1100;
    final isMobile = MediaQuery.of(context).size.width < 600;
    
    final double cardWidth = isDesktop 
        ? 80 
        : isMobile 
            ? getProportionateScreenWidth(55) 
            : 70;
    
    final double iconSize = isDesktop 
        ? 30 
        : isMobile 
            ? 24 
            : 28;
    
    final double fontSize = isDesktop 
        ? 14 
        : isMobile 
            ? 12 
            : 13;
    
    return GestureDetector(
      onTap: press,
      child: SizedBox(
        width: cardWidth,
        child: Column(
          mainAxisSize: MainAxisSize.min, // Importante para evitar desbordamiento
          children: [
            Container(
              width: cardWidth,
              height: cardWidth,
              padding: EdgeInsets.all(cardWidth * 0.25),
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(10)
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: iconSize,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              text, 
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: textColor,
                fontSize: fontSize,
              ),
            ),
          ],
        ),
      ),
    );
  }
}