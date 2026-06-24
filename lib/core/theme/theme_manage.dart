import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:raghad_pro/core/cache/cashe_helper_getStorage.dart';

class ThemeManage {
  static const _themeKey = "isDarkMode";

  
  static bool isDarkModeActive() {
   
 return CacheHelperGetStorage.getData(key: _themeKey) ?? false;  }

 
  static ThemeMode getThemeMode() {
    return isDarkModeActive() ? ThemeMode.dark : ThemeMode.light;
  }

  static void changeThemeMode() {
    bool currentStatus = isDarkModeActive();
    bool newStatus = !currentStatus;

    CacheHelperGetStorage.saveData(key: _themeKey, value: newStatus);

    Get.changeThemeMode(newStatus ? ThemeMode.dark : ThemeMode.light);
    
    // Get.updateLocale(Get.locale!); 
  }
}