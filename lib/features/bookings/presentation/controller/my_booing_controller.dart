// // features/bookings/presentation/controller/my_bookings_ui_controller.dart
//
// import 'package:get/get.dart';
//
// class MyBookingsUIController extends GetxController {
//   // Tracks which booking is selected for cancellation (-1 = none)
//   final RxInt selectedIndex = (-1).obs;
//
//   // Toggle selection
//   void toggleSelection(int index) {
//     if (selectedIndex.value == index) {
//       selectedIndex.value = -1; // Deselect if tapped again
//     } else {
//       selectedIndex.value = index;
//     }
//   }
//
//   // Clear selection (e.g., after cancel)
//   void clearSelection() {
//     selectedIndex.value = -1;
//   }
//
//   // Check if any booking is selected
//   bool get hasSelection => selectedIndex.value != -1;
//
//   @override
//   void onClose() {
//     selectedIndex.close();
//     super.onClose();
//   }
// }