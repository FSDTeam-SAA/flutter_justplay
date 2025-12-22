// import 'package:flutter/material.dart';
// import 'package:flutter_justplay/core/common/widgets/app_scaffold.dart';
// import 'package:get/get.dart';
//
// import '../controller/booking_controller.dart';
// import '../widgets/booking_cards_widget.dart';
// import '../widgets/rounded_button_widget.dart';
// import 'booking_cancel_screen.dart';
//
// class BookingsTwoScreen extends StatefulWidget {
//   @override
//   State<BookingsTwoScreen> createState() => _BookingsTwoScreenState();
// }
//
// class _BookingsTwoScreenState extends State<BookingsTwoScreen> {
//   fi
//
//   @override
//   Widget build(BuildContext context) {
//     return AppScaffold(
//       appBar: AppBar(),
//       body: Column(
//         children: [
//           const SizedBox(height: 32),
//           Padding(
//             padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
//             child: Text(
//               'My Bookings',
//               style: TextStyle(
//                 fontSize: 30,
//                 fontWeight: FontWeight.w700,
//                 color: Color(0xFF000000),
//               ),
//             ),
//           ),
//           Expanded(
//             child: Obx(() {
//               // ← THIS LINE FORCES Obx TO REBUILD WHEN selectedIndex CHANGES
//               bookingController.selectedIndex.value;
//
//               if (bookingController.bookings.isEmpty) {
//                 return Center(
//                   child: Text(
//                     'No bookings yet',
//                     style: TextStyle(fontSize: 18, color: Colors.grey[700]),
//                   ),
//                 );
//               }
//
//               return ListView.builder(
//                 padding: EdgeInsets.only(top: 16, bottom: 180),
//                 itemCount: bookingController.bookings.length,
//                 itemBuilder: (context, index) {
//                   final booking = bookingController.bookings[index];
//                   final bool isSelected =
//                       bookingController.selectedIndex.value == index;
//
//                   return BookingCard(
//                     key: ValueKey(index), // ← Keep this (good practice)
//                     date: booking['date'],
//                     time: booking['time'],
//                     pitch: booking['pitch'],
//                     isSelected: isSelected,
//                     onTap: () {
//                       if (bookingController.selectedIndex.value == index) {
//                         bookingController.selectedIndex.value = -1;
//                       } else {
//                         bookingController.selectedIndex.value = index;
//                       }
//                     },
//                   );
//                 },
//               );
//             }),
//           ),
//         ],
//       ),
//       floatingActionButton: Obx(() {
//         final bool hasBookings = bookingController.bookings.isNotEmpty;
//         final bool hasSelection = bookingController.selectedIndex.value != -1;
//
//         if (!hasBookings) return const SizedBox();
//
//         return Padding(
//           padding: const EdgeInsets.only(bottom: 80),
//           child: RoundedButton(
//             text: 'Cancel Booking',
//             onPressed: hasSelection
//                 ? () {
//                     final int index = bookingController.selectedIndex.value;
//                     bookingController.cancelBooking(index);
//                     bookingController.selectedIndex.value = -1;
//                     Get.to(() => const BookingCancelledScreen());
//                   }
//                 : null,
//             // disabled if nothing selected
//             backgroundColor: hasSelection
//                 ? Colors.black
//                 : const Color(0xFFB3B2B2), // gray when no selection
//             textColor: Colors.white,
//             height: 61,
//             width: MediaQuery.of(context).size.width * 0.9,
//             borderRadius: 91.27,
//           ),
//         );
//       }),
//     );
//   }
// }
