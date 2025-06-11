import 'package:ecommerce_app/screens/home/components/details/details_screen.dart';
import 'package:flutter/material.dart';
import 'models/product.dart';
import 'screens/splash/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/change_password_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/home/components/categories_screen.dart';
import 'screens/vendor/vendor_home_screen.dart';
import 'screens/vendor/add_edit_product_screen.dart';
import 'screens/admin/admin_dashboard_screen.dart';
import 'screens/admin/user_list_screen.dart';
import 'screens/admin/user_detail_screen.dart';
import 'screens/admin/vendor_list_screen.dart';
import 'screens/admin/vendor_detail_screen.dart';
import 'screens/admin/vendor_form_screen.dart';
import 'screens/vendor/product_list_screen.dart';
import 'screens/vendor/product_detail_screen.dart';
import 'screens/vendor/product_form_screen.dart';
import 'screens/vendor/vendor_dashboard_screen.dart';


class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String profile = '/profile';
  static const String changePassword = '/change-password';
  static const String home = '/home';
  static const String categories = '/categories';
  static const String vendorHome = '/vendor/home';
  static const String vendorDashboard = '/vendor/dashboard';
  static const String addEditProduct = '/vendor/product';
  
  // Product routes
  static const String productList = '/vendor/products';
  static const String productDetail = '/vendor/product-detail';
  static const String productForm = '/vendor/product-form';
  static const String clientProductDetail = '/product-detail';
  
  // Admin routes
  static const String adminDashboard = '/admin/dashboard';
  static const String adminUsers = '/admin/users';
  static const String adminUserDetail = '/admin/user-detail';
  static const String adminVendors = '/admin/vendors';
  static const String adminVendorDetail = '/admin/vendor-detail';
  static const String adminVendorForm = '/admin/vendor-form';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      splash: (context) => const SplashScreen(),
      login: (context) => const LoginScreen(),
      register: (context) => const RegisterScreen(),
      profile: (context) => const ProfileScreen(),
      changePassword: (context) => const ChangePasswordScreen(),
      home: (context) => const ClientHomeScreen(),
      categories: (context) => const CategoriesScreen(),
      vendorHome: (context) => const VendorHomeScreen(),
      vendorDashboard: (context) => const VendorDashboardScreen(),
      addEditProduct: (context) => const AddEditProductScreen(),
      
      // Product routes
      productList: (context) => const ProductListScreen(),
      productForm: (context) => const ProductFormScreen(),
      
      // Admin routes
      adminDashboard: (context) => const AdminDashboardScreen(),
      adminUsers: (context) => const UserListScreen(),
      adminVendors: (context) => const VendorListScreen(),
      adminVendorForm: (context) => const VendorFormScreen(),
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
      case clientProductDetail:
        final args = settings.arguments as Map<String, dynamic>?;
        final product = args?['product'] as Product?;
        if (product != null) {
          return MaterialPageRoute(
            builder: (context) => DetailsScreen(product: product),
          );
        }
        break;
      case productDetail:
        final args = settings.arguments as Map<String, dynamic>?;
        final productId = args?['productId'] as int?;
        if (productId != null) {
          return MaterialPageRoute(
            builder: (context) => ProductDetailScreen(productId: productId),
          );
        }
        break;
      case productForm:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (context) => ProductFormScreen(
            product: args?['product'],
          ),
        );
      case adminUserDetail:
        final args = settings.arguments as Map<String, dynamic>?;
        final userId = args?['userId'] as int?;
        if (userId != null) {
          return MaterialPageRoute(
            builder: (context) => UserDetailScreen(userId: userId),
          );
        }
        break;
      case adminVendorDetail:
        final args = settings.arguments as Map<String, dynamic>?;
        final vendorId = args?['vendorId'] as int?;
        if (vendorId != null) {
          return MaterialPageRoute(
            builder: (context) => VendorDetailScreen(vendorId: vendorId),
          );
        }
        break;
      default:
        return MaterialPageRoute(
          builder: (context) => const Scaffold(
            body: Center(
              child: Text('Ruta no encontrada'),
            ),
          ),
        );
    }
    
    // Fallback para rutas con argumentos faltantes
    return MaterialPageRoute(
      builder: (context) => const Scaffold(
        body: Center(
          child: Text('Argumentos de ruta inválidos'),
        ),
      ),
    );
  }
} 