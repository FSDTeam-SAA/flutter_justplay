import 'dart:async';
import 'dart:developer' as DPrint;

import 'package:flutter_justplay/features/events/models/response/get_event_list_response_model.dart';
import 'package:flutter_justplay/features/events/repositories/event_repo.dart';
import 'package:get/get.dart';
import '../../../../core/base/base_controller.dart';
import '../../../core/network/services/auth_storage_service.dart';
import '../../../core/network/services/multiple_form_data_manager.dart';
import '../../../core/realtime/player_realtime_service.dart';

class EventController extends BaseController {
  final EventRepo _eventRepo = Get.find<EventRepo>();
  final AuthStorageService _authStorageService = AuthStorageService();
  final PlayerRealtimeService _realtimeService = Get.find<PlayerRealtimeService>();

  final Rxn<GetEventListResponseModel> event = Rxn<GetEventListResponseModel>();
  // final Rxn<FetchSportResponseModel> sport = Rxn<FetchSportResponseModel>();
  // final Rxn<FetchPitchResponseModel> pitch = Rxn<FetchPitchResponseModel>();

  final MultiFormDataManager _multiFormDataManager = MultiFormDataManager();

  StreamSubscription<Map<String, dynamic>>? _eventChangedSub;
  StreamSubscription<String>? _eventDeletedSub;
  Timer? _refreshDebounce;
  int _fetchGeneration = 0;

  @override
  void onInit() {
    super.onInit();
    // Live updates: whenever an admin creates/edits/deletes an event, refresh
    // the list so the Events screen reflects it instantly without navigation.
    _eventChangedSub =
        _realtimeService.eventChangedUpdates.listen((_) => _debouncedRefresh());
    _eventDeletedSub =
        _realtimeService.eventDeletedUpdates.listen((_) => _debouncedRefresh());
  }

  void _debouncedRefresh() {
    _refreshDebounce?.cancel();
    _refreshDebounce = Timer(const Duration(milliseconds: 300), fetchEvent);
  }

  @override
  void onClose() {
    _eventChangedSub?.cancel();
    _eventDeletedSub?.cancel();
    _refreshDebounce?.cancel();
    super.onClose();
  }

  Future<void> fetchEvent() async {
    // Concurrent fetches (screen-open fetch racing a realtime-triggered
    // refresh) can resolve out of order; only apply the response from the
    // most recently issued request so a stale one can't overwrite fresh data.
    final requestId = ++_fetchGeneration;
    final result = await _eventRepo.fetchEvent();
    if (requestId != _fetchGeneration) return;

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
