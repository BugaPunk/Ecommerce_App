import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/admin_provider.dart';
import '../../utils/responsive_layout.dart';
import '../../widgets/admin_drawer.dart';
import 'user_list_screen.dart';
import 'vendor_list_screen.dart';
import 'stores_management_screen.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  @override
  void initState() {
    super.initState();
    // Cargar estadísticas iniciales
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final adminProvider = Provider.of<AdminProvider>(context, listen: false);
      adminProvider.getAllUsers();
      adminProvider.getVendors();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Panel de Administración'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        elevation: 0,
      ),
      drawer: const AdminDrawer(),
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
          // Título de bienvenida
          Text(
            'Bienvenido al Panel de Administración',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Gestiona usuarios, vendedores y configuraciones del sistema',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 24),

          // Estadísticas
          _buildStatsCards(),
          
          const SizedBox(height: 24),

          // Acciones principales
          Text(
            'Acciones Principales',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          
          _buildActionCards(),
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
          // Título de bienvenida
          Text(
            'Panel de Administración',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Gestiona usuarios, vendedores y configuraciones del sistema',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 32),

          // Estadísticas
          _buildStatsCards(),
          
          const SizedBox(height: 32),

          // Acciones principales
          Text(
            'Acciones Principales',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          
          _buildActionCards(),
        ],
      ),
    );
  }

  Widget _buildStatsCards() {
    return Consumer<AdminProvider>(
      builder: (context, adminProvider, child) {
        final totalUsers = adminProvider.users.length;
        final activeUsers = adminProvider.users.where((user) => user.active).length;
        final totalVendors = adminProvider.vendors.length;
        final activeVendors = adminProvider.vendors.where((vendor) => vendor.active).length;

        return ResponsiveLayout.builder(
          context: context,
          mobile: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      'Total Usuarios',
                      totalUsers.toString(),
                      Icons.people,
                      Colors.blue,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      'Usuarios Activos',
                      activeUsers.toString(),
                      Icons.person,
                      Colors.green,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      'Total Vendedores',
                      totalVendors.toString(),
                      Icons.store,
                      Colors.orange,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      'Vendedores Activos',
                      activeVendors.toString(),
                      Icons.store_mall_directory,
                      Colors.purple,
                    ),
                  ),
                ],
              ),
            ],
          ),
          desktop: Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Total Usuarios',
                  totalUsers.toString(),
                  Icons.people,
                  Colors.blue,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  'Usuarios Activos',
                  activeUsers.toString(),
                  Icons.person,
                  Colors.green,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  'Total Vendedores',
                  totalVendors.toString(),
                  Icons.store,
                  Colors.orange,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  'Vendedores Activos',
                  activeVendors.toString(),
                  Icons.store_mall_directory,
                  Colors.purple,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  icon,
                  color: color,
                  size: 24,
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCards() {
    final actions = [
      {
        'title': 'Gestionar Usuarios',
        'subtitle': 'Ver, activar/desactivar usuarios del sistema',
        'icon': Icons.people_alt,
        'color': Colors.blue,
        'onTap': () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const UserListScreen(),
            ),
          );
        },
      },
      {
        'title': 'Gestionar Vendedores',
        'subtitle': 'Administrar vendedores y crear nuevos',
        'icon': Icons.store,
        'color': Colors.orange,
        'onTap': () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const VendorListScreen(),
            ),
          );
        },
      },
      {
        'title': 'Gestionar Tiendas',
        'subtitle': 'Administrar tiendas del sistema',
        'icon': Icons.storefront,
        'color': Colors.purple,
        'onTap': () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const StoresManagementScreen(),
            ),
          );
        },
      },
      {
        'title': 'Configuración del Sistema',
        'subtitle': 'Ajustes generales y configuraciones',
        'icon': Icons.settings,
        'color': Colors.grey,
        'onTap': () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Funcionalidad en desarrollo'),
            ),
          );
        },
      },
      {
        'title': 'Reportes y Estadísticas',
        'subtitle': 'Ver reportes detallados del sistema',
        'icon': Icons.analytics,
        'color': Colors.green,
        'onTap': () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Funcionalidad en desarrollo'),
            ),
          );
        },
      },
    ];

    return ResponsiveLayout.builder(
      context: context,
      mobile: Column(
        children: actions.map((action) => _buildActionCard(action)).toList(),
      ),
      desktop: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 2.5,
        ),
        itemCount: actions.length,
        itemBuilder: (context, index) => _buildActionCard(actions[index]),
      ),
    );
  }

  Widget _buildActionCard(Map<String, dynamic> action) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: action['onTap'],
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: action['color'].withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  action['icon'],
                  color: action['color'],
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      action['title'],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      action['subtitle'],
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}