// screens/change_city_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_justplay/core/constants/assets_const.dart';
import '../../../core/common/widgets/app_scaffold.dart';
import '../controller/change_city_controller.dart';

class ChangeCityScreen extends StatelessWidget {
  const ChangeCityScreen({super.key});

  // Reuse city container with GetX reactivity
  Widget _cityContainer(
    String asset,
    String cityName,
    ChangeCityController controller,
  ) {
    return Obx(
      () => GestureDetector(
        onTap: () => controller.selectCity(cityName),
        child: Container(
          height: 173,
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(
              color: const Color(0xFFE0E400),
              width: controller.selectedCity.value == cityName ? 6 : 4,
            ),
            borderRadius: BorderRadius.circular(50),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: Image.asset(
              asset,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Initialize controller (Get.put creates singleton)
    final ChangeCityController controller = Get.put(ChangeCityController());

    return AppScaffold(
      appBar: AppBar(),
      body: Stack(
        children: [
          // Scrollable list of cities
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Change City',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 20),

                _cityContainer(Images.duhok, "Duhok", controller),
                const SizedBox(height: 13),
                _cityContainer(Images.erbil, "Erbil", controller),
                const SizedBox(height: 13),
                _cityContainer(Images.zaxho, "Zaxho", controller),
                const SizedBox(height: 13),
                _cityContainer(Images.zaxho, "Zaxho", controller),
                const SizedBox(height: 13),
                _cityContainer(Images.zaxho, "Zaxho", controller),
                const SizedBox(height: 13),
                _cityContainer(Images.zaxho, "Zaxho", controller),
                const SizedBox(height: 80), // extra space
              ],
            ),
          ),

          // Confirm Button at bottom
          // Confirm Button at bottom
          Positioned(
            bottom: 30,
            left: 0, // better than 0 for safe area on some devices
            right: 0,
            child: Obx(
              () => ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  // enabled state
                  disabledBackgroundColor: const Color(0x99242331),
                  // #242331 at 60% opacity
                  foregroundColor: Colors.white,
                  disabledForegroundColor: Colors.white.withOpacity(0.6),
                  // optional: slightly faded text when disabled
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  minimumSize: const Size(
                    double.infinity,
                    56,
                  ), // ensures full width
                ),
                onPressed: controller.selectedCity.value == null
                    ? null
                    : controller.confirmAndClose,
                child: const Text(
                  "Confirm Change",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
