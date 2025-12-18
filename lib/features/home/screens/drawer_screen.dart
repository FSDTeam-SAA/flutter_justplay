// screens/menu_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_justplay/features/bookings/presentation/screens/my_booking_screen.dart';
import 'package:flutter_justplay/features/home/screens/Report_an_issue.dart';
import 'package:flutter_justplay/features/home/screens/change_city_screen.dart';
import 'package:flutter_justplay/features/home/screens/profile_screen.dart';
import 'package:flutter_justplay/features/home/screens/terms_and_conditions_screen.dart';
import 'package:get/get.dart';

import '../../../core/constants/assets_const.dart' hide Icons;
import '../../../core/utils/app_svg.dart';

class MenuScreen extends StatelessWidget {
  final String username;

  const MenuScreen({Key? key, required this.username}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.white,

      // Custom AppBar with yellow background
      appBar: AppBar(
        backgroundColor: const Color(0xFFE0E400), // Tall AppBar to fit everything
        automaticallyImplyLeading: false, // We control leading manually
        flexibleSpace: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Close button
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.black, size: 35),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                // Avatar
                Padding(
                  padding: const EdgeInsets.only(right: 18.0, bottom: 7),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: AppSvg(
                      asset: Images.logo,
                      height: 24,
                      width: 24,
                      color: Colors.black,
                    ),
                  ),
                ),

                GestureDetector(
                  onTap: (){Get.to(() => ProfileEditScreen());},
                  child: Padding(
                    padding: const EdgeInsets.only(right: 18.0, bottom: 7),
                    child: AppSvg(
                      asset: Images.profile,
                      height: 24,
                      width: 24,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),

      // Body with scrollable menu items
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 32),
            Text('Hello (username)', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),),
            SizedBox(height: 32,),

            _menuItem("Bookings", () {
              Get.to(() => MyBookingScreen());
              // Navigate to bookings
            }),
            _menuItem("Change City", () {
              Get.to(() => ChangeCityScreen());
            }),
            _menuItem("Terms & Conditions", () {
              Get.to(() => TermsAndConditionsScreen());
            }),
            _menuItem("Report an Issue", () {
              Get.to(() => ReportAnIssue());
            }),

            const Spacer(),

            // Log Out Button
            Padding(
              padding: const EdgeInsets.only(bottom: 50),
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  // Handle logout
                },
                child: Container(
                  height: 92,
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 22),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(color: Colors.black, width: 1),
                  ),
                  child: const Center(
                    child: Text(
                      "Log Out",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _menuItem(String title, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 92,
          padding: const EdgeInsets.symmetric(vertical: 25),
          decoration: BoxDecoration(
            color: const Color(0xFFEFF198),
            borderRadius: BorderRadius.circular(50),
          ),
          child: Center(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }
}