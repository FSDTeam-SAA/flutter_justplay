import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'core/init/app_initializer.dart';
import 'core/localization/translations.dart';
import 'core/theme/app_theme.dart';
import 'features/routing/router.dart';
// Your GoRouter file

void main() async {
  await AppInitializer.initializeApp();
  await GetStorage.init();
    await initializeDateFormatting();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  Locale _getSavedLocale() {
    final box = GetStorage();
    final langCode = box.read('language_code') ?? 'en';
    final countryCode = box.read('country_code') ;

    return Locale(langCode, countryCode);
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp.router(
      debugShowCheckedModeBanner: false,
      
      title: 'Just Play',
      theme: AppTheme.light,

      translations: AppTranslations(),
      locale: _getSavedLocale(),
      // locale: const Locale('en', 'US'), // Default locale
      fallbackLocale: const Locale('en' ), // Fallback locale

      // Pass the GoRouter parts individually
      routeInformationProvider: router.routeInformationProvider,
      routeInformationParser: router.routeInformationParser,
      routerDelegate: router.routerDelegate,

      // Optional: back button dispatcher for proper Android back handling
      backButtonDispatcher: router.backButtonDispatcher,
    );
  }
}