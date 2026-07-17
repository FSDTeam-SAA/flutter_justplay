import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

class TermsOfService extends StatefulWidget {
  const TermsOfService({super.key});

  @override
  State<TermsOfService> createState() => _TermsOfServiceState();
}

class _TermsOfServiceState extends State<TermsOfService> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
            SizedBox(height: 50,),
              Text('terms_of_service'.tr, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 25),),
          SizedBox(height: 30,),
          Text('We take reasonable technical and organizational measures to protect your personal information against unauthorized access, loss, misuse, or alteration. These measures may include restricted access, secure servers, and encrypted communication where appropriate.\n\n'
              'Please note that no method of electronic storage or transmission is 100% secure, and we cannot guarantee absolute security.\n\n'
              'Data Retention\n We retain your personal information only for as long as necessary to:\n\n'
              'Provide our services\nComply with legal obligations\n'
              'Resolve disputes\n'
              'If you delete your account, we will delete or anonymize your personal data unless we are required to retain it for legal or operational reasons.\n\n'
          
              'Your Rights\n'
              "You have the right to:\n\n"
          
              "Access the personal data we hold about you\n"
          
             " Request correction of inaccurate or incomplete information\n"
          
              "Request deletion of your account and personal data\n"
          
              "To exercise these rights, please contact us using the details below.\n"
          
              "Age Requirements\n\n"
          
             " The App is intended for users who meet the minimum age requirement specified within the App. We do not knowingly collect personal information from individuals below the permitted age.\n\/"
          
              "Changes to This Privacy Policy\n\n"
          
              "We may update this Privacy Policy from time to time. Any changes will be posted within the App, and the Last Updated date will be revised accordingly.\n"
          )
            ],
          ),
        ),
      ),
    );
  }
}
