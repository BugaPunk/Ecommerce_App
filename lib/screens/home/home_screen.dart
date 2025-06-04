import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../utils/responsive_layout.dart';
import '../../utils/size_config.dart';
import '../login_screen.dart';
import '../profile_screen.dart';
import 'components/body.dart';

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
                    const Expanded(child: Body()),
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
                // Aquí iría la lógica para cambiar el tema
              },
            ),
            // Botón de cerrar sesión
            IconButton(
              icon: Icon(
                Icons.logout,
                color: Theme.of(context).colorScheme.onSurface,
              ),
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
        body: const Body(),
        bottomNavigationBar: _buildBottomNavigationBar(context),
      );
    }
  }
  
  // AppBar personalizado para escritorio
  Widget _buildDesktopAppBar(BuildContext context, AuthProvider authProvider, bool isDarkMode) {
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
              // Aquí iría la lógica para cambiar el tema
            },
          ),
          
          const SizedBox(width: 8),
          
          // Botón de notificaciones
          IconButton(
            icon: Badge(
              label: const Text("3"),
              child: Icon(
                Icons.notifications_none_outlined,
                color: Theme.of(context).colorScheme.onSurface,
                size: 22,
              ),
            ),
            tooltip: "Notificaciones",
            onPressed: () {
              // Aquí iría la lógica para mostrar notificaciones
            },
          ),
          
          const SizedBox(width: 8),
          
          // Perfil del usuario
          InkWell(
            onTap: () {
              // Navegar a la pantalla de perfil
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
              
              // Si estamos en la pestaña de perfil, no hacer nada más
              if (_selectedIndex == 4) return;
              
              // Actualizar el índice seleccionado para sincronizar con NavigationRail
              setState(() {
                _selectedIndex = 4; // Índice de la pestaña de perfil
              });
            },
            borderRadius: BorderRadius.circular(30),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Row(
                children: [
                  // Avatar
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    child: Text(
                      authProvider.user?.username.substring(0, 1).toUpperCase() ?? "U",
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  
                  const SizedBox(width: 8),
                  
                  // Nombre de usuario
                  Text(
                    authProvider.user?.username ?? "Usuario",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(width: 8),
          
          // Botón de cerrar sesión
          IconButton(
            icon: Icon(
              Icons.logout,
              color: Theme.of(context).colorScheme.onSurface,
              size: 22,
            ),
            tooltip: "Cerrar sesión",
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
    );
  }
  
  // NavigationRail para escritorio
  Widget _buildNavigationRail(BuildContext context) {
    final isTablet = ResponsiveLayout.isTablet(context);
    final labelType = isTablet 
        ? NavigationRailLabelType.none 
        : NavigationRailLabelType.selected;
    
    return NavigationRail(
      selectedIndex: _selectedIndex,
      onDestinationSelected: (int index) {
        setState(() {
          _selectedIndex = index;
        });
        
        // Navegar a la pantalla correspondiente según el índice
        if (index == 4) { // Índice de la pestaña de perfil
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const ProfileScreen()),
          );
        }
        // Aquí se pueden agregar más navegaciones para otras pestañas
      },
      labelType: labelType,
      useIndicator: true,
      indicatorColor: Theme.of(context).colorScheme.secondaryContainer,
      backgroundColor: Theme.of(context).colorScheme.surface,
      selectedIconTheme: IconThemeData(
        color: Theme.of(context).colorScheme.primary,
      ),
      unselectedIconTheme: IconThemeData(
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
      selectedLabelTextStyle: TextStyle(
        color: Theme.of(context).colorScheme.primary,
        fontWeight: FontWeight.bold,
        fontSize: 12,
      ),
      unselectedLabelTextStyle: TextStyle(
        color: Theme.of(context).colorScheme.onSurfaceVariant,
        fontSize: 12,
      ),
      leading: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Column(
          children: [
            // Logo
            Image.asset(
              'assets/images/logo.png',
              height: 40,
              errorBuilder: (context, error, stackTrace) {
                return Icon(
                  Icons.shopping_bag,
                  size: 32,
                  color: Theme.of(context).colorScheme.primary,
                );
              },
            ),
            if (!isTablet) const SizedBox(height: 8),
            if (!isTablet)
              Text(
                "EcoShopping",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
          ],
        ),
      ),
      destinations: [
        NavigationRailDestination(
          icon: const Icon(Icons.home_outlined),
          selectedIcon: const Icon(Icons.home),
          label: const Text('Inicio'),
        ),
        NavigationRailDestination(
          icon: const Icon(Icons.favorite_border),
          selectedIcon: const Icon(Icons.favorite),
          label: const Text('Favoritos'),
        ),
        NavigationRailDestination(
          icon: const Badge(
            label: Text('2'),
            child: Icon(Icons.shopping_cart_outlined),
          ),
          selectedIcon: const Badge(
            label: Text('2'),
            child: Icon(Icons.shopping_cart),
          ),
          label: const Text('Carrito'),
        ),
        NavigationRailDestination(
          icon: const Badge(
            label: Text('3'),
            child: Icon(Icons.chat_bubble_outline),
          ),
          selectedIcon: const Badge(
            label: Text('3'),
            child: Icon(Icons.chat_bubble),
          ),
          label: const Text('Chat'),
        ),
        NavigationRailDestination(
          icon: const Icon(Icons.person_outline),
          selectedIcon: const Icon(Icons.person),
          label: const Text('Perfil'),
        ),
      ],
    );
  }

  // BottomNavigationBar para móvil
  Widget _buildBottomNavigationBar(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: _selectedIndex,
      selectedItemColor: Theme.of(context).colorScheme.primary,
      unselectedItemColor: Theme.of(context).colorScheme.onSurfaceVariant,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home),
          label: "Inicio",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite_border),
          activeIcon: Icon(Icons.favorite),
          label: "Favoritos",
        ),
        BottomNavigationBarItem(
          icon: Badge(
            label: Text('2'),
            child: Icon(Icons.shopping_cart_outlined),
          ),
          activeIcon: Badge(
            label: Text('2'),
            child: Icon(Icons.shopping_cart),
          ),
          label: "Carrito",
        ),
        BottomNavigationBarItem(
          icon: Badge(
            label: Text('3'),
            child: Icon(Icons.chat_bubble_outline),
          ),
          activeIcon: Badge(
            label: Text('3'),
            child: Icon(Icons.chat_bubble),
          ),
          label: "Chat",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          activeIcon: Icon(Icons.person),
          label: "Perfil",
        ),
      ],
      onTap: (index) {
        setState(() {
          _selectedIndex = index;
        });
        
        // Navegar a la pantalla correspondiente según el índice
        if (index == 4) { // Índice de la pestaña de perfil
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const ProfileScreen()),
          );
        }
        // Aquí se pueden agregar más navegaciones para otras pestañas
      },
    );
  }
  
  // Obtener el título de la página actual
  String _getPageTitle() {
    switch (_selectedIndex) {
      case 0:
        return "Inicio";
      case 1:
        return "Favoritos";
      case 2:
        return "Carrito de Compras";
      case 3:
        return "Chat";
      case 4:
        return "Perfil";
      default:
        return "Inicio";
    }
  }
}