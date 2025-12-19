// controllers/change_city_controller.dart
import 'package:get/get.dart';

class ChangeCityController extends GetxController {
  // Only track the selected city name (or id if you prefer)
  var selectedCity = ''.obs; // or RxString()

  void selectCity(String cityName) {
    selectedCity.value = cityName;
  }

  void confirmAndClose() {
    Get.back(result: selectedCity.value);
    }


}