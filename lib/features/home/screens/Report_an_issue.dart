import 'package:flutter/material.dart';
import 'package:flutter_justplay/features/home/controller/home_controller.dart';
import 'package:get/get.dart';

import '../../../core/common/widgets/app_scaffold.dart';
import '../../../core/common/widgets/button_widgets.dart';

class ReportAnIssue extends StatefulWidget {
  const ReportAnIssue({super.key});

  @override
  State<ReportAnIssue> createState() => _ReportAnIssueState();
}

class _ReportAnIssueState extends State<ReportAnIssue> {
  final TextEditingController _issueField = TextEditingController();
  final HomeController _homeController = Get.find<HomeController>();
  
  _submit(){
    _homeController.issue('Issue with pitch booking', _issueField.text.trim(), '693d2eeae915efbcca41447a');
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _issueField.dispose();
  }
  
  
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 13,),
          Center(child: Text('Report an Issue', textAlign:TextAlign.center, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 30),)),
          SizedBox(height: 6,),
          Text('Please state the issue below', style: TextStyle(fontSize: 16.5, ),),
          SizedBox(height: 12,),
          TextFormField(
            controller: _issueField,
            maxLines: 20, // optional: good for reporting an issue
            decoration: InputDecoration(
              hintText: 'Describe your issue...',
              contentPadding: const EdgeInsets.all(16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4), // rectangle shape
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: const BorderSide(color: Colors.grey),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: const BorderSide(color: Colors.black, width: 1.5),
              ),
            ),
          ),
          SizedBox(height: 21,),

          Container(height: 61, child: SecondaryButton(text: 'Submit',onApiPressed: () => _submit(),))
        ],
      ),
    );
  }
}
