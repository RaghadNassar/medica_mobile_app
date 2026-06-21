import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:raghad_pro/core/constanse/string_manager.dart';
class OnboardingHeader extends StatelessWidget {
  final int currentIndex;
  final int total;
  final VoidCallback onSkip;

  const OnboardingHeader({
    super.key,
    required this.currentIndex,
    required this.total,
    required this.onSkip,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "${currentIndex + 1}/$total",
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          GestureDetector(
            onTap: onSkip,
            child: Text(
              StringManager.skip.tr, 
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
        ],
      ),
    );
  }
}