import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:raghad_pro/core/constanse/app_spacing.dart';
import 'package:raghad_pro/core/constanse/string_manager.dart';
import 'package:raghad_pro/core/utilis/size_config.dart';
import 'package:raghad_pro/core/widget/custom_tap.dart';
import 'package:raghad_pro/features/home/controller/home_controller.dart';
import 'package:raghad_pro/features/home/view/widget/tab_about_content_detail.dart';
import 'package:raghad_pro/features/home/view/widget/tab_appoinment_content.dart';
import 'package:raghad_pro/features/home/view/widget/tab_rating_containt_detail.dart';

// class DoctorDetailsBodyContent extends GetView<HomeController> {
//   const DoctorDetailsBodyContent({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//    final doctor = controller.currentDoctor.value;

    
//     final String doctorUuid = doctor?.uuid ?? '';

//   WidgetsBinding.instance.addPostFrameCallback((_) {
//     controller.getDoctorSchedules(doctorUuid);
//   });

//     return SliverPadding(
//       padding: AppSpacing.edgeInsets18.copyWith(top: 0),
//       sliver: SliverList(
//         delegate: SliverChildListDelegate([
//           SizedBox(height: context.heightPct(0.03)),
//           _buildActionTabs(context, theme),
//           SizedBox(height: context.heightPct(0.03)),
//           _buildDynamicContent(),
//         ]),
//       ),
//     );
//   }

//   Widget _buildActionTabs(BuildContext context, ThemeData theme) {
//     return Obx(() {
//       final selectedIndex = controller.activeTabIndex.value;
//       return Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           CustomGenericTabs( tabLabels: const [  StringManager.aboutDoctor,  StringManager.appointment,  StringManager.ratings],
//                   selectedIndex: controller.appointmentTabControllerIndex.value,
//                   onTabSelected: (index) {
//                     controller.changeAppointmentTab(index);
//                   },),
       
//         ],
//       );
//     });
//   }

//   Widget _buildDynamicContent() {
//     return Obx(() {
//       switch (controller.activeTabIndex.value) {
//         case 0:
//           return const TabAboutContent();
//         case 1:
//           return const TabAppointmentContent();
//         case 2:
//           return const TabRatingContent();
//         default:
//           return const SizedBox.shrink();
//       }
//     });
//   }
// }
class DoctorDetailsBodyContent extends GetView<HomeController> {
  const DoctorDetailsBodyContent({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final doctor = controller.currentDoctor.value;
    final String doctorUuid = doctor?.uuid ?? '';

    // جلب البيانات من السيرفر بعد بناء الهيكل بأمان لمنع تداخل الـ BuildContext
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (doctorUuid.isNotEmpty) {
        controller.getDoctorSchedules(doctorUuid);
      }
    });

    return SliverPadding(
      padding: AppSpacing.edgeInsets18.copyWith(top: 0),
      sliver: SliverList(
        delegate: SliverChildListDelegate([
          SizedBox(height: context.heightPct(0.03)),
          _buildActionTabs(context, theme),
          SizedBox(height: context.heightPct(0.03)),
          _buildDynamicContent(),
        ]),
      ),
    );
  }

  // 1️⃣ استدعاء الـ Tabs وربطها بالمتغيرات الصحيحة لتفاصيل الطبيب
  Widget _buildActionTabs(BuildContext context, ThemeData theme) {
    return Obx(() {
      return CustomGenericTabs( 
        tabLabels: const [ 
          StringManager.aboutDoctor,  
          StringManager.appointment,  
          StringManager.ratings
        ],
        // ربط الاندكس المختار بـ activeTabIndex التابع لتفاصيل الطبيب وليس المواعيد العامة
        selectedIndex: controller.activeTabIndex.value,
        onTabSelected: (index) {
          // استدعاء الدالة الصحيحة لتحديث اندكس تفاصيل الطبيب وإعادة البناء المباشر
          controller.updateActiveTab(index);
        },
      );
    });
  }

  // 2️⃣ عرض المحتوى الديناميكي بناءً على الـ activeTabIndex الحالي
  Widget _buildDynamicContent() {
    return Obx(() {
      switch (controller.activeTabIndex.value) {
        case 0:
          return const TabAboutContent();
        case 1:
          return const TabAppointmentContent();
        case 2:
          return const TabRatingContent();
        default:
          return const SizedBox.shrink();
      }
    });
  }
}