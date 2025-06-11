import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../components/product_card.dart';
import '../../../models/product.dart';
import '../../../providers/cart_provider.dart';
import '../../../routes.dart';
import '../../../utils/responsive_layout.dart';
import '../../../utils/size_config.dart';
import 'section_title.dart';

//Parametros producto popular
class PopularProducts extends StatelessWidget {
  final List<Product> products;

  const PopularProducts({
    Key? key,
    required this.products,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: getProportionateScreenWidth(20),
          ),
          child: Text(
            "Productos Populares",
            style: TextStyle(
              fontSize: getProportionateScreenWidth(18),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: getProportionateScreenWidth(20)),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              ...List.generate(
                products.length,
                    (index) => ProductCard(
                  product: products[index],
                  press: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.clientProductDetail,
                      arguments: {'product': products[index]},
                    );
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

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({
    Key? key,
    required this.product, required this.press,
  }) : super(key: key);

  final GestureTapCallback press;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: getProportionateScreenWidth(140),
      margin: EdgeInsets.only(left: getProportionateScreenWidth(20)),
      child: GestureDetector(
        onTap: press,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 1.02,
              child: Container(
                padding: EdgeInsets.all(getProportionateScreenWidth(20)),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Image.network(
                  product.imagenes.isNotEmpty ? product.imagenes[0] : '',
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.error);
                  },
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              product.nombre,
              style: const TextStyle(color: Colors.black),
              maxLines: 2,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "\$${product.precio}",
                  style: TextStyle(
                    fontSize: getProportionateScreenWidth(18),
                    fontWeight: FontWeight.w600,
                    color: Colors.blue,
                  ),
                ),
                InkWell(
                  borderRadius: BorderRadius.circular(50),
                  onTap: () {
                    context.read<CartProvider>().addToCart(product);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Producto agregado al carrito'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.all(getProportionateScreenWidth(8)),
                    height: getProportionateScreenWidth(28),
                    width: getProportionateScreenWidth(28),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
