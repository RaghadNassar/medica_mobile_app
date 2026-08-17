import 'package:flutter/material.dart';

class ExactReservaClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    // 1. البداية من اليسار (مرتفع قليلاً تحت الحافة)
    path.lineTo(0, size.height * 0.42);

    // 2. رسم انحناء حرف S المزدوج (ينزل ثم يصعد)
    // controlPoint1: تجذب المنحنى لأسفل في النصف الأول
    // controlPoint2: تجذب المنحنى لأعلى في النصف الثاني
    // endPoint: نقطة الاستقرار على اليمين
    var firstControlPoint = Offset(size.width * 0.38, size.height * 1.15);
    var secondControlPoint = Offset(size.width * 0.65, size.height * 0.10);
    var endPoint = Offset(size.width, size.height * 0.70);

    path.cubicTo(
      firstControlPoint.dx,
      firstControlPoint.dy,
      secondControlPoint.dx,
      secondControlPoint.dy,
      endPoint.dx,
      endPoint.dy,
    );

    path.lineTo(size.width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}