import 'package:flutter/material.dart';

import '../models/product.dart';
import '../utils/constants.dart';
import '../utils/size_config.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    this.width = 140,
    this.aspectRatio = 1.02,
    required this.product, 
    required this.press,
  });

  final double width, aspectRatio;
  final Product product;
  final GestureTapCallback press;

  @override
  Widget build(BuildContext context) {
    // Obtener el tamaño de la pantalla para ajustes responsivos
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 1100;
    final isTablet = screenWidth > 600 && screenWidth <= 1100;
    final isMobile = screenWidth <= 600;
    
    // Ajustar dimensiones según el dispositivo
    final double cardWidth = isDesktop 
        ? 220 
        : isTablet 
            ? 180 
            : getProportionateScreenWidth(width);
    
    final double cardAspectRatio = isDesktop 
        ? 1.0 
        : aspectRatio;
    
    final double fontSize = isDesktop 
        ? 15 
        : isTablet 
            ? 14 
            : getProportionateScreenWidth(14);
    
    final double priceFontSize = isDesktop 
        ? 20 
        : isTablet 
            ? 18 
            : getProportionateScreenWidth(18);
    
    final double iconSize = isDesktop 
        ? 16 
        : getProportionateScreenWidth(14);
    
    final double containerSize = isDesktop 
        ? 32 
        : getProportionateScreenWidth(28);
    
    final double padding = isDesktop 
        ? 24 
        : isTablet 
            ? 20 
            : getProportionateScreenWidth(20);
    
    // Colores adaptados al tema
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDarkMode 
        ? Theme.of(context).colorScheme.surfaceVariant 
        : FSecondaryColor.withOpacity(0.1);
    final textColor = isDarkMode 
        ? Theme.of(context).colorScheme.onSurface 
        : Colors.black;
    final priceColor = isDarkMode 
        ? Theme.of(context).colorScheme.primary 
        : FPrimaryColor;
    
    return Padding(
      padding: EdgeInsets.only(left: getProportionateScreenWidth(20)),
      child: GestureDetector(
        onTap: press,
        child: SizedBox(
          width: cardWidth,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: cardAspectRatio,
                child: Container(
                  padding: EdgeInsets.all(padding),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Hero(
                    tag: product.id.toString(),
                    child: Image.asset(
                      product.images[0],
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          Icons.image_not_supported_outlined,
                          size: isDesktop ? 80 : 60,
                          color: Colors.grey,
                        );
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                product.title,
                style: TextStyle(
                  color: textColor,
                  fontSize: fontSize,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "\$${product.price.toStringAsFixed(2)}",
                    style: TextStyle(
                      fontSize: priceFontSize,
                      fontWeight: FontWeight.w600,
                      color: priceColor,
                    ),
                  ),
                  InkWell(
                    borderRadius: BorderRadius.circular(30),
                    onTap: () {},
                    child: Container(
                      padding: EdgeInsets.all(containerSize * 0.25),
                      width: containerSize,
                      height: containerSize,
                      decoration: BoxDecoration(
                        color: product.isFavourite
                            ? priceColor.withOpacity(0.15)
                            : cardColor,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 5,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        product.isFavourite ? Icons.favorite : Icons.favorite_border,
                        size: iconSize,
                        color: product.isFavourite
                            ? const Color(0xFFFF4848)
                            : const Color(0xFFDBDEE4),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}