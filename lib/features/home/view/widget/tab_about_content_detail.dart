import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:raghad_pro/core/constanse/string_manager.dart';
import 'package:raghad_pro/core/utilis/size_config.dart';
import 'package:raghad_pro/core/widget/custom_text.dart';
import 'package:raghad_pro/features/home/controller/home_controller.dart';
import 'package:raghad_pro/features/home/view/widget/custom_work_houre_doctor.dart';
import 'package:shimmer/shimmer.dart';
import 'package:skeletonizer/skeletonizer.dart';

/*class TabAboutContent extends GetView<HomeController> {
  const TabAboutContent({super.key});

  @override
  Widget build(BuildContext context) {
   
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          title: 'Dr. Raghad Nassar is a highly skilled dental specialist dedicated to providing state-of-the-art care. Combining clinical expertise with a patient-centric approach to achieve beautiful, healthy smiles.',
          style: theme.textTheme.bodyMedium!.copyWith(
            color: theme.colorScheme.primaryContainer,
            height: 1.5,
          ),
        ),
        SizedBox(height: context.heightPct(0.03)),
        Text(StringManager.workingHour, style: theme.textTheme.bodyMedium?.copyWith(fontSize: 16, fontWeight: FontWeight.bold)),
        SizedBox(height: context.heightPct(0.01)),
        DoctorWorkingHours(workingHours: controller.workingHours),
      ],
    );
  }
}*/
/*class TabAboutContent extends GetView<HomeController> {
  const TabAboutContent({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final String doctorName = Get.arguments['doctor_name'] ?? 'Doctor';

    return Obx(() {
      if (controller.isSchedulesLoading.value) {
        return const Padding(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Center(child: CircularProgressIndicator.adaptive()),
        );
      }


      if (controller.doctorSchedules.isEmpty) {
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

      // 3. بناء الواجهة الحية بعد جلب البيانات بنجاح
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            title: 'Dr. $doctorName is a highly skilled specialist dedicated to providing state-of-the-art care. Combining clinical expertise with a patient-centric approach.',
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
          
          
          DoctorWorkingHours(workingHours: controller.formattedWorkingHours),
        ],
      );
    });
  }
}*/
/*class TabAboutContent extends GetView<HomeController> {
  const TabAboutContent({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final String doctorName = Get.arguments['doctor_name'] ?? 'Doctor';

    return Obx(() {
      // 1. حالة إذا انتهى التحميل وكانت القائمة فارغة فعلياً من السيرفر
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

      // 2. بناء الواجهة باستخدام Skeletonizer المتوافق مع إصدار 1.4.3
      return Skeletonizer(
        enabled: controller.isSchedulesLoading.value,
        effect: const ShimmerEffect(
          begin: Alignment.centerLeft,  // بداية التوهج من اليسار
          end: Alignment.centerRight,   // نهاية التوهج إلى اليمين
          duration: Duration(milliseconds: 1000), // سرعة اللمعان
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              title: 'Dr. $doctorName is a highly skilled specialist dedicated to providing state-of-the-art care. Combining clinical expertise with a patient-centric approach.',
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
            
            // الحل السليم: نمرر الـ Widget بشكل طبيعي تماماً كما كان في كودك الشغال
            // الـ Skeletonizer ذكي بما يكفي ليعرف أنه إذا كانت القائمة فارغة أثناء التحميل،
            // سيرسم هيكل تحميل افتراضي مكان الـ Widget تلقائياً!
            DoctorWorkingHours(
              workingHours: controller.formattedWorkingHours,
            ),
          ],
        ),
      );
    });
  }
}*/
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
}