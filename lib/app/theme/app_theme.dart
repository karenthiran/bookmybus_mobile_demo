import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_text_theme.dart';

class AppTheme {
  AppTheme._();

  static ThemeData light = ThemeData(
    useMaterial3: true,
    fontFamily: 'Poppins',

    scaffoldBackgroundColor: AppColors.scaffold,

    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      primary: AppColors.primary,
      error: AppColors.error,
      brightness: Brightness.light,
    ),

    textTheme: AppTextTheme.textTheme,

    cardColor: AppColors.card,

    dividerColor: AppColors.divider,

    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      elevation: 0,
    ),
  );
}