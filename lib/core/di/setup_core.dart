
import 'package:get/get.dart';

import '../base/base_controller.dart';
import '../network/api_client.dart';
import '../network/services/auth_storage_service.dart';
import '../realtime/player_realtime_service.dart';
import '../services/location_service.dart';
import '../services/push_notification_service.dart';
import '../utils/getx_helper.dart';

void setupCore() {
  Get.getOrPut(() => BaseController());
  Get.getOrPutLazy(() => ApiClient(), fenix: true);
  Get.getOrPutLazy(() =>  AuthStorageService());
  Get.getOrPutLazy(() => PlayerRealtimeService(), fenix: true);
  Get.getOrPutLazy(() => LocationService(), fenix: true);
  Get.getOrPutLazy(() => PushNotificationService(), fenix: true);
  // Get.getOrPutLazy(() => AuthenticateCheckService(Get.find(), Get.find()));
}
