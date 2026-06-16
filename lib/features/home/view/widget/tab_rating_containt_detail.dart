import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:raghad_pro/core/constanse/string_manager.dart';
import 'package:raghad_pro/core/theme/app_colors.dart';
import 'package:raghad_pro/core/utilis/size_config.dart';
import 'package:raghad_pro/features/auth/view/widget/text_click.dart'; // تعديل المسار لـ CustomTextClickable حسب مشروعك
import 'package:raghad_pro/features/home/controller/home_controller.dart';

class TabRatingContent extends GetView<HomeController> {
  const TabRatingContent({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          StringManager.rateDoctor, 
          style: theme.textTheme.bodyMedium?.copyWith(fontSize: 16, fontWeight: FontWeight.bold)
        ),
        SizedBox(height: context.heightPct(0.02)),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (index) {
            final starValue = index + 1;
            return Obx(() => IconButton(
              onPressed: controller.isRatingLoading.value 
                  ? null
                  : () => controller.userRating.value = starValue.toDouble(),
              icon: Icon(
                starValue <= controller.userRating.value ? Icons.star_rounded : Icons.star_border_rounded,
                color: AppColors.warning,
                size: 40,
              ),
            ));
          }),
        ),
        SizedBox(height: context.heightPct(0.05)),
        Obx(() {
          final hasRated = controller.userRating.value > 0.0;
          final isLoading = controller.isRatingLoading.value;

          if (isLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppColors.primaryTeal,
              ),
            );
          }

          return IgnorePointer(
            ignoring: !hasRated,
            child: Opacity(
              opacity: hasRated ? 1.0 : 0.4,
              child: CustomTextClickable(
                linkText: StringManager.send,
                alignment: Alignment.center,
                onTap: () => controller.submitRating(), 
              ),
            ),
          );
        }),
      ],
    );
  }
}

//  هاد كان واجهة بس 
/*
class TabRatingContent extends GetView<HomeController> {
  const TabRatingContent({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(StringManager.rateDoctor, style: theme.textTheme.bodyMedium?.copyWith(fontSize: 16, fontWeight: FontWeight.bold)),
        SizedBox(height: context.heightPct(0.02)),
        
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (index) {
            final starValue = index + 1;
            return Obx(() => IconButton(
              onPressed: () => controller.userRating.value = starValue.toDouble(),
              icon: Icon(
                starValue <= controller.userRating.value ? Icons.star_rounded : Icons.star_border_rounded,
                color: AppColors.warning,
                size: 40,
              ),
            ));
          }),
        ),
        SizedBox(height: context.heightPct(0.05)),
      
        Obx(() {
          final hasRated = controller.userRating.value > 0.0;
          return IgnorePointer(
            ignoring: !hasRated,
            child: Opacity(
              opacity: hasRated ? 1.0 : 0.4,
              child: CustomTextClickable(
                linkText: StringManager.send,
                alignment: Alignment.center,
                onTap: () {}, // استدعاء دالة الإرسال من الكنترولر هنا
              ),
            ),
          );
        }),
      ],
    );
  }
}*/