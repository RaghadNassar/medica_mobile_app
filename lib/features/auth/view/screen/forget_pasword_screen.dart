import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:raghad_pro/core/constanse/app_route.dart';
import 'package:raghad_pro/core/constanse/string_manager.dart';
import 'package:raghad_pro/core/helper/validation.dart';
import 'package:raghad_pro/core/utilis/size_config.dart';
import 'package:raghad_pro/core/widget/custom_botton.dart';
import 'package:raghad_pro/core/widget/custom_text_filed.dart';
import 'package:raghad_pro/features/auth/controler/forget_password.dart';
import 'package:raghad_pro/features/auth/view/widget/auth_scaffold.dart';
import 'package:raghad_pro/features/auth/view/widget/text_head_line.dart';

class ForgetPaswordScreen extends GetView<ForgetPasswordController> {
  const ForgetPaswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      child: Form(
        key: controller.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //  SizedBox(height: context.heightPct(0.05)),
            // const AuthLogoColorWidget(),
            SizedBox(height: context.heightPct(0.1)),
            CustomTextHeadLineWidget(title: StringManager.forgetPassword.tr),
            SizedBox(height: context.heightPct(0.042)),
            Text(
              StringManager.forgetPssword.tr,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            SizedBox(height: context.heightPct(0.005)),
            CustomTextFiled(
              hinttext: StringManager.enterEmail.tr,
              prefixIcon: Icons.email_outlined,
              textInputType: TextInputType.emailAddress,
              textcontroler: controller.emailController,
              validate: (value) => Validator.validateEmail(value ?? ''),
            ),
            SizedBox(height: context.heightPct(0.04)),
            // Text(
            //   StringManager.forgetPssword.tr,
            //   style: Theme.of(context).textTheme.bodyMedium,
            // ),
            //  SizedBox(height: context.heightPct(0.05)),
             Obx(() => controller.isLoading.value
                ? const Center(child: CircularProgressIndicator())
                : CustomBottomWidget(
                    text: StringManager.submit.tr,
                    backgroundColor: Theme.of(context).primaryColor,
                    colortext: Theme.of(context).colorScheme.surface,
                    onTap: () {
                      controller.forgetPassword();
                    },
                  )),
            // CustomBottomWidget(
            //   text: StringManager.submit.tr,
            //   backgroundColor: Theme.of(context).primaryColor,
            //   colortext: Theme.of(context).colorScheme.surface,
            //   onTap: () {
            //     Get.toNamed(AppRoutes.verficationCode);
            //   },
            // ),
            SizedBox(height: context.heightPct(0.05)),
          ],
        ),
      ),
    );
  }
}






















/*
class ForgetPaswordScreen extends GetView<AuthLogic> {
  const ForgetPaswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: context.heightPct(0.05)),
          // استخدام CustomText للعنوان
          const AuthLogoColorWidget(),
          SizedBox(height: context.heightPct(0.1)),
          const CustomTextHeadLineWidget(title: 'Forgot Password?'),
          SizedBox(height: context.heightPct(0.055)),
          // الـ Toggle المخصص (Reusable)
          Obx(() => CustomToggleSwitch(
                labels: const ["Email", "Phone"],
                selectedIndex: controller.selectedIndex.value,
                onSelect: (index) => controller.changeIndex(index),
              )),
          SizedBox(height: context.heightPct(0.02)),
          Obx(() => _buildInputField(controller.selectedIndex.value)),

          SizedBox(height: context.heightPct(0.04)),

          Text(StringManager.forgetPssword , style: Theme.of(context).textTheme.bodyMedium,),

          SizedBox(height: context.heightPct(0.05)),

          // زر تسجيل الدخول (استخدام الكود الخاص بك)
          CustomBottomWidget(
            text: StringManager.submit,
            backgroundColor: Theme.of(context).primaryColor,
            colortext: Theme.of(context).colorScheme.surface,
            onTap: () {
              Get.toNamed(AppRoutes.verficationCode);
            },
          ),

          SizedBox(height: context.heightPct(0.5)),
        ],
      ),
    );
  }
}

//input filed
Widget _buildInputField(int index) {
  if (index == 0) {
    return const CustomTextFiled(
      hinttext: "Enter your Email",
      prefixIcon: Icons.email_outlined,
      textInputType: TextInputType.emailAddress,
    );
  } else {
    return const CustomTextFiled(
      hinttext: "Enter your Phone Number",
      prefixIcon: Icons.phone,
      textInputType: TextInputType.phone,
    );
  }
}
*/