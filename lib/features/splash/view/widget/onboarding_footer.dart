import 'package:flutter/material.dart';
import 'package:raghad_pro/core/theme/app_colors.dart';

class OnboardingFooter extends StatelessWidget {

  final int currentIndex;
  final int total;
  final VoidCallback onNext;

  const OnboardingFooter({
    super.key,
    required this.currentIndex,
    required this.total,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {

    final bool isLastPage = currentIndex == total - 1;

    return Padding(

      padding: const EdgeInsets.all(20),

      child: Row(

        mainAxisAlignment: MainAxisAlignment.spaceBetween,

        children: [

          /// Indicators
          Row(

            children: List.generate(

              total,

              (index) => CustomIndicator(
                isActive: index == currentIndex,
              ),
            ),
          ),

          /// Button
          TextButton(

            onPressed: onNext,

            child: Text(

              isLastPage
                  ? "Get Started"
                  : "Next",
                   style: const TextStyle(
                color: AppColors.primaryTeal, 
                fontSize: 18, 
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}


class CustomIndicator extends StatelessWidget {
  final bool isActive;
  final Color activeColor;   // اللون عند التفعيل
  final Color inactiveColor; // اللون عند الخمول

  const CustomIndicator({
    super.key,
    required this.isActive,
    this.activeColor =AppColors.primaryTeal, // الافتراضي زهري كما في الصورة
    this.inactiveColor = AppColors.lightTextSecondary, // الافتراضي رمادي فاتح
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      height: 8, // ثبتنا الارتفاع ليكون متناسقاً
      width: isActive ? 24 : 8,
      decoration: BoxDecoration(
        color: isActive ? activeColor : inactiveColor,
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}