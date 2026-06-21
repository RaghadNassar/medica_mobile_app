import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:raghad_pro/core/constanse/string_manager.dart';
import 'package:raghad_pro/core/utilis/size_config.dart';
import 'package:raghad_pro/features/auth/controler/regester_controller.dart';

class SignUpProgressTracker extends GetView<RegisterController> {
  const SignUpProgressTracker({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Obx(() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildStepNode(
            isActive: controller.currentStep.value >= 0,
            title: StringManager.account.tr,
            theme: theme,
          ),
          Container(
            width: context.widthPct(0.18),
            height: context.heightPct(0.006),
            color: controller.currentStep.value == 1
                ? theme.primaryColor
                : theme.colorScheme.primaryContainer.withOpacity(0.2),
          ),
          _buildStepNode(
            isActive: controller.currentStep.value == 1,
            title: StringManager.personal.tr,
            theme: theme,
          ),
        ],
      );
    });
  }
}

Widget _buildStepNode({
  required bool isActive,
  required String title,
  required ThemeData theme,
}) {
  return Column(
    children: [
      AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isActive
              ? theme.primaryColor
              : theme.colorScheme.primaryContainer.withOpacity(0.5),
        ),
        child: Center(
          child: Icon(
            isActive ? Icons.check : Icons.circle,
            size: 12,
            color: theme.scaffoldBackgroundColor,
          ),
        ),
      ),
      const SizedBox(height: 4),
      Text(
        title,
        style: TextStyle(
          fontSize: 12,
          fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          color: isActive
              ? theme.primaryColor
              : theme.colorScheme.primaryContainer,
        ),
      ),
    ],
  );
}
