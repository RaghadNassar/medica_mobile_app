import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:raghad_pro/core/cache/cashe_helper_getStorage.dart';
import 'package:raghad_pro/core/constanse/app_pages.dart';
import 'package:raghad_pro/core/constanse/app_route.dart';
import 'package:raghad_pro/core/di/initial_binding.dart';
import 'package:raghad_pro/core/languge/translation.dart';
import 'package:raghad_pro/core/theme/app_theme.dart';
import 'package:raghad_pro/core/theme/theme_manage.dart';
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title:       'Medica',
      theme:       AppTheme.lightTheme,
      darkTheme:   AppTheme.darkTheme,
      themeMode:   ThemeManage.getThemeMode(),
      translations:    AppTranslations(),
      locale:          _getSavedLocale(),
      fallbackLocale:  const Locale('en', 'US'),
      initialRoute:    AppRoutes.splash,
      getPages:        AppPages.routes,
      initialBinding: InitialBinding(),
      debugShowCheckedModeBanner: false,
    );
  }

  Locale _getSavedLocale() {
    final lang = CacheHelperGetStorage.getString(key: 'app_language') ?? 'en';
    return lang == 'ar'
        ? const Locale('ar', 'SY')
        : const Locale('en', 'US');
  }
}

/*
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
   

    return GetMaterialApp(
      title: 'Medica',
      theme: AppTheme.lightTheme, 
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeManage.getThemeMode(),
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      debugShowCheckedModeBanner: false,
      initialBinding: InitialBinding(),
    );
  }
}*/
