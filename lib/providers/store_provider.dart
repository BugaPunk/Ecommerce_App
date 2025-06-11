import 'package:flutter/material.dart';
import '../models/store.dart';
import '../services/store_service.dart';

class StoreProvider with ChangeNotifier {
  final StoreService _storeService = StoreService();

  List<Store> _stores = [];
  Store? _selectedStore;
  bool _loading = false;
  String? _error;

  // Getters
  List<Store> get stores => _stores;
  Store? get selectedStore => _selectedStore;
  bool get loading => _loading;
  String? get error => _error;

  // Filtros y búsqueda
  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  List<Store> get filteredStores {
    if (_searchQuery.isEmpty) {
      return _stores;
    }
    
    return _stores.where((store) {
      final query = _searchQuery.toLowerCase();
      return store.nombre.toLowerCase().contains(query) ||
             store.descripcion.toLowerCase().contains(query) ||
             (store.codigoTienda?.toLowerCase().contains(query) ?? false) ||
             (store.email?.toLowerCase().contains(query) ?? false);
    }).toList();
  }

  // Métodos privados
  void _setLoading(bool loading) {
    _loading = loading;
    notifyListeners();
  }

  void _setError(String? error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
  }

  // Cargar todas las tiendas
  Future<void> loadStores() async {
    _setLoading(true);
    _clearError();
    
    try {
      _stores = await _storeService.getAllStores();
      notifyListeners();
    } catch (e) {
      _setError('Error al cargar tiendas: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  // Obtener tienda por ID
  Future<Store?> getStoreById(int id) async {
    _clearError();
    
    try {
      final store = await _storeService.getStoreById(id);
      return store;
    } catch (e) {
      _setError('Error al obtener tienda: ${e.toString()}');
      return null;
    }
  }

  // Crear nueva tienda
  Future<bool> createStore(StoreRequest storeRequest) async {
    _setLoading(true);
    _clearError();
    
    try {
      final newStore = await _storeService.createStore(storeRequest);
      _stores.add(newStore);
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Error al crear tienda: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Actualizar tienda
  Future<bool> updateStore(int id, StoreUpdateRequest storeUpdateRequest) async {
    _setLoading(true);
    _clearError();
    
    try {
      final updatedStore = await _storeService.updateStore(id, storeUpdateRequest);
      
      // Actualizar en la lista local
      final index = _stores.indexWhere((store) => store.id == id);
      if (index != -1) {
        _stores[index] = updatedStore;
        
        // Actualizar tienda seleccionada si es la misma
        if (_selectedStore?.id == id) {
          _selectedStore = updatedStore;
        }
        
        notifyListeners();
      }
      
      return true;
    } catch (e) {
      _setError('Error al actualizar tienda: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Eliminar tienda
  Future<bool> deleteStore(int id) async {
    _setLoading(true);
    _clearError();
    
    try {
      await _storeService.deleteStore(id);
      
      // Remover de la lista local
      _stores.removeWhere((store) => store.id == id);
      
      // Limpiar tienda seleccionada si es la misma
      if (_selectedStore?.id == id) {
        _selectedStore = null;
      }
      
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Error al eliminar tienda: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Seleccionar tienda
  void selectStore(Store? store) {
    _selectedStore = store;
    notifyListeners();
  }

  // Búsqueda
  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void clearSearch() {
    _searchQuery = '';
    notifyListeners();
  }

  // Limpiar errores
  void clearError() {
    _clearError();
    notifyListeners();
  }

  // Refrescar datos
  Future<void> refresh() async {
    await loadStores();
  }

  // Limpiar recursos
  @override
  void dispose() {
    _storeService.dispose();
    super.dispose();
  }

  // Métodos de utilidad
  int get totalStores => _stores.length;
  
  bool hasStoreWithCode(String codigoTienda) {
    return _stores.any((store) => store.codigoTienda == codigoTienda);
  }

  List<Store> getStoresByUser(int usuarioId) {
    return _stores.where((store) => store.usuarioId == usuarioId).toList();
  }

  // Estadísticas
  Map<String, dynamic> getStatistics() {
    if (_stores.isEmpty) {
      return {
        'total': 0,
        'active': 0,
        'averageRating': 0.0,
      };
    }

    final totalStores = _stores.length;
    final storesWithRating = _stores.where((store) => store.calificacionPromedio != null).toList();
    
    double averageRating = 0.0;
    if (storesWithRating.isNotEmpty) {
      final totalRating = storesWithRating
          .map((store) => store.calificacionPromedio!)
          .reduce((a, b) => a + b);
      averageRating = totalRating / storesWithRating.length;
    }

    return {
      'total': totalStores,
      'active': totalStores, // Asumimos que todas están activas por ahora
      'averageRating': averageRating,
      'withRating': storesWithRating.length,
    };
  }
}