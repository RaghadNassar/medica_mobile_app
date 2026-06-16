import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:raghad_pro/core/api/end_point.dart';
import 'package:raghad_pro/core/cache/cashe_helper_getStorage.dart';
import 'package:raghad_pro/core/constanse/app_assets.dart';
import 'package:raghad_pro/core/constanse/app_route.dart';
import 'package:raghad_pro/features/splash/model/splash_model.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    checkAuthAndNavigate();
  }

  Future<void> checkAuthAndNavigate() async {
    await Future.delayed(const Duration(seconds: 3));

    final bool isLoggedIn =
        CacheHelperGetStorage.getData(key: ApiKey.accessToken) != null;

    if (isLoggedIn) {
      Get.offAllNamed(AppRoutes.home);
    } else {
      Get.offAllNamed(AppRoutes.onboarding);
    }
  }

  final PageController pageController = PageController();

  // RxInt = observable
  final RxInt currentIndex = 0.obs;

  final List<OnboardingModel> pages = [
    OnboardingModel(
      image: Appassets.onboarding1,
      title: 'Book Doctors Easily',
      description: 'Find the best doctors and book appointments quickly.',
    ),
    OnboardingModel(
      image: Appassets.onboarding2,
      title: 'Track Your Health',
      description: 'Manage prescriptions, appointments and medical history.',
    ),
    OnboardingModel(
      image: Appassets.onboarding3,
      title: 'Connected Healthcare',
      description: 'Stay connected with clinics and specialists anytime.',
    ),
  ];

  void changePage(int index) {
    currentIndex.value = index;
  }

  void nextPage() {
    if (currentIndex.value < pages.length - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      Get.offAllNamed(AppRoutes.goAuth);
    }
  }

  void skip() {
    Get.offAllNamed(AppRoutes.goAuth);
  }

  @override
  void onClose() {
    pageController.dispose();

    super.onClose();
  }
}
