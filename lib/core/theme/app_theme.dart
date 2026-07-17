import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

class AppTheme {
  static ThemeData get light => ThemeData(
    scaffoldBackgroundColor: AppColors.primaryBG,
    primaryColor: AppColors.primaryButtonDeep,
    colorScheme: ColorScheme.light(primary: AppColors.primaryButtonDeep),

    textTheme: TextTheme(
      displayLarge: TextStyle(fontFamily: 'Ligconsolata', fontWeight: FontWeight.w700, color: AppColors.primaryBlack),
      displayMedium: TextStyle(fontFamily: 'Ligconsolata', fontWeight: FontWeight.w700, color: AppColors.primaryBlack),
      displaySmall: TextStyle(fontFamily: 'Ligconsolata', fontWeight: FontWeight.w700, color: AppColors.primaryBlack),
      headlineLarge: TextStyle(fontFamily: 'Ligconsolata', fontWeight: FontWeight.w700, color: AppColors.primaryBlack),
      headlineMedium: TextStyle(fontFamily: 'Ligconsolata', fontWeight: FontWeight.w700, color: AppColors.primaryBlack),
      headlineSmall: TextStyle(fontFamily: 'Ligconsolata', fontWeight: FontWeight.w700, color: AppColors.primaryBlack),
      titleLarge: TextStyle(fontFamily: 'Ligconsolata', fontWeight: FontWeight.w700, color: AppColors.primaryBlack),
      titleMedium: TextStyle(fontFamily: 'Ligconsolata', fontWeight: FontWeight.w400, color: AppColors.primaryBlack),
      titleSmall: TextStyle(fontFamily: 'Ligconsolata', fontWeight: FontWeight.w400, color: AppColors.primaryBlack),
      bodyLarge: TextStyle(fontFamily: 'Ligconsolata', fontWeight: FontWeight.w400, color: AppColors.primaryBlack),
      bodyMedium: TextStyle(fontFamily: 'Ligconsolata', fontWeight: FontWeight.w400, color: AppColors.primaryBlack),
      bodySmall: TextStyle(fontFamily: 'Ligconsolata', fontWeight: FontWeight.w400, color: AppColors.primaryBlack),
      labelLarge: TextStyle(fontFamily: 'Ligconsolata', fontWeight: FontWeight.w700, color: AppColors.primaryBlack),
      labelMedium: TextStyle(fontFamily: 'Ligconsolata', fontWeight: FontWeight.w400, color: AppColors.primaryBlack),
      labelSmall: TextStyle(fontFamily: 'Ligconsolata', fontWeight: FontWeight.w400, color: AppColors.primaryBlack),
    ),

    appBarTheme: AppBarThemeData(
      iconTheme: IconThemeData(color: AppColors.appBarIconColor),
      backgroundColor: AppColors.appBarColor,
      titleTextStyle: TextStyle(fontWeight: FontWeight.w700, fontSize: 24),
    ),
  );
}
