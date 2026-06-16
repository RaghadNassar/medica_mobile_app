import 'package:get/get.dart';

class AppTypography {

  static String get fontFamily {

    final locale =
        Get.locale?.languageCode;

    return locale == 'ar'
        ? 'Cairo'
        : 'Inter';
  }
}