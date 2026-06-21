import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:raghad_pro/core/constanse/string_manager.dart';
import 'package:raghad_pro/core/theme/app_colors.dart';
import 'package:raghad_pro/core/utilis/size_config.dart';
import 'package:raghad_pro/core/widget/custom_skeletinizor.dart';
import 'package:raghad_pro/core/widget/custom_text.dart';
import 'package:raghad_pro/features/home/controller/doctor_book_logic.dart';
import 'package:raghad_pro/features/home/view/widget/custom_work_houre_doctor.dart';
import 'package:skeletonizer/skeletonizer.dart';


class TabAboutContent extends GetView<DoctorBookingController> {
  const TabAboutContent({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Obx(() {
      final doctor = controller.currentDoctor.value;
      final String doctorName = doctor?.name ?? 'Doctor';

      if (!controller.isSchedulesLoading.value && controller.doctorSchedules.isEmpty) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Center(
            child:Icon(Icons.hourglass_bottom,size: 24,color: AppColors.lightFillTextFiled.withOpacity(0.3),)
          ),
        );
      }
    return CustomSkeletonizer(
  isLoading: controller.isSchedulesLoading.value,
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      CustomText(
        
        title: 'Dr. $doctorName is a highly skilled specialist in ${doctor?.specialization ?? "medical field"} dedicated to providing state-of-the-art care at ${doctor?.clinic ?? "clinic"}. Each consultation session lasts approximately ${doctor?.visitTime ?? "20 minutes"}.',
        style: theme.textTheme.bodyMedium!.copyWith(
          color: theme.colorScheme.primaryContainer,
          height: 1.5,
        ),
      ),
      SizedBox(height: context.heightPct(0.03)),
      Text(
        StringManager.workingHour.tr, 
        style: theme.textTheme.bodyMedium?.copyWith(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      SizedBox(height: context.heightPct(0.01)),
      
      DoctorWorkingHours(
        workingHours: controller.formattedWorkingHours,
      ),
    ],
  ),
);
    
    });
  }
}








/*
  return Skeletonizer(
        enabled: controller.isSchedulesLoading.value,
        effect: const ShimmerEffect(
          begin: Alignment.centerLeft,  
          end: Alignment.centerRight,   
          duration: Duration(milliseconds: 1000), 
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              title: 'Dr. $doctorName is a highly skilled specialist in ${doctor?.specialization ?? "medical field"} dedicated to providing state-of-the-art care at ${doctor?.clinic ?? "clinic"}. Each consultation session lasts approximately ${doctor?.visitTime ?? "20 minutes"}.',
              style: theme.textTheme.bodyMedium!.copyWith(
                color: theme.colorScheme.primaryContainer,
                height: 1.5,
              ),
            ),
            SizedBox(height: context.heightPct(0.03)),
            Text(
              StringManager.workingHour, 
              style: theme.textTheme.bodyMedium?.copyWith(fontSize: 16, fontWeight: FontWeight.bold)
            ),
            SizedBox(height: context.heightPct(0.01)),
            DoctorWorkingHours(
              workingHours: controller.formattedWorkingHours,
            ),
          ],
        ),
      );
*/



























































/*
class TabAboutContent extends GetView<HomeController> {
  const TabAboutContent({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Obx(() {
      final doctor = controller.currentDoctor.value;
      final String doctorName = doctor?.name ?? 'Doctor';

      if (!controller.isSchedulesLoading.value && controller.doctorSchedules.isEmpty) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Center(
            child: Text(
              "لم يتم تحديد أوقات دوام لهذا الطبيب حالياً",
              style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey),
            ),
          ),
        );
      }

      return Skeletonizer(
        enabled: controller.isSchedulesLoading.value,
        effect: const ShimmerEffect(
          begin: Alignment.centerLeft,  
          end: Alignment.centerRight,   
          duration: Duration(milliseconds: 1000), 
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // النبذة التعريفية الديناميكية باسم الطبيب واختصاصه ووقت زيارته
            CustomText(
              title: 'Dr. $doctorName is a highly skilled specialist in ${doctor?.specialization ?? "medical field"} dedicated to providing state-of-the-art care at ${doctor?.clinic ?? "clinic"}. Each consultation session lasts approximately ${doctor?.visitTime ?? "20 minutes"}.',
              style: theme.textTheme.bodyMedium!.copyWith(
                color: theme.colorScheme.primaryContainer,
                height: 1.5,
              ),
            ),
            SizedBox(height: context.heightPct(0.03)),
            Text(
              StringManager.workingHour, 
              style: theme.textTheme.bodyMedium?.copyWith(fontSize: 16, fontWeight: FontWeight.bold)
            ),
            SizedBox(height: context.heightPct(0.01)),
            
            DoctorWorkingHours(
              workingHours: controller.formattedWorkingHours,
            ),
          ],
        ),
      );
    });
  }
}*/
// --- التبويب الأول: نبذة عن الطبيب ---