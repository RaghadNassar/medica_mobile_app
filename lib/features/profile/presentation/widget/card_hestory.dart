// lib/features/profile/presentation/widgets/patient_summary_card.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:raghad_pro/core/constanse/app_spacing.dart';
import 'package:raghad_pro/core/theme/app_colors.dart';
import 'package:raghad_pro/core/utilis/size_config.dart';
import 'package:raghad_pro/features/profile/controller/profile_controller.dart';

class PatientSummaryCard extends GetView<ProfileController> {
  const PatientSummaryCard({super.key});

  @override
  Widget build(BuildContext context) {
    

    return Obx(() {
     // final info =controller.patientProfile.value?.personalInfo;
      final info = controller.patientProfile.value?.data?.personalInfo; 

      return Container(
        height: context.heightPct(0.2),
        width: double.infinity,
        padding: AppSpacing.edgeInsets16,
        decoration: BoxDecoration(
          color: AppColors.accentTeal,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                 const  Spacer(flex: 2),
                  Text(
                    info?.name ?? 'جاري جلب الاسم...',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(color:AppColors.lightSurface),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    " birthdate: ${info?.birthday ?? 'N/A'}",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.lightSurface.withOpacity(0.85), fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "phone number : ${info?.number ?? 'N/A'}",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.lightSurface.withOpacity(0.85), fontSize: 14),
                  ),
                  const  Spacer(flex: 3),
                ],
              ),
            ),
            CircleAvatar(
              radius: 35,
              backgroundColor: AppColors.lightSurface.withOpacity(0.2),
              child: const Icon(Icons.person, size: 40, color: AppColors.lightSurface),
            ),
            
          ],
        ),
      );
    });
  }
}