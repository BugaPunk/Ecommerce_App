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
    final isLargeDesktop = screenWidth > 1400;
    final isMediumDesktop = screenWidth > 1100 && screenWidth <= 1400;
    final isSmallDesktop = screenWidth <= 1100;
    
    // Ajustar espaciado según el tamaño de la pantalla
    final double horizontalPadding = isLargeDesktop ? 80.0 : isMediumDesktop ? 40.0 : 20.0;
    final double verticalSpacing = isLargeDesktop ? 40.0 : isMediumDesktop ? 30.0 : 20.0;
    
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
        child: Column(
          children: [
            SizedBox(height: verticalSpacing),
            HomeHeader(),
            SizedBox(height: verticalSpacing),
            
            // Layout adaptativo para banner y categorías
            if (isSmallDesktop)
              // En pantallas pequeñas, mostrar banner y categorías en columna
              Column(
                children: [
                  DiscountBanner(),
                  SizedBox(height: verticalSpacing),
                  _buildCategoriesContainer(context),
                ],
              )
            else
              // En pantallas medianas y grandes, mostrar banner y categorías en fila
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
              ),
            
            SizedBox(height: verticalSpacing),
            
            // Layout adaptativo para ofertas especiales y productos populares
            if (isLargeDesktop)
              // En pantallas grandes, mostrar ofertas y productos en fila
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Ofertas especiales (1/2 del ancho)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: SpecialOffers(),
                    ),
                  ),
                  // Productos populares (1/2 del ancho)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: PopularProducts(),
                    ),
                  ),
                ],
              )
            else
              // En pantallas medianas y pequeñas, mostrar ofertas y productos en columna
              Column(
                children: [
                  SpecialOffers(),
                  SizedBox(height: verticalSpacing),
                  PopularProducts(),
                ],
              ),
            
            SizedBox(height: verticalSpacing),
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