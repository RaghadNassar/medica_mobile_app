import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:raghad_pro/core/constanse/app_spacing.dart';
import 'package:raghad_pro/core/constanse/string_manager.dart';
import 'package:raghad_pro/core/helper/validation.dart';
import 'package:raghad_pro/core/utilis/size_config.dart';
import 'package:raghad_pro/core/widget/custom_botton.dart';
import 'package:raghad_pro/core/widget/custom_text_filed.dart';
import 'package:raghad_pro/features/profile/controller/profile_controller.dart';

class ChangePasswordCard extends StatelessWidget {
  final ProfileController controller;

  const ChangePasswordCard({super.key, Skinner, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: AppSpacing.screenPadding5,
      decoration: BoxDecoration(
        color:Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Obx(() => CustomTextFiled(
                labl: StringManager.currentPassword.tr,
                hinttext: StringManager.enterPassword.tr,
                prefixIcon: Icons.lock_outline,
                suffixIcon: controller.isPasswordHiddenUp.value ? Icons.visibility_off : Icons.visibility,
                textcontroler: controller.currentPasswordController,
                obscureText: controller.isPasswordHiddenUp.value,
                onTapSuffixIcon: () => controller.togglePasswordVisibilityUp(),
                validate: (value) {
                  if (value == null || value.isEmpty) {
                    return StringManager.enterPassword.tr; 
                  }
                  return Validator.validatePassword(value);
                },
              )),
          SizedBox(height:context.heightPct(0.01)),

          
          Obx(() => CustomTextFiled(
                labl: StringManager.password.tr,
                hinttext: StringManager.enterPassword.tr,
                prefixIcon: Icons.lock_outline,
                suffixIcon: controller.isPasswordHiddenUp.value ? Icons.visibility_off : Icons.visibility,
                textcontroler: controller.passwordUPController,
                obscureText: controller.isPasswordHiddenUp.value,
                onTapSuffixIcon: () => controller.togglePasswordVisibilityUp(),
                validate: (value) {
                  if (value == null || value.isEmpty) {
                    return StringManager.enterPassword.tr;
                  }
                  return Validator.validatePassword(value);
                },
              )),
         SizedBox(height:context.heightPct(0.01)),

          
          Obx(() => CustomTextFiled(
                labl: StringManager.confirm_password.tr,
                hinttext: StringManager.enterconfirm_password.tr,
                prefixIcon: Icons.lock_outline,
                suffixIcon: controller.isPasswordHiddenUp.value ? Icons.visibility_off : Icons.visibility,
                textcontroler: controller.confirmpasswordUPController,
                obscureText: controller.isPasswordHiddenUp.value,
                onTapSuffixIcon: () => controller.togglePasswordVisibilityUp(),
                validate: (value) {
                  if (value == null || value.isEmpty) {
                    return StringManager.enterconfirm_password.tr;
                  }
                  return Validator.validateConfirmPassword(
                    value, 
                    controller.passwordUPController.text,
                  );
                },
              )),
           SizedBox(height:context.heightPct(0.01)),
          Obx(() {
            return controller.isLoadingUP.value
                ? const Center(child: CircularProgressIndicator())
                : CustomBottomWidget(
                    text: "تحديث كلمة المرور", 
                    backgroundColor: Theme.of(context).primaryColor,
                    colortext: Theme.of(context).colorScheme.surface,
                    onTap: () => controller.updateProfileFinal(),
                  );
          }),
        ],
      ),
    );
  }
}