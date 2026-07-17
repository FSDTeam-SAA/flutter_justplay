import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../features/auth/screens/login_screen.dart';
import '../base/base_controller.dart';
import '../network/services/auth_storage_service.dart';
import 'player_realtime_service.dart';

/// App-wide real-time concerns that don't belong to any single screen:
/// live ban/unban enforcement, in-app notification toasts, booking
/// reminders, and the emergency-lockdown banner state.
class RealtimeController extends BaseController {
  final PlayerRealtimeService _realtimeService = Get.find<PlayerRealtimeService>();
  final AuthStorageService _authStorageService = AuthStorageService();

  final RxBool isLockedDown = false.obs;
  final RxString lockdownMessage = ''.obs;

  StreamSubscription<bool>? _bannedSub;
  StreamSubscription<Map<String, dynamic>>? _notificationSub;
  StreamSubscription<Map<String, dynamic>>? _reminderSub;
  StreamSubscription<Map<String, dynamic>>? _lockdownSub;

  bool _listenersAttached = false;

  void _attachListeners() {
    if (_listenersAttached) return;
    _listenersAttached = true;

    _bannedSub = _realtimeService.accountBannedUpdates.listen((isBanned) {
      if (isBanned) _forceLogoutForBan();
    });

    _notificationSub = _realtimeService.notifications.listen((payload) {
      final title = '${payload['title'] ?? 'Notification'}';
      final message = '${payload['message'] ?? ''}';
      Get.snackbar(
        title,
        message,
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 4),
      );
    });

    _reminderSub = _realtimeService.reminders.listen((payload) {
      Get.snackbar(
        'Booking reminder',
        'Your booking ${payload['bookingId'] ?? ''} starts soon (${payload['timeSlot'] ?? ''}).',
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 5),
      );
    });

    _lockdownSub = _realtimeService.lockdownUpdates.listen((payload) {
      isLockedDown.value = payload['locked'] == true;
      lockdownMessage.value = '${payload['message'] ?? ''}';
      if (isLockedDown.value) {
        Get.snackbar(
          'Bookings temporarily unavailable',
          lockdownMessage.value.isNotEmpty
              ? lockdownMessage.value
              : 'The platform is under maintenance. Please try again later.',
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 6),
        );
      }
    });
  }

  Future<void> connect(String userId) async {
    _attachListeners();
    _realtimeService.connect(userId);
  }

  void disconnect() {
    _realtimeService.disconnect();
  }

  Future<void> _forceLogoutForBan() async {
    await _authStorageService.clearAuthData();
    disconnect();
    Get.snackbar(
      'Account banned',
      'Your account has been banned by an administrator.',
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      duration: const Duration(seconds: 6),
    );
    Get.offAll(() => LoginScreen(), transition: Transition.leftToRight);
  }

  @override
  void onClose() {
    _bannedSub?.cancel();
    _notificationSub?.cancel();
    _reminderSub?.cancel();
    _lockdownSub?.cancel();
    super.onClose();
  }
}
