import 'package:flutter/material.dart';
import 'package:flutter_justplay/core/common/widgets/app_scaffold.dart';
import 'package:flutter_justplay/core/common/widgets/button_widgets.dart';
import 'package:flutter_justplay/features/bookings/presentation/controller/booking_controller.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'booking_cancel_screen.dart';

class MyBookingScreen extends StatefulWidget {
  const MyBookingScreen({super.key});

  @override
  State<MyBookingScreen> createState() => _MyBookingScreenState();
}

class _MyBookingScreenState extends State<MyBookingScreen> {
  String formatBookingDate(DateTime date) {
    return DateFormat('dd.MM.yy').format(date.toLocal());
  }

  String formatBookingTime(String time) {
    // If backend sends "8:00", make it "08:00"
    final parts = time.split(':');
    final hour = parts[0].padLeft(2, '0');
    final minute = parts.length > 1 ? parts[1].padLeft(2, '0') : '00';
    return '$hour:$minute';
  }

  final BookingController controller = Get.find<BookingController>();

  @override
  void initState() {
    super.initState();
    controller.fetchBooking();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          final bookings = controller.bookings;
          final hasBookings = bookings.isNotEmpty;
          final selectedBooking = controller.selectedBooking.value;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              SizedBox(height: 40,),

              Expanded(
                child: hasBookings
                    ? ListView.builder(
                  //padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: bookings.length,
                  itemBuilder: (context, index) {
                    final booking = bookings[index];
                    final isSelected = selectedBooking?.id == booking.id;

                    return GestureDetector(
                      onTap: () {
                        if (isSelected) {
                          controller.selectedBooking.value = null;
                        } else {
                          controller.selectedBooking.value = booking;
                        }
                      },
                      child: Container(
                        height: 92,
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 18),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFFE0E400)
                              : const Color(0xFFEAEC91),
                          borderRadius: BorderRadius.circular(91.27),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${formatBookingDate(booking.date)} | ${formatBookingTime(booking.timeSlot)}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              booking.pitch.name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                )
                    : Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                       Text(
                        'you_have_no_bookings'.tr,
                        style: TextStyle(fontSize: 18, color: Colors.black),
                      ),
                      const SizedBox(height: 30),
                      PrimaryButton(
                        text: 'new_booking'.tr,
                        onSimplePressed: () {
                          context.go('/home/booking');
                        },
                      ),
                    ],
                  ),
                ),
              ),

              if (hasBookings)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: selectedBooking == null
                          ? null
                          : () async {
                        final bookingId = selectedBooking.id;

                        final success = await controller.cancelBooking(
                          bookingId,
                          context,
                        );

                        if (success) {
                          controller.clearSelection();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                        selectedBooking == null ? Colors.grey : Colors.black,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: controller.isCancelling.value
                          ? const CircularProgressIndicator(color: Colors.white)
                          :  Text(
                        'cancel_booking'.tr,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          );
        }),
      ),
    );

  }
}
