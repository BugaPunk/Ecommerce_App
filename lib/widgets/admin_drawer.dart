import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../utils/app_routes.dart';
import '../screens/admin/admin_dashboard_screen.dart';
import '../screens/admin/user_list_screen.dart';
import '../screens/admin/vendor_list_screen.dart';
import '../screens/admin/stores_management_screen.dart';

class AdminDrawer extends StatelessWidget {
  const AdminDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;

    return Drawer(
      child: Column(
        children: [
          // Header del drawer
          UserAccountsDrawerHeader(
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
              user?.nombre ?? 'Administrador',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            accountEmail: Text(
              user?.email ?? 'admin@sistema.com',
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
              ),
            ),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(
                Icons.admin_panel_settings,
                size: 40,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),

          // Contenido del drawer
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
                        builder: (context) => const AdminDashboardScreen(),
                      ),
                    );
                  },
                ),

                const Divider(),

                // Gestión de Usuarios
                ListTile(
                  leading: const Icon(Icons.people),
                  title: const Text('Gestionar Usuarios'),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const UserListScreen(),
                      ),
                    );
                  },
                ),

                // Gestión de Vendedores
                ListTile(
                  leading: const Icon(Icons.store),
                  title: const Text('Gestionar Vendedores'),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const VendorListScreen(),
                      ),
                    );
                  },
                ),

                // Gestión de Tiendas
                ListTile(
                  leading: const Icon(Icons.storefront),
                  title: const Text('Gestionar Tiendas'),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const StoresManagementScreen(),
                      ),
                    );
                  },
                ),

                const Divider(),

                // Configuraciones
                ListTile(
                  leading: const Icon(Icons.settings),
                  title: const Text('Configuraciones'),
                  onTap: () {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Funcionalidad en desarrollo'),
                      ),
                    );
                  },
                ),

                // Reportes
                ListTile(
                  leading: const Icon(Icons.analytics),
                  title: const Text('Reportes'),
                  onTap: () {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Funcionalidad en desarrollo'),
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
              'Panel de Administración v1.0',
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