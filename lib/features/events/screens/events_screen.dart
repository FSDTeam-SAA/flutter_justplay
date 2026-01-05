import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../core/common/widgets/app_scaffold.dart';
import '../controller/event_controller.dart';
import '../models/response/get_event_list_response_model.dart';
import 'event_details_screen.dart';

class EventsScreen extends StatelessWidget {
  const EventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final EventController controller = Get.find<EventController>();

    // Fetch events when screen is opened
    controller.fetchEvent();

    return AppScaffold(
      appBar: AppBar(),
      body: Obx(() {
        // Loading state
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        // No events
        final eventResponse = controller.event.value;
        if (eventResponse == null || eventResponse.events.isEmpty) {
          return const _ComingSoonView();
        }

        // Has events → show title + list
        return const _EventsContentView();
      }),
    );
  }
}

class _ComingSoonView extends StatelessWidget {
  const _ComingSoonView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'coming_soon'.tr,
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16),
          Text(
            'No events available at the moment.',
            style: TextStyle(fontSize: 18, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// New widget to hold title + grid
class _EventsContentView extends StatelessWidget {
  const _EventsContentView();

  @override
  Widget build(BuildContext context) {
    final EventController controller = Get.find<EventController>();
    final events = controller.event.value!.events;
    final int count = events.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: 29),
        // Title/Header
        Text(
          'events'.tr,
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          events.length == 1
              ? 'events_available'.trParams({
                  'count': events.length.toString(),
                })
              : 'events_available_plural'.trParams({
                  'count': events.length.toString(),
                }),
          style: const TextStyle(fontSize: 18, color: Colors.black),
        ),

        // Text(
        //   '${events.length} event${events.length == 1 ? '' : 's'} available',
        //   style: const TextStyle(fontSize: 18, color: Colors.black),
        // ),
        const SizedBox(height: 24),

        // Events Grid
        Expanded(
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
              childAspectRatio: 3 / 1.2,
              mainAxisSpacing: 24,
              crossAxisSpacing: 16,
            ),
            itemCount: events.length,
            itemBuilder: (context, index) {
              final event = events[index];
              return _EventCard(event: event);
            },
          ),
        ),
      ],
    );
  }
}

class _EventCard extends StatelessWidget {
  final Event event;

  const _EventCard({required this.event});

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('MMMM d, yyyy').format(event.date);

    return GestureDetector(
      onTap: () {
        Get.to(() => EventDetailScreen(event: event));
      },
      child: Container(
        height: 173,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.grey[400],
          border: Border.all(color: Color(0xFFE0E400), width: 4),
          borderRadius: BorderRadius.circular(50),
          image: DecorationImage(
            image: NetworkImage(event.image.url),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              event.name,
              style: const TextStyle(
                fontSize: 22.4,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: [
                  Shadow(
                    offset: Offset(2, 2),
                    blurRadius: 4,
                    color: Colors.black54,
                  ),
                  Shadow(
                    offset: Offset(-1, -1),
                    blurRadius: 4,
                    color: Colors.black45,
                  ),
                ],
              ),
              textAlign: TextAlign.center,
              maxLines: 1, // Force single line
              overflow: TextOverflow.ellipsis, // Add ellipsis for overflow
            ),
            const SizedBox(height: 12),
            Text(
              formattedDate,
              style: const TextStyle(
                fontSize: 20,
                color: Colors.white,
                shadows: [
                  Shadow(
                    offset: Offset(2, 2),
                    blurRadius: 4,
                    color: Colors.black54,
                  ),
                  Shadow(
                    offset: Offset(-1, -1),
                    blurRadius: 4,
                    color: Colors.black45,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            // Text(
            //   '${event.sport?.name ?? 'Sport'} • ${event.city?.name ?? 'Location'}',
            //   style: const TextStyle(fontSize: 16, color: Colors.white70),
            // ),
            // if (event.time.isNotEmpty) ...[
            //   const SizedBox(height: 8),
            //   Text(
            //     event.time,
            //     style: const TextStyle(fontSize: 16, color: Colors.white70),
            //   ),
            // ],
          ],
        ),
      ),
    );
  }
}
