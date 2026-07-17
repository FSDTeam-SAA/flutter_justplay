import 'dart:developer' as DPrint;
import 'dart:io';

import 'package:flutter_justplay/features/home/models/response/fetch_profile_response_model.dart';
import 'package:get/get.dart';
import '../../../../core/base/base_controller.dart';
import '../../../core/network/services/auth_storage_service.dart';
import '../../../core/network/services/multiple_form_data_manager.dart';
import '../repositories/profile_repo.dart';


class ProfileController extends BaseController {
  final _profileRepository = Get.find<ProfileRepository>();
  final AuthStorageService _authStorageService = AuthStorageService();

  final Rxn<FetchProfileResponseModel> userInfo = Rxn<FetchProfileResponseModel>();


  final MultiFormDataManager _multiFormDataManager = MultiFormDataManager();

  @override
  void onInit() {
    super.onInit();
    fetchProfile(); //Fetch when controller is created
  }



  Future<void> fetchProfile() async {
    final result = await _profileRepository.fetchProfile();

    result.fold(
          (fail) {
        setError(fail.message);
        DPrint.log('data fetch failed');
      },
          (success) {
        userInfo.value = success.data;
        DPrint.log(success.message);
      },
    );
  }

  Future<void> updatePersonalInfo(
      String name,
      String phone, String city
      ) async {
    _multiFormDataManager.addTextData("name", name);
    _multiFormDataManager.addTextData("phone", phone);
    _multiFormDataManager.addTextData("city", city);


    final formRequest = await _multiFormDataManager.toFormDataAsync();

    final result = await _profileRepository.updatePersonalInfo(formRequest);

    result.fold(
          (fail) {
        setError(fail.message);
        DPrint.log('Personal info: ${fail.message}');
      },
          (success) async {
        DPrint.log('Personal info: ${success.message}');
        await fetchProfile();
        Get.back();
        _multiFormDataManager.clear();
        setError(success.message);
      },
    );
  }

  // //
  // //
  // Future<void> changePassword(String oldPassword, String newPassword) async{
  //   final request = UpdatePasswordRequestModel(newPassword: newPassword, currentPassword: oldPassword);
  //   final result = await _profileRepository.changePass(request);
  //
  //   result.fold(
  //         (fail) {
  //       setError(fail.message);
  //       DPrint.log("change pass success result : ${fail.message}");
  //       setLoading(false);
  //     },
  //         (success) {
  //       DPrint.log("change pass success result : ${success.message}");
  //       Get.back();
  //       setLoading(false);
  //     },
  //   );
  // }
  //
  // Future<void> fetchCtegory() async {
  //   final userId = await _authStorageService.getUserId();
  //   DPrint.log('UserId: $userId');
  //   if (userId == null || userId.isEmpty) {
  //     setError('User ID not found. Please log in again.');
  //     Get.snackbar('Error', 'User ID not found. Please log in again.');
  //     setLoading(false);
  //     return;
  //   }
  //
  //   final result = await _profileRepository.fetchProfile(userId);
  //
  //   result.fold(
  //         (fail) {
  //       setError(fail.message);
  //       DPrint.log('data fetch failed');
  //     },
  //         (success) {
  //       userInfo.value = success.data;
  //       DPrint.log(success.message);
  //     },
  //   );
  // }
  //
  // Future<void> fetchOngoingOrders() async {
  //
  //   final result = await _profileRepository.fetchOngoingOrder();
  //
  //   result.fold(
  //         (fail) {
  //       setError(fail.message);
  //       DPrint.log('data fetch failed');
  //     },
  //         (success) {
  //       ongoingOrder.value = success.data;
  //       DPrint.log(success.message);
  //     },
  //   );
  // }
  //
  // Future<void> fetchCompletedOrders() async {
  //
  //   final result = await _profileRepository.fetchCompletedOrder();
  //
  //   result.fold(
  //         (fail) {
  //       setError(fail.message);
  //       DPrint.log('data fetch failed');
  //     },
  //         (success) {
  //       completedOrder.value = success.data;
  //       DPrint.log(success.message);
  //     },
  //   );
  // }
}
