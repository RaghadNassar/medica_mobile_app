import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:raghad_pro/core/constanse/app_route.dart';
import 'package:raghad_pro/core/constanse/app_spacing.dart';
import 'package:raghad_pro/core/utilis/size_config.dart';
import 'package:raghad_pro/core/widget/custom_skeletinizor.dart';
import 'package:raghad_pro/core/widget/custom_state_card.dart';
import 'package:raghad_pro/features/home/controller/home_controller.dart';

class SpecialtySection extends GetView<HomeDashboardController> {
  const SpecialtySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (!controller.isSpecLoading.value &&
          controller.specializations.isEmpty) {
        return const SizedBox.shrink();
      }

      final bool isLoading = controller.isSpecLoading.value;

      return CustomSkeletonizer(
        isLoading: isLoading,
        child: SizedBox(
          height: context.heightPct(0.25), 
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: AppSpacing.screenPadding16_7, 
            itemCount: isLoading ? 4 : controller.specializations.length,
            separatorBuilder: (context, index) => const SizedBox(width: 12), 
            itemBuilder: (context, index) {
              final specialty =
                  isLoading ? null : controller.specializations[index];

              final icon = isLoading
                  ? Icons.local_hospital_outlined
                  : controller.getIconForSpecialty(specialty!.name);

              final iconColor = isLoading
                  ? Colors.grey[400]
                  : controller.getIconColorForSpecialty(specialty!.name);

              final titleText = specialty?.name ?? "اسم الاختصاص";

              final subtitleText = specialty != null
                  ? "${specialty.checkUpPrice.toInt()} ل.س"
                  : "0000 ل.س";

              final patientsText = specialty != null
                  ? "+${specialty.appointmentsCount ?? (index * 12 + 35)} مريض" 
                  : "00 مريض";

              return SizedBox(
                width: context.widthPct(0.35),
                child: CustomStatCard(
                  icon: icon,
                  title: titleText,
                  subtitle: subtitleText,
                  patientsCount: patientsText, 
                  contentColor: iconColor,
                  onTap: () {
                    if (isLoading || specialty == null) return;
                
                    Get.toNamed(
                      AppRoutes.alldoctor,
                      arguments: {
                        'specialtyName': specialty.name,
                        'specialtyUuid': specialty.uuid.toString(),
                      },
                    );
                  },
                ),
              );
            },
          ),
        ),
      );
    });
  }
}













































































// primary
/*
class SpecialtySection extends GetView<HomeDashboardController> {
  const SpecialtySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (!controller.isSpecLoading.value &&
          controller.specializations.isEmpty) {
        return const SizedBox.shrink();
      }

      final bool isLoading = controller.isSpecLoading.value;

      return CustomSkeletonizer(
        isLoading: isLoading,
        child: SizedBox(
          height: context.heightPct(0.16),
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: context.widthPct(0.02)),
            itemCount: isLoading ? 4 : controller.specializations.length,
            separatorBuilder: (context, index) =>
                SizedBox(width: context.widthPct(0.035)),
            itemBuilder: (context, index) {
              final specialty =
                  isLoading ? null : controller.specializations[index];

              final icon = isLoading
                  ? Icons.local_hospital_outlined
                  : controller.getIconForSpecialty(specialty!.name);

              final bgColor = isLoading
                  ? Colors.grey[200]
                  : controller.getColorForSpecialty(specialty!.name);

              final iconColor = isLoading
                  ? Colors.grey[400]
                  : controller.getIconColorForSpecialty(specialty!.name);

              final titleText = specialty?.name ?? "Specialty Name";

              final subtitleText = specialty != null
                  ? "${specialty.checkUpPrice.toInt()} "
                  : "0000 ";

              return CustomStatCard(
                icon: icon,
                title: titleText,
                subtitle: subtitleText,
                backgroundColor: bgColor,
                contentColor: iconColor,
                onTap: () {
                  if (isLoading || specialty == null) return;

                  Get.toNamed(
                    AppRoutes.alldoctor,
                    arguments: {
                      'specialtyName': specialty.name,
                      'specialtyUuid': specialty.uuid.toString(),
                    },
                  );
                },
              );
            },
          ),
        ),
      );
    });
  }
} */
/*
سكيلي 
return Skeletonizer(
        enabled: isLoading,
        effect: const ShimmerEffect(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          duration: const Duration(milliseconds: 3000),
        ),
        child: SizedBox(
          height: context.heightPct(0.16),
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: context.widthPct(0.02)),
            itemCount: isLoading ? 4 : controller.specializations.length,
            separatorBuilder: (context, index) => SizedBox(width: context.widthPct(0.035)),
            itemBuilder: (context, index) {
              final specialty = isLoading ? null : controller.specializations[index];

              final icon = isLoading
                  ? Icons.local_hospital_outlined
                  : controller.getIconForSpecialty(specialty!.name);
              final bgColor = isLoading
                  ? Colors.grey[200]
                  : controller.getColorForSpecialty(specialty!.name);
              final iconColor = isLoading
                  ? Colors.grey[400]
                  : controller.getIconColorForSpecialty(specialty!.name);
              final titleText = specialty?.name ?? "Specialty Name";
              final subtitleText = specialty != null
                  ? "${specialty.checkUpPrice.toInt()} "
                  : "0000 ";

              return CustomStatCard(
                icon: icon,
                title: titleText,
                subtitle: subtitleText,
                backgroundColor: bgColor,
                contentColor: iconColor,
                // onTap: () {
                //   if (controller.isSpecLoading.value) return;

                //   if (specialty != null) {
                //     Get.to(() => AllDoctorSpecializeScreen(
                //           specialtyName: specialty.name,
                //           specialtyUuid: specialty.uuid.toString(), // تحويل آمن لـ String
                //         ));
                //   }
                // },
                onTap: () {
  // الانتقال باستخدام الاسم مع تمرير البيانات داخل مصفوفة (Map) كـ arguments
  Get.toNamed(
    AppRoutes.alldoctor, 
    arguments: {
      'specialtyName': specialty?.name, // اسم التخصص القادم من الـ API (مثلاً: العظمية)
      'specialtyUuid': specialty?.uuid.toString(), // الـ Uuid الخاص بالتخصص القادم من الـ API
    },
  );
}
              );
            },
          ),
        ),
      );
*/












































/*class SpecialtySection extends StatelessWidget {
  const SpecialtySection({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.heightPct(0.18),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: 5,
        separatorBuilder: (context, index) =>  SizedBox(width: context.widthPct(0.05)),
        itemBuilder: (context, index) => SpecialtyItemWidget(onTap: () {Get.to(() => const AllDoctorSpecializeScreen(specialtyName: "heart"));}),
      ),
    );
  }
}*/
/*
class SpecialtySection extends GetView<HomeController> {
  const SpecialtySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (!controller.isSpecLoading.value &&
          controller.specializations.isEmpty) {
        return const SizedBox.shrink();
      }

      final bool isLoading = controller.isSpecLoading.value;

      return Skeletonizer(
        enabled: isLoading,
        effect: const ShimmerEffect(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          duration: Duration(milliseconds: 3000),
        ),
        child: SizedBox(
          height: context.heightPct(0.16),
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: context.widthPct(0.02)),
            itemCount: isLoading ? 4 : controller.specializations.length,
            separatorBuilder: (context, index) =>
                SizedBox(width: context.widthPct(0.035)),
            itemBuilder: (context, index) {
              final specialty =
                  isLoading ? null : controller.specializations[index];

              final icon = isLoading
                  ? Icons.local_hospital_outlined
                  : controller.getIconForSpecialty(specialty!.name);
              final bgColor = isLoading
                  ? Colors.grey[200]
                  : controller.getColorForSpecialty(specialty!.name);
              final iconColor = isLoading
                  ? Colors.grey[400]
                  : controller.getIconColorForSpecialty(specialty!.name);
              final titleText = specialty?.name ?? "Specialty Name";
              final subtitleText = specialty != null
                  ? "${specialty.checkUpPrice.toInt()} "
                  : "0000 ";

              return CustomStatCard(
                icon: icon,
                title: titleText,
                subtitle: subtitleText,
                backgroundColor: bgColor,
                contentColor: iconColor,
                onTap: () {
                  if (controller.isSpecLoading.value)
                    return; // الخروج فوراً ومنع النقر أثناء التحميل

                  if (specialty != null) {
                    Get.to(() => AllDoctorSpecializeScreen(
                          specialtyName: specialty.name,
                          specialtyUuid: specialty.uuid,
                        ));
                  }
                },
              );
            },
          ),
        ),
      );
    });
  }
}*/