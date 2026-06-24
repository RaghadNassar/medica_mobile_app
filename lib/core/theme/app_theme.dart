import 'package:flutter/material.dart';
import 'package:raghad_pro/core/theme/app_typography.dart';

import 'app_colors.dart';
import 'app_text_styles.dart';

class AppTheme {
  
  static ThemeData lightTheme() => ThemeData.light().copyWith(
    useMaterial3: true,
    primaryColor: AppColors.primaryTeal,
    scaffoldBackgroundColor: AppColors.lightBackground,
    colorScheme: const ColorScheme.light().copyWith(
      primary:          AppColors.primaryTeal,
      primaryContainer: AppColors.lightTextSecondary,
      secondary:        AppColors.accentOrange,
      secondaryContainer: AppColors.lightBorder,
      surface:          AppColors.lightSurface,
    ),
    appBarTheme: AppBarTheme(
      toolbarHeight: 66,
      backgroundColor: AppColors.lightSurface,
      elevation: 0,
      titleTextStyle: TextStyle(
        color:      AppColors.lightTextPrimary,
        fontSize:   18,
        fontWeight: FontWeight.bold,
        fontFamily: AppTypography.fontFamily,
      ),
      iconTheme: const IconThemeData(color: AppColors.lightTextPrimary),
    ),
    actionIconTheme: ActionIconThemeData(
      backButtonIconBuilder: (_) => const Icon(Icons.arrow_back_ios_new, size: 20),
    ),
    textTheme: AppTextStyles.textTheme(isDark: false).apply(
      fontFamily: AppTypography.fontFamily,
    ),
  );

  static ThemeData darkTheme() => ThemeData.dark().copyWith(
    useMaterial3: true,
    primaryColor: AppColors.primaryTeal,
    scaffoldBackgroundColor: AppColors.darkBackground,
    colorScheme: const ColorScheme.dark().copyWith(
      primary:          AppColors.primaryTeal,
      primaryContainer: AppColors.darkTextSecondary,
      secondary:        AppColors.accentOrange,
      secondaryContainer: AppColors.darkBorder,
      surface:          AppColors.darkSurface,
    ),
    appBarTheme: AppBarTheme(
      toolbarHeight: 76,
      backgroundColor: AppColors.darkSurface,
      elevation: 0,
      titleTextStyle: TextStyle(
        color:      AppColors.darkTextPrimary,
        fontSize:   18,
        fontWeight: FontWeight.bold,
        fontFamily: AppTypography.fontFamily, 
      ),
      iconTheme: const IconThemeData(color: AppColors.darkTextPrimary),
    ),
    actionIconTheme: ActionIconThemeData(
      backButtonIconBuilder: (_) => const Icon(Icons.arrow_back_ios_new, size: 20),
    ),
    textTheme: AppTextStyles.textTheme(isDark: true).apply(
      fontFamily: AppTypography.fontFamily, 
    ),
  );
}



































































































































/*
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
    appBarTheme:const AppBarTheme(
      toolbarHeight: 66,
      backgroundColor: AppColors.lightSurface,
      titleTextStyle: TextStyle(color: AppColors.lightTextPrimary,fontSize: 18,fontWeight: FontWeight.bold,),
      elevation: 0,
      iconTheme: const IconThemeData(
        color: AppColors.lightTextPrimary,
      ),
    ),
     actionIconTheme: ActionIconThemeData(
      backButtonIconBuilder: (BuildContext context) => const Icon(
        Icons.arrow_back_ios_new, 
        size: 20,
      ),
    ),
    // textTheme: AppTextStyles.textTheme(
    //   isDark: false,
    // ),
    textTheme: AppTextStyles.textTheme(isDark: false).apply(
      fontFamily: AppTypography.fontFamily,
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
    appBarTheme:const AppBarTheme(
      toolbarHeight: 76,
      backgroundColor: AppColors.darkSurface,
       titleTextStyle: TextStyle(color: AppColors.darkTextPrimary,fontSize: 22,fontWeight: FontWeight.bold,),
      elevation: 0,
      iconTheme: const IconThemeData(
        color: AppColors.darkTextPrimary,
      ),
    ),
    actionIconTheme: ActionIconThemeData(
      backButtonIconBuilder: (BuildContext context) => const Icon(
        Icons.arrow_back_ios_new, 
        size: 20,
      ),
    ),
    // textTheme: AppTextStyles.textTheme(
    //   isDark: true,
    // ),
    textTheme: AppTextStyles.textTheme(isDark: true).apply(
      fontFamily: AppTypography.fontFamily,
    ),
  );
}*/
// core/theme/app_theme.dart