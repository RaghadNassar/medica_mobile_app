import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:raghad_pro/core/constanse/string_manager.dart';
import 'package:raghad_pro/core/helper/validation.dart';
import 'package:raghad_pro/core/widget/custom_text_filed.dart';
import 'package:raghad_pro/features/auth/controler/login_controller.dart';

class InputLogin extends GetView<LoginController> {
  const InputLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return Form(
      key:controller.formKey,
      child: Column(
        children:[
             CustomTextFiled(
             labl : StringManager.email.tr,
              hinttext: StringManager.enterEmail.tr,
              prefixIcon: Icons.person,
              textInputType: TextInputType.emailAddress,
              textcontroler: controller.emailController,
              validate: (value) => Validator.validateEmail(value ?? ''),
            ),
                   Obx(() => CustomTextFiled(
            labl: StringManager.password.tr,
            hinttext: StringManager.enterPassword.tr,
            prefixIcon: Icons.lock,
            suffixIcon: controller.isPasswordHidden.value 
                ? Icons.visibility_off 
                : Icons.visibility,
                
            textcontroler: controller.passwordController,
            validate: (value) => Validator.validatePassword(value ?? ''),
            obscureText: controller.isPasswordHidden.value,
            onTapSuffixIcon: () {
              controller.togglePassword();
            },)),
        ]
      ),
    );
  }
}