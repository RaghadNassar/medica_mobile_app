import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:raghad_pro/core/constanse/string_manager.dart';
import 'package:raghad_pro/core/utilis/size_config.dart';
import 'package:raghad_pro/features/auth/controler/auth_logic.dart';
import 'package:raghad_pro/features/auth/view/widget/auth_scaffold.dart';
import 'package:raghad_pro/features/auth/view/widget/input_regester.dart';
import 'package:raghad_pro/features/auth/view/widget/submit_sign_up.dart';
import 'package:raghad_pro/features/auth/view/widget/text_head_line.dart';

class RegesterScreen extends GetView<AuthLogic> {
  const RegesterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // SizedBox(height: context.heightPct(0.05)),
          // const AuthLogoColorWidget(),
          SizedBox(height: context.heightPct(0.02)),
          const CustomTextHeadLineWidget(title: StringManager.signup),
          SizedBox(height: context.heightPct(0.04)),
           const InputRegester(),
          SizedBox(height: context.heightPct(0.05)),
            const SubmitSignUp(),
       
        
        ],
      ),
    );
  }
}
/*
  // حقل البريد الإلكتروني
          const CustomTextFiled(
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
          const CustomTextFiled(
            hinttext: "Confirm Password",
            prefixIcon: Icons.lock,
            suffixIcon: Icons.visibility,
            obscureText: true,
          ),
*/