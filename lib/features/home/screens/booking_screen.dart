import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/common/widgets/app_scaffold.dart';
import '../../../../core/common/widgets/button_widgets.dart';
 // PitchesResponse & Pitch
import '../controller/home_controller.dart';
import '../models/response/fetch_city_response_model.dart';
import '../models/response/fetch_pitch_response_model.dart';
import '../models/response/fetch_sport_response_model.dart';
import 'booking_confirmed_screen.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final HomeController homeController = Get.find<HomeController>();

  _submit() {
    if (selectedDate.value == null || selectedTimeSlot.value == null) return;

    final formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate.value!);
    final cleanedTimeSlot = selectedTimeSlot.value!.replaceAll('\n', ' ').trim();

    homeController.createBooking(
      selectedCity.value!.id,
      selectedSport.value!.id,
      selectedPitch.value!.id,
      formattedDate,
      cleanedTimeSlot,
      selectedPitch.value!.price,
      selectedPitch.value!.currency,
    );
  }

  // Local reactive selections
  var selectedCity = Rxn<City>();
  var selectedSport = Rxn<Sport>();
  var selectedPitch = Rxn<Pitch>();
  var selectedDate = Rxn<DateTime>();
  var selectedTimeSlot = Rxn<String>();

  var currentStep = 0.obs; // 0: City, 1: Sport, 2: Pitch, 3: Time
  var isReviewMode = false.obs;

  final List<String> timeSlots = [
    '8:00\n am', '9:00\n am', '10:00\n am', '11:00\n am', '12:00\n pm',
    '1:00\n pm', '2:00\n pm', '3:00\n pm', '4:00\n pm', '5:00\n pm',
    '6:00\n pm', '7:00\n pm', '8:00\n pm', '9:00\n pm', '10:00\n pm',
  ];

  final Set<String> bookedSlots = {'12:00 pm', '3:00 pm', '7:00 pm'};

  List<DateTime> get dateOptions {
    final today = DateTime.now();
    return List.generate(7, (i) => today.add(Duration(days: i)));
  }

  @override
  void initState() {
    super.initState();
    // Fetch cities when screen opens
    if (homeController.cities.value == null) {
      homeController.fetchCity();
    }
  }

  Widget _buildPill({
    required String text,
    required bool isSelected,
    required VoidCallback? onTap,
    bool isBooked = false,
    bool isDatePill = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: isDatePill ? 95 : 125,
        height: 75,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFE0E400) : Colors.white,
          borderRadius: BorderRadius.circular(50),
          border: Border.all(color: const Color(0xFFE0E400), width: 1),
        ),
        child: Center(
          child: isDatePill
              ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: text.split('\n').map((line) => Text(
              line,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.3,
                fontWeight: FontWeight.w700,
                color: isBooked ? Colors.grey[600] : Colors.black,
              ),
            )).toList(),
          )
              : Text(
            text,
            style: TextStyle(
              fontSize: 14.3,
              fontWeight: FontWeight.w600,
              color: isBooked ? Colors.grey[600] : Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      removePadding: true,
      appBar: AppBar(),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 10),

            // Progress Tabs
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Obx(() {
                String getTabText(int index) {
                  switch (index) {
                    case 0:
                      return selectedCity.value?.name ?? 'City';
                    case 1:
                      return selectedSport.value?.name ?? 'Sport';
                    case 2:
                      return selectedPitch.value?.name ?? 'Pitch';
                    case 3:
                      if (selectedDate.value != null && selectedTimeSlot.value != null) {
                        return '${DateFormat('d MMM').format(selectedDate.value!)} • ${selectedTimeSlot.value!.replaceAll('\n', ' ').trim()}';
                      }
                      return 'Time & Date';
                    default:
                      return '';
                  }
                }

                return Row(
                  children: List.generate(4, (i) {
                    final isActive = currentStep.value >= i;
                    final isCurrent = currentStep.value == i;
                    return Expanded(
                      child: GestureDetector(
                        onTap: currentStep.value >= i ? () => currentStep.value = i : null,
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: isActive ? Colors.black : Colors.white,
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(color: const Color(0xFFE0E400), width: isActive ? 0 : 1.5),
                          ),
                          child: Text(
                            getTabText(i),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: isActive ? Colors.white : Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 13.5,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    );
                  }),
                );
              }),
            ),

            // Main Content
            Expanded(
              child: Obx(() {
                final step = currentStep.value;

                // Step 0: Select City
                if (step == 0) {
                  return Column(
                    children: [
                      const SizedBox(height: 20),
                      const Text('Select Your City', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 20),
                      Expanded(
                        child: homeController.isLoading.value
                            ? const Center(child: CircularProgressIndicator())
                            : homeController.cities.value == null || homeController.cities.value!.cities.isEmpty
                            ? const Center(child: Text('No cities available'))
                            : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: homeController.cities.value!.cities.length,
                          itemBuilder: (context, index) {
                            final city = homeController.cities.value!.cities[index];
                            return GestureDetector(
                              onTap: () {
                                selectedCity.value = city;
                                selectedSport.value = null;
                                selectedPitch.value = null;
                                homeController.fetchSport(); // Fetch sports
                                currentStep.value = 1;
                              },
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 20),
                                height: 220,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  border: Border.all(color: const Color(0xFFE0E400), width: 4),
                                  image: DecorationImage(
                                    image: NetworkImage(city.image.url),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    city.name,
                                    style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold, shadows: [
                                      Shadow(color: Colors.black, blurRadius: 10),
                                    ]),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                }

                // Step 1: Select Sport
                if (step == 1) {
                  final sports = homeController.sport.value?.sports ?? [];
                  return Column(
                    children: [
                      const SizedBox(height: 20),
                      const Text('Select Your Sport', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 20),
                      Expanded(
                        child: sports.isEmpty
                            ? const Center(child: Text('No sports available'))
                            : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: sports.length,
                          itemBuilder: (context, index) {
                            final sport = sports[index];
                            return GestureDetector(
                              onTap: () {
                                selectedSport.value = sport;
                                selectedPitch.value = null;
                                homeController.fetchPitch(); // Fetch pitches (add filters later)
                                currentStep.value = 2;
                              },
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 20),
                                height: 220,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  border: Border.all(color: const Color(0xFFE0E400), width: 4),
                                  image: DecorationImage(
                                    image: NetworkImage(sport.image.url),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    sport.name,
                                    style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold, shadows: [
                                      Shadow(color: Colors.black, blurRadius: 10),
                                    ]),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                }

                // Step 2: Select Pitch
                if (step == 2) {
                  final pitches = homeController.pitch.value?.pitches ?? [];
                  return Column(
                    children: [
                      const SizedBox(height: 20),
                      const Text('Select Your Pitch', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 20),
                      Expanded(
                        child: pitches.isEmpty
                            ? const Center(child: Text('No pitches available'))
                            : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: pitches.length,
                          itemBuilder: (context, index) {
                            final pitch = pitches[index];
                            return GestureDetector(
                              onTap: () {
                                selectedPitch.value = pitch;
                                currentStep.value = 3;
                              },
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(50),
                                  border: Border.all(color: const Color(0xFFE0E400), width: 3),
                                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 12, offset: const Offset(0, 6))],
                                ),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(20),
                                      child: Column(
                                        children: [
                                          Text(pitch.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700), textAlign: TextAlign.center),
                                          const SizedBox(height: 12),
                                          Row(
                                            children: [
                                              const Icon(Icons.location_on_outlined),
                                              const SizedBox(width: 8),
                                              Expanded(child: Text(pitch.location)),
                                              Text('${pitch.price} ${pitch.currency}', style: const TextStyle(fontWeight: FontWeight.bold)),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    ClipRRect(
                                      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(42)),
                                      child: Image.network(pitch.image.url, height: 96, width: double.infinity, fit: BoxFit.cover),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                }

                // Step 3: Time & Date
                if (step == 3) {
                  if (isReviewMode.value) {
                    final pitch = selectedPitch.value!;
                    final dateStr = selectedDate.value != null ? DateFormat('EEEE d MMMM').format(selectedDate.value!) : '';
                    final timeStr = selectedTimeSlot.value?.replaceAll('\n', ' ').trim() ?? '';

                    return Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          const Text('Confirm Booking', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700)),
                          const SizedBox(height: 30),
                          Container(
                            decoration: BoxDecoration(border: Border.all(color: const Color(0xFFE0E400), width: 4), borderRadius: BorderRadius.circular(30)),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(26),
                              child: Stack(
                                children: [
                                  Image.network(pitch.image.url, height: 220, width: double.infinity, fit: BoxFit.cover),
                                  Positioned(bottom: 16, left: 16, child: Text(pitch.name, style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold, shadows: [Shadow(blurRadius: 10, color: Colors.black)]))),
                                  Positioned(bottom: 16, right: 16, child: Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: const Color(0xFFE0E400), borderRadius: BorderRadius.circular(30)), child: Text('${pitch.price} ${pitch.currency}', style: const TextStyle(fontWeight: FontWeight.bold)))),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(border: Border.all(color: const Color(0xFFE0E400), width: 4), borderRadius: BorderRadius.circular(50)),
                            child: Text('$dateStr  $timeStr', textAlign: TextAlign.center, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
                          ),
                          const Spacer(),
                          SecondaryButton(
                            text: 'Confirm Booking',
                            onSimplePressed: () {
                              _submit();
                              context.push(
                                '/home/booking_confirm',
                                extra: {
                                  'pitch': selectedPitch.value,
                                  'date': selectedDate.value,
                                  'time': selectedTimeSlot.value,
                                },
                              );
                            },
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    );
                  }

                  // Normal time selection
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(18),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Center(child: Text('Time & Date', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700))),
                            const SizedBox(height: 20),
                            const Text('Select Date', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 10),
                            SizedBox(
                              height: 140,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: dateOptions.length,
                                itemBuilder: (context, i) {
                                  final date = dateOptions[i];
                                  final isSelected = selectedDate.value != null && DateTime(date.year, date.month, date.day) == DateTime(selectedDate.value!.year, selectedDate.value!.month, selectedDate.value!.day);
                                  final label = i == 0 ? 'Today' : DateFormat('EEE').format(date);
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8),
                                    child: _buildPill(text: '$label\n${date.day}', isSelected: isSelected, onTap: () => selectedDate.value = date, isDatePill: true),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 30),
                            const Text('Select Time', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Wrap(
                            spacing: 16,
                            runSpacing: 16,
                            alignment: WrapAlignment.center,
                            children: timeSlots.map((slot) {
                              final clean = slot.replaceAll('\n', ' ').trim();
                              final isBooked = bookedSlots.contains(clean);
                              return _buildPill(
                                text: slot,
                                isSelected: selectedTimeSlot.value == slot,
                                onTap: isBooked ? null : () => selectedTimeSlot.value = slot,
                                isBooked: isBooked,
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      if (selectedDate.value != null && selectedTimeSlot.value != null)
                        Padding(
                          padding: const EdgeInsets.all(18),
                          child: SecondaryButton(text: 'Review Booking', onSimplePressed: () => isReviewMode.value = true),
                        ),
                    ],
                  );
                }

                return const SizedBox();
              }),
            ),
          ],
        ),
      ),
    );
  }
}