// import 'package:flutter/material.dart';
// import 'package:flutter_justplay/features/bookings/screens/my_booking_screen.dart';
// import 'package:flutter_justplay/features/events/screens/events_screen.dart';
// import 'package:get/get.dart';
//
// import 'core/constants/assets_const.dart';
// import 'features/home/screens/home_screen.dart';
//
// class NavigationMenu extends StatelessWidget {
//   const NavigationMenu({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.put(NavigationController());
//
//     return Scaffold(
//       //backgroundColor: const Color(0xFFFFF1DB),
//       body: Obx(() => controller.screens[controller.selectedIndex.value]),
//
//       bottomNavigationBar: Obx(() {
//         return Container(
//           padding: const EdgeInsets.only(bottom: 22, top: 14),
//           color: const Color(0xFFDBE000),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: List.generate(controller.items.length, (index) {
//               final item = controller.items[index];
//               final isSelected = controller.selectedIndex.value == index;
//
//               return GestureDetector(
//                 onTap: () => controller.selectedIndex.value = index,
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     // CIRCULAR ICON
//                     AnimatedContainer(
//                       duration: const Duration(milliseconds: 250),
//                       height: 55,
//                       width: 55,
//                       decoration: BoxDecoration(
//                         color: isSelected ? Colors.black : Colors.white,
//                         shape: BoxShape.circle,
//                       ),
//                       child: Center(
//                         child: Image.asset(
//                           isSelected ? item['selectedIcon'] : item['icon'],
//                           height: 26,
//                           width: 26,
//                           fit: BoxFit.contain,
//                         ),
//                       ),
//                     ),
//
//                     const SizedBox(height: 6),
//
//                     // LABEL
//                     Text(
//                       item['label'],
//                       style: TextStyle(
//                         fontSize: 12,
//                         color: Colors.black,
//                         fontWeight: isSelected
//                             ? FontWeight.w600
//                             : FontWeight.w400,
//                       ),
//                     ),
//                   ],
//                 ),
//               );
//             }),
//           ),
//         );
//       }),
//     );
//   }
// }
//
// class NavigationController extends GetxController {
//   final RxInt selectedIndex = 0.obs;
//
//   final List<Map<String, dynamic>> items = [
//     {'icon': Images.home,
//       'selectedIcon': Images.home1,
//       'label': 'Home'},
//     {
//       'icon': Images.appointment1,
//       'selectedIcon': Images.appointment,
//       'label': 'Bookings',
//     },
//     {'icon': Images.event1, 'selectedIcon': Images.event, 'label': 'Events'},
//   ];
//
//   final List<Widget> screens = [
//     const HomeScreen(),
//     MyBookingScreen(),
//     EventsScreen(),
//   ];
// }
