import 'package:flutter/cupertino.dart';
import 'package:flutter_justplay/features/auth/screens/create_account_screen.dart';
import 'package:get/get.dart';

import 'core/init/app_initializer.dart';
import 'core/theme/app_theme.dart';

void main() async {
  await AppInitializer.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Just Play',
      theme: AppTheme.light,
      home: CreateAccountScreen(),
    );
  }
}
