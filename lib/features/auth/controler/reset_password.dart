import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:raghad_pro/core/api/end_point.dart';
import 'package:raghad_pro/core/constanse/app_route.dart';
import 'package:raghad_pro/core/constanse/string_manager.dart';
import 'package:raghad_pro/core/helper/alert_helper.dart';
import 'package:raghad_pro/features/auth/data/reposetry/auth_repostry.dart';
// ResetPasswordBinding.dart
class ResetPasswordBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ResetPasswordController>(() => ResetPasswordController(Get.find()));
  }
}
class ResetPasswordController extends GetxController {
  final AuthRepostry _repository;
  ResetPasswordController(this._repository);

  final formKey                   = GlobalKey<FormState>();
  final passwordController        = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final isLoading                 = false.obs;
  final isPasswordHidden          = true.obs;
  final isConfirmPasswordHidden   = true.obs;

  void togglePassword()        => isPasswordHidden.value = !isPasswordHidden.value;
  void toggleConfirmPassword() => isConfirmPasswordHidden.value = !isConfirmPasswordHidden.value;
  late final String patientEmail; 
  //String get patientEmail => Get.arguments as String? ?? '';

  @override
  void onInit() {
    super.onInit();
     final args = Get.arguments;
  if (args is String && args.isNotEmpty) {
    patientEmail = args;
  } else {
    patientEmail = '';
  }
   // patientEmail = Get.arguments as String? ?? '';
  }
  Future<void> resetPassword() async {
  
   // if (!formKey.currentState!.validate()) return;
    
if (!(formKey.currentState?.validate() ?? false)) return;
    isLoading.value = true;

    final response = await _repository.resetPassword(
      email:                patientEmail,
      password:             passwordController.text,
      passwordConfirmation: confirmPasswordController.text,
    );

    response.fold(
      (error) {
        isLoading.value = false;
        AlertHelper.showSnackbar(message: error, type: AlertType.error);
      },
      (data) async{
        isLoading.value = false;
        AlertHelper.showSnackbar(
          message: data[ApiKey.message] ?? StringManager.passwordUpdated.tr,
          type: AlertType.success,
        );
        // passwordController.clear();
        // confirmPasswordController.clear();
          FocusManager.instance.primaryFocus?.unfocus();
        WidgetsBinding.instance.addPostFrameCallback((_) {
    Get.offAllNamed(AppRoutes.login);
  });
       // Get.offAllNamed(AppRoutes.login);
      },
    );
  }

 /* @override
  void onClose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }*/
}