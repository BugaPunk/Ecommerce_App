import 'package:flutter/material.dart';

import '../../../utils/responsive_layout.dart';
import '../../../utils/size_config.dart';
import 'section_title.dart';

//Aqui se define los parametros para el carrusel
class SpecialOffers extends StatelessWidget {
  const SpecialOffers({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // Determinar si estamos en escritorio o móvil
    final isDesktop = ResponsiveLayout.isDesktop(context);
    final isTablet = ResponsiveLayout.isTablet(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final isLargeDesktop = screenWidth > 1400;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(
          text: "Especial para ti",
          press: (){},
        ),
        SizedBox(height: getProportionateScreenWidth(20)),
        
        // En escritorio grande, mostrar ofertas en grid
        if (isLargeDesktop)
          _buildDesktopSpecialOffersGrid(context)
        // En tablet o escritorio pequeño, mostrar ofertas en fila con scroll
        else
          _buildSpecialOffersCarousel(context, isDesktop || isTablet),
      ],
    );
  }
  
  // Grid de ofertas especiales para escritorio grande
  Widget _buildDesktopSpecialOffersGrid(BuildContext context) {
    // Lista de ofertas especiales
    final List<Map<String, dynamic>> offers = [
      {
        "image": "assets/images/banner_1.jpg",
        "category": "Smartphones",
        "numOfBrands": 18,
      },
      {
        "image": "assets/images/banner_2.jpg",
        "category": "Moda",
        "numOfBrands": 24,
      },
    ];
    
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 2.5, // Proporción ancho/alto de cada elemento
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
        ),
        itemCount: offers.length,
        itemBuilder: (context, index) {
          return SpecialOfferCard(
            image: offers[index]["image"],
            category: offers[index]["category"],
            numOfBrands: offers[index]["numOfBrands"],
            press: (){},
          );
        },
      ),
    );
  }
  
  // Carrusel de ofertas especiales para móvil y escritorio pequeño
  Widget _buildSpecialOffersCarousel(BuildContext context, bool isDesktopOrTablet) {
    // Ajustar el padding según el dispositivo
    final double horizontalPadding = isDesktopOrTablet ? 20.0 : getProportionateScreenWidth(20);
    
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
        child: Row(
          children: [
            //Aqui esta el carrusel con parametros
            SpecialOfferCard(
              image: "assets/images/banner_1.jpg",
              category: "Smartphones",
              numOfBrands: 18,
              press: (){} ,
            ),
            SizedBox(width: isDesktopOrTablet ? 20 : getProportionateScreenWidth(20)),
            SpecialOfferCard(
              image: "assets/images/banner_2.jpg",
              category: "Moda",
              numOfBrands: 24,
              press: (){} ,
            ),
            SizedBox(width: isDesktopOrTablet ? 20 : getProportionateScreenWidth(20)),
          ],
        ),
      ),
    );
  }
}

class SpecialOfferCard extends StatelessWidget {
  const SpecialOfferCard({
    super.key,
    required this.category,
    required this.image,
    required this.numOfBrands,
    required this.press,
  });

  final String category, image;
  final int numOfBrands;
  final GestureTapCallback press;

  @override
  Widget build(BuildContext context) {
    // Determinar si estamos en escritorio o móvil
    final isDesktop = ResponsiveLayout.isDesktop(context);
    final isTablet = ResponsiveLayout.isTablet(context);
    final isLargeDesktop = ResponsiveLayout.isLargeDesktop(context);
    
    // Ajustar dimensiones según el dispositivo
    final double cardWidth = isLargeDesktop 
        ? 280 
        : isDesktop 
            ? 260 
            : isTablet 
                ? 240 
                : getProportionateScreenWidth(242);
    
    final double cardHeight = isLargeDesktop 
        ? 110 
        : isDesktop 
            ? 100 
            : isTablet 
                ? 90 
                : getProportionateScreenWidth(100);
    
    final double fontSize = isLargeDesktop 
        ? 18 
        : isDesktop 
            ? 16 
            : isTablet 
                ? 15 
                : getProportionateScreenWidth(18);
    
    final double subFontSize = isLargeDesktop 
        ? 13 
        : isDesktop 
            ? 12 
            : isTablet 
                ? 11 
                : getProportionateScreenWidth(12);
    
    final double horizontalPadding = isLargeDesktop 
        ? 18 
        : isDesktop 
            ? 16 
            : isTablet 
                ? 14 
                : getProportionateScreenWidth(15);
    
    final double verticalPadding = isLargeDesktop 
        ? 12 
        : isDesktop 
            ? 10 
            : isTablet 
                ? 8 
                : getProportionateScreenWidth(10);
    
    final double leftPadding = isDesktop || isTablet 
        ? 0 
        : getProportionateScreenWidth(20);
    
    return Padding(
      padding: EdgeInsets.only(left: leftPadding),
      child: GestureDetector(
        onTap: press,
        child: Container(
          width: cardWidth,
          height: cardHeight,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(isDesktop ? 15 : 20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(isDesktop ? 15 : 20),
            child: Stack(
              children: [
                // Imagen de fondo
                Image.asset(
                  image,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[300],
                      child: Center(
                        child: Icon(
                          Icons.image_not_supported_outlined,
                          size: isDesktop ? 30 : 40,
                          color: Colors.grey,
                        ),
                      ),
                    );
                  },
                ),
                // Gradiente para mejorar legibilidad
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        const Color(0xFF343434).withOpacity(0.4),
                        const Color(0xFF343434).withOpacity(0.15),
                      ],
                    ),
                  ),
                ),
                // Contenido de texto
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: horizontalPadding,
                    vertical: verticalPadding,
                  ),
                  child: Text.rich(
                    TextSpan(
                      style: const TextStyle(color: Colors.white),
                      children: [
                        TextSpan(
                          text: "$category\n",
                          style: TextStyle(
                            fontSize: fontSize,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                offset: const Offset(1, 1),
                                blurRadius: 2,
                                color: Colors.black.withOpacity(0.5),
                              ),
                            ],
                          ),
                        ),
                        TextSpan(
                          text: "$numOfBrands productos",
                          style: TextStyle(
                            fontSize: subFontSize,
                            shadows: [
                              Shadow(
                                offset: const Offset(1, 1),
                                blurRadius: 2,
                                color: Colors.black.withOpacity(0.5),
                              ),
                            ],
                          ),
                        ),
                      ]
                    )
                  ),
                ),
                // Botón de acción en escritorio
                if (isDesktop)
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 5,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.arrow_forward,
                          color: Color(0xFF343434),
                          size: 16,
                        ),
                        padding: const EdgeInsets.all(4),
                        constraints: const BoxConstraints(
                          minWidth: 24,
                          minHeight: 24,
                        ),
                        onPressed: () => press(),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}