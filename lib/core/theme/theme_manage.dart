import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:raghad_pro/core/cache/cashe_helper_getStorage.dart';

class ThemeManage {
  static const _themeKey = "isDarkMode";

  // الحصول على الحالة الحالية
  static bool isDarkModeActive() {
    // نستخدم ?? لتبسيط الكود (Null Safety)
 return CacheHelperGetStorage.getData(key: _themeKey) ?? false;  }

  // الحصول على النمط المناسب للـ GetMaterialApp
  static ThemeMode getThemeMode() {
    return isDarkModeActive() ? ThemeMode.dark : ThemeMode.light;
  }

  // الدالة الأساسية للتبديل
  static void changeThemeMode() {
    bool currentStatus = isDarkModeActive();
    bool newStatus = !currentStatus;

    // 1. حفظ القيمة الجديدة أولاً
    CacheHelperGetStorage.saveData(key: _themeKey, value: newStatus);

    // 2. تغيير الثيم في التطبيق
    Get.changeThemeMode(newStatus ? ThemeMode.dark : ThemeMode.light);
    
    // ملاحظة: GetX أحياناً يحتاج لتحديث الواجهة يدوياً في بعض الإصدارات
    // Get.updateLocale(Get.locale!); // اختيارية فقط إذا واجهتِ مشاكل في الخطوط
  }
}