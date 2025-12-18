import 'package:get/get.dart';

class MyBookingsController extends GetxController {
  // later connect API
  var bookings = [].obs;
     var selectedIndex = (-1).obs;

  @override
  void onInit() {
    super.onInit();
    // Mock data (replace with API call later)
    loadBookings();
  }


  void selectBooking(int index) {
    selectedIndex.value = index;
  }

  void loadBookings() {
    bookings.assignAll([
      {'date': '18.01.25', 'time': '13:00', 'pitch': 'Duhok Pitch 1'},
      {'date': '18.01.25', 'time': '13:00', 'pitch': 'Duhok Pitch 1'},
      {'date': '18.01.25', 'time': '13:00', 'pitch': 'Duhok Pitch 1'},
      {'date': '18.01.25', 'time': '13:00', 'pitch': 'Duhok Pitch 1'},
    ]);
  }

  void cancelBooking(int index) {
    bookings.removeAt(index);
  }
  void newBooking() {
    // TODO: Navigate to new booking screen
  }
}
