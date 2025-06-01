import 'package:flutter/material.dart';

import '../models/user.dart';
import '../models/create_vendor_request.dart';
import '../services/admin_service.dart';

class AdminProvider with ChangeNotifier {
  final AdminService _adminService = AdminService();

  List<User> _vendors = [];
  User? _selectedVendor;
  String? _errorMessage;
  bool _loading = false;

  // Getters
  List<User> get vendors => _vendors;
  User? get selectedVendor => _selectedVendor;
  String? get errorMessage => _errorMessage;
  bool get loading => _loading;

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

  // Activar/Desactivar un vendedor
  Future<bool> toggleVendorStatus(int vendorId, bool active) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      await _adminService.toggleUserStatus(vendorId, active);
      
      // Actualizar el estado del vendedor en la lista
      final index = _vendors.indexWhere((vendor) => vendor.id == vendorId);
      if (index != -1) {
        _vendors[index] = _vendors[index].copyWith(active: active);
      }
      
      // Actualizar el vendedor seleccionado si es el mismo
      if (_selectedVendor != null && _selectedVendor!.id == vendorId) {
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