

import 'package:flutter_justplay/features/bookings/presentation/controller/booking_controller.dart';
import 'package:flutter_justplay/features/events/controller/event_controller.dart';
import 'package:flutter_justplay/features/home/controller/home_controller.dart';
import 'package:flutter_justplay/features/home/controller/profile_controller.dart';
import 'package:get/get.dart';

import '../../features/auth/controller/auth_controller.dart';
import '../realtime/realtime_controller.dart';
import '../utils/getx_helper.dart';

void setupControllers() {
  Get.getOrPut(() => AuthController(), fenix: true);
  Get.getOrPut(() => ProfileController(), fenix: true);
  Get.getOrPut(() => HomeController(), fenix: true);
  Get.getOrPut(() => EventController(), fenix: true);
  Get.getOrPut(() => BookingController(), fenix: true);
  Get.getOrPut(() => RealtimeController(), fenix: true);
}
