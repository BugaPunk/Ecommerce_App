import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../utils/app_routes.dart';
import '../screens/vendor/vendor_dashboard_screen.dart';
import '../screens/vendor/product_list_screen.dart';
import '../screens/vendor/product_form_screen.dart';

class VendorDrawer extends StatelessWidget {
  const VendorDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          // Header del drawer
          Consumer<AuthProvider>(
            builder: (context, authProvider, child) {
              return UserAccountsDrawerHeader(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).colorScheme.primary,
                      Theme.of(context).colorScheme.primary.withOpacity(0.8),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                accountName: Text(
                  authProvider.user?.nombre ?? 'Vendedor',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                accountEmail: Text(
                  authProvider.user?.email ?? '',
                  style: const TextStyle(fontSize: 14),
                ),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Colors.white.withOpacity(0.2),
                  child: Icon(
                    Icons.store,
                    size: 40,
                    color: Colors.white,
                  ),
                ),
              );
            },
          ),
          
          // Opciones del menú
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                // Dashboard
                ListTile(
                  leading: const Icon(Icons.dashboard),
                  title: const Text('Dashboard'),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => const VendorDashboardScreen(),
                      ),
                    );
                  },
                ),
                
                const Divider(),
                
                // Sección de Productos
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    'PRODUCTOS',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
                
                // Gestionar Productos
                ListTile(
                  leading: const Icon(Icons.inventory_2),
                  title: const Text('Gestionar Productos'),
                  subtitle: const Text('Ver y administrar productos'),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const ProductListScreen(),
                      ),
                    );
                  },
                ),
                
                // Nuevo Producto
                ListTile(
                  leading: const Icon(Icons.add_box),
                  title: const Text('Nuevo Producto'),
                  subtitle: const Text('Agregar producto al catálogo'),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const ProductFormScreen(),
                      ),
                    );
                  },
                ),
                
                const Divider(),
                
                // Sección de Ventas (próximamente)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    'VENTAS',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
                
                // Pedidos
                ListTile(
                  leading: const Icon(Icons.shopping_cart),
                  title: const Text('Pedidos'),
                  subtitle: const Text('Gestionar pedidos recibidos'),
                  onTap: () {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Funcionalidad de pedidos próximamente'),
                      ),
                    );
                  },
                ),
                
                // Ventas
                ListTile(
                  leading: const Icon(Icons.trending_up),
                  title: const Text('Historial de Ventas'),
                  subtitle: const Text('Ver ventas realizadas'),
                  onTap: () {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Funcionalidad de ventas próximamente'),
                      ),
                    );
                  },
                ),
                
                const Divider(),
                
                // Sección de Reportes (próximamente)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    'REPORTES',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
                
                // Estadísticas
                ListTile(
                  leading: const Icon(Icons.analytics),
                  title: const Text('Estadísticas'),
                  subtitle: const Text('Ver reportes detallados'),
                  onTap: () {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Funcionalidad de reportes próximamente'),
                      ),
                    );
                  },
                ),
                
                const Divider(),
                
                // Configuración
                ListTile(
                  leading: const Icon(Icons.settings),
                  title: const Text('Configuración'),
                  subtitle: const Text('Ajustes de la tienda'),
                  onTap: () {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Funcionalidad de configuración próximamente'),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          
          // Footer del drawer
          const Divider(),
          
          // Cerrar Sesión
          ListTile(
            leading: Icon(
              Icons.logout,
              color: Theme.of(context).colorScheme.error,
            ),
            title: Text(
              'Cerrar Sesión',
              style: TextStyle(
                color: Theme.of(context).colorScheme.error,
              ),
            ),
            onTap: () {
              Navigator.of(context).pop();
              _showLogoutDialog(context);
            },
          ),
          
          // Información de la app
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Panel de Vendedor v1.0',
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            bool isLoggingOut = false;
            
            return AlertDialog(
              title: const Text('Cerrar Sesión'),
              content: isLoggingOut 
                ? const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(width: 16),
                      Text('Cerrando sesión...'),
                    ],
                  )
                : const Text('¿Estás seguro de que deseas cerrar sesión?'),
              actions: isLoggingOut ? [] : [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancelar'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      isLoggingOut = true;
                    });
                    
                    final authProvider = Provider.of<AuthProvider>(context, listen: false);
                    await authProvider.logout();
                    
                    if (context.mounted) {
                      Navigator.of(context).pop(); // Cerrar diálogo
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        AppRoutes.login,
                        (route) => false,
                      );
                    }
                  },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error,
                foregroundColor: Colors.white,
              ),
                  child: const Text('Cerrar Sesión'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}