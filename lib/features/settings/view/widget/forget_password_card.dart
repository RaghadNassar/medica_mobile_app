import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:raghad_pro/core/constanse/app_route.dart';
import 'package:raghad_pro/core/constanse/app_spacing.dart';
import 'package:raghad_pro/core/constanse/string_manager.dart';
import 'package:raghad_pro/core/theme/app_colors.dart';
import 'package:raghad_pro/core/utilis/size_config.dart';
import 'package:raghad_pro/core/widget/custom_botton.dart';

class ForgotPasswordCard extends StatelessWidget {
  const ForgotPasswordCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppSpacing.screenPadding5,
      width: double.infinity,
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
          Text(
            StringManager.forgetPassword.tr,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          SizedBox(height: context.heightPct(0.01)),
          Text(
            StringManager.ifYouDontRemember.tr,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context)
                      .colorScheme
                      .primaryContainer
                      .withOpacity(0.8),
                  height: 1.4,
                ),
          ),
          SizedBox(height: context.heightPct(0.01)),
          CustomBottomWidget(
            text: StringManager.forgetPassword.tr,
            onTap: () => Get.toNamed(AppRoutes.login),
            backgroundColor: Theme.of(context).colorScheme.surface,
            textColor: AppColors.primaryTeal,
            border: Border.all(color: AppColors.primaryTeal, width: 1.5),
            colortext: AppColors.primaryTeal,
          ),
        ],
      ),
    );
  }
}
