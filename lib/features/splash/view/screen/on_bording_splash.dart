import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:raghad_pro/features/splash/controller/splash_logic.dart';
import 'package:raghad_pro/features/splash/view/widget/onboarding_body.dart';
import 'package:raghad_pro/features/splash/view/widget/onboarding_footer.dart';
import 'package:raghad_pro/features/splash/view/widget/onboarding_header.dart';

class OnboardingView extends GetView<SplashController> {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Obx(
          () => Column(
            children: [
              /// HEADER
              OnboardingHeader(
                currentIndex: controller.currentIndex.value,
                total: controller.pages.length,
              ),

              /// PAGES
              Expanded(
                child: PageView.builder(
                  controller: controller.pageController,
                  itemCount: controller.pages.length,
                  onPageChanged: controller.changePage,
                  itemBuilder: (context, index) {
                    final item = controller.pages[index];

                    return OnboardingBody(model: item);
                  },
                ),
              ),

              /// FOOTER
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
