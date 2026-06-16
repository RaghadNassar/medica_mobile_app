import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_text_styles.dart';

class AppTheme {
  // ================= LIGHT =================

  static final ThemeData lightTheme = ThemeData.light().copyWith(
    useMaterial3: true,
    primaryColor: AppColors.primaryTeal,
    scaffoldBackgroundColor: AppColors.lightBackground,
    colorScheme: const ColorScheme.light().copyWith(
      primary: AppColors.primaryTeal,
      primaryContainer: AppColors.lightTextSecondary,
      secondary: AppColors.accentOrange,
      secondaryContainer: AppColors.lightBorder,
      surface: AppColors.lightSurface,
    ),
    appBarTheme: const AppBarTheme(
      toolbarHeight: 66,
      backgroundColor: AppColors.lightSurface,
      titleTextStyle: TextStyle(color: AppColors.lightTextPrimary,fontSize: 18,fontWeight: FontWeight.bold),
      elevation: 0,
      iconTheme: IconThemeData(
        color: AppColors.lightTextPrimary,
      ),
    ),
     actionIconTheme: ActionIconThemeData(
      backButtonIconBuilder: (BuildContext context) => const Icon(
        Icons.arrow_back_ios_new, 
        size: 20,
      ),
    ),
    textTheme: AppTextStyles.textTheme(
      isDark: false,
    ),
  );

  // ================= DARK =================

  static final ThemeData darkTheme = ThemeData.dark().copyWith(
    useMaterial3: true,
    primaryColor: AppColors.primaryTeal,
    scaffoldBackgroundColor: AppColors.darkBackground,
    colorScheme: const ColorScheme.dark().copyWith(
      primary: AppColors.primaryTeal,
      primaryContainer:AppColors.darkTextSecondary ,
      secondary: AppColors.accentOrange,
      secondaryContainer: AppColors.darkBorder,
      surface: AppColors.darkSurface,
    ),
    appBarTheme: const AppBarTheme(
      toolbarHeight: 76,
      backgroundColor: AppColors.darkSurface,
       titleTextStyle: TextStyle(color: AppColors.darkTextPrimary,fontSize: 18,fontWeight: FontWeight.bold),
      elevation: 0,
      iconTheme: IconThemeData(
        color: AppColors.darkTextPrimary,
      ),
    ),
    actionIconTheme: ActionIconThemeData(
      backButtonIconBuilder: (BuildContext context) => const Icon(
        Icons.arrow_back_ios_new, 
        size: 20,
      ),
    ),
    textTheme: AppTextStyles.textTheme(
      isDark: true,
    ),
  );
}
