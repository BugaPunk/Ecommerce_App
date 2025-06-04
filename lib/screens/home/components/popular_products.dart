import 'package:flutter/material.dart';

import '../../../components/product_card.dart';
import '../../../models/product.dart';
import '../../../utils/size_config.dart';
import 'section_title.dart';

//Parametros producto popular
class PopularProducts extends StatelessWidget {
  const PopularProducts({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SectionTitle(
          text: "Productos Populares",
          press: (){},
        ),
        SizedBox(height: getProportionateScreenWidth(20)),
        SingleChildScrollView(
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
        ),
      ],
    );
  }
}