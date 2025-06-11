import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../models/cart_item.dart';
import '../../providers/cart_provider.dart';
import '../../components/empty_state.dart';
import '../../constants.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadCartItems();
  }

  Future<void> _loadCartItems() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Cargar los items del carrito desde el provider
      await Provider.of<CartProvider>(context, listen: false).loadCartItems();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al cargar el carrito: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
  
  // Método para construir la imagen del producto
  Widget _buildProductImage(String imageUrl, double width, double height) {
    if (imageUrl.startsWith('http')) {
      // Si es una URL, cargar desde la red
      return Image.network(
        imageUrl,
        width: width,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _buildImagePlaceholder(width, height);
        },
      );
    } else {
      // Si no, intentar cargar como asset
      return Image.asset(
        imageUrl,
        width: width,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _buildImagePlaceholder(width, height);
        },
      );
    }
  }
  
  // Método para construir un placeholder para imágenes
  Widget _buildImagePlaceholder(double width, double height) {
    return Container(
      width: width,
      height: height,
      color: Colors.grey[200],
      child: const Icon(
        Icons.image_not_supported_outlined,
        color: Colors.grey,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Obtener los items del carrito desde el CartProvider
    final cartProvider = Provider.of<CartProvider>(context);
    final List<CartItem> cartItems = cartProvider.items;
    final bool isEmpty = cartItems.isEmpty;
    final double total = cartProvider.totalAmount;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Mi Carrito',
          style: TextStyle(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : Colors.black,
          ),
        ),
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : isEmpty
              ? const EmptyState(
                  icon: Icons.shopping_cart_outlined,
                  title: 'Tu carrito está vacío',
                  message:
                      'Parece que aún no has agregado productos a tu carrito.',
                  buttonText: 'Explorar productos',
                  buttonRoute: '/home',
                )
              : Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: cartItems.length,
                        itemBuilder: (context, index) {
                          final item = cartItems[index];
                          return _buildCartItem(context, item);
                        },
                      ),
                    ),
                    _buildCartSummary(context, total),
                  ],
                ),
    );
  }

  Widget _buildCartItem(BuildContext context, CartItem item) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen del producto
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: _buildProductImage(item.imageUrl, 80, 80),
            ),
            const SizedBox(width: 16),
            // Detalles del producto
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '\$${item.price.toStringAsFixed(2)}',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Controles de cantidad
                  Row(
                    children: [
                      _buildQuantityButton(
                        context,
                        Icons.remove,
                        () {
                          // Disminuir cantidad
                          Provider.of<CartProvider>(context, listen: false)
                              .decreaseQuantity(item.id);
                        },
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                            color: Colors.grey[300]!,
                          ),
                        ),
                        child: Text(
                          '${item.quantity}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      _buildQuantityButton(
                        context,
                        Icons.add,
                        () {
                          // Aumentar cantidad
                          Provider.of<CartProvider>(context, listen: false)
                              .increaseQuantity(item.id);
                        },
                      ),
                      const Spacer(),
                      // Botón para eliminar el item
                      IconButton(
                        icon: const Icon(
                          Icons.delete_outline,
                          color: Colors.red,
                        ),
                        onPressed: () {
                          // Eliminar del carrito
                          Provider.of<CartProvider>(context, listen: false)
                              .removeFromCart(item.id);
                        },
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

  Widget _buildQuantityButton(
      BuildContext context, IconData icon, VoidCallback onPressed) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(4),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: Theme.of(context).brightness == Brightness.dark 
                ? Colors.grey[700]! 
                : Colors.grey[300]!,
          ),
        ),
        child: Icon(
          icon,
          size: 16,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  Widget _buildCartSummary(BuildContext context, double total) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).brightness == Brightness.dark 
                ? Colors.black.withOpacity(0.2) 
                : Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.titleLarge?.color,
                  ),
                ),
                Text(
                  '\$${total.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Navegar a la pantalla de checkout
                Navigator.of(context).pushNamed('/checkout');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: kPrimaryColor,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Proceder al pago',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}