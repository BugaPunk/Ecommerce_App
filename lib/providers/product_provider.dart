import 'package:flutter/foundation.dart';

import '../models/product.dart';
import '../models/category.dart' as cat;
import '../services/product_service.dart';
import '../services/api_service.dart';

class ProductProvider with ChangeNotifier {
  final ProductService _productService = ProductService();
  final ApiService _apiService = ApiService();

  // Estado de carga
  bool _loading = false;
  bool get loading => _loading;

  // Mensaje de error
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  // Lista de productos
  List<Product> _products = [];
  List<Product> get products => _products;

  // Lista de categorías
  List<cat.Category> _categories = [];
  List<cat.Category> get categories => _categories;

  // Producto seleccionado
  Product? _selectedProduct;
  Product? get selectedProduct => _selectedProduct;

  // Información de paginación
  int _currentPage = 0;
  int _totalPages = 0;
  int _totalElements = 0;
  bool _hasNext = false;
  bool _hasPrevious = false;

  int get currentPage => _currentPage;
  int get totalPages => _totalPages;
  int get totalElements => _totalElements;
  bool get hasNext => _hasNext;
  bool get hasPrevious => _hasPrevious;

  // Obtener todos los productos (paginados)
  Future<void> getAllProducts({
    int page = 0,
    int size = 10,
    String sort = 'id',
    String direction = 'asc',
  }) async {
    try {
      _setLoading(true);
      _clearError();

      final result = await _productService.getProducts(
        page: page,
        size: size,
        sort: sort,
        direction: direction,
      );

      _products = result;
      _currentPage = page;
      
      notifyListeners();
    } catch (e) {
      _setError('Error al cargar productos: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  // Obtener todos los productos (sin paginación)
  Future<void> getAllProductsNoPagination() async {
    try {
      _setLoading(true);
      _clearError();

      _products = await _productService.getAllProducts();
      notifyListeners();
    } catch (e) {
      _setError('Error al cargar productos: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }
  
  // Método para obtener productos (para la pantalla de productos)
  Future<void> fetchProducts() async {
    try {
      _setLoading(true);
      _clearError();
      
      print('[DEBUG_LOG] Fetching products from API...');
      
      // Obtener productos de la API real usando el endpoint /all
      final response = await _apiService.get('/api/productos/all');
      if (response != null) {
        print('[DEBUG_LOG] Products fetched successfully: ${response.length} products');
        _products = (response as List).map((item) => Product.fromJson(item)).toList();
        print('[DEBUG_LOG] Products parsed: ${_products.length} products');
        
        // Imprimir algunos detalles para depuración
        if (_products.isNotEmpty) {
          print('[DEBUG_LOG] First product: ${_products.first.nombre}, ID: ${_products.first.id}');
        }
      } else {
        print('[DEBUG_LOG] API returned null, trying paginated endpoint...');
        
        // Si el endpoint /all falla, intentar con el endpoint paginado
        try {
          final paginatedResponse = await _apiService.get('/api/productos');
          if (paginatedResponse != null && paginatedResponse['content'] != null) {
            print('[DEBUG_LOG] Products fetched successfully from paginated endpoint');
            final List<dynamic> productsJson = paginatedResponse['content'];
            _products = productsJson.map((item) => Product.fromJson(item)).toList();
            print('[DEBUG_LOG] Products parsed from paginated response: ${_products.length} products');
            
            if (_products.isNotEmpty) {
              print('[DEBUG_LOG] First product: ${_products.first.nombre}, ID: ${_products.first.id}');
            }
          } else {
            print('[DEBUG_LOG] Both endpoints failed, using demo products');
            _products = demoProducts;
          }
        } catch (paginatedError) {
          print('[DEBUG_LOG] Error fetching from paginated endpoint: $paginatedError');
          _products = demoProducts;
        }
      }
      
      notifyListeners();
    } catch (e) {
      print('[DEBUG_LOG] Error fetching products: $e');
      _setError('Error al cargar productos: ${e.toString()}');
      // Fallback a productos de demostración en caso de error
      _products = demoProducts;
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  // Obtener productos por categoría
  Future<void> getProductsByCategory(
    int categoryId, {
    int page = 0,
    int size = 10,
    String sort = 'id',
    String direction = 'asc',
  }) async {
    try {
      _setLoading(true);
      _clearError();

      final result = await _productService.getProductsByCategory(
        categoryId,
        page: page,
        size: size,
        sort: sort,
        direction: direction,
      );

      _products = result['products'];
      _totalElements = result['totalElements'];
      _totalPages = result['totalPages'];
      _currentPage = result['currentPage'];
      _hasNext = result['hasNext'];
      _hasPrevious = result['hasPrevious'];

      notifyListeners();
    } catch (e) {
      _setError('Error al cargar productos por categoría: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  // Obtener productos por tienda
  Future<void> getProductsByStore(
    int storeId, {
    int page = 0,
    int size = 10,
    String sort = 'id',
    String direction = 'asc',
  }) async {
    try {
      _setLoading(true);
      _clearError();

      final result = await _productService.getProductsByStore(
        storeId,
        page: page,
        size: size,
        sort: sort,
        direction: direction,
      );

      _products = result['products'];
      _totalElements = result['totalElements'];
      _totalPages = result['totalPages'];
      _currentPage = result['currentPage'];
      _hasNext = result['hasNext'];
      _hasPrevious = result['hasPrevious'];

      notifyListeners();
    } catch (e) {
      _setError('Error al cargar productos por tienda: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  // Crear producto
  Future<bool> createProduct(Product product) async {
    try {
      _setLoading(true);
      _clearError();

      final newProduct = await _productService.createProduct(product);
      _products.insert(0, newProduct);
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Error al crear producto: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Actualizar producto
  Future<bool> updateProduct(int productId, Product product) async {
    try {
      _setLoading(true);
      _clearError();

      final updatedProduct = await _productService.updateProduct(productId, product);
      
      final index = _products.indexWhere((p) => p.id == productId);
      if (index != -1) {
        _products[index] = updatedProduct;
        
        // Actualizar también el producto seleccionado si es el mismo
        if (_selectedProduct?.id == productId) {
          _selectedProduct = updatedProduct;
        }
        
        notifyListeners();
      }
      return true;
    } catch (e) {
      _setError('Error al actualizar producto: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Eliminar producto
  Future<bool> deleteProduct(int productId) async {
    try {
      _setLoading(true);
      _clearError();

      await _productService.deleteProduct(productId);
      
      _products.removeWhere((product) => product.id == productId);
      
      // Limpiar el producto seleccionado si es el que se eliminó
      if (_selectedProduct?.id == productId) {
        _selectedProduct = null;
      }
      
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Error al eliminar producto: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Obtener todas las categorías
  Future<void> getAllCategories() async {
    try {
      _setLoading(true);
      _clearError();

      print('[DEBUG_LOG] Fetching categories from API...');
      
      // Intentar obtener categorías directamente desde la API
      try {
        final response = await _apiService.get('/api/categorias');
        if (response != null) {
          print('[DEBUG_LOG] Categories fetched successfully: ${response.length} categories');
          _categories = (response as List).map((item) => 
            cat.Category.fromJson(item)
          ).toList();
          
          // Imprimir algunos detalles para depuración
          if (_categories.isNotEmpty) {
            print('[DEBUG_LOG] First category: ${_categories.first.nombre}, ID: ${_categories.first.id}');
          }
          
          notifyListeners();
          return;
        }
      } catch (apiError) {
        print('[DEBUG_LOG] Error fetching categories from API: $apiError');
        // Continuar con el método alternativo
      }
      
      // Si falla el método directo, intentar con el servicio de productos
      try {
        final categoriesData = await _productService.getCategories();
        
        _categories = categoriesData.map((categoryJson) => 
          cat.Category(
            id: categoryJson['id'],
            nombre: categoryJson['nombre'],
            descripcion: categoryJson['descripcion'] ?? '',
            tiendaId: categoryJson['tiendaId'] ?? 1,
          )
        ).toList();
        
        notifyListeners();
        return;
      } catch (serviceError) {
        print('[DEBUG_LOG] Error fetching categories from service: $serviceError');
        // Continuar con el fallback
      }
      
      // Fallback: usar categorías demo si fallan ambos métodos
      print('[DEBUG_LOG] Using demo categories');
      _categories = cat.demoCategories;
      notifyListeners();
    } catch (e) {
      print('[DEBUG_LOG] General error fetching categories: $e');
      _setError('Error al cargar categorías: ${e.toString()}');
      
      // Fallback: usar categorías demo
      _categories = cat.demoCategories;
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  // Seleccionar producto
  void selectProduct(Product product) {
    _selectedProduct = product;
    notifyListeners();
  }

  // Limpiar producto seleccionado
  void clearSelectedProduct() {
    _selectedProduct = null;
    notifyListeners();
  }

  // Buscar productos por nombre
  List<Product> searchProducts(String query) {
    if (query.isEmpty) return _products;
    
    return _products.where((product) {
      return product.nombre.toLowerCase().contains(query.toLowerCase()) ||
             product.descripcion.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  // Filtrar productos por estado
  List<Product> filterProductsByStatus(String status) {
    if (status == 'TODOS') return _products;
    
    return _products.where((product) => product.estado == status).toList();
  }

  // Filtrar productos por categoría
  List<Product> filterProductsByCategory(int categoryId) {
    return _products.where((product) => product.categoriaId == categoryId).toList();
  }

  // Obtener productos con stock bajo
  List<Product> getLowStockProducts({int threshold = 10}) {
    return _products.where((product) => product.stock <= threshold && product.stock > 0).toList();
  }

  // Obtener productos agotados
  List<Product> getOutOfStockProducts() {
    return _products.where((product) => product.stock == 0).toList();
  }

  // Helper para establecer el estado de carga
  void _setLoading(bool loading) {
    _loading = loading;
    notifyListeners();
  }

  // Helper para establecer mensaje de error
  void _setError(String message) {
    _errorMessage = message;
    notifyListeners();
  }

  // Helper para limpiar mensaje de error
  void _clearError() {
    _errorMessage = null;
  }

  // Limpiar todos los datos
  void clearData() {
    _products.clear();
    _categories.clear();
    _selectedProduct = null;
    _currentPage = 0;
    _totalPages = 0;
    _totalElements = 0;
    _hasNext = false;
    _hasPrevious = false;
    _clearError();
    notifyListeners();
  }
}