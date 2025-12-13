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
    final int currentIndex = navigationShell.currentIndex;

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
      body: navigationShell, // This shows the current branch (tab) content + nested routes

      bottomNavigationBar: Container(
        padding: const EdgeInsets.only(bottom: 22, top: 14),
        color: const Color(0xFFDBE000),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(items.length, (index) {
            final item = items[index];
            final bool isSelected = currentIndex == index;

            return GestureDetector(
              onTap: () {
                // Switch tab while preserving state
                navigationShell.goBranch(
                  index,
                  // Prevents unnecessary reload if already on this branch
                  initialLocation: navigationShell.currentIndex == index,
                );
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Circular Icon
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
                  // Label
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