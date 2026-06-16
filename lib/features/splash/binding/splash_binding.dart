import 'package:get/get.dart';
import 'package:raghad_pro/features/splash/controller/splash_logic.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(SplashController(), permanent: true);
  }
}
