

import 'package:flutter_justplay/features/events/controller/event_controller.dart';
import 'package:flutter_justplay/features/home/controller/home_controller.dart';
import 'package:flutter_justplay/features/home/controller/profile_controller.dart';
import 'package:get/get.dart';

import '../../features/auth/controller/auth_controller.dart';
import '../utils/getx_helper.dart';

void setupControllers() {
  Get.getOrPut(() => AuthController());
  Get.getOrPut(() => ProfileController());
  Get.getOrPut(() => HomeController());
  Get.getOrPut(() => EventController());
}
