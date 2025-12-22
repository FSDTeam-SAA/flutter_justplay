import 'dart:developer' as DPrint;
import 'package:flutter/material.dart';
import 'package:flutter_justplay/features/bookings/presentation/models/response/get_all_booking_response_model.dart';
import 'package:flutter_justplay/features/bookings/presentation/repositories/booking_repo.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/base/base_controller.dart';
import '../../../../core/network/services/auth_storage_service.dart';
import '../../../../core/network/services/multiple_form_data_manager.dart';

class BookingController extends BaseController {
  final BookingRepo _bookingRepo = Get.find<BookingRepo>();

  final Rx<Booking?> selectedBooking = Rxn<Booking?>();

  // Optional: clear selection after cancel
  void clearSelection() {
    selectedBooking.value = null;
  }

  @override
  void onClose() {
    selectedBooking.value = null;
    super.onClose();
  }

  final Rxn<GetAllBookingResponseModel> bookingResponse = Rxn<GetAllBookingResponseModel>();


  // Observable to track if a cancellation is in progress
  final RxBool isCancelling = false.obs;

  // Get the current list of bookings (reactive)
  List<Booking> get bookings => bookingResponse.value?.bookings ?? [];

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
        final currentBookings = bookings;
        currentBookings.removeWhere((b) => b.id == bookingId);

        // Update the reactive value (triggers UI rebuild)
        bookingResponse.value = GetAllBookingResponseModel(bookings: currentBookings);

        DPrint.log('Booking $bookingId cancelled successfully');
        Get.snackbar(
          'Success',
          'Booking cancelled successfully',
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