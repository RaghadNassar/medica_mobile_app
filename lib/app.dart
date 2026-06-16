import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:raghad_pro/core/constanse/app_pages.dart';
import 'package:raghad_pro/core/di/initial_binding.dart';
import 'package:raghad_pro/core/theme/app_theme.dart';
import 'package:raghad_pro/core/theme/theme_manage.dart';
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
   
    // ever(RxString(CacheHelperGetStorage.getData(key: 'token') ?? ''), (token) {
    //   if (token.isNotEmpty) {
    //     print("🚀 تم كشف تسجيل دخول جديد، إعادة تشغيل الخدمات الآن...");
       
    //   //  Get.find<RealTimeService>().init();
    //   }
    // });

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
}
/*
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    ever(RxString(CacheHelperGetStorage.getData(key: 'token') ?? ''), (token) {
      if (token.isNotEmpty) {
        print("🚀 تم كشف تسجيل دخول جديد، تشغيل الخدمات الآن...");
        Get.find<NotificationLogic>().initNotificationSettings();
        Get.find<RealTimeService>().init();
      }
    });
    return GetMaterialApp(
      title: 'Medica',
      // locale: localeState.locale, // اللغة العالمية
       theme: AppTheme.lightTheme, // الثيم العالمي
       darkTheme: AppTheme.darkTheme,
       themeMode: ThemeManage.getThemeMode(),
      // routerConfig: AppRouter.router,
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      debugShowCheckedModeBanner: false,
      initialBinding: InitialBinding()
    );
  }
}*/
