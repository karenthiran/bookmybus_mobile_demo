import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTextTheme {
  AppTextTheme._();

  static const String _fontFamily = 'Poppins';

  static TextTheme textTheme = const TextTheme(
    headlineLarge: TextStyle(
      fontFamily: _fontFamily,
      fontSize: 32,
      fontWeight: FontWeight.bold,
      color: AppColors.textPrimary,
    ),

    headlineMedium: TextStyle(
      fontFamily: _fontFamily,
      fontSize: 26,
      fontWeight: FontWeight.bold,
      color: AppColors.textPrimary,
    ),

    titleLarge: TextStyle(
      fontFamily: _fontFamily,
      fontSize: 20,
      fontWeight: FontWeight.w700,
      color: AppColors.textPrimary,
    ),

    titleMedium: TextStyle(
      fontFamily: _fontFamily,
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: AppColors.textPrimary,
    ),

    bodyLarge: TextStyle(
      fontFamily: _fontFamily,
      fontSize: 16,
      color: AppColors.textPrimary,
    ),

    bodyMedium: TextStyle(
      fontFamily: _fontFamily,
      fontSize: 14,
      color: AppColors.textSecondary,
    ),

    labelLarge: TextStyle(
      fontFamily: _fontFamily,
      fontSize: 14,
      fontWeight: FontWeight.w600,
    ),
  );
}