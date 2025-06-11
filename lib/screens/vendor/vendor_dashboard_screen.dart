import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/product_provider.dart';
import '../../providers/auth_provider.dart';
import '../../utils/responsive_layout.dart';
import '../../widgets/vendor_drawer.dart';
import 'product_list_screen.dart';
import 'product_form_screen.dart';

class VendorDashboardScreen extends StatefulWidget {
  const VendorDashboardScreen({super.key});

  @override
  State<VendorDashboardScreen> createState() => _VendorDashboardScreenState();
}

class _VendorDashboardScreenState extends State<VendorDashboardScreen> {
  @override
  void initState() {
    super.initState();
    // Cargar datos iniciales
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final productProvider = Provider.of<ProductProvider>(context, listen: false);
      productProvider.getAllProductsNoPagination();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Vendedor'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Actualizar',
            onPressed: () {
              Provider.of<ProductProvider>(context, listen: false).getAllProductsNoPagination();
            },
          ),
        ],
      ),
      drawer: const VendorDrawer(),
      body: ResponsiveLayout.builder(
        context: context,
        mobile: _buildMobileLayout(context),
        desktop: _buildDesktopLayout(context),
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Saludo y información del usuario
          _buildWelcomeSection(context),
          
          const SizedBox(height: 24),
          
          // Estadísticas rápidas
          _buildStatsSection(context),
          
          const SizedBox(height: 24),
          
          // Acciones principales
          _buildQuickActionsSection(context),
          
          const SizedBox(height: 24),
          
          // Productos recientes
          _buildRecentProductsSection(context),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Saludo y información del usuario
          _buildWelcomeSection(context),
          
          const SizedBox(height: 32),
          
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Columna izquierda - Estadísticas y acciones
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    _buildStatsSection(context),
                    const SizedBox(height: 24),
                    _buildQuickActionsSection(context),
                  ],
                ),
              ),
              
              const SizedBox(width: 32),
              
              // Columna derecha - Productos recientes
              Expanded(
                flex: 3,
                child: _buildRecentProductsSection(context),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeSection(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context).colorScheme.primary.withOpacity(0.8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.white.withOpacity(0.2),
                      child: Icon(
                        Icons.store,
                        size: 30,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '¡Bienvenido!',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            authProvider.user?.nombre ?? 'Vendedor',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white.withOpacity(0.9),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  'Gestiona tu tienda y productos desde aquí',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatsSection(BuildContext context) {
    return Consumer<ProductProvider>(
      builder: (context, productProvider, child) {
        final products = productProvider.products;
        final activeProducts = products.where((p) => p.estado == 'ACTIVO').length;
        final lowStockProducts = products.where((p) => p.stock <= 10 && p.stock > 0).length;
        final outOfStockProducts = products.where((p) => p.stock == 0).length;
        final totalValue = products.fold<double>(0, (sum, product) => sum + (product.precio * product.stock));

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Resumen de tu Tienda',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onBackground,
              ),
            ),
            const SizedBox(height: 16),
            
            // Grid de estadísticas
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: ResponsiveLayout.isMobile(context) ? 2 : 4,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: ResponsiveLayout.isMobile(context) ? 1.2 : 1.5,
              children: [
                _buildStatCard(
                  context,
                  'Total Productos',
                  products.length.toString(),
                  Icons.inventory_2,
                  Colors.blue,
                ),
                _buildStatCard(
                  context,
                  'Productos Activos',
                  activeProducts.toString(),
                  Icons.check_circle,
                  Colors.green,
                ),
                _buildStatCard(
                  context,
                  'Stock Bajo',
                  lowStockProducts.toString(),
                  Icons.warning,
                  Colors.orange,
                ),
                _buildStatCard(
                  context,
                  'Sin Stock',
                  outOfStockProducts.toString(),
                  Icons.error,
                  Colors.red,
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Valor total del inventario
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(
                      Icons.attach_money,
                      color: Theme.of(context).colorScheme.primary,
                      size: 32,
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Valor Total del Inventario',
                          style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                          ),
                        ),
                        Text(
                          '\$${totalValue.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatCard(BuildContext context, String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: color,
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Acciones Rápidas',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onBackground,
          ),
        ),
        const SizedBox(height: 16),
        
        // Grid de acciones
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: ResponsiveLayout.isMobile(context) ? 2 : 3,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: ResponsiveLayout.isMobile(context) ? 1.3 : 1.5,
          children: [
            _buildActionCard(
              context,
              'Gestionar Productos',
              'Ver y administrar todos tus productos',
              Icons.inventory_2,
              Colors.blue,
              () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const ProductListScreen(),
                  ),
                );
              },
            ),
            _buildActionCard(
              context,
              'Nuevo Producto',
              'Agregar un producto a tu catálogo',
              Icons.add_box,
              Colors.green,
              () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const ProductFormScreen(),
                  ),
                );
              },
            ),
            _buildActionCard(
              context,
              'Stock Bajo',
              'Ver productos con stock crítico',
              Icons.warning,
              Colors.orange,
              () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const ProductListScreen(),
                  ),
                );
                // TODO: Implementar filtro automático para stock bajo
              },
            ),
            _buildActionCard(
              context,
              'Ventas',
              'Ver historial de ventas',
              Icons.trending_up,
              Colors.purple,
              () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Funcionalidad de ventas próximamente'),
                  ),
                );
              },
            ),
            _buildActionCard(
              context,
              'Pedidos',
              'Gestionar pedidos recibidos',
              Icons.shopping_cart,
              Colors.teal,
              () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Funcionalidad de pedidos próximamente'),
                  ),
                );
              },
            ),
            _buildActionCard(
              context,
              'Reportes',
              'Ver estadísticas detalladas',
              Icons.analytics,
              Colors.indigo,
              () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Funcionalidad de reportes próximamente'),
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard(
    BuildContext context,
    String title,
    String description,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 32,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecentProductsSection(BuildContext context) {
    return Consumer<ProductProvider>(
      builder: (context, productProvider, child) {
        if (productProvider.loading) {
          return const Card(
            child: Padding(
              padding: EdgeInsets.all(32),
              child: Center(child: CircularProgressIndicator()),
            ),
          );
        }

        final recentProducts = productProvider.products.take(5).toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Productos Recientes',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const ProductListScreen(),
                      ),
                    );
                  },
                  child: const Text('Ver todos'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            if (recentProducts.isEmpty)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    children: [
                      Icon(
                        Icons.inventory_2_outlined,
                        size: 64,
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No hay productos registrados',
                        style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const ProductFormScreen(),
                            ),
                          );
                        },
                        icon: const Icon(Icons.add),
                        label: const Text('Crear Primer Producto'),
                      ),
                    ],
                  ),
                ),
              )
            else
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: recentProducts.map((product) {
                    return ListTile(
                      leading: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.inventory_2,
                          color: Colors.grey,
                        ),
                      ),
                      title: Text(
                        product.nombre,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(
                        '\$${product.precio.toStringAsFixed(2)} • Stock: ${product.stock}',
                      ),
                      trailing: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: _getStatusColor(product.estado).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          _getStatusText(product.estado),
                          style: TextStyle(
                            color: _getStatusColor(product.estado),
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const ProductListScreen(),
                          ),
                        );
                      },
                    );
                  }).toList(),
                ),
              ),
          ],
        );
      },
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'ACTIVO':
        return Colors.green;
      case 'INACTIVO':
        return Colors.orange;
      case 'AGOTADO':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'ACTIVO':
        return 'Activo';
      case 'INACTIVO':
        return 'Inactivo';
      case 'AGOTADO':
        return 'Agotado';
      default:
        return status;
    }
  }
}