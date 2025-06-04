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
    // Obtener el tamaño de la pantalla para ajustes responsivos
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 1100;
    final isTablet = screenWidth > 600 && screenWidth <= 1100;
    final isMobile = screenWidth <= 600;
    
    // Ajustar dimensiones según el dispositivo
    final double cardWidth = isDesktop 
        ? 300 
        : isTablet 
            ? 260 
            : getProportionateScreenWidth(242);
    
    final double cardHeight = isDesktop 
        ? 120 
        : isTablet 
            ? 110 
            : getProportionateScreenWidth(100);
    
    final double fontSize = isDesktop 
        ? 20 
        : isTablet 
            ? 18 
            : getProportionateScreenWidth(18);
    
    final double subFontSize = isDesktop 
        ? 14 
        : isTablet 
            ? 13 
            : getProportionateScreenWidth(12);
    
    final double horizontalPadding = isDesktop 
        ? 20 
        : isTablet 
            ? 18 
            : getProportionateScreenWidth(15);
    
    final double verticalPadding = isDesktop 
        ? 15 
        : isTablet 
            ? 12 
            : getProportionateScreenWidth(10);
    
    return Padding(
      padding: EdgeInsets.only(left: getProportionateScreenWidth(20)),
      child: GestureDetector(
        onTap: press,
        child: SizedBox(
          width: cardWidth,
          height: cardHeight,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Stack(
              children: [
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
                          size: isDesktop ? 60 : 40,
                          color: Colors.grey,
                        ),
                      ),
                    );
                  },
                ),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}