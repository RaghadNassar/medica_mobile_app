import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:raghad_pro/core/constanse/string_manager.dart';
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
          Row(
            children: List.generate(
              total,
              (index) => CustomIndicator(
                isActive: index == currentIndex,
              ),
            ),
          ),
          TextButton(
            onPressed: onNext,
            child: Text(
              isLastPage ? StringManager.getStarted.tr : StringManager.next.tr,
              style: const TextStyle(
                color: AppColors.primaryTeal,
                fontSize: 20,
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
  final Color activeColor;   
  final Color ?inactiveColor;

  const CustomIndicator({
    super.key,
    required this.isActive,
    this.activeColor =AppColors.primaryTeal,
    this.inactiveColor, 
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      height: 8, 
      width: isActive ? 24 : 8,
      decoration: BoxDecoration(
        color: isActive ? activeColor : AppColors.primaryTeal.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}