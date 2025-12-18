
import 'package:flutter/material.dart';
import 'package:flutter_justplay/core/common/widgets/app_scaffold.dart';
import 'package:flutter_justplay/features/bookings/presentation/screens/bookings_two_screen.dart';
import 'package:get/get.dart';

import '../controller/booking_controller.dart';

class MyBookingScreen extends StatefulWidget {
  const MyBookingScreen({super.key});

  @override
  State<MyBookingScreen> createState() => _MyBookingScreenState();
}

class _MyBookingScreenState extends State<MyBookingScreen> {
  final controller = Get.put(MyBookingsController());

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      backgroundColor: Colors.grey.shade100,

      appBar: AppBar(),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'My Bookings',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 30,
                color: Color(0xFF000000),
              ),
            ),
            const SizedBox(height: 18),
            Obx(() {
              if (controller.bookings.isEmpty) {
                return const Text(
                  'You have no bookings',
                  style: TextStyle(
                    fontSize: 16.5,
                    color: Color(0xFF000000),
                    fontWeight: FontWeight.w700,
                  ),
                );
              }
              return Text('${controller.bookings.length} bookings found');
            }),
            const SizedBox(height: 31),
            Container(
              width: double.infinity,
              height: 61,
              child: ElevatedButton(
                onPressed: () {
                  Get.to(() => BookingsTwoScreen());
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE0E400),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(97.27),
                  ),
                ),
                child: const Text(
                  'New Booking',
                  style: TextStyle(
                    fontSize: 16.5,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF000000),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget navIcon(IconData icon, String label, bool active, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: active ? 22 : 20,
            backgroundColor: active ? Colors.black : Colors.white,
            child: Icon(
              icon,
              size: 22,
              color: active ? Colors.white : Colors.black,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: active ? FontWeight.bold : FontWeight.normal,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
