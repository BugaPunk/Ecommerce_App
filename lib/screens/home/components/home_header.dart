import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/auth_provider.dart';
import '../../../utils/responsive_layout.dart';
import '../../../utils/size_config.dart';
import '../../profile_screen.dart';
import 'icon_btn_with_counter.dart';
import 'search_field.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;
    
    // Determinar si estamos en escritorio o móvil
    final isDesktop = ResponsiveLayout.isDesktop(context);
    final isTablet = ResponsiveLayout.isTablet(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final isLargeDesktop = screenWidth > 1400;
    
    // Ajustar espaciado según el dispositivo
    final double horizontalPadding = isDesktop 
        ? 0.0 
        : getProportionateScreenWidth(20);
    
    final double iconSpacing = isDesktop 
        ? 15.0 
        : getProportionateScreenWidth(5);
    
    final double searchFieldSpacing = isDesktop 
        ? 20.0 
        : getProportionateScreenWidth(10);
    
    final double avatarSize = isDesktop 
        ? 20.0 
        : getProportionateScreenWidth(15);
    
    final double avatarFontSize = isDesktop ? 16.0 : 14.0;
    
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Logo o título en escritorio
          if (isDesktop)
            Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: Row(
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
                          fontSize: 22,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          
          // Campo de búsqueda
          Expanded(
            child: SearchField(),
          ),
          
          SizedBox(width: searchFieldSpacing),
          
          // Botones de acción
          Row(
            children: [
              // Carrito
              IconBtnWithCounter(
                icon: Icons.shopping_cart_outlined,
                press: () {},
              ),
              SizedBox(width: iconSpacing),
              
              // Notificaciones
              IconBtnWithCounter(
                icon: Icons.notifications_none_outlined,
                numOfItems: 3,
                press: () {},
              ),
              SizedBox(width: iconSpacing),
              
              // Perfil
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const ProfileScreen()),
                  );
                },
                child: Row(
                  children: [
                    // Avatar
                    CircleAvatar(
                      radius: avatarSize,
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      child: Text(
                        user?.username.substring(0, 1).toUpperCase() ?? "U",
                        style: TextStyle(
                          fontSize: avatarFontSize,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    
                    // Nombre de usuario en escritorio
                    if (isDesktop)
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Text(
                          user?.username ?? "Usuario",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              
              // Botón de tema en escritorio
              if (isDesktop)
                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: IconButton(
                    icon: Icon(
                      Theme.of(context).brightness == Brightness.dark 
                          ? Icons.light_mode 
                          : Icons.dark_mode,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    onPressed: () {
                      // Aquí iría la lógica para cambiar el tema
                    },
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}