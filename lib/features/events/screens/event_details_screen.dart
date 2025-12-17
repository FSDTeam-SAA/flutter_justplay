import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/common/widgets/app_scaffold.dart';
import '../models/response/get_event_list_response_model.dart';


class EventDetailScreen extends StatelessWidget {
  final Event event;

  const EventDetailScreen({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('MMMM d, yyyy').format(event.date);

    return AppScaffold(
      appBar: AppBar(
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 26,),
            Text('Event Page Template', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),),
            SizedBox(height: 26,),
            // Event Image
            // Replace the existing Container for the image with this:
            Container(
              width: double.infinity,
              height: 300,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10), // Adjust this value: 32 = very rounded, 150+ = almost circle
              ),
              clipBehavior: Clip.hardEdge, // Important: clips the image to the border radius
              child: Image.network(
                event.image.url,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const Center(child: CircularProgressIndicator());
                },
                errorBuilder: (context, error, stackTrace) {
                  return const Center(
                    child: Icon(Icons.error, color: Colors.red, size: 50),
                  );
                },
              ),
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // SizedBox(height: 30,),
                // Text(
                //   event.name,
                //   style: const TextStyle(fontSize: 22.4, fontWeight: FontWeight.bold),
                // ),
                // const SizedBox(height: 16),
                // Text(
                //   formattedDate,
                //   style: const TextStyle(fontSize: 24, color: Colors.grey),
                // ),
                // const SizedBox(height: 8),
                // Text(
                //   '${event.time} • ${event.location}',
                //   style: const TextStyle(fontSize: 20),
                // ),
                // const SizedBox(height: 8),
                // Text(
                //   '${event.sport?.name} in ${event.city?.name}',
                //   style: const TextStyle(fontSize: 18, color: Colors.blue),
                // ),
                const SizedBox(height: 38),
                //Description - if you add one to the model later
                Text(event.description, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}