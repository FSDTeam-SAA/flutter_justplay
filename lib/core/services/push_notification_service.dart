import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutx_core/core/debug_print.dart';
import 'package:get/get.dart';

import '../../features/home/repositories/profile_repo.dart';

/// Handles FCM push-notification registration/delivery for booking
/// confirmations, status changes and reminders.
///
/// SETUP REQUIRED before this actually delivers anything: this project has
/// no Firebase project wired up yet (no google-services.json /
/// GoogleService-Info.plist / firebase_options.dart exist in the repo). To
/// activate push notifications:
///   1. Create a Firebase project (or reuse one) at console.firebase.google.com
///   2. Run `flutterfire configure` from this app's root — it registers the
///      Android/iOS apps and writes `lib/firebase_options.dart` plus the
///      native config files automatically.
///   3. Add the same project's service-account credentials to the backend's
///      .env as FIREBASE_PROJECT_ID / FIREBASE_CLIENT_EMAIL /
///      FIREBASE_PRIVATE_KEY (or FIREBASE_SERVICE_ACCOUNT_JSON) — see
///      backend_just_play/utils/pushProvider.js.
/// Until then, `initialize()` fails fast and is caught, so the rest of the
/// app (including the existing in-app socket notifications) keeps working
/// normally without this.
class PushNotificationService {
  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;

    try {
      await Firebase.initializeApp();
    } catch (e) {
      DPrint.log('Push notifications unavailable (Firebase not configured): $e');
      return;
    }

    try {
      final messaging = FirebaseMessaging.instance;
      final settings = await messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.denied) {
        DPrint.log('Push notification permission denied by user');
        return;
      }

      final token = await messaging.getToken();
      if (token != null) {
        await _registerToken(token);
      }

      messaging.onTokenRefresh.listen(_registerToken);

      // Foreground messages: the OS doesn't auto-display these, so surface
      // them the same way the in-app socket notifications are shown.
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        final title = message.notification?.title ?? 'Notification';
        final body = message.notification?.body ?? '';
        Get.snackbar(title, body, snackPosition: SnackPosition.TOP);
      });

      // Background/terminated messages are shown automatically by the OS
      // using the FCM `notification` payload the backend sends.
      FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundHandler);

      _initialized = true;
    } catch (e) {
      DPrint.log('Push notification setup failed: $e');
    }
  }

  Future<void> _registerToken(String token) async {
    try {
      if (!Get.isRegistered<ProfileRepository>()) return;
      final repo = Get.find<ProfileRepository>();
      await repo.registerDeviceToken(token);
    } catch (e) {
      DPrint.log('Failed to register device token: $e');
    }
  }

  Future<void> unregisterCurrentToken() async {
    try {
      final token = await FirebaseMessaging.instance.getToken();
      if (token == null) return;
      if (!Get.isRegistered<ProfileRepository>()) return;
      await Get.find<ProfileRepository>().removeDeviceToken(token);
    } catch (e) {
      DPrint.log('Failed to remove device token: $e');
    }
  }
}

/// Must be a top-level function per the firebase_messaging plugin contract.
Future<void> _firebaseBackgroundHandler(RemoteMessage message) async {
  // No-op: the OS already renders the notification from the FCM payload.
  // This handler only needs to exist so background delivery is registered.
}
