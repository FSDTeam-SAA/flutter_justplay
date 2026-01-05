import 'package:flutter/material.dart';
import 'package:flutter_justplay/core/common/widgets/button_widgets.dart';
import 'package:flutter_justplay/features/home/controller/profile_controller.dart';
import 'package:flutter_justplay/features/home/screens/booking_screen.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../../core/common/widgets/app_scaffold.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ProfileController _profileController =Get.find<ProfileController>();


  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(
      ),
      body: Column(crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Obx(() {
          final userInfo = _profileController.userInfo.value;
          final userName = userInfo?.user.name;
          return Text(
            'Hello $userName',
            style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
          );
        }),
        SizedBox(height: 49,),
        Container(height:70,child: SecondaryButton(text: 'Make New Booking',onSimplePressed: (){
          // Navigate to the nested booking flow inside Home tab
          context.push('/home/booking');},)),
        SizedBox(height: 20,),
        Padding(
          padding: const EdgeInsets.only(bottom: 50),
          child: GestureDetector(
            onTap: () {
             context.push('/bookings');
              // Handle logout
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 22),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(32),
                border: Border.all(color: Colors.black, width: 1),
              ),
              child: const Center(
                child: Text(
                  "Your Bookings",
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    ),
    );
  }
}
