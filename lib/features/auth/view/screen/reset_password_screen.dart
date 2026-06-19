import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:raghad_pro/core/constanse/string_manager.dart';
import 'package:raghad_pro/core/theme/app_colors.dart';
import 'package:raghad_pro/core/utilis/size_config.dart';
import 'package:raghad_pro/core/widget/custom_botton.dart';
import 'package:raghad_pro/features/auth/controler/auth_logic.dart';
import 'package:raghad_pro/features/auth/view/widget/auth_logo_color.dart';
import 'package:raghad_pro/features/auth/view/widget/auth_scaffold.dart';
import 'package:raghad_pro/features/auth/view/widget/input_reset_password.dart';
import 'package:raghad_pro/features/auth/view/widget/text_head_line.dart';

class ResetPasswordScreen extends GetView<AuthLogic> {
  const ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: context.heightPct(0.05)),
          const Center(child:  Icon(Icons.lock_reset_outlined,color: AppColors.primaryTeal,size: 130,)),
          //const AuthLogoColorWidget(),
          SizedBox(height: context.heightPct(0.04)),
          const CustomTextHeadLineWidget(title: StringManager.resetPassword),
          SizedBox(height: context.heightPct(0.04)),
          const InputResetPassword(),
          SizedBox(height: context.heightPct(0.04)),
          Obx(() {
            return controller.isResetPasswordLoading.value
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: CircularProgressIndicator(),
                    ),
                  )
                : CustomBottomWidget(
                    text: StringManager.reset,
                    backgroundColor: Theme.of(context).primaryColor,
                    colortext: Theme.of(context).colorScheme.surface,
                    onTap: () async {
                      await controller.resetPassword();
                    },
                  );
          }),
        ],
      ),
    );
  }
}
