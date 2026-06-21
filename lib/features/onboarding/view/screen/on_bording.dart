import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:raghad_pro/features/onboarding/controller/onboarding_logic.dart';
import 'package:raghad_pro/features/onboarding/view/widget/onboarding_body.dart';
import 'package:raghad_pro/features/onboarding/view/widget/onboarding_footer.dart';
import 'package:raghad_pro/features/onboarding/view/widget/onboarding_header.dart';
class OnboardingView extends GetView<OnboardingController> {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Obx(
          () => Column(
            children: [
            
              OnboardingHeader(
                currentIndex: controller.currentIndex.value,
                total: controller.pages.length,
                onSkip: controller.skip,
              ),

              Expanded(
                child: PageView.builder(
                  controller: controller.pageController,
                  itemCount: controller.pages.length,
                  onPageChanged: controller.changePage,
                  itemBuilder: (context, index) {
                    return OnboardingBody(model: controller.pages[index]);
                  },
                ),
              ),

              OnboardingFooter(
                currentIndex: controller.currentIndex.value,
                total: controller.pages.length,
                onNext: controller.nextPage,
              ),
            ],
          ),
        ),
      ),
    );
  }
}