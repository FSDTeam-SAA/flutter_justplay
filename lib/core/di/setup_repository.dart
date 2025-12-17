

import 'package:flutter_justplay/features/events/repositories/event_repo.dart';
import 'package:flutter_justplay/features/events/repositories/event_repo_impl.dart';
import 'package:flutter_justplay/features/home/repositories/home_repo.dart';
import 'package:flutter_justplay/features/home/repositories/home_repo_impl.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';

import '../../features/auth/repositories/auth_repository.dart';
import '../../features/auth/repositories/auth_repository_impl.dart';
import '../../features/home/repositories/profile_repo.dart';
import '../../features/home/repositories/profile_repo_impl.dart';
import '../utils/getx_helper.dart';

void setupRepository() {
  Get.getOrPut<AuthRepository>(() => AuthRepositoryImpl(apiClient: Get.find()));
  Get.getOrPut<ProfileRepository>(() => ProfileRepositoryImpl(apiClient: Get.find()));
  Get.getOrPut<HomeRepo>(() => HomeRepoImpl(apiClient: Get.find()));
  Get.getOrPut<EventRepo>(() => EventRepoImpl(apiClient: Get.find()));
  // Get.getOrPut<HomeRepository>(() => HomeRepositoryImpl(apiClient: Get.find()));
  // Get.getOrPut<FavoriteFoodRepository>(() => FavoriteFoodRepositoryImpl(apiClient: Get.find()));
  // Get.getOrPut<CartRepository>(() => CartRepositoryImpl(apiClient: Get.find()));
  // Get.getOrPut<CartRepo>(() => CartRepoImpl(apiClient: Get.find()));
  // Get.getOrPut<PlaceOrderRepo>(() => PlaceOrderRepoImpl(apiClient: Get.find()));
  // Get.getOrPut<SearchRepository>(() => SearchRepositoryImpl(apiClient: Get.find()));
  // Get.getOrPut<MsgRepository>(() => MessageRepoImpl(apiClient: Get.find()));
  // Get.getOrPut<RateRepo>(() => RateRepoImpl(apiClient: Get.find()));
}
