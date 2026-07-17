import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/common/widgets/app_cached_image.dart';
import '../../../../core/common/widgets/app_scaffold.dart';
import '../../../../core/common/widgets/button_widgets.dart';
import '../models/response/fetch_pitch_response_model.dart'; // For Pitch model

class BookingConfirmedScreen extends StatefulWidget {
  const BookingConfirmedScreen({super.key});

  @override
  State<BookingConfirmedScreen> createState() => _BookingConfirmedScreenState();
}

class _BookingConfirmedScreenState extends State<BookingConfirmedScreen> {
  final selectedPitch = Rxn<Pitch>();
  final selectedDate = Rxn<DateTime>();
  final selectedTimeSlot = Rxn<String>();
  final bookingStatus = Rxn<String>();
  final bookingRefId = Rxn<String>();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Safely retrieve extra data from GoRouter
    final extra = GoRouterState.of(context).extra as Map<String, dynamic>?;

    if (extra != null && selectedPitch.value == null) {
      // Only set once
      selectedPitch.value = extra['pitch'.tr] as Pitch?;
      selectedDate.value = extra['date'.tr] as DateTime?;
      selectedTimeSlot.value = extra['time'.tr] as String?;
      bookingStatus.value = extra['status'] as String?;
      bookingRefId.value = extra['bookingId'] as String?;
    }
  }

  void _resetAndNavigate(BuildContext context) {
    selectedPitch.value = null;
    selectedDate.value = null;
    selectedTimeSlot.value = null;
    context.push('/home/booking');
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      removePadding: true,
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Obx(() {
            final pitch = selectedPitch.value;
            final date = selectedDate.value;
            final timeSlot = selectedTimeSlot.value;

            if (pitch == null || date == null || timeSlot == null) {
              return Center(child: Text('booking_details_not_found'.tr));
            }

            final formattedDate = DateFormat('EEEE d MMMM').format(date);
            final timeDisplay = timeSlot.replaceAll('\n', ' ').trim();
            final isPending = (bookingStatus.value ?? '').toLowerCase() == 'pending';

            return Column(
              children: [
                Text(
                  isPending ? 'booking_pending_confirmation'.tr : 'booking_confirmed'.tr,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: isPending ? 24 : 30, fontWeight: FontWeight.w700),
                ),
                if (bookingRefId.value != null && bookingRefId.value!.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    bookingRefId.value!,
                    style: const TextStyle(fontSize: 13, color: Colors.grey, fontWeight: FontWeight.w600),
                  ),
                ],
                const SizedBox(height: 5),
                Text(
                  'please_pay_venue_on_arrival'.tr,
                  style: TextStyle(
                    fontSize: 16.5,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 25),

                // Pitch Image Card with Yellow Border
                Container(
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
                          left: 20,
                          child: Text(
                            pitch.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22.4,
                              fontWeight: FontWeight.bold,
                              shadows: [
                                Shadow(color: Colors.black, blurRadius: 10),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 16,
                          right: 20,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE0E400),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Text(
                              '${pitch.price} ${pitch.currency}',
                              style: const TextStyle(
                                fontSize: 16.12,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // Date & Time Pill
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(
                      color: const Color(0xFFE0E400),
                      width: 4,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      '$formattedDate  $timeDisplay',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),

                const Spacer(),

                // Make Another Booking Button
                SizedBox(
                  width: double.infinity,
                  height: 70,
                  child: ElevatedButton(
                    onPressed: () => _resetAndNavigate(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1E1E1E),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(35),
                      ),
                    ),
                    child: Text(
                      'make_another_booking'.tr,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),
              ],
            );
          }),
        ),
      ),
    );
  }
}