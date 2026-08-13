import 'dart:async';
import 'dart:developer' as DPrint;

import 'package:flutter_justplay/features/home/controller/profile_controller.dart';
import 'package:flutter_justplay/features/home/models/request/issue_request_model.dart';
import 'package:flutter_justplay/features/home/models/request/reserve_booking_request_model.dart';
import 'package:flutter_justplay/features/home/models/response/availability_response_model.dart';
import 'package:flutter_justplay/features/home/models/response/booking%20_response_model.dart'
    as booking_model;
import 'package:flutter_justplay/features/home/models/response/fetch_city_response_model.dart';
import 'package:flutter_justplay/features/home/models/response/fetch_pitch_response_model.dart';
import 'package:flutter_justplay/features/home/models/response/fetch_sport_response_model.dart';
import 'package:flutter_justplay/features/home/models/response/public_settings_response_model.dart';
import 'package:flutter_justplay/features/home/repositories/home_repo.dart';
import 'package:flutter_justplay/features/home/repositories/profile_repo.dart';
import 'package:flutter_justplay/features/home/screens/drawer_screen.dart';
import 'package:get/get.dart';
import '../../../../core/base/base_controller.dart';
import '../../../core/network/services/auth_storage_service.dart';
import '../../../core/network/services/multiple_form_data_manager.dart';
import '../../../core/realtime/player_realtime_service.dart';
import '../../bookings/presentation/controller/booking_controller.dart';

class HomeController extends BaseController {
  final HomeRepo _homeRepo = Get.find<HomeRepo>();
  final ProfileRepository _profileRepository = Get.find<ProfileRepository>();
  final AuthStorageService _authStorageService = AuthStorageService();
  final ProfileController _profileController = Get.find<ProfileController>();
  final PlayerRealtimeService _realtimeService =
      Get.find<PlayerRealtimeService>();

  final Rxn<FetchCityResponseModel> cities = Rxn<FetchCityResponseModel>();
  final Rxn<FetchSportResponseModel> sport = Rxn<FetchSportResponseModel>();
  final Rxn<FetchPitchResponseModel> pitch = Rxn<FetchPitchResponseModel>();
  final Rxn<PublicSettingsResponseModel> publicSettings =
      Rxn<PublicSettingsResponseModel>();

  final MultiFormDataManager _multiFormDataManager = MultiFormDataManager();

  StreamSubscription<Map<String, dynamic>>? _cityChangedSub;
  StreamSubscription<String>? _cityDeletedSub;
  Timer? _cityRefreshDebounce;
  int _cityFetchGeneration = 0;

  StreamSubscription<Map<String, dynamic>>? _sportChangedSub;
  StreamSubscription<String>? _sportDeletedSub;
  Timer? _sportRefreshDebounce;
  int _sportFetchGeneration = 0;

  @override
  void onInit() {
    super.onInit();
    // Live updates: whenever an admin creates/edits/deletes a country, refresh
    // the list so city pickers reflect it instantly without navigation.
    _cityChangedSub = _realtimeService.cityChangedUpdates.listen(
      (_) => _debouncedCityRefresh(),
    );
    _cityDeletedSub = _realtimeService.cityDeletedUpdates.listen(
      (_) => _debouncedCityRefresh(),
    );

    // Same for sports.
    _sportChangedSub = _realtimeService.sportChangedUpdates.listen(
      (_) => _debouncedSportRefresh(),
    );
    _sportDeletedSub = _realtimeService.sportDeletedUpdates.listen(
      (_) => _debouncedSportRefresh(),
    );
  }

  void _debouncedCityRefresh() {
    _cityRefreshDebounce?.cancel();
    _cityRefreshDebounce = Timer(const Duration(milliseconds: 300), fetchCity);
  }

  void _debouncedSportRefresh() {
    _sportRefreshDebounce?.cancel();
    _sportRefreshDebounce = Timer(
      const Duration(milliseconds: 300),
      fetchSport,
    );
  }

  @override
  void onClose() {
    _cityChangedSub?.cancel();
    _cityDeletedSub?.cancel();
    _cityRefreshDebounce?.cancel();
    _sportChangedSub?.cancel();
    _sportDeletedSub?.cancel();
    _sportRefreshDebounce?.cancel();
    super.onClose();
  }

  Future<void> fetchCity() async {
    // Concurrent fetches (screen-open fetch racing a realtime-triggered
    // refresh) can resolve out of order; only apply the response from the
    // most recently issued request so a stale one can't overwrite fresh data.
    final requestId = ++_cityFetchGeneration;
    final result = await _homeRepo.fetchCity();
    if (requestId != _cityFetchGeneration) return;

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
    // Concurrent fetches (screen-open fetch racing a realtime-triggered
    // refresh) can resolve out of order; only apply the response from the
    // most recently issued request so a stale one can't overwrite fresh data.
    final requestId = ++_sportFetchGeneration;
    try {
      final result = await _homeRepo.fetchSport(); // No parameters needed
      if (requestId != _sportFetchGeneration) return;

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
      if (requestId != _sportFetchGeneration) return;
      Get.snackbar('Error', 'Failed to load sports');
      sport.value = null;
    } finally {
      isLoading.value = false;
    }
  }

  // Fetch pitches, filtered by the selected city/sport plus optional
  // price/distance/availability filters.
  Future<void> fetchPitch({
    String? cityId,
    String? sportId,
    double? minPrice,
    double? maxPrice,
    String? bookingAvailability,
    double? userLat,
    double? userLng,
    double? maxDistanceKm,
  }) async {
    isLoading.value = true;
    try {
      final result = await _homeRepo.fetchPitch(
        cityId: cityId,
        sportId: sportId,
        minPrice: minPrice,
        maxPrice: maxPrice,
        bookingAvailability: bookingAvailability,
        userLat: userLat,
        userLng: userLng,
        maxDistanceKm: maxDistanceKm,
      );

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

  /// Fetches the platform-wide business rules (cancellation window, hold
  /// duration, etc.) so the booking flow can reflect them without hardcoding.
  Future<PublicSettingsResponseModel?> fetchPublicSettings() async {
    final result = await _homeRepo.getPublicSettings();
    return result.fold(
      (fail) {
        DPrint.log('Public settings fetch failed: ${fail.message}');
        return null;
      },
      (success) {
        publicSettings.value = success.data;
        return success.data;
      },
    );
  }

  /// Fetches which slots are already reserved/booked for a pitch on a date,
  /// plus the pitch's live opening-hours/closed-dates/availability state.
  Future<AvailabilityResponseModel?> fetchAvailability({
    required String pitchId,
    required String date,
  }) async {
    final result = await _homeRepo.getAvailability(
      pitchId: pitchId,
      date: date,
    );
    return result.fold((fail) {
      setError(fail.message);
      return null;
    }, (success) => success.data);
  }

  Future<bool> issue(
    String title,
    String description, [
    String? bookingId,
  ]) async {
    final request = IssueRequestModel(
      title: title,
      description: description,
      bookingId: bookingId,
    );

    final result = await _homeRepo.issue(request);

    //DPrint.log("Login Response ${result.isRight()}");

    return result.fold(
      (fail) {
        setError(fail.message);
        Get.snackbar('error'.tr, 'failed_to_submit_issue'.tr);
        return false;
      },
      (success) {
        Get.snackbar('success'.tr, 'issue_submitted_successfully'.tr);
        return true;
      },
    );
  }

  /// Step 1 of the booking flow: temporarily holds the slot (default 5
  /// minutes, configurable server-side) so no other player can take it
  /// while this player finishes confirming. Returns the reserved booking
  /// (with `reservationExpiresAt`) on success, or null on failure.
  Future<booking_model.Booking?> reserveSlot({
    required String cityId,
    required String sportId,
    required String pitchId,
    required String date,
    required String timeSlot,
    required int price,
    required String currency,
  }) async {
    final request = ReserveBookingRequestModel(
      cityId: cityId,
      sportId: sportId,
      pitchId: pitchId,
      date: date,
      timeSlot: timeSlot,
      price: price,
      currency: currency,
    );

    final result = await _homeRepo.reserveBooking(request);

    return result.fold((fail) {
      setError(fail.message);
      Get.snackbar('Error', fail.message);
      return null;
    }, (success) => success.data.booking);
  }

  /// Step 2: turns a held reservation into a real "Pending" booking. Fails
  /// with a clear message if the 5-minute hold already expired.
  Future<booking_model.Booking?> confirmReservation(
    String reservationId,
  ) async {
    final result = await _homeRepo.confirmReservedBooking(reservationId);

    return result.fold(
      (fail) {
        setError(fail.message);
        Get.snackbar('Error', fail.message);
        return null;
      },
      (success) {
        // Critical: Refresh the bookings list immediately so "My Bookings"
        // reflects the new booking without a manual refresh.
        if (Get.isRegistered<BookingController>()) {
          Get.find<BookingController>().fetchBooking();
        }
        return success.data.booking;
      },
    );
  }

  /// [navigateToMenu] is true for the drawer's dedicated "Change City"
  /// screen, which should land back on the menu after confirming. Pass
  /// false when persisting a first-time pick from mid-flow (e.g. the
  /// booking wizard's city step) so the user isn't yanked out of it.
  Future<void> changeCity(String city, {bool navigateToMenu = true}) async {
    _multiFormDataManager.addTextData("city", city);
    //_multiFormDataManager.addTextData("id", id);

    final formRequest = await _multiFormDataManager.toFormDataAsync();

    final result = await _profileRepository.updatePersonalInfo(formRequest);

    result.fold(
      (fail) {
        DPrint.log('Personal info: ${fail.message}');
      },
      (success) async {
        DPrint.log('Personal info: ${success.message}');
        await _profileController.fetchProfile(); // Update profile with new city
        if (navigateToMenu) Get.to(() => MenuScreen());
        _multiFormDataManager.clear();
      },
    );
  }
}
