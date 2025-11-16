import 'package:flutter/material.dart';
import '../core/services/supabase_service.dart';
import '../core/constants/app_config.dart';

class AuthProvider with ChangeNotifier {
  bool _isAuthenticated = false;
  String? _userId;
  bool _isLoading = false;

  bool get isAuthenticated => _isAuthenticated;
  String? get userId => _userId;
  bool get isLoading => _isLoading;

  AuthProvider() {
    _checkAuthStatus();
  }

  void _checkAuthStatus() {
    if (AppConfig.demoMode) {
      // In demo mode, skip auth check
      return;
    }
    
    try {
      final user = SupabaseService.currentUser;
      if (user != null) {
        _isAuthenticated = true;
        _userId = user.id;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Auth check failed: $e');
    }
  }

  Future<bool> signUp(String email, String password, String username, String name) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await SupabaseService.signUp(email, password);
      if (response.user != null) {
        // Create user profile
        await SupabaseService.insert('users', {
          'id': response.user!.id,
          'email': email,
          'username': username,
          'name': name,
        });

        _isAuthenticated = true;
        _userId = response.user!.id;
        _isLoading = false;
        notifyListeners();
        return true;
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  Future<bool> signIn(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await SupabaseService.signIn(email, password);
      if (response.user != null) {
        _isAuthenticated = true;
        _userId = response.user!.id;
        _isLoading = false;
        notifyListeners();
        return true;
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  Future<void> signOut() async {
    await SupabaseService.signOut();
    _isAuthenticated = false;
    _userId = null;
    notifyListeners();
  }
}
