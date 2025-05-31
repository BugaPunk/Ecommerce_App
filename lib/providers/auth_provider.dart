import 'package:flutter/material.dart';

import '../models/user.dart';
import '../models/auth_response.dart';
import '../models/login_request.dart';
import '../models/register_request.dart';
import '../models/update_profile_request.dart';
import '../models/change_password_request.dart';
import '../models/user_profile_response.dart';
import '../services/auth_service.dart';
import '../services/profile_service.dart';

enum AuthStatus {
  uninitialized,
  authenticated,
  unauthenticated,
}

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  final ProfileService _profileService = ProfileService();

  AuthStatus _status = AuthStatus.uninitialized;
  User? _user;
  String? _token;
  String? _errorMessage;
  bool _loading = false;

  // Getters
  AuthStatus get status => _status;
  User? get user => _user;
  String? get token => _token;
  String? get errorMessage => _errorMessage;
  bool get loading => _loading;
  bool get isAuthenticated => _status == AuthStatus.authenticated;

  // Constructor - initialize the auth state
  AuthProvider() {
    _initializeAuthState();
  }

  // Initialize auth state from storage
  Future<void> _initializeAuthState() async {
    _setLoading(true);
    
    try {
      final isLoggedIn = await _authService.isLoggedIn();
      
      if (isLoggedIn) {
        // Get user from storage
        _user = await _authService.getCurrentUser();
        _token = await _authService.getToken();
        
        if (_user != null && _token != null) {
          // Verify session with the server
          final serverUser = await _authService.getSessionInfo();
          
          if (serverUser != null) {
            _user = serverUser;
            _status = AuthStatus.authenticated;
          } else {
            // Session invalid, clear data
            await _authService.logout();
            _status = AuthStatus.unauthenticated;
            _user = null;
            _token = null;
          }
        } else {
          _status = AuthStatus.unauthenticated;
        }
      } else {
        _status = AuthStatus.unauthenticated;
      }
    } catch (e) {
      _status = AuthStatus.unauthenticated;
      _errorMessage = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  // Register a new user
  Future<bool> register(RegisterRequest request) async {
    _setLoading(true);
    _errorMessage = null;
    
    try {
      final success = await _authService.register(request);
      return success;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Login user
  Future<bool> login(LoginRequest request) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      final AuthResponse response = await _authService.login(request);

      _user = User(
        id: response.id,
        username: response.username,
        email: response.email,
        firstName: '',
        lastName: '',
        roles: response.roles,
      );

      _token = response.token;
      _status = AuthStatus.authenticated;

      // Try to get full profile data after login
      try {
        final profile = await _profileService.getUserProfile();
        _user = User.fromProfileResponse(profile, response.roles);
        // Update stored user data with complete profile
        await _authService.updateStoredUser(_user!);
      } catch (e) {
        // If profile fetch fails, continue with basic user data
        print('[DEBUG_LOG] Failed to fetch profile after login: $e');
      }

      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _status = AuthStatus.unauthenticated;
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Logout user
  Future<void> logout() async {
    _setLoading(true);

    try {
      await _authService.logout();
    } finally {
      _user = null;
      _token = null;
      _status = AuthStatus.unauthenticated;
      _setLoading(false);
    }
  }

  // Get user profile
  Future<UserProfileResponse?> getUserProfile() async {
    _setLoading(true);
    _errorMessage = null;

    try {
      final profile = await _profileService.getUserProfile();
      return profile;
    } catch (e) {
      _errorMessage = e.toString();
      if (e.toString().contains('Session expired')) {
        await logout();
      }
      return null;
    } finally {
      _setLoading(false);
    }
  }

  // Update user profile
  Future<bool> updateProfile(UpdateProfileRequest request) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      final updatedProfile = await _profileService.updateProfile(request);

      // Update the current user with new profile data
      if (_user != null) {
        _user = User.fromProfileResponse(updatedProfile, _user!.roles);
        // Update stored user data
        await _authService.updateStoredUser(_user!);
        notifyListeners();
      }

      return true;
    } catch (e) {
      _errorMessage = e.toString();
      if (e.toString().contains('Session expired')) {
        await logout();
      }
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Change password
  Future<bool> changePassword(ChangePasswordRequest request) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      await _profileService.changePassword(request);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      if (e.toString().contains('Session expired')) {
        await logout();
      }
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Helper to set loading state
  void _setLoading(bool loading) {
    _loading = loading;
    notifyListeners();
  }
}