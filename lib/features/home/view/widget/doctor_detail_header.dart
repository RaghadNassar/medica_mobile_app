import 'package:flutter/material.dart';
import 'package:raghad_pro/core/constanse/app_assets.dart';
import 'package:raghad_pro/core/constanse/app_spacing.dart';
import 'package:raghad_pro/core/utilis/size_config.dart';
import 'package:raghad_pro/core/widget/custom_text.dart';
import 'package:raghad_pro/features/home/controller/doctor_book_logic.dart';
import 'package:raghad_pro/features/home/view/widget/custom_states_row_deatil.dart';
import 'package:raghad_pro/features/home/view/widget/doctor_header_image_detail.dart';
import 'package:get/get.dart';

class DoctorDetailsHeaderSection extends GetView<DoctorBookingController> {
  const DoctorDetailsHeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SliverToBoxAdapter(
      child: Obx(() {
    
        final doctor = controller.currentDoctor.value;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          
            DoctorHeaderImage(
              
              imagePath: doctor?.image ?? Appassets.onboarding3, 
              doctorName: doctor?.name ?? '...',
              specialty: doctor?.specialization ?? '...',
              onBackTap: () => Get.back(),
              onShareTap: () => debugPrint('Share clicked'),
              onFavoriteTap: () => debugPrint('Favorite toggled'),
            ),

          
            Padding(
              padding: AppSpacing.edgeInsets18.copyWith(bottom: 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    title: doctor?.name ?? '...', 
                    style: theme.textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold),
                  ),
                  CustomText(
                    title: "${doctor?.specialization ?? '...'} (${doctor?.clinic ?? '...'})", 
                    style: theme.textTheme.bodyLarge!.copyWith(color: theme.primaryColor, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: context.heightPct(0.015)),
                  
              
                  DoctorStatsRow(
                    patients: doctor?.patientsCount.toString() ?? '0',
                    experience: doctor?.reviewersCount.toString() ?? '0',
                    rating: doctor?.averageRating.toString() ?? '0.0',
                    onChatTap: () {},
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}



















/*
class DoctorDetailsHeaderSection extends StatelessWidget {
  const DoctorDetailsHeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // هيدر الصورة المحمي من القص
          DoctorHeaderImage(
            imagePath: Appassets.onboarding3, 
            doctorName: 'Dr. Ahmad Nassar',
            specialty: 'Dentist Specialist',
            onBackTap: () => Get.back(),
            onShareTap: () => debugPrint('Share clicked'),
            onFavoriteTap: () => debugPrint('Favorite toggled'),
          ),

          // تفاصيل الطبيب الأساسية والإحصائيات
          Padding(
            padding: AppSpacing.edgeInsets18.copyWith(bottom: 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  title: 'Dr. Ahmad Nassar', 
                  style: theme.textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold),
                ),
                CustomText(
                  title: 'Specialized Dentist', 
                  style: theme.textTheme.bodyLarge!.copyWith(color: theme.primaryColor, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: context.heightPct(0.015)),
                
                DoctorStatsRow(
                  patients: '850',
                  experience: '15',
                  rating: '4.9',
                  onChatTap: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}*/