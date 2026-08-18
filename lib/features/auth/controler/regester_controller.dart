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
class RegisterBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthRepostry>(() => AuthRepostry(Get.find<ApiConsumer>()));
    Get.lazyPut<RegisterController>(() => RegisterController(Get.find<AuthRepostry>()));
  }
}
class RegisterController extends GetxController {
  final AuthRepostry _repository;
  RegisterController(this._repository);

  // Step management
  final currentStep = 0.obs;
  final formKeyStepOne = GlobalKey<FormState>();
  final formKeyStepTwo = GlobalKey<FormState>();

  // Step 1 controllers
  final nameController            = TextEditingController();
  final nickNameController        = TextEditingController();
  final emailController           = TextEditingController();
  final passwordController        = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // Step 2 controllers
  final phoneController       = TextEditingController();
  final dateOfBirthController = TextEditingController();

  final isPasswordHidden        = true.obs;
  final isConfirmPasswordHidden = true.obs;
  final isLoading               = false.obs;
  final selectedGender          = 'male'.obs;

  void togglePassword()        => isPasswordHidden.value = !isPasswordHidden.value;
  void toggleConfirmPassword() => isConfirmPasswordHidden.value = !isConfirmPasswordHidden.value;
  void changeGender(String g)  => selectedGender.value = g;

  void nextStep() {
    if (formKeyStepOne.currentState!.validate()) {
      currentStep.value = 1;
    }
  }

  void previousStep() => currentStep.value = 0;

  Future<void> selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context:     context,
      initialDate: DateTime(2000),
      firstDate:   DateTime(1920),
      lastDate:    DateTime.now(),
    );
    if (picked != null) {
      dateOfBirthController.text =
          '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
    }
  }

  Future<void> register() async {
   // if (!formKeyStepTwo.currentState!.validate()) return;
if (!(formKeyStepTwo.currentState?.validate() ?? false)) return;
    isLoading.value = true;

    final response = await _repository.register(
      name:            nameController.text.trim(),
      nickName:        nickNameController.text.trim(),
      email:           emailController.text.trim(),
      password:        passwordController.text,
      confirmPassword: confirmPasswordController.text,
      phone:           phoneController.text.trim(),
      gender:          selectedGender.value,
      dateOfBirth:     dateOfBirthController.text,
    );

    response.fold(
      (error) {
        isLoading.value = false;
        AlertHelper.showSnackbar(message: error, type: AlertType.error);
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
    nameController.dispose();
    nickNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    phoneController.dispose();
    dateOfBirthController.dispose();
    super.onClose();
  }
}