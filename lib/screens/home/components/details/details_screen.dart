import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../constants.dart';
import '../../../../models/product.dart';
import '../../../../providers/cart_provider.dart';
import '../../../../components/rounded_icon_btn.dart';

class DetailsScreen extends StatefulWidget {
  final Product product;

  const DetailsScreen({Key? key, required this.product}) : super(key: key);

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final bool isDesktop = size.width > 1024;
    final bool isTablet = size.width > 768 && size.width <= 1024;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined, color: Colors.black),
            onPressed: () {
              Navigator.of(context).pushNamed('/cart');
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: isDesktop
          ? _buildDesktopLayout(context)
          : _buildMobileLayout(context, isTablet),
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Imagen del producto (40% del ancho)
        Expanded(
          flex: 4,
          child: _buildProductImage(context),
        ),
        // Detalles del producto (60% del ancho)
        Expanded(
          flex: 6,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProductTitle(context),
                const SizedBox(height: 24),
                _buildProductDescription(context),
                const SizedBox(height: 32),
                _buildPriceAndQuantity(context),
                const SizedBox(height: 32),
                _buildAddToCartButton(context),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout(BuildContext context, bool isTablet) {
    return Column(
      children: [
        // Imagen del producto (40% de la altura)
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.4,
          child: _buildProductImage(context),
        ),
        // Detalles del producto (60% de la altura)
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(isTablet ? 32 : 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProductTitle(context),
                const SizedBox(height: 16),
                _buildProductDescription(context),
                const SizedBox(height: 24),
                _buildPriceAndQuantity(context),
                const SizedBox(height: 24),
                _buildAddToCartButton(context),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Obtener el icono de categoría basado en el ID de categoría
  IconData _getCategoryIcon() {
    switch (widget.product.categoriaId) {
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
    switch (widget.product.categoriaId) {
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
          size: 100,
          color: isDarkMode 
              ? _getCategoryColor(context).withOpacity(0.9) 
              : _getCategoryColor(context),
        ),
      ),
    );
  }

  Widget _buildProductImage(BuildContext context) {
    return Container(
      color: Theme.of(context).brightness == Brightness.dark 
          ? Theme.of(context).cardColor 
          : Colors.grey[100],
      child: Center(
        child: Hero(
          tag: 'product-${widget.product.id}',
          child: widget.product.imagenUrl != null && widget.product.imagenUrl!.isNotEmpty
              ? Image.network(
                  widget.product.imagenUrl!,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return _buildCategoryIcon(context);
                  },
                )
              : widget.product.imagenes.isNotEmpty
                  ? Image.network(
                      widget.product.imagenes.first,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return _buildCategoryIcon(context);
                      },
                    )
                  : _buildCategoryIcon(context),
        ),
      ),
    );
  }

  Widget _buildProductTitle(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.product.nombre,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).textTheme.titleLarge?.color,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Icon(
              Icons.star,
              color: Colors.amber,
              size: 20,
            ),
            const SizedBox(width: 4),
            Text(
              '4.8',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).textTheme.bodyMedium?.color,
              ),
            ),
            const SizedBox(width: 16),
            Text(
              '(${widget.product.stock} disponibles)',
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.8),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildProductDescription(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Descripción',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).textTheme.titleMedium?.color,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          widget.product.descripcion,
          style: TextStyle(
            fontSize: 16,
            height: 1.5,
            color: Theme.of(context).textTheme.bodyMedium?.color,
          ),
        ),
      ],
    );
  }

  Widget _buildPriceAndQuantity(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Precio
        Text(
          '\$${widget.product.precio.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        // Control de cantidad
        Row(
          children: [
            RoundedIconBtn(
              icon: Icons.remove,
              showShadow: true,
              press: () {
                if (quantity > 1) {
                  setState(() {
                    quantity--;
                  });
                }
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                '$quantity',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            RoundedIconBtn(
              icon: Icons.add,
              showShadow: true,
              press: () {
                setState(() {
                  quantity++;
                });
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAddToCartButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: () async {
          try {
            // Agregar al carrito
            await Provider.of<CartProvider>(context, listen: false)
                .addToCart(widget.product, quantity: quantity);
            
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                      '${widget.product.nombre} agregado al carrito'),
                  backgroundColor: kPrimaryColor,
                  action: SnackBarAction(
                    label: 'Ver carrito',
                    textColor: Colors.white,
                    onPressed: () {
                      Navigator.of(context).pushNamed('/cart');
                    },
                  ),
                ),
              );
            }
          } catch (e) {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Error: ${e.toString()}'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: kPrimaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: const Text(
          'Agregar al carrito',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}