import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:raghad_pro/core/api/api_consumer.dart';
import 'package:raghad_pro/core/api/end_point.dart';
import 'package:raghad_pro/core/cache/cashe_helper_getStorage.dart';
import 'package:raghad_pro/core/constanse/app_route.dart';
import 'package:raghad_pro/core/helper/alert_helper.dart';
import 'package:raghad_pro/features/auth/data/model/login_model.dart';
import 'package:raghad_pro/features/auth/data/reposetry/auth_repostry.dart';
import 'package:raghad_pro/features/chat/controller/notification_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthRepostry>(() => AuthRepostry(Get.find<ApiConsumer>()));
    Get.lazyPut<AuthLogic>(() => AuthLogic(Get.find<AuthRepostry>()));
    //Get.lazyPut<AuthLogic>(() => AuthLogic(Get.find<AuthRepostry>()), fenix: true);
  }
}

class AuthLogic extends GetxController {
  final AuthRepostry repostry;
  AuthLogic(this.repostry);
  // final ApiConsumer api;
  //AuthLogic({required this.api});
  //login logic
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> formKeyLog = GlobalKey<FormState>();
  var isPasswordHidden = true.obs;
  var isLoading = false.obs;
  LoginModel? user;

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

// signU logic
  final TextEditingController nameController = TextEditingController();
  final TextEditingController nickNameController = TextEditingController();
  final TextEditingController emailUpController = TextEditingController();
  final TextEditingController passwordUPController = TextEditingController();
  final TextEditingController confirmpasswordUPController =
      TextEditingController();
  final TextEditingController phone = TextEditingController();
  // final TextEditingController gender = TextEditingController();
  final TextEditingController dateOfBridth = TextEditingController();
  final GlobalKey<FormState> formKeyUP = GlobalKey<FormState>();
  var isPasswordHiddenUp = true.obs;
  var isLoadingUP = false.obs;
  var selectedGender = "male".obs;
  // Forget Password Logic
  final TextEditingController forgetEmailController = TextEditingController();
  final GlobalKey<FormState> formKeyForget = GlobalKey<FormState>();
  var isForgetLoading = false.obs;
  // Verify OTP Logic
  final TextEditingController otpController = TextEditingController();
  var isVerifyOtpLoading = false.obs;
  String currentPatientEmail = "";
  // Reset Password Logic
  final TextEditingController resetPasswordController = TextEditingController();
  final TextEditingController resetConfirmPasswordController =
      TextEditingController();
  final GlobalKey<FormState> formKeyResetPassword = GlobalKey<FormState>();
  var isResetPasswordLoading = false.obs;
  var isResetPasswordHidden = true.obs;
  var isResetConfirmPasswordHidden = true.obs;

  void toggleResetPasswordVisibility() =>
      isResetPasswordHidden.value = !isResetPasswordHidden.value;
  void toggleResetConfirmPasswordVisibility() =>
      isResetConfirmPasswordHidden.value = !isResetConfirmPasswordHidden.value;

  void changeGender(String gender) {
    selectedGender.value = gender;
  }

  void togglePasswordVisibilityUp() {
    isPasswordHiddenUp.value = !isPasswordHiddenUp.value;
  }

  Future<void> selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1920),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      dateOfBridth.text =
          "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
    }
  }

// fprget password
  var selectedIndex = 0.obs;

  void changeIndex(int index) {
    selectedIndex.value = index;
  }

  login() async {
    if (!formKeyLog.currentState!.validate()) return;
    isLoading.value = true;
    final response = await repostry.login(
        email: emailController.text, password: passwordController.text);
    response.fold((errorMessage) {
      isLoading.value = false;
      AlertHelper.showSnackbar(
        title: "فشل الدخول",
        message: errorMessage,
        type: AlertType.error,
      );
    }, (LoginModel) {
      isLoading.value = false;
      user = LoginModel;
      CacheHelperGetStorage.saveData(
          key: ApiKey.token, value: LoginModel.token);
      CacheHelperGetStorage.saveData(
          key: ApiKey.uuid, value: LoginModel.user.uuid);
      if (Get.isRegistered<NotificationLogic>()) {
        Get.find<NotificationLogic>().requestPermissionAndSync();
      }
      Get.offAllNamed(AppRoutes.home);
    });
  }

  register() async {
    if (!formKeyUP.currentState!.validate()) return;

    isLoadingUP.value = true;

    final response = await repostry.register(
      name: nameController.text.trim(),
      nickName: nickNameController.text.trim(),
      email: emailUpController.text.trim(),
      password: passwordUPController.text,
      confirmPassword: confirmpasswordUPController.text,
      phone: phone.text.trim(),
      gender: selectedGender.value,
      dateOfBirth: dateOfBridth.text,
    );

    response.fold(
      (errorMessage) {
        isLoadingUP.value = false;
        AlertHelper.showSnackbar(
          title: "فشل إنشاء الحساب",
          message: errorMessage,
          type: AlertType.error,
        );
      },
      (loginModel) {
        isLoadingUP.value = false;
        user = loginModel;
        CacheHelperGetStorage.saveData(
            key: ApiKey.token, value: loginModel.token);

        CacheHelperGetStorage.saveData(
            key: ApiKey.uuid, value: loginModel.user.uuid);

        if (Get.isRegistered<NotificationLogic>()) {
          Get.find<NotificationLogic>().requestPermissionAndSync();
        }
        Get.offAllNamed(AppRoutes.home);
      },
    );
  }

  //  forgetPassword
  forgetPassword() async {
    if (!formKeyForget.currentState!.validate()) return;

    isForgetLoading.value = true;

    final response = await repostry.forgetPassword(
      email: forgetEmailController.text.trim(),
    );

    response.fold(
      (errorMessage) {
        isForgetLoading.value = false;
        AlertHelper.showSnackbar(
          title: "خطأ",
          message: errorMessage,
          type: AlertType.error,
        );
      },
      (successData) {
        isForgetLoading.value = false;
        AlertHelper.showSnackbar(
          title: "نجاح العملية",
          message: successData[ApiKey.message] ?? "جاري إرسال الرمز...",
          type: AlertType.success,
        );
        Get.toNamed(AppRoutes.verficationCode,
            arguments: forgetEmailController.text.trim());
      },
    );
  }

  verifyOtp() async {
    if (otpController.text.length < 6) {
      AlertHelper.showSnackbar(
        title: "تنبيه",
        message: "يرجى إدخال رمز التحقق كاملاً المكون من 6 أرقام",
        type: AlertType.warning,
      );
      return;
    }

    isVerifyOtpLoading.value = true;

    final response = await repostry.verifyOtp(
      email: currentPatientEmail,
      code: otpController.text.trim(),
    );

    response.fold(
      (errorMessage) {
        isVerifyOtpLoading.value = false;
        AlertHelper.showSnackbar(
          title: "فشل التحقق",
          message: errorMessage,
          type: AlertType.error,
        );
      },
      (successData) {
        isVerifyOtpLoading.value = false;
        AlertHelper.showSnackbar(
          title: "نجاح العملية",
          message: successData['message'] ?? "تم التحقق بنجاح.",
          type: AlertType.success,
        );
        Get.toNamed(AppRoutes.resetPassword, arguments: currentPatientEmail);
      },
    );
  }

  resetPassword() async {
    if (!formKeyResetPassword.currentState!.validate()) return;

    isResetPasswordLoading.value = true;

    final response = await repostry.resetPassword(
      email: currentPatientEmail,
      password: resetPasswordController.text,
      passwordConfirmation: resetConfirmPasswordController.text,
    );

    response.fold(
      (errorMessage) {
        isResetPasswordLoading.value = false;
        AlertHelper.showSnackbar(
          title: "خطأ في التحديث",
          message: errorMessage,
          type: AlertType.error,
        );
      },
      (successData) {
        isResetPasswordLoading.value = false;
        AlertHelper.showSnackbar(
          title: "تم بنجاح",
          message: successData[ApiKey.message] ?? "تم تحديث كلمة المرور بنجاح.",
          type: AlertType.success,
        );

        resetPasswordController.clear();
        resetConfirmPasswordController.clear();
        Get.offAllNamed(AppRoutes.login);
      },
    );
  }

  @override
  void onClose() {
    forgetEmailController.dispose();
    super.onClose();
  }
}

/*login() async {
    try {
      isLoading.value = true;
      final response = await api.post(EndPoint.signIn, data: {
        ApiKey.email: emailController.text,
        ApiKey.password: passwordController.text
      });
      user = LoginModel.fromJson(response);
      CacheHelper().saveData(key: ApiKey.token, value: user!.token);
      CacheHelper().saveData(key: ApiKey.uuid, value: user!.user.uuid);
    } on ServerException catch (e) {
      AlertHelper.showSnackbar(
        title: "فشل الدخول",
        message: e.errorModel.message,
        type: AlertType.error,
      );
      isLoading.value = false;
    }
  }*/
