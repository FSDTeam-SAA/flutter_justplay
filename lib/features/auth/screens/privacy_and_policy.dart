import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

class PrivacyAndPolicy extends StatefulWidget {
  const PrivacyAndPolicy({super.key});

  @override
  State<PrivacyAndPolicy> createState() => _PrivacyAndPolicyState();
}

class _PrivacyAndPolicyState extends State<PrivacyAndPolicy> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 50),
              Text(
                'privacy_policy'.tr,
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 25),
              ),
              SizedBox(height: 30),
              Text(
                'Your privacy is important to us. This Privacy Policy explains how we collect, use, store, and protect your personal information when you use our pitch booking mobile application and related services (the "App").\n\nBy using the App, you agree to the collection and use of information in accordance with this Privacy Policy.\n\n'
                'Last UpdatedThis Privacy Policy was last updated on [DATE].\n'
                'Information We Collect\n We collect only the information necessary to provide and improve our services.\n\n'
                'Personal Information\nWhen you create an account or make a booking, we may collect:\n'
                'First and Last Name – to identify you and manage your bookings\nDate of Birth – to verify age eligibility\nPhone Number – for account creation, login, and verification via one-time password (OTP)\n\nBooking Information\nPitch bookings, dates, times, and related booking details\n'
                'Payments\n'
                'We do not collect or store payment card or banking details. All payments are made directly to pitch or stadium owners, typically in cash, unless otherwise stated in the App.\nHow We Use Your Information We use your information for the following purposes:To create and manage your user account To verify your identity using OTP',

                //     To process, confirm, and manage pitch bookings
                //
                //     To communicate booking confirmations, updates, or cancellations
                //
                //     To send push notifications related to your bookings
                //
                //     To improve the functionality, security, and user experience of the App
                //
                // Push Notifications
                //
                // We may send push notifications to inform you about:
                //
                // Booking confirmations
                //
                // Booking status updates (approved, declined, or canceled)
                //
                // Important reminders related to your bookings
                //
                // You can enable or disable push notifications at any time through your device settings.
                //
                // Data Sharing
                //
                // We respect your privacy and do not sell, rent, or trade your personal information.
                //
                // Your data may be shared only with:
                //
                // Pitch or Stadium Owners/Managers – strictly for the purpose of reviewing, approving, managing, or declining booking requests
                //
                // We do not share your personal data with third parties for marketing or advertising purposes.
              ),
            ],
          ),
        ),
      ),
    );
  }
}
