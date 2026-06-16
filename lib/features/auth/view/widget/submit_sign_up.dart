import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:raghad_pro/core/constanse/app_spacing.dart';
import 'package:raghad_pro/core/constanse/string_manager.dart';
import 'package:raghad_pro/core/utilis/size_config.dart';
import 'package:raghad_pro/core/widget/custom_botton.dart';
import 'package:raghad_pro/features/auth/controler/auth_logic.dart';
import 'package:raghad_pro/features/auth/view/widget/text_click.dart';

class SubmitSignUp extends GetView<AuthLogic> {
  const SubmitSignUp({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Obx(() {
          return controller.isLoadingUP.value
              ? const Center(
                  child: Padding(
                    padding: AppSpacing.vertical8,
                    child: CircularProgressIndicator(),
                  ),
                )
              : CustomBottomWidget(
                  text: StringManager.signup,
                  backgroundColor: Theme.of(context).primaryColor,
                  colortext: Theme.of(context).colorScheme.surface,
                  onTap: () {
                    controller.register();
                  },
                );
        }),

        SizedBox(height: context.heightPct(0.05)),

        // قسم التواصل الاجتماعي
        // const SochialIconWidget(),

        // SizedBox(height: context.heightPct(0.05)),

        CustomTextClickable(
          text: StringManager.alreadyhaveaccount,
          linkText: StringManager.signin,
          isUnderline: true,
          onTap: () {
           
            // context.push(AppRoutes.signUp);
          },
        ),
        SizedBox(height: context.heightPct(0.05)),
      ],
    );
  }
}
