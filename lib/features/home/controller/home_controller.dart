import 'dart:developer' as DPrint;

import 'package:flutter_justplay/features/home/controller/profile_controller.dart';
import 'package:flutter_justplay/features/home/models/request/booking_request_model.dart';
import 'package:flutter_justplay/features/home/models/request/issue_request_model.dart';
import 'package:flutter_justplay/features/home/models/response/fetch_city_response_model.dart';
import 'package:flutter_justplay/features/home/models/response/fetch_pitch_response_model.dart';
import 'package:flutter_justplay/features/home/models/response/fetch_sport_response_model.dart';
import 'package:flutter_justplay/features/home/repositories/home_repo.dart';
import 'package:flutter_justplay/features/home/screens/drawer_screen.dart';
import 'package:get/get.dart';
import '../../../../core/base/base_controller.dart';
import '../../../core/network/services/auth_storage_service.dart';
import '../../../core/network/services/multiple_form_data_manager.dart';

class HomeController extends BaseController {
  final HomeRepo _homeRepo = Get.find<HomeRepo>();
  final AuthStorageService _authStorageService = AuthStorageService();
  final ProfileController _profileController = Get.find<ProfileController>();

  final Rxn<FetchCityResponseModel> cities = Rxn<FetchCityResponseModel>();
  final Rxn<FetchSportResponseModel> sport = Rxn<FetchSportResponseModel>();
  final Rxn<FetchPitchResponseModel> pitch = Rxn<FetchPitchResponseModel>();

  final MultiFormDataManager _multiFormDataManager = MultiFormDataManager();

  // @override
  // void onInit() {
  //   super.onInit();
  //   fetchCity(); // Fetch cities when controller is initialized
  // }

  Future<void> fetchCity() async {
    final result = await _homeRepo.fetchCity();

    result.fold(
          (fail) {
        setError(fail.message);
        DPrint.log('City fetch failed: ${fail.message}');
      },
          (success) {
        cities.value = success.data;
        //DPrint.log('City fetch successful: ${success.cities.length} cities loaded');
      },
    );
  }

  Future<void> fetchSport() async {
    try {
      final result = await _homeRepo.fetchSport(); // No parameters needed

      result.fold(
            (failure) {
          Get.snackbar('Error', failure.message);
          sport.value = null;
        },
            (response) {
          sport.value = response.data;
        },
      );
    } catch (e) {
      Get.snackbar('Error', 'Failed to load sports');
      sport.value = null;
    } finally {
      isLoading.value = false;
    }
  }

  // Fetch pitches (backend knows city + sport from context)
  Future<void> fetchPitch() async {
    isLoading.value = true;
    try {
      final result = await _homeRepo.fetchPitch(); // No parameters

      result.fold(
            (failure) {
          Get.snackbar('Error', failure.message);
          pitch.value = null;
        },
            (response) {
          pitch.value = response.data;
        },
      );
    } catch (e) {
      Get.snackbar('Error', 'Failed to load pitches');
      pitch.value = null;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> issue(String title, String description, String bookingId) async {
    final request = IssueRequestModel(title: title, description: description, bookingId: bookingId);

    final result = await _homeRepo.issue(request);

    //DPrint.log("Login Response ${result.isRight()}");

    result.fold(
          (fail) {
        setError(fail.message);
      },
          (success) async {
        // Navigate to home screen
            Get.offAll(() => MenuScreen());
      },
    );
  }



  Future<void> createBooking(String cityId, String sportId, String pitchId, String date, String timeSlot, int price, String currency) async {
    final request = BookingRequest(cityId: cityId, sportId: sportId, pitchId: pitchId, date: date, timeSlot: timeSlot, price: price, currency: currency);

    final result = await _homeRepo.createBooking(request);

    //DPrint.log("Login Response ${result.isRight()}");

    result.fold(
          (fail) {
        setError(fail.message);
      },
          (success) async {
        // Navigate to home screen
        //     context.push(
        //       '/home/booking_confirm',
        //     );
      },
    );
  }
}
