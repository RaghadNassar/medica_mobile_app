import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:raghad_pro/core/constanse/string_manager.dart';
import 'package:raghad_pro/core/theme/app_colors.dart';
import 'package:raghad_pro/core/utilis/size_config.dart';
import 'package:raghad_pro/core/widget/custom_botton.dart';
import 'package:raghad_pro/features/auth/controler/otp_controller.dart';
import 'package:raghad_pro/features/auth/view/widget/text_click.dart';
import 'package:raghad_pro/features/onboarding/model/onboarding_model.dart';
import 'package:raghad_pro/features/onboarding/view/widget/onboarding_body.dart';
class VerificationCodeScreen extends GetView<OtpController> {
  const VerificationCodeScreen({super.key});

  @override
  Widget build(BuildContext context) {
  //  controller.patientEmail = Get.arguments ?? "";

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        iconTheme: Theme.of(context).iconTheme, 
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: context.widthPct(0.06)),
        child: SingleChildScrollView(
          child: Column(
           // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: context.heightPct(0.05)),
              const Icon(Icons.lock,color: AppColors.primaryTeal,size: 120,),
              SizedBox(height: context.heightPct(0.05)),
              OnboardingBody(
                model: OnboardingModel(
                  title: StringManager.enterotp.tr,
                  description: StringManager.otpEmailDesc.tr
                      .replaceAll('%s', controller.patientEmail),
                ),
              ),
              SizedBox(height: context.heightPct(0.05)),

             
              Center(
                child: Pinput(
                  length: 6, 
                  controller: controller.otpController, 
                  defaultPinTheme: _getPinTheme(context, isSelected: false),
                  focusedPinTheme: _getPinTheme(context, isSelected: true),
                  submittedPinTheme: _getPinTheme(context, isSubmitted: true),
                  onCompleted: (pin) {
                    controller.verifyOtp(); 
                  },
                ),
              ),

              SizedBox(height: context.heightPct(0.06)),
              Obx(() => controller.isLoading.value
                  ? const Center(child: CircularProgressIndicator())
                  : CustomBottomWidget(
                      text: StringManager.verfiey.tr,
                      backgroundColor: Theme.of(context).primaryColor,
                      colortext: Theme.of(context).colorScheme.onPrimary, 
                      onTap: () {
                        controller.verifyOtp(); 
                      },
                    )),

              SizedBox(height: context.heightPct(0.03)),

              _buildResendSection(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResendSection(BuildContext context) {
    return CustomTextClickable(
      text: StringManager.Didntreceivethecode.tr,
      linkText: StringManager.resend.tr,
      onTap: () {
       
        controller.resendOtp(); 
      },
    );
  }

  PinTheme _getPinTheme(BuildContext context,
      {bool isSelected = false, bool isSubmitted = false}) {
    final theme = Theme.of(context);
    final double boxSize = context.widthPct(0.13); 

    return PinTheme(
      width: boxSize,
      height: context.widthPct(0.15),
      textStyle: theme.textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.bold,
        color: theme.colorScheme.primary,
      ),
      decoration: BoxDecoration(
        color: isSubmitted
            ? theme.colorScheme.surface.withOpacity(0.7)
            : theme.colorScheme.surface.withOpacity(0.9),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: theme.colorScheme.primary,
          width: isSelected ? 2 : 1,
        ),
      ),
    );
  }
}


































/*
class VerificationCodeScreen extends StatelessWidget {
  const VerificationCodeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        iconTheme:
            Theme.of(context).iconTheme, 
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: context.widthPct(0.06)),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: context.heightPct(0.1)),
              OnboardingBody(
                  model: OnboardingModel(
                      title: "Enter Verification Code",
                      description:
                          "Enter code that we have sent to your number 08528188***")),
              SizedBox(height: context.heightPct(0.05)),

              // قسم الـ OTP
              Center(
                child: Pinput(
                  length: 4,
                  defaultPinTheme: _getPinTheme(context, isSelected: false),
                  focusedPinTheme: _getPinTheme(context, isSelected: true),
                  submittedPinTheme: _getPinTheme(context, isSubmitted: true),
                  onCompleted: (pin) {
                    // Logic here
                  },
                ),
              ),

              SizedBox(height: context.heightPct(0.05)),

              CustomBottomWidget(
                text: "Verify",
                backgroundColor: Theme.of(context).primaryColor,
                colortext: Theme.of(context)
                    .colorScheme
                    .onPrimary, // لضمان تباين اللون في الحالتين
                onTap: () {
                  // Navigation Logic
                  Get.toNamed(AppRoutes.home);
                },
              ),

              SizedBox(height: context.heightPct(0.03)),

              _buildResendSection(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResendSection(BuildContext context) {
    return CustomTextClickable(
      text: "Didn't receive the code?",
      linkText: "Resend",
      onTap: () {
        // Resend logic
      },
    );
  }

  // --- Logic-Based UI Styling (Clean Code) ---

  PinTheme _getPinTheme(BuildContext context,
      {bool isSelected = false, bool isSubmitted = false}) {
    final theme = Theme.of(context);

    final double boxSize = context.widthPct(0.18);

    return PinTheme(
      width: boxSize,
      height: boxSize,
      textStyle: theme.textTheme.headlineSmall?.copyWith(
        fontWeight: FontWeight.bold,
        color: Theme.of(context).colorScheme.primary,
      ),
      decoration: BoxDecoration(
        color: isSubmitted
            ? theme.colorScheme.surface.withOpacity(0.7)
            : theme.colorScheme.surface.withOpacity(0.9),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: isSelected
              ? theme.colorScheme.primary
              : theme.colorScheme.primary, // Border color من الثيم
          width: isSelected ? 2 : 1,
        ),
      ),
    );
  }
}*/
