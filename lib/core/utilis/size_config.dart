import 'package:flutter/material.dart';

extension ScreenSize on BuildContext {
  // الحصول على عرض الشاشة
  double get screenWidth => MediaQuery.sizeOf(this).width;

  // الحصول على ارتفاع الشاشة
  double get screenHeight => MediaQuery.sizeOf(this).height;

  // دوال مساعدة للنسب المئوية (مثلاً عرض العنصر 50% من الشاشة)
  double widthPct(double percent) => screenWidth * percent;
  double heightPct(double percent) => screenHeight * percent;
}