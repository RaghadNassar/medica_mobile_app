import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:raghad_pro/core/constanse/app_assets.dart';
import 'package:raghad_pro/core/constanse/app_route.dart';
import 'package:raghad_pro/core/constanse/string_manager.dart';
import 'package:raghad_pro/core/widget/custom_card_top_doctor.dart';
import 'package:raghad_pro/core/widget/null_data_widget.dart';
import 'package:raghad_pro/features/home/controller/doctor_book_logic.dart';
import 'package:raghad_pro/features/home/controller/home_controller.dart';
import 'package:skeletonizer/skeletonizer.dart';

/*class TopDoctorsList extends StatelessWidget {
  const TopDoctorsList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 10,
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: TopDoctorCard(onTap: () {
          Get.toNamed(AppRoutes.detail);
        }),
      ),
    );
  }
}
*/
/*
class TopDoctorsList extends GetView<HomeController> {
  const TopDoctorsList({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
     
      if (!controller.isTopDoctorsLoading.value && controller.topDoctors.isEmpty) {
          return NullDataWidget(text: StringManager.noDoctorsAvailable, imagePath: Appassets.logoSecondry,);
      }


      return Skeletonizer(
        enabled: controller.isTopDoctorsLoading.value,
        effect: const ShimmerEffect(
          begin: Alignment.centerLeft,  
          end: Alignment.centerRight,   
          duration: Duration(milliseconds: 3000),
        ),
        child: ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(), 
          itemCount: controller.topDoctors.length,
          itemBuilder: (context, index) {
            final doctor = controller.topDoctors[index];
            
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: DoctorCommonCard(
                name: doctor.name,
                specialization: doctor.specialization,
                visitTime: doctor.visitTime,
                isFromTopDoctors: true, 
                averageRating: doctor.averageRating,
                image: doctor.image,
                clinic: doctor.clinic,
                //patientsCount: doctor.patientsCount,
                
                
               onTap: () {
                  if (controller.isTopDoctorsLoading.value) return;

                 
                  controller.initDoctorDetails(doctor);

                  
                  Get.toNamed(AppRoutes.detail, arguments: doctor);
                },
              ),
            );
          },
        ),
      );
    });
  }
}*/
class TopDoctorsList extends GetView<HomeDashboardController> {
  const TopDoctorsList({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (!controller.isTopDoctorsLoading.value && controller.topDoctors.isEmpty) {
        return NullDataWidget(
          text: StringManager.noDoctorsAvailable,
          imagePath: Appassets.logoSecondry,
        );
      }

      return Skeletonizer(
        enabled: controller.isTopDoctorsLoading.value,
        effect: const ShimmerEffect(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          duration: Duration(milliseconds: 3000),
        ),
        child: ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: controller.topDoctors.length,
          itemBuilder: (context, index) {
            final doctor = controller.topDoctors[index];

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: DoctorCommonCard(
                name: doctor.name,
                specialization: doctor.specialization,
                visitTime: doctor.visitTime,
                isFromTopDoctors: true,
                averageRating: doctor.averageRating,
                image: doctor.image,
                clinic: doctor.clinic,
                onTap: () {
  if (controller.isTopDoctorsLoading.value) return;

  // 💡 الحل المعماري للمشكلة الثانية: استدعاء مباشر لـ Get.find سيقوم ببناء الكونترولر إن لم يكن موجوداً بفضل fenix
  final bookingController = Get.find<DoctorBookingController>();
  bookingController.initDoctorDetails(doctor);

  // الانتقال إلى شاشة التفاصيل مع تمرير المعطيات
  Get.toNamed(AppRoutes.detail, arguments: doctor);
},
              ),
            );
          },
        ),
      );
    });
  }
}