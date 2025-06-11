import 'package:flutter/material.dart';
import '../../../../models/product.dart';
import 'package:provider/provider.dart';

import '../../../../providers/cart_provider.dart';
import '../../../../utils/size_config.dart';

class DetailsScreen extends StatelessWidget {
  final Product product;

  const DetailsScreen({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalles del Producto'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Container(
              width: double.infinity,
              height: 300,
              decoration: BoxDecoration(
                color: Colors.grey[200],
              ),
              child: product.imagenes.isNotEmpty
                  ? Image.network(
                product.imagenes[0],
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return const Center(child: Icon(Icons.error));
                },
              )
                  : const Center(child: Icon(Icons.image_not_supported, size: 100)),
            ),

            Padding(
              padding: EdgeInsets.all(getProportionateScreenWidth(20)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Name
                  Text(
                    product.nombre,
                    style: TextStyle(
                      fontSize: getProportionateScreenWidth(24),
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: getProportionateScreenHeight(10)),

                  // Price and Stock
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "\$${product.precio}",
                        style: TextStyle(
                          fontSize: getProportionateScreenWidth(22),
                          fontWeight: FontWeight.w600,
                          color: Colors.blue,
                        ),
                      ),
                      Text(
                        product.stockLevel,
                        style: TextStyle(
                          fontSize: getProportionateScreenWidth(16),
                          color: product.hasStock ? Colors.green : Colors.red,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: getProportionateScreenHeight(20)),

                  // Description
                  Text(
                    "Descripción",
                    style: TextStyle(
                      fontSize: getProportionateScreenWidth(18),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: getProportionateScreenHeight(10)),
                  Text(
                    product.descripcion,
                    style: TextStyle(
                      fontSize: getProportionateScreenWidth(16),
                      color: Colors.grey[700],
                    ),
                  ),
                  SizedBox(height: getProportionateScreenHeight(30)),

                  // Add to Cart Button
                  SizedBox(
                    width: double.infinity,
                    height: getProportionateScreenHeight(56),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: product.hasStock
                          ? () {
                        context.read<CartProvider>().addItem(product.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Producto agregado al carrito'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      }
                          : null,
                      child: Text(
                        "Agregar al Carrito",
                        style: TextStyle(
                          fontSize: getProportionateScreenWidth(18),
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
