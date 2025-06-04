import 'package:flutter/material.dart';

import '../../../components/product_card.dart';
import '../../../models/product.dart';
import '../../../utils/responsive_layout.dart';
import '../../../utils/size_config.dart';
import 'section_title.dart';

//Parametros producto popular
class PopularProducts extends StatelessWidget {
  const PopularProducts({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // Determinar si estamos en escritorio o móvil
    final isDesktop = ResponsiveLayout.isDesktop(context);
    final isTablet = ResponsiveLayout.isTablet(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final isExtraLargeDesktop = screenWidth > 1800;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(
          text: "Productos Populares",
          press: (){},
        ),
        SizedBox(height: getProportionateScreenWidth(20)),
        
        // En escritorio, mostrar productos en grid
        if (isDesktop || isTablet)
          _buildDesktopProductGrid(context, isExtraLargeDesktop)
        // En móvil, mostrar productos en carrusel horizontal
        else
          _buildMobileProductCarousel(context),
      ],
    );
  }
  
  // Grid de productos para escritorio
  Widget _buildDesktopProductGrid(BuildContext context, bool isExtraLargeDesktop) {
    // Determinar el número de columnas según el ancho de la pantalla
    final screenWidth = MediaQuery.of(context).size.width;
    int crossAxisCount;
    
    if (isExtraLargeDesktop) {
      crossAxisCount = 4; // 4 columnas para pantallas extra grandes
    } else if (screenWidth > 1400) {
      crossAxisCount = 3; // 3 columnas para pantallas grandes
    } else if (screenWidth > 900) {
      crossAxisCount = 2; // 2 columnas para pantallas medianas
    } else {
      crossAxisCount = 1; // 1 columna para pantallas pequeñas
    }
    
    // Calcular el espaciado entre elementos
    final double spacing = isExtraLargeDesktop ? 30.0 : 20.0;
    
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          childAspectRatio: 0.75, // Proporción altura/ancho de cada elemento
          crossAxisSpacing: spacing,
          mainAxisSpacing: spacing,
        ),
        itemCount: demoProducts.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(0),
            child: ProductCard(
              product: demoProducts[index],
              press: () {
                // Navegar a la pantalla de detalles del producto
              },
              width: double.infinity, // Ancho completo dentro de la celda
            ),
          );
        },
      ),
    );
  }
  
  // Carrusel de productos para móvil
  Widget _buildMobileProductCarousel(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          //aqui parametro de list de productos editar para la Api
          ...List.generate(
            demoProducts.length, 
            (index) => ProductCard(
              product: demoProducts[index],
              press: () {
                // Navegar a la pantalla de detalles del producto
                // Navigator.pushNamed(
                //   context, 
                //   DetailsScreen.routeName,
                //   arguments: ProductDetailsArguments(product: demoProducts[index]),
                // );
              },
            ),
          ),
          SizedBox(width: getProportionateScreenWidth(20)),
        ],
      ),
    );
  }
}