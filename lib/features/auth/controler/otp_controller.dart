import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:raghad_pro/core/api/end_point.dart';
import 'package:raghad_pro/core/constanse/app_route.dart';
import 'package:raghad_pro/core/constanse/string_manager.dart';
import 'package:raghad_pro/core/helper/alert_helper.dart';
import 'package:raghad_pro/features/auth/data/reposetry/auth_repostry.dart';

class OtpController extends GetxController {
  final AuthRepostry _repository;
  OtpController(this._repository);

  final otpController = TextEditingController();
  final isLoading     = false.obs;
  late final String patientEmail;
  final isResending   = false.obs;
  //String get patientEmail => Get.arguments as String? ?? '';
  @override
  void onInit() {
    super.onInit();
    patientEmail = Get.arguments as String? ?? '';
  }

  Future<void> verifyOtp() async {
    if (otpController.text.trim().length < 6) {
      AlertHelper.showSnackbar(
        message: StringManager.otpIncomplete.tr,
        type: AlertType.warning,
      );
      return;
    }

    isLoading.value = true;

    final response = await _repository.verifyOtp(
      email: patientEmail,
      code:  otpController.text.trim(),
    );

    response.fold(
      (error) {
        isLoading.value = false;
        AlertHelper.showSnackbar(message: error, type: AlertType.error);
      },
      (data) {
        isLoading.value = false;
        AlertHelper.showSnackbar(
          message: data[ApiKey.message] ?? StringManager.otpSuccess.tr,
          type: AlertType.success,
        );
        Get.toNamed(AppRoutes.resetPassword, arguments: patientEmail);
      },
    );
  }
 Future<void> resendOtp() async {
    if (isResending.value) return;
    
    isResending.value = true;
    final response = await _repository.forgetPassword(email: patientEmail);

    response.fold(
      (error) {
        isResending.value = false;
        AlertHelper.showSnackbar(message: error, type: AlertType.error);
      },
      (data) {
        isResending.value = false;
        AlertHelper.showSnackbar(
          message: data[ApiKey.message] ?? StringManager.otpSent.tr,
          type: AlertType.success,
        );
      },
    );
  }

  @override
  void onClose() {
    otpController.dispose();
    super.onClose();
  }
}