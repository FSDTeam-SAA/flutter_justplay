import 'package:flutter/material.dart';

import '../../../core/common/widgets/app_scaffold.dart';
import '../../../core/common/widgets/button_widgets.dart';

class ReportAnIssue extends StatefulWidget {
  const ReportAnIssue({super.key});

  @override
  State<ReportAnIssue> createState() => _ReportAnIssueState();
}

class _ReportAnIssueState extends State<ReportAnIssue> {
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(child: Text('Report an Issue', textAlign:TextAlign.center, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 30),)),
          SizedBox(height: 6,),
          Text('Please state the issue below', style: TextStyle(fontSize: 16.5, ),),
          SizedBox(height: 12,),
          TextField(
            maxLines: 10, // optional: good for reporting an issue
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

          Container(height: 61, child: SecondaryButton(text: 'Submit',))
        ],
      ),
    );
  }
}
