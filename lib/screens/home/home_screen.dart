import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../utils/responsive_layout.dart';
import '../../utils/size_config.dart';
import '../login_screen.dart';
import '../profile_screen.dart';
import 'components/body.dart';
import 'components/categories_screen.dart';

class ClientHomeScreen extends StatefulWidget {
  static String routeName = "/client_home";
  
  const ClientHomeScreen({super.key});

  @override
  State<ClientHomeScreen> createState() => _ClientHomeScreenState();
}

class _ClientHomeScreenState extends State<ClientHomeScreen> {
  int _selectedIndex = 0;
  
  @override
  Widget build(BuildContext context) {
    // Inicializar SizeConfig
    SizeConfig().init(context);
    
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    // Determinar si estamos en escritorio o móvil
    final isDesktop = ResponsiveLayout.isDesktop(context);
    final isTablet = ResponsiveLayout.isTablet(context);
    final isMobile = ResponsiveLayout.isMobile(context);

    if (isDesktop || isTablet) {
      // Layout para escritorio con NavigationRail
      return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: SafeArea(
          child: Row(
            children: [
              // NavigationRail para escritorio
              _buildNavigationRail(context),
              
              // Línea divisoria vertical
              VerticalDivider(
                thickness: 1, 
                width: 1,
                color: Theme.of(context).dividerColor,
              ),
              
              // Contenido principal
              Expanded(
                child: Column(
                  children: [
                    // AppBar personalizado para escritorio
                    _buildDesktopAppBar(context, authProvider, isDarkMode),
                    
                    // Contenido principal
                    Expanded(
                      child: _getSelectedScreen(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      // Layout para móvil con BottomNavigationBar
      return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.surface,
          elevation: 0,
          title: Row(
            children: [
              Image.asset(
                'assets/images/logo.png',
                height: 30,
                errorBuilder: (context, error, stackTrace) {
                  return Text(
                    "EcoShopping",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                },
              ),
            ],
          ),
          actions: [
            // Botón de modo oscuro/claro
            IconButton(
              icon: Icon(
                isDarkMode ? Icons.light_mode : Icons.dark_mode,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              onPressed: () {
                // TODO: Implementar cambio de tema
              },
            ),
            // Botón de carrito
            IconButton(
              icon: Icon(
                Icons.shopping_cart_outlined,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              onPressed: () {
                // TODO: Navegar al carrito
              },
            ),
            // Menú de usuario
            PopupMenuButton<String>(
              offset: const Offset(0, 40),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              icon: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                    width: 2,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: CircleAvatar(
                    backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    radius: 14,
                    child: Text(
                      user?.nombre?.isNotEmpty == true 
                          ? user!.nombre![0].toUpperCase() 
                          : "U",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ),
              tooltip: "Opciones de usuario",
              itemBuilder: (context) => [
                // Información del usuario
                PopupMenuItem(
                  enabled: false,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user?.nombre ?? "Usuario",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        user?.email ?? "",
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                const PopupMenuDivider(),
                
                // Opción de perfil
                PopupMenuItem<String>(
                  value: 'profile',
                  child: Row(
                    children: [
                      Icon(
                        Icons.person_outline,
                        color: Theme.of(context).colorScheme.onSurface,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      const Text("Mi perfil"),
                    ],
                  ),
                ),
                
                // Opción de cerrar sesión
                PopupMenuItem<String>(
                  value: 'logout',
                  child: Row(
                    children: [
                      Icon(
                        Icons.logout,
                        color: Theme.of(context).colorScheme.error,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        "Cerrar sesión",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              onSelected: (value) async {
                if (value == 'profile') {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const ProfileScreen()),
                  );
                } else if (value == 'logout') {
                  await authProvider.logout();
                  if (context.mounted) {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => const LoginScreen()),
                    );
                  }
                }
              },
            ),
          ],
        ),
        body: _getSelectedScreen(),
        bottomNavigationBar: _buildBottomNavigationBar(context),
      );
    }
  }
  
  // AppBar personalizado para escritorio
  Widget _buildDesktopAppBar(BuildContext context, AuthProvider authProvider, bool isDarkMode) {
    final user = authProvider.user;
    
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Título de la sección actual
          Text(
            _getPageTitle(),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          
          const Spacer(),
          
          // Botón de modo oscuro/claro
          IconButton(
            icon: Icon(
              isDarkMode ? Icons.light_mode : Icons.dark_mode,
              color: Theme.of(context).colorScheme.onSurface,
              size: 22,
            ),
            tooltip: isDarkMode ? "Modo claro" : "Modo oscuro",
            onPressed: () {
              // TODO: Implementar cambio de tema
            },
          ),
          
          const SizedBox(width: 8),
          
          // Botón de carrito
          IconButton(
            icon: Icon(
              Icons.shopping_cart_outlined,
              color: Theme.of(context).colorScheme.onSurface,
              size: 22,
            ),
            tooltip: "Carrito de compras",
            onPressed: () {
              // TODO: Navegar al carrito
            },
          ),
          
          const SizedBox(width: 8),
          
          // Menú de usuario con PopupMenuButton
          PopupMenuButton<String>(
            offset: const Offset(0, 40),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            icon: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                  width: 2,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: CircleAvatar(
                  backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  radius: 16,
                  child: Text(
                    user?.nombre?.isNotEmpty == true 
                        ? user!.nombre![0].toUpperCase() 
                        : "U",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            tooltip: "Opciones de usuario",
            itemBuilder: (context) => [
              // Información del usuario
              PopupMenuItem(
                enabled: false,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user?.nombre ?? "Usuario",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user?.email ?? "",
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              
              // Opción de perfil
              PopupMenuItem<String>(
                value: 'profile',
                child: Row(
                  children: [
                    Icon(
                      Icons.person_outline,
                      color: Theme.of(context).colorScheme.onSurface,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    const Text("Mi perfil"),
                  ],
                ),
              ),
              
              // Opción de cerrar sesión
              PopupMenuItem<String>(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(
                      Icons.logout,
                      color: Theme.of(context).colorScheme.error,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      "Cerrar sesión",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            onSelected: (value) async {
              if (value == 'profile') {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const ProfileScreen()),
                );
              } else if (value == 'logout') {
                await authProvider.logout();
                if (context.mounted) {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                  );
                }
              }
            },
          ),
        ],
      ),
    );
  }
  
  // NavigationRail para escritorio
  Widget _buildNavigationRail(BuildContext context) {
    final isExtended = MediaQuery.of(context).size.width >= 800;
    
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: NavigationRail(
        extended: isExtended,
        minExtendedWidth: 200,
        useIndicator: true,
        indicatorColor: Theme.of(context).colorScheme.primaryContainer,
        selectedIconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.primary,
        ),
        unselectedIconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
        ),
        selectedLabelTextStyle: TextStyle(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.bold,
        ),
        unselectedLabelTextStyle: TextStyle(
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
        ),
        destinations: const [
          NavigationRailDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: Text('Inicio'),
          ),
          NavigationRailDestination(
            icon: Icon(Icons.category_outlined),
            selectedIcon: Icon(Icons.category),
            label: Text('Categorías'),
          ),
          NavigationRailDestination(
            icon: Icon(Icons.local_offer_outlined),
            selectedIcon: Icon(Icons.local_offer),
            label: Text('Ofertas'),
          ),
          NavigationRailDestination(
            icon: Icon(Icons.favorite_outline),
            selectedIcon: Icon(Icons.favorite),
            label: Text('Favoritos'),
          ),
        ],
        selectedIndex: _selectedIndex,
        onDestinationSelected: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        // Agregar logo en la parte superior cuando está extendido
        leading: isExtended
            ? Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Column(
                  children: [
                    Image.asset(
                      'assets/images/logo.png',
                      height: 40,
                      errorBuilder: (context, error, stackTrace) {
                        return Text(
                          "EcoShopping",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              )
            : null,
      ),
    );
  }

  // BottomNavigationBar para móvil
  Widget _buildBottomNavigationBar(BuildContext context) {
    return NavigationBar(
      selectedIndex: _selectedIndex,
      onDestinationSelected: (int index) {
        setState(() {
          _selectedIndex = index;
        });
      },
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home),
          label: 'Inicio',
        ),
        NavigationDestination(
          icon: Icon(Icons.category_outlined),
          selectedIcon: Icon(Icons.category),
          label: 'Categorías',
        ),
        NavigationDestination(
          icon: Icon(Icons.local_offer_outlined),
          selectedIcon: Icon(Icons.local_offer),
          label: 'Ofertas',
        ),
        NavigationDestination(
          icon: Icon(Icons.favorite_outline),
          selectedIcon: Icon(Icons.favorite),
          label: 'Favoritos',
        ),
      ],
    );
  }
  
  // Obtener el título de la página actual
  String _getPageTitle() {
    switch (_selectedIndex) {
      case 0:
        return 'Inicio';
      case 1:
        return 'Categorías';
      case 2:
        return 'Ofertas';
      case 3:
        return 'Favoritos';
      default:
        return 'EcoShopping';
    }
  }
  
  // Obtener la pantalla seleccionada
  Widget _getSelectedScreen() {
    switch (_selectedIndex) {
      case 0:
        return const Body();
      case 1:
        return const CategoriesScreen();
      case 2:
        // TODO: Implementar pantalla de ofertas
        return const Center(child: Text('Próximamente: Ofertas'));
      case 3:
        // TODO: Implementar pantalla de favoritos
        return const Center(child: Text('Próximamente: Favoritos'));
      default:
        return const Body();
    }
  }
}