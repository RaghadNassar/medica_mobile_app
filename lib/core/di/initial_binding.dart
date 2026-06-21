import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:raghad_pro/core/api/api_consumer.dart';
import 'package:raghad_pro/core/api/dio_consumer.dart';
import 'package:raghad_pro/features/chat/data/repositry/chat_repostry.dart';
import 'package:raghad_pro/features/splash/controller/splash_logic.dart'; 

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<Dio>(Dio(), permanent: true);

    Get.put<ApiConsumer>(
      DioConsumer(dio: Get.find<Dio>()),
      permanent: true,
    );
    Get.put<SplashController>(SplashController());
   // Get.lazyPut<ChatRepository>(() => ChatRepository(Get.find<ApiConsumer>()), fenix: true);
  }
}
