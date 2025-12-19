import 'package:flutter/foundation.dart';
import '../../core/network/services/auth_storage_service.dart';


class AuthNotifier extends ChangeNotifier {
  final AuthStorageService _authStorageService = AuthStorageService();

  bool _isAuthenticated = false;
  bool get isAuthenticated => _isAuthenticated;

  bool _isLoading = true; // To handle initial check
  bool get isLoading => _isLoading;

  AuthNotifier() {
    checkAuthStatus();
  }

  Future<void> checkAuthStatus() async {
    _isLoading = true;
    notifyListeners();

    final token = await _authStorageService.getRefreshToken();
    _isAuthenticated = token != null && token.isNotEmpty;

    _isLoading = false;
    notifyListeners();
  }

  // Call these after successful login/logout
  Future<void> login() async {
    _isAuthenticated = true;
    notifyListeners();
  }

  Future<void> logout() async {
    await _authStorageService.clearAuthData(); // Implement clear if needed
    _isAuthenticated = false;
    notifyListeners();
  }
}