import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'core/init/app_initializer.dart';
import 'core/theme/app_theme.dart';
import 'features/routing/router.dart';
// Your GoRouter file

void main() async {
  await AppInitializer.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Just Play',
      theme: AppTheme.light,

      // Pass the GoRouter parts individually
      routeInformationProvider: router.routeInformationProvider,
      routeInformationParser: router.routeInformationParser,
      routerDelegate: router.routerDelegate,

      // Optional: back button dispatcher for proper Android back handling
      backButtonDispatcher: router.backButtonDispatcher,
    );
  }
}