import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:raghad_pro/core/constanse/app_route.dart';
import 'package:raghad_pro/core/constanse/string_manager.dart';
import 'package:raghad_pro/core/utilis/size_config.dart';
import 'package:raghad_pro/core/widget/custom_botton.dart';
import 'package:raghad_pro/features/auth/controler/login_controller.dart';
import 'package:raghad_pro/features/auth/view/widget/sochial_icon.dart';
import 'package:raghad_pro/features/auth/view/widget/text_click.dart';

class SubmitWidget extends GetView<LoginController> {
  const SubmitWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomTextClickable(
          linkText: StringManager.forgetPassword.tr,
          alignment: Alignment.centerRight,
          onTap: () {
            Get.toNamed(AppRoutes.forgotPassword);
          },
        ),
        SizedBox(height: context.heightPct(0.05)),
        Obx(() {
          return controller.isLoading.value
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: CircularProgressIndicator(),
                  ),
                )
              : CustomBottomWidget(
                  text: StringManager.Login.tr,
                  backgroundColor: Theme.of(context).primaryColor,
                  colortext: Theme.of(context).colorScheme.surface,
                  onTap: () async {
                    await controller.login();
                  },
                );
        }),

       // SizedBox(height: context.heightPct(0.05)),

      //  const SochialIconWidget(),

        SizedBox(height: context.heightPct(0.05)),

        CustomTextClickable(
          text: StringManager.createAnAccount.tr,
          linkText: StringManager.signup.tr,
          isUnderline: true, 
          onTap: () {
            Get.toNamed(AppRoutes.signUp);
          },
        ),
        SizedBox(height: context.heightPct(0.05)),
      ],
    );
  }
}
