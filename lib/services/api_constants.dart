class ApiConstants {
  // Base URL for the API
  // Use 10.0.2.2 for Android emulator to connect to host machine's localhost
  // Use your machine's actual IP address when testing on physical devices
  // static const String baseUrl = 'http://10.0.2.2:8080'; // For Android emulator
  // static const String baseUrl = 'http://localhost:8080'; // For web or desktop
  static const String baseUrl = 'https://ecommerce-springboot-backend-xen4.onrender.com'; // Render deployment
  // static const String baseUrl = 'http://YOUR_MACHINE_IP:8080'; // For physical devices

  // Authentication endpoints
  static const String registerEndpoint = '/api/auth/signup';
  static const String loginEndpoint = '/api/auth/login';
  static const String sessionInfoEndpoint = '/api/auth/session-info';
  static const String logoutEndpoint = '/api/auth/logout';

  // Profile endpoints
  static const String profileEndpoint = '/api/profile';
  static const String changePasswordEndpoint = '/api/profile/change-password';

  // Admin endpoints
  static const String adminVendorsEndpoint = '/api/admin/usuarios/vendedores';
  static const String adminUsersEndpoint = '/api/admin/usuarios';

  // Product endpoints
  static const String productsEndpoint = '/api/productos';
  static const String productsByCategoryEndpoint = '/api/productos/categoria';
  static const String productsByStoreEndpoint = '/api/productos/tienda';

  // Category endpoints
  static const String categoriesEndpoint = '/api/categorias';
  static const String categoriesByStoreEndpoint = '/api/categorias/tienda';

  // Store endpoints
  static const String storesEndpoint = '/api/tiendas';

  // Cart endpoints
  static const String cartEndpoint = '/api/carrito';

  // Order endpoints
  static const String ordersEndpoint = '/api/pedidos';

  // Payment endpoints
  static const String paymentsEndpoint = '/api/pagos';

  // Invoice endpoints
  static const String invoicesEndpoint = '/api/facturas';

  // Product review endpoints
  static const String productReviewsEndpoint = '/api/resenias';

  // Store review endpoints
  static const String storeReviewsEndpoint = '/api/tiendas';

  // Token key for secure storage
  static const String tokenKey = 'auth_token';
  static const String userKey = 'user_data';
}
