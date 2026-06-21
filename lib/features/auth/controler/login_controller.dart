import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:raghad_pro/core/api/api_consumer.dart';
import 'package:raghad_pro/core/api/end_point.dart';
import 'package:raghad_pro/core/cache/cashe_helper_getStorage.dart';
import 'package:raghad_pro/core/constanse/app_route.dart';
import 'package:raghad_pro/core/helper/alert_helper.dart';
import 'package:raghad_pro/features/auth/data/reposetry/auth_repostry.dart';
import 'package:raghad_pro/features/chat/controller/notification_controller.dart';
class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthRepostry>(() => AuthRepostry(Get.find<ApiConsumer>()));
    Get.lazyPut<LoginController>(() => LoginController(Get.find<AuthRepostry>()));
  }
}
class LoginController extends GetxController {
  final AuthRepostry _repository;
  LoginController(this._repository);

  final formKey = GlobalKey<FormState>();
  final emailController    = TextEditingController();
  final passwordController = TextEditingController();

  final isLoading         = false.obs;
  final isPasswordHidden  = true.obs;

  void togglePassword() =>
      isPasswordHidden.value = !isPasswordHidden.value;

  Future<void> login() async {
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;

    final response = await _repository.login(
      email:    emailController.text.trim(),
      password: passwordController.text,
    );

    response.fold(
      (error) {
        isLoading.value = false;
        AlertHelper.showSnackbar(
          message: error,
          type: AlertType.error,
        );
      },
      (loginModel) {
        isLoading.value = false;
        CacheHelperGetStorage.saveData(key: ApiKey.token, value: loginModel.token);
        CacheHelperGetStorage.saveData(key: ApiKey.uuid,  value: loginModel.user.uuid);
        Get.find<NotificationLogic>().requestPermissionAndSync();
        Get.offAllNamed(AppRoutes.home);
      },
    );
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}