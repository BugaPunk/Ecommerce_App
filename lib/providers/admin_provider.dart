import 'package:flutter/material.dart';

import '../models/user.dart';
import '../models/create_vendor_request.dart';
import '../services/admin_service.dart';

class AdminProvider with ChangeNotifier {
  final AdminService _adminService = AdminService();

  List<User> _users = [];
  List<User> _vendors = [];
  User? _selectedUser;
  User? _selectedVendor;
  String? _errorMessage;
  bool _loading = false;

  // Getters
  List<User> get users => _users;
  List<User> get vendors => _vendors;
  User? get selectedUser => _selectedUser;
  User? get selectedVendor => _selectedVendor;
  String? get errorMessage => _errorMessage;
  bool get loading => _loading;

  // Obtener lista de todos los usuarios
  Future<void> getAllUsers() async {
    _setLoading(true);
    _errorMessage = null;

    try {
      _users = await _adminService.getAllUsers();
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  // Obtener lista de vendedores
  Future<void> getVendors() async {
    _setLoading(true);
    _errorMessage = null;

    try {
      _vendors = await _adminService.getVendors();
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  // Obtener detalles de un usuario
  Future<void> getUserDetails(int userId) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      _selectedUser = await _adminService.getUserDetails(userId);
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  // Obtener detalles de un vendedor
  Future<void> getVendorDetails(int vendorId) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      _selectedVendor = await _adminService.getUserDetails(vendorId);
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  // Crear un nuevo vendedor
  Future<bool> createVendor(CreateVendorRequest request) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      final newVendor = await _adminService.createVendor(request);
      _vendors.add(newVendor);
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Activar/Desactivar un usuario
  Future<bool> toggleUserStatus(int userId, bool active) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      await _adminService.toggleUserStatus(userId, active);
      
      // Actualizar el estado del usuario en la lista de todos los usuarios
      final userIndex = _users.indexWhere((user) => user.id == userId);
      if (userIndex != -1) {
        _users[userIndex] = _users[userIndex].copyWith(active: active);
      }
      
      // Actualizar el estado del usuario en la lista de vendedores si es vendedor
      final vendorIndex = _vendors.indexWhere((vendor) => vendor.id == userId);
      if (vendorIndex != -1) {
        _vendors[vendorIndex] = _vendors[vendorIndex].copyWith(active: active);
      }
      
      // Actualizar el usuario seleccionado si es el mismo
      if (_selectedUser != null && _selectedUser!.id == userId) {
        _selectedUser = _selectedUser!.copyWith(active: active);
      }
      
      // Actualizar el vendedor seleccionado si es el mismo
      if (_selectedVendor != null && _selectedVendor!.id == userId) {
        _selectedVendor = _selectedVendor!.copyWith(active: active);
      }
      
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Activar/Desactivar un vendedor (método de compatibilidad)
  Future<bool> toggleVendorStatus(int vendorId, bool active) async {
    return await toggleUserStatus(vendorId, active);
  }

  // Limpiar el usuario seleccionado
  void clearSelectedUser() {
    _selectedUser = null;
    notifyListeners();
  }

  // Limpiar el vendedor seleccionado
  void clearSelectedVendor() {
    _selectedVendor = null;
    notifyListeners();
  }

  // Helper para establecer el estado de carga
  void _setLoading(bool loading) {
    _loading = loading;
    notifyListeners();
  }
}