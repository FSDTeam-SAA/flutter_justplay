// controllers/change_city_controller.dart
import 'package:get/get.dart';

class ChangeCityController extends GetxController {
  // Reactive selected city (null means nothing selected)
  var selectedCity = Rxn<String>(); // Rxn<String> allows nullability + reactivity

  void selectCity(String cityName) {
    selectedCity.value = cityName;
  }

  void confirmAndClose() {
    if (selectedCity.value != null) {
      Get.back(result: selectedCity.value);
    }
  }

  void clear() {
    selectedCity.value = null;
  }
}