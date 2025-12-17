import 'package:flutter/material.dart';
import 'package:flutter_justplay/features/home/screens/Report_an_issue.dart';
import 'package:flutter_justplay/features/home/screens/booking_confirmed_screen.dart';
import 'package:flutter_justplay/features/home/screens/change_city_screen.dart';
import 'package:flutter_justplay/features/home/screens/terms_and_conditions_screen.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter_justplay/features/home/screens/home_screen.dart';
import 'package:flutter_justplay/features/home/screens/booking_screen.dart';
import 'package:flutter_justplay/features/bookings/screens/my_booking_screen.dart';
import 'package:flutter_justplay/features/events/screens/events_screen.dart';
import 'package:flutter_justplay/features/auth/screens/create_account_screen.dart';
import 'package:flutter_justplay/features/auth/screens/login_screen.dart';
import 'navigation_menu_shell.dart';

final GoRouter router = GoRouter(
  navigatorKey: Get.key,
  initialLocation: '/create-account',
  routes: [
    // Full-screen auth routes (NO bottom navigation)
    GoRoute(
      path: '/create-account',
      name: 'create-account',
      builder: (context, state) => const CreateAccountScreen(),
      routes: [
        GoRoute(
          path: 'login',
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
        // Branch 0: Home
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
                ),
                GoRoute(
                  path: 'booking_confirm',
                  name: 'booking_confirm',
                  builder: (context, state) => const BookingConfirmedScreen(),
                ),
              ],
            ),
          ],
        ),

        // Branch 1: Bookings
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/bookings',
              name: 'bookings',
              builder: (context, state) => const MyBookingScreen(),
            ),
          ],
        ),

        // Branch 2: Events
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/events',
              name: 'events',
              builder: (context, state) => const EventsScreen(),
            ),
          ],
        ),

        // NEW Branch 3: Utility (no tab selected)
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/utility',
              name: 'utility',
              pageBuilder: (context, state) => const NoTransitionPage(
                child: SizedBox.shrink(), // Empty placeholder
              ),
              routes: [
                GoRoute(
                  path: 'change_city',  // ← change from 'terms' to 'terms_condition'
                  name: 'change_city',
                  builder: (context, state) => const ChangeCityScreen(),
                ),
                GoRoute(
                  path: 'terms_condition',  // ← change from 'terms' to 'terms_condition'
                  name: 'terms_condition',
                  builder: (context, state) => const TermsAndConditionsScreen(),
                ),
                GoRoute(
                  path: 'report_issue',
                  name: 'report_issue',
                  builder: (context, state) => const ReportAnIssue(),
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  ],
);