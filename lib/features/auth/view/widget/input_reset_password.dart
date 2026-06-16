import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:raghad_pro/core/constanse/string_manager.dart';
import 'package:raghad_pro/core/helper/validation.dart';
import 'package:raghad_pro/core/widget/custom_text_filed.dart';
import 'package:raghad_pro/features/auth/controler/auth_logic.dart';

class InputResetPassword extends GetView<AuthLogic> {
  const InputResetPassword({super.key});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: controller.formKeyResetPassword,
      child: Column(
        children: [
          CustomTextFiled(
            labl: StringManager.email,
            hinttext: StringManager.enterEmail,
            prefixIcon: Icons.email_outlined,
            textInputType: TextInputType.emailAddress,
            textcontroler: controller.forgetEmailController,
            validate: (value) => Validator.validateEmail(value ?? ''),
          ),
          const SizedBox(height: 16),
          Obx(() => CustomTextFiled(
                labl: StringManager.password,
                hinttext: StringManager.enterPassword,
                prefixIcon: Icons.lock_outline,
                suffixIcon: controller.isResetPasswordHidden.value
                    ? Icons.visibility_off
                    : Icons.visibility,
                textcontroler: controller.resetPasswordController,
                obscureText: controller.isResetPasswordHidden.value,
                onTapSuffixIcon: () {
                  controller.toggleResetPasswordVisibility();
                },
                validate: (value) => Validator.validatePassword(value ?? ''),
              )),
          const SizedBox(height: 16),
          Obx(() => CustomTextFiled(
                labl: StringManager.confirm_password,
                hinttext: StringManager.enterconfirm_password,
                prefixIcon: Icons.lock_reset,
                suffixIcon: controller.isResetConfirmPasswordHidden.value
                    ? Icons.visibility_off
                    : Icons.visibility,
                textcontroler: controller.resetConfirmPasswordController,
                obscureText: controller.isResetConfirmPasswordHidden.value,
                onTapSuffixIcon: () {
                  controller.toggleResetConfirmPasswordVisibility();
                },
                validate: (value) => Validator.validateConfirmPassword(
                  value,
                  controller.resetPasswordController.text,
                ),
              )),
        ],
      ),
    );
  }
}
