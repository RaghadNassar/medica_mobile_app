import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:raghad_pro/core/constanse/app_route.dart';
import 'package:raghad_pro/core/constanse/string_manager.dart';
import 'package:raghad_pro/core/utilis/size_config.dart';
import 'package:raghad_pro/core/widget/custom_botton.dart';
import 'package:raghad_pro/features/auth/controler/auth_logic.dart';
import 'package:raghad_pro/features/auth/view/widget/sochial_icon.dart';
import 'package:raghad_pro/features/auth/view/widget/text_click.dart';

class SubmitWidget extends GetView<AuthLogic> {
  const SubmitWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomTextClickable(
          linkText: StringManager.forgetPassword,
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
                  text: StringManager.Login,
                  backgroundColor: Theme.of(context).primaryColor,
                  colortext: Theme.of(context).colorScheme.surface,
                  onTap: () async {
                    await controller.login();
                    print('sucess');
                  },
                );
        }),

        SizedBox(height: context.heightPct(0.05)),

        const SochialIconWidget(),

        SizedBox(height: context.heightPct(0.05)),

        CustomTextClickable(
          text: StringManager.createAnAccount,
          linkText: StringManager.signup,
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
