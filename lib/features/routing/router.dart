import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter_justplay/features/home/screens/home_screen.dart';
import 'package:flutter_justplay/features/home/screens/select_city_screen.dart';
import 'package:flutter_justplay/features/home/screens/booking_screen.dart'; // If you have more steps later
import 'package:flutter_justplay/features/bookings/screens/my_booking_screen.dart';
import 'package:flutter_justplay/features/events/screens/events_screen.dart';

import '../auth/screens/create_account_screen.dart';
import 'navigation_menu_shell.dart';

final GoRouter router = GoRouter(
  initialLocation: '/home',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return NavigationMenuShell(navigationShell: navigationShell);
      },
      branches: [
        // Branch 0: Home Tab + Nested Booking Flow
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/create-account',
              name: 'create-account',
              builder: (context, state) => const CreateAccountScreen(),
            ),
// Add login, onboarding, etc. here too
            GoRoute(
              path: '/home',
              name: 'home',
              builder: (context, state) => const HomeScreen(),
              routes: [
                // 1. Select City Screen (keeps bottom bar)
                GoRoute(
                  path: 'city',
                  name: 'select-city',
                  builder: (context, state) => const BookingScreen(),
                ),

                // 2. You can add more nested steps here later
                // Example: After city → choose sport → pitches → time
                GoRoute(
                  path: 'booking',
                  name: 'booking-flow',
                  builder: (context, state) => const BookingScreen(),
                ),

                // Add more if needed:
                // path: 'sport',
                // path: 'pitches',
                // path: 'time-date',
                // path: 'confirm',
              ],
            ),
          ],
        ),

        // Branch 1: Bookings Tab
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/bookings',
              name: 'bookings',
              builder: (context, state) => const MyBookingScreen(),
            ),
          ],
        ),

        // Branch 2: Events Tab
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/events',
              name: 'events',
              builder: (context, state) => const EventsScreen(),
            ),
          ],
        ),
      ],
    ),
  ],
);