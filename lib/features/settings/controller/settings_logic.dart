
import 'dart:ui';

import 'package:get/get.dart';
import 'package:raghad_pro/core/cache/cashe_helper_getStorage.dart';
import 'package:raghad_pro/core/theme/theme_manage.dart';

class SettingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SettingsController>(
      () => SettingsController(),
      fenix: true,
    );
  }
}
class SettingsController extends GetxController {
  final isDarkMode      = ThemeManage.isDarkModeActive().obs;
  final currentLanguage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    final savedLang = CacheHelperGetStorage.getString(key: 'app_language') ?? 'en';
    currentLanguage.value = savedLang;
  }

  void toggleTheme(bool value) {
    ThemeManage.changeThemeMode();
    isDarkMode.value = value;
  }

  void changeLanguage(String lang) {
    currentLanguage.value = lang;
    CacheHelperGetStorage.saveData(key: 'app_language', value: lang);

    if (lang == 'en') {
      Get.updateLocale(const Locale('en', 'US'));
    } else {
      Get.updateLocale(const Locale('ar', 'SY'));
    }
  }
}