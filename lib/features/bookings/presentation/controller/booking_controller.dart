import 'dart:async';
import 'dart:developer' as DPrint;
import 'package:flutter/material.dart';
import 'package:flutter_justplay/features/bookings/presentation/models/response/get_all_booking_response_model.dart';
import 'package:flutter_justplay/features/bookings/presentation/repositories/booking_repo.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/base/base_controller.dart';
import '../../../../core/network/services/auth_storage_service.dart';
import '../../../../core/network/services/multiple_form_data_manager.dart';
import '../../../../core/realtime/player_realtime_service.dart';

class BookingController extends BaseController {
  final BookingRepo _bookingRepo = Get.find<BookingRepo>();
  final PlayerRealtimeService _realtimeService = Get.find<PlayerRealtimeService>();

  final Rx<Booking?> selectedBooking = Rxn<Booking?>();

  StreamSubscription<Map<String, dynamic>>? _bookingSub;
  StreamSubscription<Map<String, dynamic>>? _bookingDeletedSub;
  Timer? _refreshDebounce;

  @override
  void onInit() {
    super.onInit();
    // Live updates: whenever a booking is created/updated (by this player,
    // the pitch owner, or an admin) or deleted, refresh the list so "My
    // Bookings" always reflects the latest status without a manual pull.
    _bookingSub = _realtimeService.bookingUpdates.listen((_) => _debouncedRefresh());
    _bookingDeletedSub =
        _realtimeService.bookingDeletedUpdates.listen((_) => _debouncedRefresh());
  }

  void _debouncedRefresh() {
    _refreshDebounce?.cancel();
    _refreshDebounce = Timer(const Duration(milliseconds: 300), fetchBooking);
  }

  // Optional: clear selection after cancel
  void clearSelection() {
    selectedBooking.value = null;
  }

  @override
  void onClose() {
    selectedBooking.value = null;
    _bookingSub?.cancel();
    _bookingDeletedSub?.cancel();
    _refreshDebounce?.cancel();
    super.onClose();
  }

  final Rxn<GetAllBookingResponseModel> bookingResponse =
      Rxn<GetAllBookingResponseModel>();

  // Observable to track if a cancellation is in progress
  final RxBool isCancelling = false.obs;

  // Selected status for filtering
  final RxString selectedStatus = 'pending'.obs;

  // List of all bookings
  List<Booking> get allBookings => bookingResponse.value?.bookings ?? [];

  // Filtered bookings based on selected status
  List<Booking> get bookings {
    final status = selectedStatus.value.toLowerCase();
    return allBookings.where((booking) {
      return booking.status.toLowerCase() == status;
    }).toList();
  }

  void setStatus(String status) {
    selectedStatus.value = status;
    clearSelection();
  }

  /// Fetch all bookings for the current user
  Future<void> fetchBooking() async {
    setLoading(true);
    clearError();

    final result = await _bookingRepo.fetchBooking();

    result.fold(
      (fail) {
        setError(fail.message);
        DPrint.log('Booking fetch failed: ${fail.message}');
      },
      (success) {
        bookingResponse.value = success.data;
        DPrint.log('Bookings loaded: ${bookings.length} bookings');
      },
    );

    setLoading(false);
  }

  /// Cancel a booking by ID and refresh the list on success
  Future<bool> cancelBooking(String bookingId, BuildContext context) async {
    if (isCancelling.value) return false;

    isCancelling.value = true;
    clearError();

    final result = await _bookingRepo.deleteBooking(bookingId);

    result.fold(
      (fail) {
        setError(fail.message);
        DPrint.log('Cancel booking failed: ${fail.message}');
        isCancelling.value = false;
        return false;
      },
      (success) {
        // Remove the cancelled booking from local list
        final currentBookings = List<Booking>.from(allBookings);
        currentBookings.removeWhere((b) => b.id == bookingId);

        // Update the reactive value (triggers UI rebuild)
        bookingResponse.value = GetAllBookingResponseModel(
          bookings: currentBookings,
        );

        DPrint.log('Booking $bookingId cancelled successfully');
        Get.snackbar(
          'success'.tr,
          'booking_cancelled_successfully'.tr,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        clearSelection(); // ✅ reset selection first

        context.go('/bookings/cancel');

        isCancelling.value = false;
        return true;
      },
    );
    return false;
  }
}
