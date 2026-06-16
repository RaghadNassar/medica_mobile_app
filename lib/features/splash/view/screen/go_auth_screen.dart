import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:raghad_pro/core/constanse/app_assets.dart';
import 'package:raghad_pro/core/constanse/app_route.dart';
import 'package:raghad_pro/core/theme/app_colors.dart';
import 'package:raghad_pro/core/utilis/size_config.dart';
import 'package:raghad_pro/core/widget/custom_botton.dart';
import 'package:raghad_pro/features/splash/model/splash_model.dart';
import 'package:raghad_pro/features/splash/view/widget/app_logo.dart';
import 'package:raghad_pro/features/splash/view/widget/onboarding_body.dart';

class GoAuthScreen extends StatelessWidget {
  const GoAuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:Theme.of(context).scaffoldBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(flex: 4),
            AppLogoWithText(
              imageLogo: Appassets.logoSecondry,
              colorImage: AppColors.primaryTeal,
              style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryTeal,
                  ),
            ),
             SizedBox(height: context.heightPct(0.1)),
            
           OnboardingBody(
              model: OnboardingModel(
                //image: Appassets.logoSecondry,
                title: "Let’s get started!",
                description: "Login to enjoy the features we’ve provided, and stay healthy!.",
              ),
            ),
            SizedBox(height: context.heightPct(0.07)),
            // زر تسجيل الدخول (Login)
            CustomBottomWidget(
              text: "Login",
              onTap: () => Get.toNamed(AppRoutes.login),
              backgroundColor: AppColors.primaryTeal,
              textColor: AppColors.lightSurface, colortext: AppColors.lightSurface,
            ),
             SizedBox(height: context.heightPct(0.02)),
            // زر إنشاء حساب (Sign Up) - اللون الأبيض بحدود
            CustomBottomWidget(
              text: "Sign Up",
              onTap: () => Get.toNamed(AppRoutes.signUp),
              backgroundColor:Theme.of(context).colorScheme.surface,
              textColor: AppColors.primaryTeal,
              border: Border.all(color: AppColors.primaryTeal, width: 1.5), colortext:  AppColors.primaryTeal,
            ),
            const Spacer(flex: 5),
          ],
        ),
      ),
    );
  }
}