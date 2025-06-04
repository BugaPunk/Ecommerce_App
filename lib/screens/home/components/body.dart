import 'package:flutter/material.dart';

import '../../../utils/responsive_layout.dart';
import '../../../utils/size_config.dart';
import 'categories.dart';
import 'discount_banner.dart';
import 'home_header.dart';
import 'popular_products.dart';
import 'special_offers.dart';

class Body extends StatelessWidget {
  const Body({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ResponsiveLayout.builder(
        context: context,
        mobile: _buildMobileLayout(context),
        desktop: _buildDesktopLayout(context),
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    // Obtener el tamaño de la pantalla para ajustes responsivos
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    
    // Ajustar espaciado según el tamaño de la pantalla
    final bool isLargePhone = screenHeight > 800;
    final bool isSmallPhone = screenHeight < 600;
    
    final double verticalSpacing = isLargePhone 
        ? getProportionateScreenWidth(30) 
        : isSmallPhone 
            ? getProportionateScreenWidth(15) 
            : getProportionateScreenWidth(20);
    
    final double horizontalPadding = screenWidth * 0.05;
    
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
        child: Column(
          children: [
            SizedBox(height: verticalSpacing * 0.7),
            HomeHeader(),
            SizedBox(height: verticalSpacing),
            DiscountBanner(),
            SizedBox(height: verticalSpacing),
            
            // Contenedor para categorías con título
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 15),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  Text(
                    "Categorías",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  SizedBox(height: 10),
                  Categories(),
                ],
              ),
            ),
            
            SizedBox(height: verticalSpacing),
            SpecialOffers(),
            SizedBox(height: verticalSpacing),
            PopularProducts(),
            SizedBox(height: verticalSpacing),
          ],
        ),
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    // Obtener el ancho de la pantalla para ajustes responsivos
    final screenWidth = MediaQuery.of(context).size.width;
    final isExtraLargeDesktop = screenWidth > 1800;
    final isLargeDesktop = screenWidth > 1400 && screenWidth <= 1800;
    final isMediumDesktop = screenWidth > 1100 && screenWidth <= 1400;
    final isSmallDesktop = screenWidth <= 1100;
    
    // Ajustar espaciado según el tamaño de la pantalla
    final double horizontalPadding = isExtraLargeDesktop 
        ? 120.0 
        : isLargeDesktop 
            ? 80.0 
            : isMediumDesktop 
                ? 40.0 
                : 20.0;
    
    final double verticalSpacing = isExtraLargeDesktop 
        ? 50.0 
        : isLargeDesktop 
            ? 40.0 
            : isMediumDesktop 
                ? 30.0 
                : 20.0;
    
    // Determinar el ancho máximo del contenido para centrar en pantallas muy grandes
    final double maxContentWidth = isExtraLargeDesktop ? 1600 : double.infinity;
    
    return SingleChildScrollView(
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxContentWidth),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: Column(
              children: [
                SizedBox(height: verticalSpacing),
                
                // Header con búsqueda y botones
                HomeHeader(),
                SizedBox(height: verticalSpacing),
                
                // Layout adaptativo para banner, categorías y ofertas
                if (isExtraLargeDesktop)
                  // En pantallas extra grandes, mostrar banner, categorías y ofertas en una fila
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Banner de descuento (50% del ancho)
                      Expanded(
                        flex: 5,
                        child: DiscountBanner(),
                      ),
                      SizedBox(width: 20),
                      // Categorías (20% del ancho)
                      Expanded(
                        flex: 2,
                        child: _buildCategoriesContainer(context),
                      ),
                      SizedBox(width: 20),
                      // Ofertas especiales (30% del ancho)
                      Expanded(
                        flex: 3,
                        child: _buildSpecialOffersVertical(context),
                      ),
                    ],
                  )
                else if (isLargeDesktop || isMediumDesktop)
                  // En pantallas grandes y medianas, mostrar banner y categorías en fila
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Banner de descuento (2/3 del ancho)
                      Expanded(
                        flex: 2,
                        child: DiscountBanner(),
                      ),
                      SizedBox(width: 20),
                      // Categorías (1/3 del ancho)
                      Expanded(
                        flex: 1,
                        child: _buildCategoriesContainer(context),
                      ),
                    ],
                  )
                else
                  // En pantallas pequeñas, mostrar banner y categorías en columna
                  Column(
                    children: [
                      DiscountBanner(),
                      SizedBox(height: verticalSpacing),
                      _buildCategoriesContainer(context),
                    ],
                  ),
                
                SizedBox(height: verticalSpacing),
                
                // Layout adaptativo para ofertas especiales y productos populares
                if (isExtraLargeDesktop)
                  // En pantallas extra grandes, mostrar solo productos populares (ofertas ya están arriba)
                  PopularProducts()
                else if (isLargeDesktop)
                  // En pantallas grandes, mostrar ofertas y productos en fila
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Ofertas especiales (45% del ancho)
                      Expanded(
                        flex: 45,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 15.0),
                          child: SpecialOffers(),
                        ),
                      ),
                      // Productos populares (55% del ancho)
                      Expanded(
                        flex: 55,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 15.0),
                          child: PopularProducts(),
                        ),
                      ),
                    ],
                  )
                else
                  // En pantallas medianas y pequeñas, mostrar ofertas y productos en columna
                  Column(
                    children: [
                      if (!isExtraLargeDesktop) SpecialOffers(),
                      SizedBox(height: verticalSpacing),
                      PopularProducts(),
                    ],
                  ),
                
                SizedBox(height: verticalSpacing),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  // Componente de ofertas especiales en formato vertical para pantallas extra grandes
  Widget _buildSpecialOffersVertical(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 5, bottom: 15),
            child: Text(
              "Ofertas Especiales",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
          // Mostrar ofertas en columna en lugar de fila
          Column(
            children: [
              _buildVerticalSpecialOfferCard(
                context: context,
                image: "assets/images/banner_1.jpg",
                category: "Smartphones",
                numOfBrands: 18,
              ),
              const SizedBox(height: 15),
              _buildVerticalSpecialOfferCard(
                context: context,
                image: "assets/images/banner_2.jpg",
                category: "Moda",
                numOfBrands: 24,
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  // Tarjeta de oferta especial en formato vertical
  Widget _buildVerticalSpecialOfferCard({
    required BuildContext context,
    required String image,
    required String category,
    required int numOfBrands,
  }) {
    return Container(
      height: 120,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
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
                  child: const Center(
                    child: Icon(
                      Icons.image_not_supported_outlined,
                      size: 40,
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
              padding: const EdgeInsets.all(15),
              child: Text.rich(
                TextSpan(
                  style: const TextStyle(color: Colors.white),
                  children: [
                    TextSpan(
                      text: "$category\n",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            offset: Offset(1, 1),
                            blurRadius: 2,
                            color: Color(0x80000000),
                          ),
                        ],
                      ),
                    ),
                    TextSpan(
                      text: "$numOfBrands productos",
                      style: const TextStyle(
                        fontSize: 14,
                        shadows: [
                          Shadow(
                            offset: Offset(1, 1),
                            blurRadius: 2,
                            color: Color(0x80000000),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildCategoriesContainer(BuildContext context) {
    return Container(
      height: 180,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 15.0),
            child: Text(
              "Categorías",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Categories(),
            ),
          ),
        ],
      ),
    );
  }
}