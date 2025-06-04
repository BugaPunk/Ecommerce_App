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
        ? 12.0 
        : isTablet
            ? 10.0
            : getProportionateScreenWidth(5);
    
    final double searchFieldSpacing = isDesktop 
        ? 15.0 
        : isTablet
            ? 12.0
            : getProportionateScreenWidth(10);
    
    final double avatarSize = isDesktop 
        ? 18.0 
        : isTablet
            ? 16.0
            : getProportionateScreenWidth(15);
    
    final double avatarFontSize = isDesktop 
        ? 14.0 
        : isTablet
            ? 12.0
            : 10.0;
    
    final double logoHeight = isDesktop 
        ? 36.0 
        : 40.0;
    
    final double logoFontSize = isDesktop 
        ? 20.0 
        : 22.0;
    
    final double usernameFontSize = isDesktop 
        ? 14.0 
        : 16.0;
    
    final double themeIconSize = isDesktop 
        ? 20.0 
        : 24.0;
    
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Logo o título en escritorio
          if (isDesktop)
            Padding(
              padding: const EdgeInsets.only(right: 15.0),
              child: Row(
                children: [
                  Image.asset(
                    'assets/images/logo.png',
                    height: logoHeight,
                    errorBuilder: (context, error, stackTrace) {
                      return Text(
                        "EcoShopping",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: logoFontSize,
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
            mainAxisSize: MainAxisSize.min, // Para que no ocupe más espacio del necesario
            children: [
              // Carrito
              IconBtnWithCounter(
                icon: Icons.shopping_cart_outlined,
                press: () {},
              ),
              SizedBox(width: iconSpacing),
              
              // Botón de tema en escritorio
              if (isDesktop)
                Padding(
                  padding: const EdgeInsets.only(left: 5.0),
                  child: IconButton(
                    icon: Icon(
                      Theme.of(context).brightness == Brightness.dark 
                          ? Icons.light_mode 
                          : Icons.dark_mode,
                      color: Theme.of(context).colorScheme.onSurface,
                      size: themeIconSize,
                    ),
                    padding: EdgeInsets.all(8),
                    constraints: BoxConstraints(
                      minWidth: 36,
                      minHeight: 36,
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