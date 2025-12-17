import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/assets_const.dart';

class NavigationMenuShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const NavigationMenuShell({
    super.key,
    required this.navigationShell,
  });

  @override
  Widget build(BuildContext context) {
    // Get real index
    final int rawIndex = navigationShell.currentIndex;

    // Only highlight if index is 0, 1, or 2 (Home, Bookings, Events)
    // If index == 3 (utility), we show NO selection
    final int displayIndex = rawIndex < 3 ? rawIndex : -1; // -1 means no tab selected

    final List<Map<String, dynamic>> items = [
      {
        'icon': Images.home,
        'selectedIcon': Images.home1,
        'label': 'Home',
      },
      {
        'icon': Images.appointment1,
        'selectedIcon': Images.appointment,
        'label': 'Bookings',
      },
      {
        'icon': Images.event1,
        'selectedIcon': Images.event,
        'label': 'Events',
      },
    ];

    return Scaffold(
      body: navigationShell,

      bottomNavigationBar: Container(
        padding: const EdgeInsets.only(bottom: 22, top: 14),
        color: const Color(0xFFDBE000),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(items.length, (index) {
            final item = items[index];
            final bool isSelected = displayIndex == index; // Only true for 0,1,2

            return GestureDetector(
              onTap: () {
                // Always go to real branch 0,1,2 when user taps
                navigationShell.goBranch(
                  index,
                  initialLocation: rawIndex == index,
                );
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    height: 55,
                    width: 55,
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.black : Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Image.asset(
                        isSelected ? item['selectedIcon'] : item['icon'],
                        height: 26,
                        width: 26,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item['label'],
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}