import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_justplay/core/common/widgets/app_scaffold.dart';

// ------------------- GetX Controller -------------------
class BookingController extends GetxController {
  // Reactive variables
  var selectedTabIndex = 0.obs; // 0: City, 1: Sport, 2: Pitch, 3: Time & Date
  var selectedCity = Rxn<String>();
  var selectedSport = Rxn<String>();
  var selectedPitch = Rxn<String>();

  // Mock data
  final Map<String, List<String>> citySports = {
    'Duhok': ['Football', 'Tennis', 'Padel'],
    'Erbil': ['Football', 'Basketball'],
    'Zaxho': ['Football'],
  };

  final Map<String, Map<String, List<Map<String, String>>>> sportPitches = {
    'Duhok': {
      'Football': [
        {'name': 'Pitch Name 1', 'location': 'Location....', 'price': '40000 Iqd'},
        {'name': 'Pitch Name 2', 'location': 'Location....', 'price': '45000 Iqd'},
        {'name': 'Pitch Name 3', 'location': 'Location....', 'price': '45000 Iqd'},
        {'name': 'Pitch Name 4', 'location': 'Location....', 'price': '45000 Iqd'},
      ],
      'Tennis': [
        {'name': 'Tennis Court A', 'location': 'Central Park', 'price': '30000 Iqd'},
      ],
      'Padel': [
        {'name': 'Padel Arena', 'location': 'Downtown', 'price': '50000 Iqd'},
      ],
    },
    'Erbil': {
      'Football': [
        {'name': 'Erbil Stadium', 'location': 'Main Road', 'price': '60000 Iqd'},
      ],
    },
  };

  final List<String> cities = ['Duhok', 'Erbil', 'Zaxho', 'Duhok', 'Erbil', 'Zaxho'];
  final List<String> tabTitles = ['City', 'Sport', 'Pitch', 'Time & Date'];

  // Helper: Check if tab is enabled
  bool isTabEnabled(int index) {
    if (index == 0) return true;
    if (index == 1) return selectedCity.value != null;
    if (index == 2) return selectedSport.value != null;
    if (index == 3) return selectedPitch.value != null;
    return false;
  }

  // Actions
  void selectCity(String city) {
    selectedCity.value = city;
    selectedSport.value = null;
    selectedPitch.value = null;
    selectedTabIndex.value = 1;
  }

  void selectSport(String sport) {
    selectedSport.value = sport;
    selectedPitch.value = null;
    selectedTabIndex.value = 2;
  }

  void selectPitch(String pitchName) {
    selectedPitch.value = pitchName;
    selectedTabIndex.value = 3;
  }

  void goToTab(int index) {
    if (isTabEnabled(index)) {
      selectedTabIndex.value = index;
    }
  }
}

// ------------------- UI Screen -------------------
class BookingScreen extends StatelessWidget {
  const BookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize controller (Get.put creates it once)
    final BookingController controller = Get.put(BookingController());

    Widget buildContent() {
      return Obx(() {
        final index = controller.selectedTabIndex.value;

        // Tab 0: City
        if (index == 0) {
          return Column(
            children: [
              const SizedBox(height: 18.66),
              const Text(
                'Select Your City',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: controller.cities.length,
                  itemBuilder: (context, i) {
                    final city = controller.cities[i];
                    return GestureDetector(
                      onTap: () => controller.selectCity(city),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        height: 220,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: const Color(0xFFE0E400), width: 4),
                          image: DecorationImage(
                            image: NetworkImage('https://picsum.photos/400/220?random=${i + 1}'),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            city,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              shadows: [Shadow(color: Colors.black, blurRadius: 10)],
                            ),
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

        // Tab 1: Sport
        if (index == 1) {
          final sports = controller.citySports[controller.selectedCity.value] ?? [];
          if (sports.isEmpty) {
            return const Center(
              child: Text('No sports available in this city', style: TextStyle(fontSize: 20, color: Colors.grey)),
            );
          }

          return Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(20),
                child: Text('Select Your Sport', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: sports.length,
                  itemBuilder: (context, i) {
                    final sport = sports[i];
                    return GestureDetector(
                      onTap: () => controller.selectSport(sport),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        height: 220,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: const Color(0xFFE0E400), width: 4),
                          image: DecorationImage(
                            image: NetworkImage('https://picsum.photos/200/200?random=${sport.hashCode}'),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            sport,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              shadows: [Shadow(color: Colors.black, blurRadius: 10)],
                            ),
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

        // Tab 2: Pitch
        if (index == 2) {
          final pitches = controller.sportPitches[controller.selectedCity.value]?[controller.selectedSport.value] ?? [];
          if (pitches.isEmpty) {
            return const Center(
              child: Text('No pitches available', style: TextStyle(fontSize: 20, color: Colors.grey)),
            );
          }

          return Column(
            children: [
              const SizedBox(height: 18.66),
              const Text('Select Your Pitch', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 15),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: pitches.length,
                  itemBuilder: (context, i) {
                    final pitch = pitches[i];
                    return GestureDetector(
                      onTap: () => controller.selectPitch(pitch['name']!),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 13),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(color: const Color(0xFFE0E400), width: 3),
                          boxShadow: [
                            BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 12, offset: const Offset(0, 6)),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 9.0, vertical: 8),
                          child: Column(
                            children: [
                              // Top: Name, Location, Price
                              Padding(
                                padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      pitch['name']!,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.black),
                                    ),
                                    const SizedBox(height: 12),
                                    Row(
                                      children: [
                                        const Icon(Icons.location_on_outlined, size: 20, color: Colors.black),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            pitch['location']!,
                                            style: const TextStyle(fontSize: 16, color: Colors.black),
                                          ),
                                        ),
                                        Text(
                                          pitch['price']!,
                                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.black),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),

                              // Bottom: Image
                              SizedBox(
                                height: 96,
                                width: double.infinity,
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10),
                                    bottomLeft: Radius.circular(42),
                                    bottomRight: Radius.circular(42),
                                  ),
                                  child: Image.network(
                                    'https://picsum.photos/400/250?random=${i + 200}',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ],
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

        // Tab 3: Time & Date
        if (index == 3) {
          return const Center(
            child: Text(
              'Time & Date Selection Coming Soon!\n(You can implement calendar + time slots here)',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20),
            ),
          );
        }

        return const SizedBox();
      });
    }

    return AppScaffold(
      removePadding: true,
      appBar: AppBar(),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 10.66),
            // Top Tabs
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Obx(() => Row(
                children: List.generate(controller.tabTitles.length, (i) {
                  final isSelected = controller.selectedTabIndex.value == i;
                  final isEnabled = controller.isTabEnabled(i);

                  return Expanded(
                    child: GestureDetector(
                      onTap: isEnabled ? () => controller.goToTab(i) : null,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 7),
                          decoration: BoxDecoration(
                            color: isSelected ? Colors.black : Colors.white,
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Text(
                            controller.tabTitles[i],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: isSelected ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              )),
            ),

            // Content
            Expanded(child: buildContent()),
          ],
        ),
      ),
    );
  }
}