import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:raghad_pro/core/api/api_consumer.dart';
import 'package:raghad_pro/core/api/end_point.dart';
import 'package:raghad_pro/core/cache/cashe_helper_getStorage.dart';
import 'package:raghad_pro/core/constanse/app_route.dart';
import 'package:raghad_pro/core/helper/alert_helper.dart';
import 'package:raghad_pro/core/helper/upload_image_api.dart';
import 'package:raghad_pro/core/theme/theme_manage.dart';
import 'package:raghad_pro/features/profile/controller/medical_hestory.dart';
import 'package:raghad_pro/features/profile/data/model/profile_model.dart';
import 'package:raghad_pro/features/profile/data/repostry/user_repostry.dart';

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileRepostry>(
        () => ProfileRepostry(Get.find<ApiConsumer>()));
    Get.lazyPut<ProfileController>(
        () => ProfileController(Get.find<ProfileRepostry>()));
    Get.lazyPut<MedicalHistoryController>(
        () => MedicalHistoryController(Get.find<ProfileRepostry>()));
    //Get.lazyPut<AuthLogic>(() => AuthLogic(Get.find<ProfileRepostry>()), fenix: true);
  }
}

class ProfileController extends GetxController {
  final ProfileRepostry repostry;
  ProfileController(this.repostry);
  //primary
  var isDarkMode = ThemeManage.isDarkModeActive().obs;
  var currentLanguage = 'العربية'.obs;

  //update profile
  final formKeyprofile = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController nickNameController =
      TextEditingController(); // مستخدم بويدجت الإدخال عندكِ
  TextEditingController emailUpController = TextEditingController();
  TextEditingController passwordUPController = TextEditingController();
  TextEditingController confirmpasswordUPController = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController dateOfBridth = TextEditingController();
  TextEditingController currentPasswordController = TextEditingController();
  var isLoadingUP = false.obs;
  var isPasswordHiddenUp = true.obs;
  var selectedGender = ''.obs;
  Rxn<XFile> pickedImage = Rxn<XFile>();
  var isEditProfileLoading = false.obs;
//profile
  var isProfileLoading = false.obs;
  Rxn<ProfileModel> patientProfile = Rxn<ProfileModel>();
//logout
  var isLogoutLoading = false.obs;

  void onInit() {
    super.onInit();
    nameController = TextEditingController();
    nickNameController = TextEditingController();
    emailUpController = TextEditingController();
    passwordUPController = TextEditingController();
    confirmpasswordUPController = TextEditingController();
    phone = TextEditingController();
    dateOfBridth = TextEditingController();
   getProfile().then((_) {
    fillControllersWithCurrentData();
  });
  }

// theme

  void toggleTheme(bool value) {
    ThemeManage.changeThemeMode();
    isDarkMode.value = value;
  }

  void fillControllersWithCurrentData() {
    if (patientProfile.value != null) {
      final info = patientProfile.value!.data.personalInfo;
      nameController.text = info.name;
      nickNameController.text = info.name; // تعبئة الاسم مؤقتاً باللقب أيضاً
      emailUpController.text = info.email;
      phone.text = info.number;
      dateOfBridth.text = info.birthday;
      selectedGender.value = info.gender;
      pickedImage.value = null;
      passwordUPController.clear();
      confirmpasswordUPController.clear();
    }
  }

  Future<void> pickProfileImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery,imageQuality: 50,);

    if (image != null) {
      pickedImage.value = image;
    }
  }

  void togglePasswordVisibilityUp() {
    isPasswordHiddenUp.value = !isPasswordHiddenUp.value;
  }

  void changeGender(String gender) {
    selectedGender.value = gender;
  }

  Future<void> selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.tryParse(dateOfBridth.text) ?? DateTime(2000, 1, 1),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      dateOfBridth.text = picked.toString().split(' ')[0]; // YYYY-MM-DD
    }
  }

  void changeLanguage(String lang) {
    currentLanguage.value = lang;
    if (lang == 'English') {
      Get.updateLocale(const Locale('en', 'US'));
    } else {
      Get.updateLocale(const Locale('ar', 'SY'));
    }
  }

  getProfile() async {
    isProfileLoading.value = true;

    final response = await repostry.getPatientProfile();

    response.fold(
      (errorMessage) {
        isProfileLoading.value = false;
        AlertHelper.showSnackbar(
          title: "خطأ في البيانات",
          message: errorMessage,
          type: AlertType.error,
        );
      },
      (profileModel) {
        isProfileLoading.value = false;
        patientProfile.value = profileModel;
      },
    );
  }

//logout
  void logoutUser() async {
    isLogoutLoading.value = true;

    final response = await repostry.logout();

    response.fold(
      (errorMessage) {
        isLogoutLoading.value = false;
        AlertHelper.showSnackbar(
          title: "خطأ",
          message: errorMessage,
          type: AlertType.error,
        );
      },
      (successMessage) async {
        isLogoutLoading.value = false;
        await CacheHelperGetStorage.removeData(key: ApiKey.token);

        Get.offAllNamed(AppRoutes.login);
      },
    );
  }

  // update profile
  updateProfileFinal() async {
    if (!formKeyprofile.currentState!.validate()) return;

    isLoadingUP.value = true;
    Map<String, dynamic> bodyData = {
      ApiKey.name: nameController.text,
      ApiKey.email: emailUpController.text,
      ApiKey.number: phone.text,
      ApiKey.birthday: dateOfBridth.text,
      ApiKey.gender: selectedGender.value.toLowerCase(),
    };

    if (passwordUPController.text.isNotEmpty) {
      bodyData['current_password'] = currentPasswordController.text;
      bodyData['password'] = passwordUPController.text;
      bodyData['password_confirmation'] = confirmpasswordUPController.text;
    }

    if (pickedImage.value != null) {
      bodyData[ApiKey.image] = await uploadImageToApi(pickedImage.value!);
    }

    final response = await repostry.updatePatientProfile(updateData: bodyData);

    response.fold(
      (errorMessage) {
        isLoadingUP.value = false;
        AlertHelper.showSnackbar(
          title: "فشل التحديث",
          message: errorMessage,
          type: AlertType.error,
        );
      },
      (updatedProfileModel) async {
        isLoadingUP.value = false;
        patientProfile.value = updatedProfileModel;

        AlertHelper.showSnackbar(
          title: "تم بنجاح",
          message: "تم تحديث بيانات البروفايل بنجاح.",
          type: AlertType.success,
        );

        Get.back();
      },
    );
  }

  @override
  void onClose() {
    nameController.dispose();
    nickNameController.dispose();
    emailUpController.dispose();
    passwordUPController.dispose();
    confirmpasswordUPController.dispose();
    phone.dispose();
    dateOfBridth.dispose();
    super.onClose();
  }
}
