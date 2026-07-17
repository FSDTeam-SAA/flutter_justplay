import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/common/widgets/app_cached_image.dart';
import '../../../core/common/widgets/app_scaffold.dart';
import '../models/response/get_event_list_response_model.dart';

class EventDetailScreen extends StatelessWidget {
  final Event event;

  const EventDetailScreen({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('MMMM d, yyyy').format(event.date);

    return AppScaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 26),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                event.name,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
              ),
            ),
            SizedBox(height: 26),
            // Event Image
            AppCachedImage(
              imageUrl: event.image.url,
              width: double.infinity,
              height: 300,
              fit: BoxFit.cover,
              icon: Icons.image_outlined,
              iconColor: Colors.grey.shade400,
              borderRadius: BorderRadius.circular(10),
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 30),
                Row(
                  children: [
                    Text(
                      event.name,
                      style: const TextStyle(
                        fontSize: 22.4,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Text(
                      formattedDate,
                      style: const TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                    SizedBox(width: 12),
                    Text(
                      '${event.time} ',
                      style: const TextStyle(fontSize: 18),
                    ),
                  ],
                ),

                const SizedBox(height: 5),
                Text(event.location),

                //
                // const SizedBox(height: 8),
                const SizedBox(height: 38),
                //Description - if you add one to the model later
                Text(
                  event.description,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
