import 'dart:developer' as DPrint;

import 'package:flutter_justplay/features/events/models/response/get_event_list_response_model.dart';
import 'package:flutter_justplay/features/events/repositories/event_repo.dart';
import 'package:get/get.dart';
import '../../../../core/base/base_controller.dart';
import '../../../core/network/services/auth_storage_service.dart';
import '../../../core/network/services/multiple_form_data_manager.dart';

class EventController extends BaseController {
  final EventRepo _eventRepo = Get.find<EventRepo>();
  final AuthStorageService _authStorageService = AuthStorageService();

  final Rxn<GetEventListResponseModel> event = Rxn<GetEventListResponseModel>();
  // final Rxn<FetchSportResponseModel> sport = Rxn<FetchSportResponseModel>();
  // final Rxn<FetchPitchResponseModel> pitch = Rxn<FetchPitchResponseModel>();

  final MultiFormDataManager _multiFormDataManager = MultiFormDataManager();

  // @override
  // void onInit() {
  //   super.onInit();
  //   fetchCity(); // Fetch cities when controller is initialized
  // }

  Future<void> fetchEvent() async {
    final result = await _eventRepo.fetchEvent();

    result.fold(
          (fail) {
        setError(fail.message);
        DPrint.log('City fetch failed: ${fail.message}');
      },
          (success) {
        event.value = success.data;
        //DPrint.log('City fetch successful: ${success.cities.length} cities loaded');
      },
    );
  }
}
