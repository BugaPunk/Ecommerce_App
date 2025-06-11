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
      
      // Obtener productos de la API real
      final response = await _apiService.get('/api/productos/all');
      if (response != null) {
        _products = (response as List).map((item) => Product.fromJson(item)).toList();
      } else {
        // Fallback a productos de demostración si la API no devuelve datos
        _products = demoProducts;
      }
      
      notifyListeners();
    } catch (e) {
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

      // Obtener categorías reales del backend
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
    } catch (e) {
      _setError('Error al cargar categorías: ${e.toString()}');
      
      // Fallback: usar categorías demo si falla la carga del backend
      _categories = [
        cat.Category(id: 1, nombre: "Electrónicos", descripcion: "Productos electrónicos", tiendaId: 1),
        cat.Category(id: 2, nombre: "Moda", descripcion: "Ropa y accesorios", tiendaId: 1),
        cat.Category(id: 3, nombre: "Hogar", descripcion: "Artículos para el hogar", tiendaId: 1),
        cat.Category(id: 4, nombre: "Deportes", descripcion: "Artículos deportivos", tiendaId: 1),
        cat.Category(id: 5, nombre: "Libros", descripcion: "Libros y literatura", tiendaId: 1),
      ];
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