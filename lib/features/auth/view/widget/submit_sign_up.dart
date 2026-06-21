import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:raghad_pro/core/constanse/string_manager.dart';
import 'package:raghad_pro/core/utilis/size_config.dart';
import 'package:raghad_pro/core/widget/custom_botton.dart';
import 'package:raghad_pro/features/auth/controler/regester_controller.dart';
import 'package:raghad_pro/features/auth/view/widget/text_click.dart';

class SubmitSignUp extends GetView<RegisterController> {
  const SubmitSignUp({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Obx(() {
      final isStepOne = controller.currentStep.value == 0;

      return Column(
        children: [
          if (isStepOne)
            
            CustomBottomWidget(
              text: StringManager.next.tr,
              backgroundColor: theme.primaryColor,
              colortext: theme.colorScheme.surface,
              onTap: () => controller.nextStep(),
            )
          else
            
            Column(
              children: [
                controller.isLoading.value
                    ? const Center(child: CircularProgressIndicator())
                    : CustomBottomWidget(
                        text: StringManager.signup.tr,
                        backgroundColor: theme.primaryColor,
                        colortext: theme.colorScheme.surface,
                        onTap: () => controller.register(), 
                      ),
                SizedBox(height: context.heightPct(0.015)),
                
                TextButton(
                  onPressed: () => controller.previousStep(),
                  child: Text(
                    StringManager.back.tr,
                    style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),

          SizedBox(height: context.heightPct(0.03)),
          
          CustomTextClickable(
            text: StringManager.alreadyhaveaccount.tr,
            linkText: StringManager.signin.tr,
            isUnderline: true,
            onTap: () {
              Get.back(); 
            },
          ),
        ],
      );
    });
  }
}








































/*
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
*/