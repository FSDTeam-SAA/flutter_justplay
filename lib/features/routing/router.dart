import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter_justplay/features/home/screens/home_screen.dart';
import 'package:flutter_justplay/features/home/screens/booking_screen.dart';
import 'package:flutter_justplay/features/bookings/screens/my_booking_screen.dart';
import 'package:flutter_justplay/features/events/screens/events_screen.dart';

import 'package:flutter_justplay/features/auth/screens/create_account_screen.dart';
import 'package:flutter_justplay/features/auth/screens/login_screen.dart'; // You'll need to create this
import 'navigation_menu_shell.dart';

final GoRouter router = GoRouter(
  navigatorKey: Get.key,
  initialLocation: '/create-account',

  // Optional: Add redirect logic later for authenticated users
  // redirect: (context, state) {
  //   final isLoggedIn = AuthController.instance.isLoggedIn;
  //   if (isLoggedIn && state.uri.toString().startsWith('/create-account') || state.uri.toString() == '/login') {
  //     return '/home';
  //   }
  //   return null;
  // },

  routes: [
    // Full-screen auth routes (NO bottom navigation)
    GoRoute(
      path: '/create-account',
      name: 'create-account',
      builder: (context, state) => const CreateAccountScreen(),
      routes: [
        GoRoute(
          path: 'login', // So you can navigate to /create-account/login
          name: 'login',
          builder: (context, state) => const LoginScreen(),
        ),
      ],
    ),

    // Authenticated shell with bottom navigation
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return NavigationMenuShell(navigationShell: navigationShell);
      },
      branches: [
        // Branch 0: Home + Nested Booking Flow
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/home',
              name: 'home',
              builder: (context, state) => const HomeScreen(),
              routes: [
                GoRoute(
                  path: 'booking',
                  name: 'booking-flow',
                  builder: (context, state) => const BookingScreen(),
                  // Add more nested routes later: sport, pitches, time, etc.
                ),
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