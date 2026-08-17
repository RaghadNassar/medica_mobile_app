import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:raghad_pro/core/constanse/string_manager.dart';
import 'package:raghad_pro/core/theme/app_colors.dart';
import 'package:raghad_pro/core/utilis/size_config.dart';
import 'package:raghad_pro/core/widget/custom_skeletinizor.dart';
import 'package:raghad_pro/core/widget/custom_text.dart';
import 'package:raghad_pro/features/home/controller/doctor_book_logic.dart';
import 'package:raghad_pro/features/home/view/widget/custom_work_houre_doctor.dart';

class TabAboutContent extends GetView<DoctorBookingController> {
  const TabAboutContent({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Obx(() {
      final doctor = controller.currentDoctor.value;

      if (!controller.isSchedulesLoading.value && controller.doctorSchedules.isEmpty) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Center(
            child: Icon(
              Icons.hourglass_bottom,
              size: 24,
              color: AppColors.lightFillTextFiled.withOpacity(0.3),
            ),
          ),
        );
      }

      return CustomSkeletonizer(
        isLoading: controller.isSchedulesLoading.value,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // قسم عن الطبيب
            Text(
              StringManager.aboutDoctor.tr, 
              style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: context.heightPct(0.01)),
            CustomText(
              title: _buildAboutText(doctor),
              style: theme.textTheme.bodyMedium!.copyWith(
                color: theme.colorScheme.primaryContainer,
                height: 1.5,
              ),
            ),
            
            SizedBox(height: context.heightPct(0.02)),

            // قسم ساعات العمل
            Text(
              StringManager.workingHour.tr, 
              style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: context.heightPct(0.01)),
            
            // عرض ساعات العمل
            DoctorWorkingHours(
              workingHours: controller.formattedWorkingHours,
            ),

           
            if (controller.hasAlternativeSchedule) ...[
              SizedBox(height: context.heightPct(0.015)),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.warning.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppColors.warning.withOpacity(0.4),
                  ),
                ),
                child: Row(
                  children: [
                 const   Icon(
                      Icons.info_outline_rounded,
                      color: AppColors.warning,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        controller.alternativeSchedulePeriod,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      );
    });
  }

  String _buildAboutText( doctor) {
    final template = StringManager.doctorAboutDesc.tr;
    return template
        .replaceFirst('%s', doctor?.name          ?? 'Doctor')
        .replaceFirst('%s', doctor?.specialization ?? 'medical field')
        .replaceFirst('%s', doctor?.clinic         ?? 'clinic')
        .replaceFirst('%s', doctor?.visitTime      ?? '20 min');
  }
}



























































































/*

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
       Text(
        StringManager.aboutDoctor.tr, 
        style: theme.textTheme.bodyLarge?.copyWith( fontWeight: FontWeight.bold),
      ),
       SizedBox(height: context.heightPct(0.01)),
      CustomText(
        title: _buildAboutText(doctor),
       // title: 'Dr. $doctorName is a highly skilled specialist in ${doctor?.specialization ?? "medical field"} dedicated to providing state-of-the-art care at ${doctor?.clinic ?? "clinic"}. Each consultation session lasts approximately ${doctor?.visitTime ?? "20 minutes"}.',
        style: theme.textTheme.bodyMedium!.copyWith(
          color: theme.colorScheme.primaryContainer,
          height: 1.5,
        ),
      ),
      SizedBox(height: context.heightPct(0.003)),
      Text(
        StringManager.workingHour.tr, 
         style: theme.textTheme.bodyLarge?.copyWith( fontWeight: FontWeight.bold),
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






   String _buildAboutText(doctor) {
    final template = StringManager.doctorAboutDesc.tr;
    return template
        .replaceFirst('%s', doctor?.name          ?? 'Doctor')
        .replaceFirst('%s', doctor?.specialization ?? 'medical field')
        .replaceFirst('%s', doctor?.clinic         ?? 'clinic')
        .replaceFirst('%s', doctor?.visitTime      ?? '20 min');
  }
}
*/









































































































/*
class TabAboutContent extends GetView<DoctorBookingController> {
  const TabAboutContent({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Obx(() {
      final doctor = controller.currentDoctor.value;

      if (!controller.isSchedulesLoading.value && controller.doctorSchedules.isEmpty) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Center(
            child: Icon(
              Icons.hourglass_bottom,
              size: 24,
              color: AppColors.lightFillTextFiled.withOpacity(0.3),
            ),
          ),
        );
      }
      return CustomSkeletonizer(
        isLoading: controller.isSchedulesLoading.value,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              StringManager.aboutDoctor.tr,
              style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: context.heightPct(0.01)),
            CustomText(
              title: _buildAboutText(doctor),
              style: theme.textTheme.bodyMedium!.copyWith(
                color: theme.colorScheme.primaryContainer,
                height: 1.5,
              ),
            ),
            SizedBox(height: context.heightPct(0.02)),
            Text(
              StringManager.workingHour.tr,
              style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: context.heightPct(0.01)),
            
            // ✨ تم الإصلاح: نمرر الـ schedules مباشرة الآن
            DoctorWorkingHours(
              schedules: controller.sortedDoctorSchedules,
            ),
          ],
        ),
      );
    });
  }

  String _buildAboutText(doctor) {
    final template = StringManager.doctorAboutDesc.tr;
    return template
        .replaceFirst('%s', doctor?.name ?? 'Doctor')
        .replaceFirst('%s', doctor?.specialization ?? 'medical field')
        .replaceFirst('%s', doctor?.clinic ?? 'clinic')
        .replaceFirst('%s', doctor?.visitTime ?? '20 min');
  }
}
class DoctorWorkingHours extends StatelessWidget {
  // نقوم بتحديد نوع الـ List ليكون من نوع المودل الخاص بكِ بدقة (Clean Code)
  final List<DoctorScheduleModel> schedules; 

  const DoctorWorkingHours({
    super.key, 
    required this.schedules,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: schedules.map((schedule) {
        // ✨ استخدام الحقول الحقيقية من المودل الخاص بكِ
        final String dayName = schedule.day; // تم التعديل من dayName إلى day
        final String timeValue = "${schedule.startTime} - ${schedule.endTime}"; // دمج وقت البداية والنهاية
        final bool isModified = schedule.isModified; 

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: isModified ? const EdgeInsets.all(10.0) : EdgeInsets.zero,
            decoration: isModified
                ? BoxDecoration(
                    color: Colors.red.withOpacity(0.06), // خلفية حمراء مريحة تدل على التعديل
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.red.withOpacity(0.25), width: 1),
                  )
                : null,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // اسم اليوم
                Text(
                  dayName,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: isModified ? Colors.red.shade900 : theme.colorScheme.onSurface,
                    fontWeight: isModified ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                
                // شارة "دوام معدل" والوقت
                Row(
                  children: [
                    if (isModified) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        margin: const EdgeInsets.only(left: 8),
                        decoration: BoxDecoration(
                          color: Colors.red.shade100,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.edit_calendar_rounded, size: 12, color: Colors.red.shade900),
                            const SizedBox(width: 4),
                            Text(
                              "دوام معدل",
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.red.shade900,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    
                    // نص توقيت الدوام (بداية - نهاية)
                    Text(
                      timeValue,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: isModified 
                            ? Colors.red.shade800 
                            : theme.colorScheme.primaryContainer,
                        fontWeight: isModified ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}*/

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