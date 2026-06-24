import 'package:raghad_pro/core/cache/cashe_helper_getStorage.dart';

class AppTypography {

  // static String? get fontFamily {

  //   final locale =
  //       Get.locale?.languageCode;

  //   return locale == 'ar'
  //       ? 'Almarai':null;
        
  //       //: 'Inter';
  // }
   static String? get fontFamily {
    final lang = CacheHelperGetStorage.getString(key: 'app_language') ?? 'en';
    return lang == 'ar' ? 'Almarai' : null;
  }
}