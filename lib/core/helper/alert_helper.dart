import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:raghad_pro/core/theme/app_colors.dart'; // تأكدي من مسار الألوان الخاص بكِ

enum AlertType { success, error, warning, info }

class AlertHelper {
  static void showSnackbar({
    required String message,
    String title = "تنبيه",
    AlertType type = AlertType.info,
    Duration duration = const Duration(seconds: 3),
  }) {
    
    Color backgroundColor;
    Color textColor = Colors.white; // اللون الافتراضي للنصوص

    switch (type) {
      case AlertType.success:
        backgroundColor = AppColors.success; // 🟢 لون النجاح
        break;
      case AlertType.error:
        backgroundColor = AppColors.error; // 🔴 لون الخطأ (أو Colors.redAccent)
        break;
      case AlertType.warning:
        backgroundColor = AppColors.warning; // 🟠 لون التحذير
        break;
      case AlertType.info:
        backgroundColor = AppColors.info; // ⚪ أو ابيض/رمادي حسب ثيم التطبيق
        break;
    }

   
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: backgroundColor.withOpacity(0.9),
      colorText: textColor,
      margin: const EdgeInsets.all(12),
      borderRadius: 12,
      duration: duration,
      icon: Icon(
        _getIconByType(type),
        color: Colors.white,
      ),
      snackStyle: SnackStyle.FLOATING,
    );
  }

  // دالة مساعدة داخلية لتحديد الأيقونة المناسبة بشكل تلقائي لحجم وجمالية التنبيه
  static IconData _getIconByType(AlertType type) {
    switch (type) {
      case AlertType.success:
        return Icons.check_circle_outline;
      case AlertType.error:
        return Icons.error_outline;
      case AlertType.warning:
        return Icons.warning_amber_rounded;
      case AlertType.info:
        return Icons.info_outline;
    }
  }
}