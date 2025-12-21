import 'package:flutter/material.dart';
import 'package:flutter_justplay/core/common/widgets/app_scaffold.dart';
import 'package:get/get.dart';

import '../widgets/rounded_button_widget.dart';

class BookingCancelledScreen extends StatelessWidget {
  const BookingCancelledScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 30),

              Text(
                'Your booking has\nbeen cancelled',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 30,
                  color: Color(0xFF000000),
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 16),

              Text(
                'The venue has been notified',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16.5,
                  height: 1.4,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF000000),
                ),
              ),

              const SizedBox(height: 30),

              RoundedButton(
                text: 'Back To Bookings',
                backgroundColor: Color(0xFF242331),
                textColor: Color(0xFFFFFFFF),

                height: 56,
                width: Get.width * 0.8,
                borderRadius: 100,
                onPressed: () => Get.back(),
              ),

              const SizedBox(height: 6.95),

              RoundedButton(
                text: 'Make New Booking',
                backgroundColor: Colors.transparent,
                textColor: Color(0xFF000000),
                borderColor: Color(0xFF000000), // ← border added
                borderWidth: 1,
                height: 56,
                width: Get.width * 0.8,
                borderRadius: 100,
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
