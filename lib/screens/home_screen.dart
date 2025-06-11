import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../utils/responsive_layout.dart';
import 'login_screen.dart';
import 'profile_screen.dart';
import 'admin/admin_dashboard_screen.dart';
import 'admin/user_list_screen.dart';
import 'admin/vendor_list_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Aplicación de Comercio Electrónico'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await authProvider.logout();
              if (context.mounted) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              }
            },
          ),
        ],
      ),
      body: user == null
          ? const Center(child: CircularProgressIndicator())
          : ResponsiveLayout.builder(
              context: context,
              mobile: _buildMobileLayout(context, user),
              desktop: _buildDesktopLayout(context, user),
            ),
      drawer: user != null && user.roles.contains('ROLE_ADMIN')
          ? _buildAdminDrawer(context)
          : null,
    );
  }
  
  Widget _buildAdminDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.admin_panel_settings,
                  color: Colors.white,
                  size: 48,
                ),
                const SizedBox(height: 16),
                Text(
                  'Panel de Administración',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                      ),
                ),
                Text(
                  'Gestión de la plataforma',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withOpacity(0.8),
                      ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.dashboard,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            title: Text(
              'Panel de Administración',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            onTap: () {
              Navigator.pop(context); // Cerrar el drawer
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const AdminDashboardScreen(),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(
              Icons.people_alt,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            title: Text(
              'Gestión de Usuarios',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            onTap: () {
              Navigator.pop(context); // Cerrar el drawer
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const UserListScreen(),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(
              Icons.store,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            title: Text(
              'Gestión de Vendedores',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            onTap: () {
              Navigator.pop(context); // Cerrar el drawer
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const VendorListScreen(),
                ),
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: Icon(
              Icons.dashboard,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            title: Text(
              'Volver al Inicio',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            onTap: () {
              Navigator.pop(context); // Cerrar el drawer
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context, user) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        child: Text(
                          user.username.substring(0, 1).toUpperCase(),
                          style: const TextStyle(
                            fontSize: 40,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: Text(
                        '${user.firstName} ${user.lastName}',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Center(
                      child: Text(
                        '@${user.username}',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Divider(),
                    const SizedBox(height: 8),
                    Text(
                      'Correo: ${user.email}',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Perfiles: ${user.roles.join(", ")}',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              '¡Bienvenido a la Aplicación de Comercio Electrónico!',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Theme.of(context).colorScheme.onBackground,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Esta es una aplicación de muestra que demuestra la autenticación con una API backend de Spring Boot. Puedes navegar por productos, añadirlos a tu carrito y realizar el pago.',
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).colorScheme.onBackground,
              ),
            ),
            const SizedBox(height: 24),
            
            // Accesos rápidos para móvil
            if (user.roles.contains('ROLE_ADMIN')) ...[
              _buildMobileActionCard(
                context,
                Icons.dashboard,
                'Panel de Administración',
                'Accede al panel principal de admin',
                Colors.deepPurple,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const AdminDashboardScreen(),
                    ),
                  );
                },
              ),
              _buildMobileActionCard(
                context,
                Icons.people_alt,
                'Gestión de Usuarios',
                'Administra todos los usuarios del sistema',
                Colors.blue,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const UserListScreen(),
                    ),
                  );
                },
              ),
              _buildMobileActionCard(
                context,
                Icons.store,
                'Gestión de Vendedores',
                'Administra los usuarios vendedores',
                Colors.orange,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const VendorListScreen(),
                    ),
                  );
                },
              ),
            ],
            
            // Accesos rápidos para vendedores
            if (user.roles.contains('ROLE_VENDEDOR')) ...[
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green, width: 2),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.store,
                      color: Colors.green.shade700,
                      size: 48,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '¡Eres un Vendedor!',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.green.shade700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Accede a tu dashboard para gestionar productos',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.green.shade600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.of(context).pushReplacementNamed('/vendor/dashboard');
                      },
                      icon: const Icon(Icons.dashboard),
                      label: const Text('Ir a Mi Dashboard'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            
            _buildMobileActionCard(
              context,
              Icons.person,
              'Mi Perfil',
              'Actualiza tu información personal',
              Colors.purple,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const ProfileScreen()),
                );
              },
            ),
            
            const SizedBox(height: 24),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_cart,
                    size: 80,
                    color: Theme.of(context).colorScheme.onBackground.withOpacity(0.3),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '¡Productos próximamente!',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context, user) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left sidebar - user profile
        Container(
          width: 300,
          color: Theme.of(context).colorScheme.surface,
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 70,
                backgroundColor: Theme.of(context).colorScheme.primary,
                child: Text(
                  user.username.substring(0, 1).toUpperCase(),
                  style: const TextStyle(
                    fontSize: 60,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                '${user.firstName} ${user.lastName}',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                '@${user.username}',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 16),
              _buildProfileInfoItem(
                context,
                Icons.email,
                'Correo',
                user.email
              ),
              const SizedBox(height: 16),
              _buildProfileInfoItem(
                context,
                Icons.badge,
                'Perfiles',
                user.roles.join(", ")
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const ProfileScreen()),
                  );
                },
                icon: const Icon(Icons.edit),
                label: const Text('Editar Perfil'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                  minimumSize: const Size(double.infinity, 50),
                ),
              ),
              if (user.roles.contains('ROLE_ADMIN')) ...[
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const AdminDashboardScreen(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.dashboard),
                  label: const Text('Panel de Administración'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    foregroundColor: Theme.of(context).colorScheme.onSecondary,
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const UserListScreen(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.people_alt),
                  label: const Text('Gestión de Usuarios'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const VendorListScreen(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.store),
                  label: const Text('Gestión de Vendedores'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                ),
              ],
              
              // Sección para vendedores en escritorio
              if (user.roles.contains('ROLE_VENDEDOR')) ...[
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.green, width: 2),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.store,
                        color: Colors.green.shade700,
                        size: 48,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        '¡Eres un Vendedor!',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.green.shade700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Gestiona tu tienda y productos',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.green.shade600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.of(context).pushReplacementNamed('/vendor/dashboard');
                        },
                        icon: const Icon(Icons.dashboard),
                        label: const Text('Ir a Mi Dashboard'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                          minimumSize: const Size(double.infinity, 50),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              
              const Spacer(),
              ElevatedButton.icon(
                onPressed: () async {
                  final authProvider = Provider.of<AuthProvider>(context, listen: false);
                  await authProvider.logout();
                  if (context.mounted) {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => const LoginScreen()),
                    );
                  }
                },
                icon: const Icon(Icons.logout),
                label: const Text('Cerrar Sesión'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                  minimumSize: const Size(double.infinity, 50),
                ),
              ),
            ],
          ),
        ),

        // Main content area
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '¡Bienvenido, ${user.firstName}!',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Esta es una aplicación de muestra que demuestra la autenticación con una API backend de Spring Boot. Puedes navegar por productos, añadirlos a tu carrito y realizar el pago.',
                  style: TextStyle(
                    fontSize: 18,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 48),

                // Dashboard cards
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 3,
                    crossAxisSpacing: 24,
                    mainAxisSpacing: 24,
                    children: [
                      if (user.roles.contains('ROLE_ADMIN'))
                        _buildDashboardCard(
                          context,
                          Icons.admin_panel_settings,
                          'Gestión de Vendedores',
                          'Administra los usuarios vendedores',
                          Colors.deepPurple,
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const VendorListScreen(),
                              ),
                            );
                          },
                        ),
                      _buildDashboardCard(
                        context,
                        Icons.shopping_bag,
                        'Productos',
                        'Explora nuestro catálogo de productos',
                        Colors.blue,
                      ),
                      _buildDashboardCard(
                        context,
                        Icons.shopping_cart,
                        'Carrito',
                        'Revisa los productos en tu carrito',
                        Colors.orange,
                      ),
                      _buildDashboardCard(
                        context,
                        Icons.receipt_long,
                        'Pedidos',
                        'Historial de tus compras',
                        Colors.green,
                      ),
                      _buildDashboardCard(
                        context,
                        Icons.favorite,
                        'Favoritos',
                        'Productos guardados para más tarde',
                        Colors.red,
                      ),
                      _buildDashboardCard(
                        context,
                        Icons.person,
                        'Perfil',
                        'Actualiza tu información personal',
                        Colors.purple,
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => const ProfileScreen()),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileInfoItem(BuildContext context, IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: Colors.grey,
                ),
              ),
              Text(
                value,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDashboardCard(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
    Color color, {
    VoidCallback? onTap,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap ?? () {},
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0), // Reducido de 24 a 16
          child: Column(
            mainAxisSize: MainAxisSize.min, // Usar el mínimo espacio necesario
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 36, // Reducido de 48 a 36
                color: color,
              ),
              const SizedBox(height: 12), // Reducido de 16 a 12
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith( // Cambiado de titleLarge a titleMedium
                  color: Theme.of(context).colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
                maxLines: 1, // Limitar a una línea
                overflow: TextOverflow.ellipsis, // Mostrar elipsis si es demasiado largo
              ),
              const SizedBox(height: 4), // Reducido de 8 a 4
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodySmall?.copyWith( // Cambiado de bodyMedium a bodySmall
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                ),
                textAlign: TextAlign.center,
                maxLines: 2, // Limitar a dos líneas
                overflow: TextOverflow.ellipsis, // Mostrar elipsis si es demasiado largo
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMobileActionCard(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
    Color color, {
    VoidCallback? onTap,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap ?? () {},
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  size: 32,
                  color: color,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}