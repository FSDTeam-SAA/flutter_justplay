import 'package:flutter/material.dart';
import 'package:flutter_justplay/features/auth/models/request/register_request_model.dart';
import 'package:flutter_justplay/features/auth/screens/login_screen.dart';
import 'package:flutter_justplay/features/home/screens/home_screen.dart';
import 'package:flutx_core/core/debug_print.dart';
import 'package:get/get.dart'; // You can keep GetX for dependency injection and state
import 'package:go_router/go_router.dart'; // ← ADD THIS

import '../../../core/base/base_controller.dart';
import '../../../core/network/constants/key_constants.dart';
import '../../../core/network/services/auth_storage_service.dart';
import '../../../core/network/services/secure_store_services.dart';
import '../models/request/login_request_model.dart';
import '../repositories/auth_repository.dart';

class AuthController extends BaseController {
  final _authRepo = Get.find<AuthRepository>();
  final AuthStorageService _authStorageService = AuthStorageService();
  final SecureStoreServices _secureStoreServices = SecureStoreServices();

  Future<void> register(String name, String phone, BuildContext context) async {
    final request = RegisterRequestModel(name: name, phone: phone);

    final result = await _authRepo.register(request);

    result.fold(
          (fail) {
        setError(fail.message);
        DPrint.log("Register failed: ${fail.message}");
        setLoading(false);
      },
          (success) {
        DPrint.log("Register success: User ID ${success.data.id}");
        setLoading(false);
        // Navigate to Login screen (replace current screen)
        context.go('/create-account/login'); // or just '/login' if you prefer named route
        // Alternatively: context.push('/create-account/login');
      },
    );
  }

  Future<void> login(String name, String phone, BuildContext context) async {
    setLoading(true);

    final request = LoginRequestModel(name: name, phone: phone);

    final result = await _authRepo.login(request);

    result.fold(
          (fail) {
        setError(fail.message);
        setLoading(false);
      },
          (success) async {
        final user = success.data.user;

        // Store tokens
        await _authStorageService.storeAuthData(
          accessToken: success.data.accessToken,
          refreshToken: success.data.refreshToken,
          userId: user.id,
        );

        setLoading(false);

        // CORRECT: Use GoRouter to go to the main app (with bottom navigation)
        context.go('/home');
        // This triggers the StatefulShellRoute → shows NavigationMenuShell with Home tab selected
      },
    );
  }

  Future<void> logout(BuildContext context) async {
    await _authStorageService.clearAuthData();
    await _secureStoreServices.deleteData(KeyConstants.conversationId);

    // Go to auth flow, clearing all previous routes
    context.go('/login');
  }

// Optional: Add a helper if you need to access context elsewhere
// But better to pass context from UI
}