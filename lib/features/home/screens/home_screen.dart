import 'package:flutter/material.dart';
import 'package:flutter_justplay/core/common/widgets/button_widgets.dart';
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
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(
        
      ),
      body: Column(crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Hello "userName"', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 35),),
        SizedBox(height: 49,),
        Container(height:70,child: SecondaryButton(text: 'Make New Booking',onSimplePressed: (){
          // Navigate to the nested booking flow inside Home tab
          context.push('/home/booking');},)),
        SizedBox(height: 20,),
        Padding(
          padding: const EdgeInsets.only(bottom: 50),
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context);
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
