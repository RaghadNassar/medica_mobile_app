import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:raghad_pro/core/api/api_consumer.dart';
import 'package:raghad_pro/core/api/end_point.dart';
import 'package:raghad_pro/core/constanse/app_route.dart';
import 'package:raghad_pro/core/constanse/string_manager.dart';
import 'package:raghad_pro/core/helper/alert_helper.dart';
import 'package:raghad_pro/features/auth/controler/otp_controller.dart';
import 'package:raghad_pro/features/auth/controler/reset_password.dart';
import 'package:raghad_pro/features/auth/data/reposetry/auth_repostry.dart';
/*
class ForgotPasswordBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthRepostry>(() => AuthRepostry(Get.find<ApiConsumer>()));
    Get.lazyPut<ForgetPasswordController>(() => ForgetPasswordController(Get.find<AuthRepostry>()), fenix: true);
    Get.lazyPut<OtpController>(() => OtpController(Get.find<AuthRepostry>()), fenix: true);
    Get.lazyPut<ResetPasswordController>(() => ResetPasswordController(Get.find<AuthRepostry>()), fenix: true);
  }
}*/
class ForgotPasswordBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthRepostry>(() => AuthRepostry(Get.find<ApiConsumer>()));
    Get.lazyPut<ForgetPasswordController>(() => ForgetPasswordController(Get.find<AuthRepostry>()));
  }
}
class ForgetPasswordController extends GetxController {
  final AuthRepostry _repository;
  ForgetPasswordController(this._repository);

  final formKey       = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final isLoading     = false.obs;
  /*

  Future<void> forgetPassword() async {
   // if (!formKey.currentState!.validate()) return;
   if (!(formKey.currentState?.validate() ?? false)) return;
    FocusManager.instance.primaryFocus?.unfocus();

    isLoading.value = true;

    final response = await _repository.forgetPassword(
      email: emailController.text.trim(),
    );

    response.fold(
      (error) {
        isLoading.value = false;
        AlertHelper.showSnackbar(message: error, type: AlertType.error);
      },
      (data) {
        isLoading.value = false;
        AlertHelper.showSnackbar(
          message: data[ApiKey.message] ?? StringManager.otpSent.tr,
          type: AlertType.success,
        );
        Get.toNamed(
          AppRoutes.verficationCode,
          arguments: emailController.text.trim(),
        );
      },
    );
  }
  */
  Future<void> forgetPassword() async {
  if (!(formKey.currentState?.validate() ?? false)) return;

  // إغلاق الكيبورد فوراً لمنع تعارض الـ Gesture
  FocusManager.instance.primaryFocus?.unfocus();

  isLoading.value = true;

  final response = await _repository.forgetPassword(
    email: emailController.text.trim(),
  );

  response.fold(
    (error) {
      isLoading.value = false;
      AlertHelper.showSnackbar(message: error, type: AlertType.error);
    },
    (data) {
      isLoading.value = false;
      AlertHelper.showSnackbar(
        message: data[ApiKey.message] ?? StringManager.otpSent.tr,
        type: AlertType.success,
      );
      
      // تأخير بسيط جداً لضمان إغلاق الكيبورد وانتهاء الـ Gesture
      Future.delayed(const Duration(milliseconds: 100), () {
        Get.toNamed(
          AppRoutes.verficationCode,
          arguments: emailController.text.trim(),
        );
      });
    },
  );
}

  // @override
  // void onClose() {
  //   emailController.dispose();
  //   super.onClose();
  // }
}