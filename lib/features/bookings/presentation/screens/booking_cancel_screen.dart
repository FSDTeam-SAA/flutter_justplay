import 'package:flutter/material.dart';
import 'package:flutter_justplay/core/common/widgets/app_scaffold.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:go_router/go_router.dart';

class CancelledScreen extends StatefulWidget {
  const CancelledScreen({super.key});

  @override
  State<CancelledScreen> createState() => _CancelledScreenState();
}

class _CancelledScreenState extends State<CancelledScreen> {
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      // backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
               Text(
                'your_booking_has_been_cancelled'.tr,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),
               Text(
                'the_venue_has_been_notified'.tr,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16.5, color: Colors.black, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 60),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child:  Text(
                    'back_to_bookings'.tr,
                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    context.go('/home/booking');
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.black),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child:  Text(
                    'make_new_booking'.tr,
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                      fontSize: 14
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}