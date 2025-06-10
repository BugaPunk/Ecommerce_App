import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/change_password_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/vendor/vendor_home_screen.dart';
import 'screens/vendor/add_edit_product_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String profile = '/profile';
  static const String changePassword = '/change-password';
  static const String home = '/home';
  static const String vendorHome = '/vendor/home';
  static const String addEditProduct = '/vendor/product';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      login: (context) => const LoginScreen(),
      register: (context) => const RegisterScreen(),
      profile: (context) => const ProfileScreen(),
      changePassword: (context) => const ChangePasswordScreen(),
      home: (context) => const ClientHomeScreen(),
      vendorHome: (context) => const VendorHomeScreen(),
      addEditProduct: (context) => const AddEditProductScreen(),
    };
  }

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case addEditProduct:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (context) => AddEditProductScreen(
            product: args?['product'],
          ),
        );
      default:
        return MaterialPageRoute(
          builder: (context) => const Scaffold(
            body: Center(
              child: Text('Ruta no encontrada'),
            ),
          ),
        );
    }
  }
} 