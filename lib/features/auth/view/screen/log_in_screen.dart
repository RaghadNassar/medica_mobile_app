import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:raghad_pro/core/constanse/string_manager.dart';
import 'package:raghad_pro/core/utilis/size_config.dart';
import 'package:raghad_pro/features/auth/view/widget/auth_logo_color.dart';
import 'package:raghad_pro/features/auth/view/widget/auth_scaffold.dart';
import 'package:raghad_pro/features/auth/view/widget/input_login.dart';
import 'package:raghad_pro/features/auth/view/widget/submit_logint.dart';
import 'package:raghad_pro/features/auth/view/widget/text_head_line.dart';


class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: context.heightPct(0.05)),
          const AuthLogoColorWidget(),
          SizedBox(height: context.heightPct(0.04)),
           CustomTextHeadLineWidget(title:StringManager.logIn.tr),
          SizedBox(height: context.heightPct(0.04)),
         const InputLogin(),
         const SubmitWidget(),

      
        ],
      ),
    );
  }
}
























































    // حقل البريد الإلكتروني
       /*   const CustomTextFiled(
            hinttext: "Username or Email",
            prefixIcon: Icons.person,
            textInputType: TextInputType.emailAddress,
          ),

          // حقل كلمة المرور
          const CustomTextFiled(
            hinttext: "Password",
            prefixIcon: Icons.lock,
            suffixIcon: Icons.visibility,
            obscureText: true,
          ),
*/
         /* CustomTextClickable(
            linkText: "Forgot Password?",
            alignment: Alignment.centerRight, // ليكون على اليمين كما في التصميم
            onTap: () {
              Get.toNamed(AppRoutes.forgotPassword);
            },
          ),

          SizedBox(height: context.heightPct(0.05)),

          // زر تسجيل الدخول (استخدام الكود الخاص بك)
          CustomBottomWidget(
            text: "Login",
            backgroundColor: Theme.of(context).primaryColor,
            colortext: Theme.of(context).colorScheme.surface,
            onTap: () {
              Get.toNamed(AppRoutes.home);
            },
          ),

          SizedBox(height: context.heightPct(0.05)),

          const SochialIconWidget(),

          SizedBox(height: context.heightPct(0.05)),

          CustomTextClickable(
            text: "Create An Account",
            linkText: "Sign Up",
            isUnderline: true, // تفعيل الخط السفلي هنا فقط
            onTap: () {
              Get.toNamed(AppRoutes.signUp);
            },
          ),
          SizedBox(height: context.heightPct(0.05)),*/
