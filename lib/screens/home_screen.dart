import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../utils/responsive_layout.dart';
import 'login_screen.dart';
import 'profile_screen.dart';

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
    );
  }

  Widget _buildMobileLayout(BuildContext context, user) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            elevation: 4,
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
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Center(
                    child: Text(
                      '@${user.username}',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 8),
                  Text(
                    'Correo: ${user.email}',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Perfiles: ${user.roles.join(", ")}',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            '¡Bienvenido a la Aplicación de Comercio Electrónico!',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          const Text(
            'Esta es una aplicación de muestra que demuestra la autenticación con una API backend de Spring Boot. Puedes navegar por productos, añadirlos a tu carrito y realizar el pago.',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.shopping_cart,
                    size: 100,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '¡Productos próximamente!',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],
              ),
            ),
          ),
        ],
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
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                '@${user.username}',
                style: Theme.of(context).textTheme.titleMedium,
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
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                const SizedBox(height: 24),
                const Text(
                  'Esta es una aplicación de muestra que demuestra la autenticación con una API backend de Spring Boot. Puedes navegar por productos, añadirlos a tu carrito y realizar el pago.',
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 48),
                
                // Dashboard cards
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 3,
                    crossAxisSpacing: 24,
                    mainAxisSpacing: 24,
                    children: [
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
                      ),
                      _buildDashboardCard(
                        context,
                        Icons.settings,
                        'Configuración',
                        'Personaliza tu experiencia',
                        Colors.teal,
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
                style: Theme.of(context).textTheme.bodyLarge,
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
    Color color,
  ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 48,
                color: color,
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}