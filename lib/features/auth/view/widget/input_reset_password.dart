import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:raghad_pro/core/constanse/string_manager.dart';
import 'package:raghad_pro/core/helper/validation.dart';
import 'package:raghad_pro/core/widget/custom_text_filed.dart';
import 'package:raghad_pro/features/auth/controler/reset_password.dart';

class InputResetPassword extends GetView<ResetPasswordController> {
  const InputResetPassword({super.key});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: controller.formKey,
      child: Column(
        children: [
          // CustomTextFiled(
          //   labl: StringManager.email.tr,
          //   hinttext: StringManager.enterEmail.tr,
          //   prefixIcon: Icons.email_outlined,
          //   textInputType: TextInputType.emailAddress,
          //   textcontroler: controller.patientEmail,
          //   validate: (value) => Validator.validateEmail(value ?? ''),
          // ),
          const SizedBox(height: 16),
          Obx(() => CustomTextFiled(
                labl: StringManager.password.tr,
                hinttext: StringManager.enterPassword.tr,
                prefixIcon: Icons.lock_outline,
                suffixIcon: controller.isPasswordHidden.value
                    ? Icons.visibility_off
                    : Icons.visibility,
                textcontroler: controller.passwordController,
                obscureText: controller.isPasswordHidden.value,
                onTapSuffixIcon: () {
                  controller.togglePassword();
                },
                validate: (value) => Validator.validatePassword(value ?? ''),
              )),
          const SizedBox(height: 16),
          Obx(() => CustomTextFiled(
                labl: StringManager.confirm_password.tr,
                hinttext: StringManager.enterconfirm_password.tr,
                prefixIcon: Icons.lock_reset,
                suffixIcon: controller.isConfirmPasswordHidden.value
                    ? Icons.visibility_off
                    : Icons.visibility,
                textcontroler: controller.confirmPasswordController,
                obscureText: controller.isConfirmPasswordHidden.value,
                onTapSuffixIcon: () {
                  controller.toggleConfirmPassword();
                },
                validate: (value) => Validator.validateConfirmPassword(
                  value,
                  controller.passwordController.text,
                ),
              )),
        ],
      ),
    );
  }
}
