// screens/change_city_screen.dart
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/common/widgets/app_scaffold.dart';
import '../../home/controller/home_controller.dart';
import '../controller/change_city_controller.dart';

class ChangeCityScreen extends StatefulWidget {
  const ChangeCityScreen({super.key});

  @override
  State<ChangeCityScreen> createState() => _ChangeCityScreenState();
}

class _ChangeCityScreenState extends State<ChangeCityScreen> {
  final HomeController _homeController = Get.find<HomeController>();
  final ChangeCityController _changeCityController = Get.put(ChangeCityController());

  @override
  void initState() {
    super.initState();
    // Fetch cities as soon as the screen is opened
    // Assuming your HomeController has a method to fetch cities
    _homeController.fetchCity(); // <-- Add this method in HomeController
  }

  Widget _cityContainer({
    required String imageUrl,
    required String cityName,
    required ChangeCityController controller,
  }) {
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
            child: Stack(
              fit: StackFit.expand,
              children: [
                CachedNetworkImage(
                  imageUrl: imageUrl,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(color: Color(0xFFE0E400)),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: Colors.grey[300],
                    child: const Icon(Icons.broken_image, size: 60, color: Colors.grey),
                  ),
                ),
                Center(
                  child: Text(
                    cityName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22.4,
                      fontWeight: FontWeight.bold,
                      shadows: const [
                        Shadow(
                          offset: Offset(2, 2),
                          blurRadius: 8,
                          color: Colors.black87,
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(
        // title:  Text('change_city'.tr),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Obx(() {
            final cityData = _homeController.cities.value;
            final cityList = cityData?.cities ?? [];

            // Show loading if currently fetching
            if (_homeController.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            if (cityList.isEmpty) {
              return  Center(
                child: Text(
                  'no_cities_available'.tr,
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              );
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 100), // Space for button
              child: Column(
                children: [
                  const SizedBox(height: 20),
                   Text(
                    'change_city'.tr,
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 30),
                  ...cityList.map((city) {
                    return Column(
                      children: [
                        _cityContainer(
                          imageUrl: city.image.url,
                          cityName: city.name,
                          controller: _changeCityController,
                        ),
                        const SizedBox(height: 13),
                      ],
                    );
                  }),
                  const SizedBox(height: 20),
                ],
              ),
            );
          }),

          // Confirm Button
          // Confirm Button
          Positioned(
            bottom: 30,
            left: 16,
            right: 16,
            child: Obx(() {
              final selectedCityName = _changeCityController.selectedCity.value;
              final isCitySelected = selectedCityName.isNotEmpty; // or != null if you initialize as RxString('')

              return ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  disabledBackgroundColor: const Color(0x99242331),
                  foregroundColor: Colors.white,
                  disabledForegroundColor: Colors.white.withOpacity(0.6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  minimumSize: const Size(double.infinity, 56),
                ),
                onPressed: isCitySelected && !_homeController.isLoading.value
                    ? () {
                  // Pass the specific selected city name
                  _homeController.changeCity(selectedCityName);
                  // Optionally pop the screen after change or on success
                  // Get.back();
                }
                    : null,
                child: _homeController.isLoading.value
                    ? const SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2.5,
                  ),
                )
                    :  Text(
                  "confirm_change".tr,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}