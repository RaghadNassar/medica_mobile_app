import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:raghad_pro/core/constanse/app_assets.dart';
import 'package:raghad_pro/core/constanse/app_route.dart';
import 'package:raghad_pro/core/constanse/string_manager.dart';
import 'package:raghad_pro/features/onboarding/model/onboarding_model.dart';

class OnboardingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OnboardingController>(
      () => OnboardingController(),
    );
  }
}

class OnboardingController extends GetxController {
  final PageController pageController = PageController();
  final RxInt currentIndex = 0.obs;

  List<OnboardingModel> get pages => [
        OnboardingModel(
          image: Appassets.onboarding3,
          title: StringManager.onboardingTitle1.tr,
          description: StringManager.onboardingDesc1.tr,
        ),
        OnboardingModel(
          image: Appassets.onboarding2,
          title: StringManager.onboardingTitle2.tr,
          description: StringManager.onboardingDesc2.tr,
        ),
        OnboardingModel(
          image: Appassets.onboarding1,
          title: StringManager.onboardingTitle3.tr,
          description: StringManager.onboardingDesc3.tr,
        ),
      ];

  void changePage(int index) => currentIndex.value = index;

  void nextPage() {
    if (currentIndex.value < pages.length - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      skip();
    }
  }

  void skip() => Get.offAllNamed(AppRoutes.goAuth);

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
