import 'package:flutter/material.dart';
import '../../../constants.dart';
import '../../../models/product.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onPress;

  const ProductCard({
    Key? key,
    required this.product,
    required this.onPress,
  }) : super(key: key);
  
  // Obtener el icono de categoría basado en el ID de categoría
  IconData _getCategoryIcon() {
    switch (product.categoriaId) {
      case 1:
        return Icons.devices;
      case 2:
        return Icons.checkroom;
      case 3:
        return Icons.home;
      case 4:
        return Icons.sports_basketball;
      case 5:
        return Icons.book;
      default:
        return Icons.shopping_bag;
    }
  }
  
  // Obtener el color de fondo para el icono de categoría
  Color _getCategoryColor(BuildContext context) {
    switch (product.categoriaId) {
      case 1:
        return Colors.blue;
      case 2:
        return Colors.purple;
      case 3:
        return Colors.green;
      case 4:
        return Colors.orange;
      case 5:
        return Colors.brown;
      default:
        return Theme.of(context).primaryColor;
    }
  }
  
  // Intentar obtener la imagen del producto, con fallback a un icono
  Widget _getProductImageOrIcon(BuildContext context) {
    if (product.imagenUrl != null && product.imagenUrl!.isNotEmpty) {
      return Image.network(
        product.imagenUrl!,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _buildCategoryIcon(context);
        },
      );
    } else if (product.imagenes.isNotEmpty) {
      return Image.network(
        product.imagenes.first,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _buildCategoryIcon(context);
        },
      );
    } else {
      return _buildCategoryIcon(context);
    }
  }
  
  // Construir un icono de categoría con un fondo de color
  Widget _buildCategoryIcon(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      color: isDarkMode 
          ? _getCategoryColor(context).withOpacity(0.3) 
          : _getCategoryColor(context).withOpacity(0.2),
      child: Center(
        child: Icon(
          _getCategoryIcon(),
          size: 50,
          color: isDarkMode 
              ? _getCategoryColor(context).withOpacity(0.9) 
              : _getCategoryColor(context),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).shadowColor.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen del producto
            AspectRatio(
              aspectRatio: 1,
              child: Hero(
                tag: 'product-${product.id}',
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                  ),
                  clipBehavior: Clip.hardEdge,
                  child: Stack(
                    children: [
                      // Imagen o icono del producto
                      _getProductImageOrIcon(context),
                      
                      // Etiqueta de descuento (si aplica)
                      if (product.descuento != null && product.descuento! > 0)
                        Positioned(
                          top: 8,
                          left: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: kPrimaryColor,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              '-${product.descuento}%',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            // Detalles del producto
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.nombre,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Theme.of(context).textTheme.titleMedium?.color,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '\$${product.precio.toStringAsFixed(2)}',
                    style: TextStyle(
                      color: kPrimaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Calificación del producto
                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        product.rating?.toString() ?? '4.5',
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodySmall?.color,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '(${product.stock} disponibles)',
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodySmall?.color,
                          fontSize: 12,
                        ),
                      ),
                    ],
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