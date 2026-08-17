import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:raghad_pro/core/utilis/size_config.dart';
import 'package:raghad_pro/features/home/controller/home_controller.dart';
import 'package:raghad_pro/features/home/view/widget/bannar_indicator.dart';
import 'package:raghad_pro/features/home/view/widget/bannar_slid_item.dart';
import 'package:skeletonizer/skeletonizer.dart';

class HomeBannerCard extends GetView<HomeDashboardController> {
  const HomeBannerCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Obx(() {
      final bool isLoading = controller.isSpecLoading.value;

      return Skeletonizer(
        enabled: isLoading,
        effect: const ShimmerEffect(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          duration: Duration(milliseconds: 3000),
        ),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: context.heightPct(0.239),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
              ),
              child: Stack(
                children: [
                  PageView(
                    physics: isLoading
                        ? const NeverScrollableScrollPhysics()
                        : const BouncingScrollPhysics(),
                    controller: controller.bannerPageController,
                    onPageChanged: controller.updateBannerPage,
                    children: controller.medicalBanners.map((banner) {
                      return ImageBannerSlideItem(
                        imagePath: banner.image,
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            SizedBox(height: context.heightPct(0.017)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                controller.medicalBanners.length,
                (index) => BannerDotIndicator(
                  index: index,
                  currentPage: controller.currentBannerPage.value,
                  theme: theme,
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
































































//  الكود القديم للبانر 

/*
class HomeBannerCard extends GetView<HomeController> {
  const HomeBannerCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Obx(() {
      final bool isLoading =
          controller.isSpecLoading.value || controller.stats == null;

      final stats = controller.stats;

      return Skeletonizer(
        enabled: isLoading,
        effect: const ShimmerEffect(
          begin: Alignment.centerLeft, // توهج انسيابي من اليسار
          end: Alignment.centerRight, // ينتهي لليمين
          duration: Duration(milliseconds: 3000), // سرعة مناسبة للحركة الشفافة
        ),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: context.heightPct(0.212),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    theme.colorScheme.primary.withOpacity(0.16),
                    theme.colorScheme.primary.withOpacity(0.04),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Stack(
                children: [
                  Positioned.directional(
                    textDirection: Directionality.of(context),
                    start: -context.widthPct(0.12),
                    bottom: -context.heightPct(0.04),
                    child: CircleAvatar(
                      radius: context.widthPct(0.25),
                      backgroundColor:
                          theme.colorScheme.primary.withOpacity(0.04),
                    ),
                  ),
                  PageView(
                    physics: isLoading
                        ? const NeverScrollableScrollPhysics()
                        : const BouncingScrollPhysics(),
                    controller: controller.bannerPageController,
                    onPageChanged: controller.updateBannerPage,
                    children: [
                      BannerSlideItem(
                        icon: Icons.payments_rounded,
                        color: AppColors.success,
                        tag: StringManager.average_check_up_price,
                        title: stats != null
                            ? "${stats.avgPrice.toInt()} "
                            : "00000 ",
                        desc: stats != null
                            ? " from  ${stats.minPrice.toInt()}  to ${stats.maxPrice.toInt()} "
                            : " from  000  to 0000 ",
                      ),
                      BannerSlideItem(
                        icon: Icons.local_fire_department_rounded,
                        color: AppColors.warning,
                        tag: StringManager.most_requested_specialization,
                        title: stats != null
                            ? " ${stats.mostRequested}"
                            : " Specialization Placeholder ",
                        desc: StringManager.medicaldepartment,
                      ),
                      BannerSlideItem(
                        icon: Icons.business_center_rounded,
                        color: theme.colorScheme.primary,
                        tag: StringManager.Available,
                        title: stats != null ? "${stats.totalCount}" : "00",
                        desc: StringManager.ready,
                      ),
                      BannerSlideItem(
                        icon: Icons.trending_down_rounded,
                        color: AppColors.info,
                        tag: StringManager.least_requested_specialization,
                        title: stats != null
                            ? " ${stats.leastRequested}"
                            : " Specialization Placeholder ",
                        desc: StringManager.Featuring,
                      ),
                    ],
                  ),
                  Positioned.directional(
                    textDirection: Directionality.of(context),
                    end: context.widthPct(0.04),
                    bottom: 0,
                    child: Image.asset(
                      Appassets.onboarding3,
                      height: context.heightPct(0.19),
                      width: context.widthPct(0.30),
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: context.heightPct(0.023)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                4,
                (index) => BannerDotIndicator(
                  index: index,
                  currentPage: controller.currentBannerPage.value,
                  theme: theme,
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}*/