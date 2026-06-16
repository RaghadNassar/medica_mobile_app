import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_typography.dart';

class AppTextStyles {

  static TextTheme textTheme({
    required bool isDark,
  }) {

    final primary =
        isDark
            ? AppColors.darkTextPrimary
            : AppColors.lightTextPrimary;

    final secondary =
        isDark
            ? AppColors.darkTextSecondary
            : AppColors.lightTextSecondary.withOpacity(0.69);

    return TextTheme(

      displayLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: primary,
        fontFamily: AppTypography.fontFamily,
      ),

      headlineMedium: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: primary,
        fontFamily: AppTypography.fontFamily,
      ),

      titleLarge: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: primary,
        fontFamily: AppTypography.fontFamily,
      ),
       headlineLarge:TextStyle(
        fontSize: 17,
        color: primary,
        fontWeight: FontWeight.bold,
        fontFamily: AppTypography.fontFamily,
      ) ,
      bodyLarge: TextStyle(
        fontSize: 16,
        color: primary,
        fontFamily: AppTypography.fontFamily,
      ),

      bodyMedium: TextStyle(
        fontSize: 14,
        color: secondary,
        fontFamily: AppTypography.fontFamily,
      ),

      labelLarge: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: AppColors.lightSurface,
        fontFamily: AppTypography.fontFamily,
      ),
    );
  }
}