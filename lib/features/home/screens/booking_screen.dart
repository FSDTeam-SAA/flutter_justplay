import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/common/widgets/app_cached_image.dart';
import '../../../../core/common/widgets/app_scaffold.dart';
import '../../../../core/common/widgets/button_widgets.dart';
import '../../../../core/realtime/player_realtime_service.dart';
import '../../../../core/services/location_service.dart';
// PitchesResponse & Pitch
import '../controller/home_controller.dart';
import '../models/pitch_filters.dart';
import '../models/response/availability_response_model.dart';
import '../models/response/booking _response_model.dart' as booking_model;
import '../models/response/fetch_city_response_model.dart';
import '../models/response/fetch_pitch_response_model.dart';
import '../models/response/fetch_sport_response_model.dart';
import '../widgets/pitch_filter_sheet.dart';

/// One bookable hour-long slot. `start`/`end` are 24h "HH:mm" strings sent
/// to (and matched against) the backend, which validates them against the
/// pitch's opening hours and the unique pitch+date+timeSlot index.
class _TimeSlotOption {
  final String label; // e.g. "8:00 am" — shown to the user
  final String start; // e.g. "08:00"
  final String end; // e.g. "09:00"

  const _TimeSlotOption({required this.label, required this.start, required this.end});

  String get value => '$start - $end';

  int get startMinutes {
    final parts = start.split(':');
    return int.parse(parts[0]) * 60 + int.parse(parts[1]);
  }

  int get endMinutes {
    final parts = end.split(':');
    return int.parse(parts[0]) * 60 + int.parse(parts[1]);
  }
}

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final HomeController homeController = Get.find<HomeController>();
  final PlayerRealtimeService _realtimeService = Get.find<PlayerRealtimeService>();
  final LocationService _locationService = LocationService();

  StreamSubscription<Map<String, dynamic>>? _pitchChangedSub;
  StreamSubscription<String>? _pitchDeletedSub;
  Timer? _countdownTimer;

  Future<void> _submit() async {
    if (selectedDate.value == null || selectedTimeSlot.value == null) return;

    final formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate.value!);

    isSubmitting.value = true;
    final reserved = await homeController.reserveSlot(
      cityId: selectedCity.value!.id,
      sportId: selectedSport.value!.id,
      pitchId: selectedPitch.value!.id,
      date: formattedDate,
      timeSlot: selectedTimeSlot.value!.value,
      price: selectedPitch.value!.price,
      currency: selectedPitch.value!.currency,
    );
    isSubmitting.value = false;

    if (reserved == null) {
      // Slot may have just been taken by someone else — refresh availability.
      await _loadAvailability();
      return;
    }

    reservedBooking.value = reserved;
    isReviewMode.value = true;
    _startCountdown(reserved.reservationExpiresAt);
  }

  Future<void> _confirmReservation() async {
    final reservation = reservedBooking.value;
    if (reservation == null) return;

    isSubmitting.value = true;
    final confirmed = await homeController.confirmReservation(reservation.id);
    isSubmitting.value = false;

    if (confirmed == null) {
      // Most likely expired — reset back to slot selection.
      Get.snackbar('error'.tr, 'reservation_expired'.tr);
      _resetReservationState();
      await _loadAvailability();
      return;
    }

    _countdownTimer?.cancel();
    if (!mounted) return;
    context.push(
      '/home/booking_confirm',
      extra: {
        'pitch'.tr: selectedPitch.value,
        'date'.tr: selectedDate.value,
        'time'.tr: selectedTimeSlot.value?.label,
        'status': confirmed.status,
        'bookingId': confirmed.bookingId,
      },
    );
  }

  void _startCountdown(DateTime? expiresAt) {
    _countdownTimer?.cancel();
    if (expiresAt == null) return;

    void tick() {
      final remaining = expiresAt.difference(DateTime.now()).inSeconds;
      secondsRemaining.value = remaining > 0 ? remaining : 0;
      if (remaining <= 0) {
        _countdownTimer?.cancel();
        Get.snackbar('error'.tr, 'reservation_expired'.tr);
        _resetReservationState();
        _loadAvailability();
      }
    }

    tick();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) => tick());
  }

  void _resetReservationState() {
    isReviewMode.value = false;
    reservedBooking.value = null;
    secondsRemaining.value = 0;
    selectedTimeSlot.value = null;
  }

  // Local reactive selections
  var selectedCity = Rxn<City>();
  var selectedSport = Rxn<Sport>();
  var selectedPitch = Rxn<Pitch>();
  var selectedDate = Rxn<DateTime>();
  var selectedTimeSlot = Rxn<_TimeSlotOption>();

  var currentStep = 0.obs; // 0: City, 1: Sport, 2: Pitch, 3: Time
  var isReviewMode = false.obs;
  var isSubmitting = false.obs;

  // GPS + filters (pitch step)
  final currentLat = Rxn<double>();
  final currentLng = Rxn<double>();
  final isLocating = false.obs;
  final filters = const PitchFilters().obs;

  // Availability (time step)
  final availability = Rxn<AvailabilityResponseModel>();
  final isLoadingAvailability = false.obs;

  // Reservation hold (review step)
  final reservedBooking = Rxn<booking_model.Booking>();
  final secondsRemaining = 0.obs;

  static const List<_TimeSlotOption> timeSlots = [
    _TimeSlotOption(label: '8:00\n am', start: '08:00', end: '09:00'),
    _TimeSlotOption(label: '9:00\n am', start: '09:00', end: '10:00'),
    _TimeSlotOption(label: '10:00\n am', start: '10:00', end: '11:00'),
    _TimeSlotOption(label: '11:00\n am', start: '11:00', end: '12:00'),
    _TimeSlotOption(label: '12:00\n pm', start: '12:00', end: '13:00'),
    _TimeSlotOption(label: '1:00\n pm', start: '13:00', end: '14:00'),
    _TimeSlotOption(label: '2:00\n pm', start: '14:00', end: '15:00'),
    _TimeSlotOption(label: '3:00\n pm', start: '15:00', end: '16:00'),
    _TimeSlotOption(label: '4:00\n pm', start: '16:00', end: '17:00'),
    _TimeSlotOption(label: '5:00\n pm', start: '17:00', end: '18:00'),
    _TimeSlotOption(label: '6:00\n pm', start: '18:00', end: '19:00'),
    _TimeSlotOption(label: '7:00\n pm', start: '19:00', end: '20:00'),
    _TimeSlotOption(label: '8:00\n pm', start: '20:00', end: '21:00'),
    _TimeSlotOption(label: '9:00\n pm', start: '21:00', end: '22:00'),
    _TimeSlotOption(label: '10:00\n pm', start: '22:00', end: '23:00'),
  ];

  List<DateTime> get dateOptions {
    final today = DateTime.now();
    return List.generate(7, (i) => today.add(Duration(days: i)));
  }

  @override
  void initState() {
    super.initState();
    // Fetch cities when screen opens
    if (homeController.cities.value == null) {
      homeController.fetchCity();
    }
    homeController.fetchPublicSettings();

    // Live updates: if the selected pitch (or any pitch, while browsing the
    // pitch list) changes availability/status in Super Admin or the owner
    // app, refresh so the player never books something that just closed.
    _pitchChangedSub = _realtimeService.pitchChangedUpdates.listen((payload) {
      final changedId = '${payload['_id'] ?? ''}';
      if (currentStep.value == 2) {
        _loadPitches();
      }
      if (changedId.isNotEmpty && changedId == selectedPitch.value?.id) {
        if (selectedDate.value != null) _loadAvailability();
      }
    });
    _pitchDeletedSub = _realtimeService.pitchDeletedUpdates.listen((id) {
      if (currentStep.value == 2) _loadPitches();
      if (id == selectedPitch.value?.id) {
        Get.snackbar('error'.tr, 'no_pitches_available'.tr);
        selectedPitch.value = null;
        currentStep.value = 2;
      }
    });
  }

  @override
  void dispose() {
    _pitchChangedSub?.cancel();
    _pitchDeletedSub?.cancel();
    _countdownTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadPitches() async {
    await homeController.fetchPitch(
      cityId: selectedCity.value?.id,
      sportId: selectedSport.value?.id,
      minPrice: filters.value.minPrice,
      maxPrice: filters.value.maxPrice,
      bookingAvailability: filters.value.onlyAvailable ? 'accepting' : null,
      userLat: currentLat.value,
      userLng: currentLng.value,
      maxDistanceKm: filters.value.maxDistanceKm,
    );
  }

  Future<void> _useMyLocation() async {
    isLocating.value = true;
    final position = await _locationService.getCurrentPosition();
    isLocating.value = false;

    if (position == null) {
      Get.snackbar(
        'error'.tr,
        'Could not get your location. Please check permissions.',
      );
      return;
    }

    currentLat.value = position.latitude;
    currentLng.value = position.longitude;
    await _loadPitches();
  }

  Future<void> _openFilterSheet() async {
    final hasLocation = currentLat.value != null && currentLng.value != null;
    final result = await showModalBottomSheet<PitchFilters>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => PitchFilterSheet(initial: filters.value, hasLocation: hasLocation),
    );

    if (result != null) {
      filters.value = result;
      await _loadPitches();
    }
  }

  Future<void> _loadAvailability() async {
    if (selectedPitch.value == null || selectedDate.value == null) return;
    isLoadingAvailability.value = true;
    final formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate.value!);
    final result = await homeController.fetchAvailability(
      pitchId: selectedPitch.value!.id,
      date: formattedDate,
    );
    availability.value = result;
    isLoadingAvailability.value = false;
  }

  /// Returns why [slot] can't be booked on the selected date, or null if
  /// it's free.
  String? _slotUnavailableReason(_TimeSlotOption slot) {
    final data = availability.value;
    if (data == null) return 'select_date'.tr;

    if (!data.isPitchBookable) return 'pitch_unavailable_now'.tr;

    final dateKey = selectedDate.value != null
        ? DateFormat('yyyy-MM-dd').format(selectedDate.value!)
        : '';
    if (data.closedDates.contains(dateKey)) return 'pitch_closed_today'.tr;

    final jsWeekday = selectedDate.value != null ? selectedDate.value!.weekday % 7 : -1;
    final dayConfig = data.openingHours.where((h) => h.dayOfWeek == jsWeekday);
    if (dayConfig.isEmpty || !dayConfig.first.enabled) {
      return 'pitch_closed'.tr;
    } else {
      final opens = _parseHHmm(dayConfig.first.opensAt);
      final closes = _parseHHmm(dayConfig.first.closesAt);
      if (slot.startMinutes < opens || slot.endMinutes > closes) {
        return 'pitch_closed'.tr;
      }
    }

    final booked = data.bookedSlots.any((b) => b.timeSlot == slot.value);
    if (booked) return 'booking_details_not_found'.tr; // generic "taken" fallback

    return null;
  }

  int _parseHHmm(String value) {
    final parts = value.split(':');
    if (parts.length != 2) return 0;
    return (int.tryParse(parts[0]) ?? 0) * 60 + (int.tryParse(parts[1]) ?? 0);
  }

  Widget _buildPill({
    required String text,
    required bool isSelected,
    required VoidCallback? onTap,
    bool isBooked = false,
    bool isDatePill = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: isDatePill ? 80 : 110,
        height: 60,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFE0E400) : Colors.white,
          borderRadius: BorderRadius.circular(50),
          border: Border.all(color: const Color(0xFFE0E400), width: 1),
        ),
        child: Center(
          child: isDatePill
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: text
                      .split('\n')
                      .map(
                        (line) => Text(
                          line,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14.3,
                            fontWeight: FontWeight.w700,
                            color: isBooked ? Colors.grey[600] : Colors.black,
                          ),
                        ),
                      )
                      .toList(),
                )
              : Text(
                  text,
                  style: TextStyle(
                    fontSize: 14.3,
                    fontWeight: FontWeight.w600,
                    color: isBooked ? Colors.grey[600] : Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      removePadding: true,
      appBar: AppBar(),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 10),

            // Progress Tabs
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Obx(() {
                String getTabText(int index) {
                  switch (index) {
                    case 0:
                      return selectedCity.value?.name ?? 'city'.tr;
                    case 1:
                      return selectedSport.value?.name ?? 'sport'.tr;
                    case 2:
                      return selectedPitch.value?.name ?? 'pitch'.tr;
                    case 3:
                      if (selectedDate.value != null &&
                          selectedTimeSlot.value != null) {
                        return '${DateFormat('d MMM').format(selectedDate.value!)} • ${selectedTimeSlot.value!.label.replaceAll('\n', ' ').trim()}';
                      }
                      return 'time_and_date'.tr;
                    default:
                      return '';
                  }
                }

                return Row(
                  children: List.generate(4, (i) {
                    final isActive = currentStep.value >= i;
                    return Expanded(
                      child: GestureDetector(
                        onTap: currentStep.value >= i
                            ? () => currentStep.value = i
                            : null,
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: isActive ? Colors.black : Colors.white,
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(
                              color: const Color(0xFFE0E400),
                              width: isActive ? 0 : 1.5,
                            ),
                          ),
                          child: Text(
                            getTabText(i),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: isActive ? Colors.white : Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 13.5,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    );
                  }),
                );
              }),
            ),

            // Main Content
            Expanded(
              child: Obx(() {
                final step = currentStep.value;

                // Step 0: Select City
                if (step == 0) {
                  return Column(
                    children: [
                      const SizedBox(height: 20),
                      Text(
                        'select_your_city'.tr,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Expanded(
                        child: homeController.isLoading.value
                            ? const Center(child: CircularProgressIndicator())
                            : homeController.cities.value == null ||
                                  homeController.cities.value!.cities.isEmpty
                            ? Center(child: Text('no_cities_available'.tr))
                            : ListView.builder(
                                padding: const EdgeInsets.all(16),
                                itemCount:
                                    homeController.cities.value!.cities.length,
                                itemBuilder: (context, index) {
                                  final city = homeController
                                      .cities
                                      .value!
                                      .cities[index];
                                  return GestureDetector(
                                    onTap: () {
                                      selectedCity.value = city;
                                      selectedSport.value = null;
                                      selectedPitch.value = null;
                                      homeController
                                          .fetchSport(); // Fetch sports
                                      currentStep.value = 1;
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.only(bottom: 20),
                                      height: 220,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        border: Border.all(
                                          color: const Color(0xFFE0E400),
                                          width: 4,
                                        ),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(26),
                                        child: Stack(
                                          fit: StackFit.expand,
                                          children: [
                                            AppCachedImage(
                                              imageUrl: city.image.url,
                                              fit: BoxFit.cover,
                                              icon: Icons.image_outlined,
                                              iconColor: Colors.grey.shade400,
                                            ),
                                            Center(
                                              child: Text(
                                                city.name,
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 28,
                                                  fontWeight: FontWeight.bold,
                                                  shadows: [
                                                    Shadow(
                                                      color: Colors.black,
                                                      blurRadius: 10,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                      ),
                    ],
                  );
                }

                // Step 1: Select Sport
                if (step == 1) {
                  final sports = homeController.sport.value?.sports ?? [];
                  return Column(
                    children: [
                      const SizedBox(height: 20),
                      Text(
                        'select_your_sport'.tr,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Expanded(
                        child: sports.isEmpty
                            ? Center(child: Text('no_sports_available'.tr))
                            : ListView.builder(
                                padding: const EdgeInsets.all(16),
                                itemCount: sports.length,
                                itemBuilder: (context, index) {
                                  final sport = sports[index];
                                  return GestureDetector(
                                    onTap: () {
                                      selectedSport.value = sport;
                                      selectedPitch.value = null;
                                      currentStep.value = 2;
                                      _loadPitches();
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.only(bottom: 20),
                                      height: 220,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        border: Border.all(
                                          color: const Color(0xFFE0E400),
                                          width: 4,
                                        ),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(26),
                                        child: Stack(
                                          fit: StackFit.expand,
                                          children: [
                                            AppCachedImage(
                                              imageUrl: sport.image.url,
                                              fit: BoxFit.cover,
                                              icon: Icons.image_outlined,
                                              iconColor: Colors.grey.shade400,
                                            ),
                                            Center(
                                              child: Text(
                                                sport.name,
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 28,
                                                  fontWeight: FontWeight.bold,
                                                  shadows: [
                                                    Shadow(
                                                      color: Colors.black,
                                                      blurRadius: 10,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                      ),
                    ],
                  );
                }

                // Step 2: Select Pitch
                if (step == 2) {
                  final pitches = homeController.pitch.value?.pitches ?? [];
                  return Column(
                    children: [
                      const SizedBox(height: 12),
                      Text(
                        'select_your_pitch'.tr,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: isLocating.value ? null : _useMyLocation,
                                icon: isLocating.value
                                    ? const SizedBox(
                                        width: 14,
                                        height: 14,
                                        child: CircularProgressIndicator(strokeWidth: 2),
                                      )
                                    : const Icon(Icons.my_location, size: 18),
                                label: Text(
                                  'use_my_location'.tr,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            OutlinedButton.icon(
                              onPressed: _openFilterSheet,
                              icon: Icon(
                                Icons.filter_list,
                                color: filters.value.isActive
                                    ? const Color(0xFFAEB300)
                                    : null,
                              ),
                              label: Text('filter_pitches'.tr),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Expanded(
                        child: homeController.isLoading.value
                            ? const Center(child: CircularProgressIndicator())
                            : pitches.isEmpty
                            ? Center(child: Text('no_pitches_available'.tr))
                            : ListView.builder(
                                padding: const EdgeInsets.all(16),
                                itemCount: pitches.length,
                                itemBuilder: (context, index) {
                                  final pitch = pitches[index];
                                  final bookable = pitch.isBookable;
                                  return GestureDetector(
                                    onTap: bookable
                                        ? () {
                                            selectedPitch.value = pitch;
                                            selectedDate.value = null;
                                            selectedTimeSlot.value = null;
                                            availability.value = null;
                                            currentStep.value = 3;
                                          }
                                        : null,
                                    child: Opacity(
                                      opacity: bookable ? 1 : 0.5,
                                      child: Container(
                                        margin: const EdgeInsets.only(bottom: 16),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(50),
                                          border: Border.all(
                                            color: const Color(0xFFE0E400),
                                            width: 3,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(0.08),
                                              blurRadius: 12,
                                              offset: const Offset(0, 6),
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.all(20),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.center,
                                                    children: [
                                                      Flexible(
                                                        child: Text(
                                                          pitch.name,
                                                          style: const TextStyle(
                                                            fontSize: 20,
                                                            fontWeight: FontWeight.w700,
                                                          ),
                                                          textAlign: TextAlign.center,
                                                        ),
                                                      ),
                                                      if (!bookable) ...[
                                                        const SizedBox(width: 8),
                                                        Container(
                                                          padding: const EdgeInsets
                                                              .symmetric(
                                                            horizontal: 8,
                                                            vertical: 3,
                                                          ),
                                                          decoration: BoxDecoration(
                                                            color: Colors.red[100],
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                    20),
                                                          ),
                                                          child: Text(
                                                            pitch.status != 'active'
                                                                ? 'pitch_closed'.tr
                                                                : 'not_accepting_bookings'
                                                                    .tr,
                                                            style: TextStyle(
                                                              fontSize: 11,
                                                              color: Colors.red[800],
                                                              fontWeight:
                                                                  FontWeight.w600,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ],
                                                  ),
                                                  const SizedBox(height: 12),
                                                  Row(
                                                    children: [
                                                      const Icon(
                                                        Icons.location_on_outlined,
                                                      ),
                                                      const SizedBox(width: 8),
                                                      Expanded(
                                                        child: Text(pitch.location),
                                                      ),
                                                      if (pitch.distanceKm != null) ...[
                                                        Text(
                                                          'km_away'.trParams({
                                                            'km': pitch.distanceKm!
                                                                .toStringAsFixed(1),
                                                          }),
                                                          style: const TextStyle(
                                                            fontSize: 12,
                                                            color: Colors.grey,
                                                          ),
                                                        ),
                                                        const SizedBox(width: 8),
                                                      ],
                                                      Text(
                                                        '${pitch.price} ${pitch.currency}',
                                                        style: const TextStyle(
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            AppCachedImage(
                                              imageUrl: pitch.image.url,
                                              height: 96,
                                              width: double.infinity,
                                              fit: BoxFit.cover,
                                              icon: Icons.image_outlined,
                                              iconColor: Colors.grey.shade400,
                                              borderRadius: const BorderRadius.vertical(
                                                bottom: Radius.circular(42),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                      ),
                    ],
                  );
                }

                // Step 3: Time & Date
                if (step == 3) {
                  if (isReviewMode.value) {
                    final pitch = selectedPitch.value!;
                    final currentLocale = Get.locale?.languageCode ?? 'en';

                    final dateFormatLocale = currentLocale == 'ku' ? 'ar' : currentLocale;

                    final dateStr = selectedDate.value != null
                        ? DateFormat('EEEE d MMMM', dateFormatLocale)
                            .format(selectedDate.value!)
                        : '';

                    final timeStr =
                        selectedTimeSlot.value?.label.replaceAll('\n', ' ').trim() ?? '';

                    final minutes = secondsRemaining.value ~/ 60;
                    final seconds = secondsRemaining.value % 60;
                    final countdownStr =
                        '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';

                    return Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Text(
                            'confirm_booking'.tr,
                            style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: secondsRemaining.value <= 30
                                  ? Colors.red[50]
                                  : const Color(0xFFFFFDE0),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: secondsRemaining.value <= 30
                                    ? Colors.red
                                    : const Color(0xFFE0E400),
                              ),
                            ),
                            child: Text(
                              'reservation_expires_in'.trParams({'time': countdownStr}),
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: secondsRemaining.value <= 30
                                    ? Colors.red
                                    : Colors.black,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: const Color(0xFFE0E400),
                                width: 4,
                              ),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(26),
                              child: Stack(
                                children: [
                                  AppCachedImage(
                                    imageUrl: pitch.image.url,
                                    height: 220,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    icon: Icons.image_outlined,
                                    iconColor: Colors.grey.shade400,
                                  ),
                                  Positioned(
                                    bottom: 16,
                                    left: 16,
                                    child: Text(
                                      pitch.name,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                        shadows: [
                                          Shadow(blurRadius: 10, color: Colors.black),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 16,
                                    right: 16,
                                    child: Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFE0E400),
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      child: Text(
                                        '${pitch.price} ${pitch.currency}',
                                        style: const TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: const Color(0xFFE0E400),
                                width: 4,
                              ),
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Text(
                              '$dateStr  $timeStr',
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                            ),
                          ),
                          if (homeController.publicSettings.value != null) ...[
                            const SizedBox(height: 12),
                            Text(
                              'cancellation_window_notice'.trParams({
                                'hours': homeController.publicSettings.value!
                                    .cancellationWindowHours
                                    .toStringAsFixed(0),
                              }),
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ],
                          const Spacer(),
                          TextButton(
                            onPressed: isSubmitting.value
                                ? null
                                : () {
                                    _countdownTimer?.cancel();
                                    isReviewMode.value = false;
                                  },
                            child: Text('back_to_bookings'.tr),
                          ),
                          SecondaryButton(
                            text: isSubmitting.value ? '...' : 'confirm_booking'.tr,
                            onSimplePressed: isSubmitting.value ? () {} : _confirmReservation,
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    );
                  }

                  // Normal time selection
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(18),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Text(
                                'time_and_date'.tr,
                                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              'select_date'.tr,
                              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10),
                            SizedBox(
                              height: 140,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: dateOptions.length,
                                itemBuilder: (context, i) {
                                  final date = dateOptions[i];
                                  final currentLocale = Get.locale?.languageCode ?? 'en';
                                  final dateFormatLocale =
                                      currentLocale == 'ku' ? 'ar' : currentLocale;

                                  final isSelected = selectedDate.value != null &&
                                      DateTime(date.year, date.month, date.day) ==
                                          DateTime(
                                            selectedDate.value!.year,
                                            selectedDate.value!.month,
                                            selectedDate.value!.day,
                                          );
                                  final label = i == 0
                                      ? 'today'.tr
                                      : DateFormat('EEE', dateFormatLocale).format(date);

                                  return Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8),
                                    child: _buildPill(
                                      text: '$label\n${date.day}',
                                      isSelected: isSelected,
                                      onTap: () {
                                        selectedDate.value = date;
                                        selectedTimeSlot.value = null;
                                        _loadAvailability();
                                      },
                                      isDatePill: true,
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 30),
                            Text(
                              'select_time'.tr,
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                      if (selectedDate.value == null)
                        Expanded(
                          child: Center(child: Text('select_date'.tr)),
                        )
                      else if (isLoadingAvailability.value)
                        const Expanded(
                          child: Center(child: CircularProgressIndicator()),
                        )
                      else if (availability.value != null && !availability.value!.isPitchBookable)
                        Expanded(
                          child: Center(child: Text('pitch_unavailable_now'.tr)),
                        )
                      else if (availability.value != null &&
                          availability.value!.closedDates.contains(
                            DateFormat('yyyy-MM-dd').format(selectedDate.value!),
                          ))
                        Expanded(
                          child: Center(child: Text('pitch_closed_today'.tr)),
                        )
                      else
                        Expanded(
                          child: SingleChildScrollView(
                            child: Wrap(
                              spacing: 16,
                              runSpacing: 16,
                              alignment: WrapAlignment.center,
                              children: timeSlots.map((slot) {
                                final unavailableReason = _slotUnavailableReason(slot);
                                final isBooked = unavailableReason != null;
                                return _buildPill(
                                  text: slot.label,
                                  isSelected: selectedTimeSlot.value?.value == slot.value,
                                  onTap: isBooked
                                      ? null
                                      : () => selectedTimeSlot.value = slot,
                                  isBooked: isBooked,
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      if (selectedDate.value != null && selectedTimeSlot.value != null)
                        Padding(
                          padding: const EdgeInsets.all(18),
                          child: SecondaryButton(
                            text: isSubmitting.value ? '...' : 'review_booking'.tr,
                            onSimplePressed: isSubmitting.value ? () {} : _submit,
                          ),
                        ),
                    ],
                  );
                }

                return const SizedBox();
              }),
            ),
          ],
        ),
      ),
    );
  }
}
