
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:raghad_pro/core/constanse/app_assets.dart';
import 'package:raghad_pro/core/constanse/app_spacing.dart';
import 'package:raghad_pro/core/constanse/string_manager.dart';
import 'package:raghad_pro/core/utilis/size_config.dart';
import 'package:raghad_pro/core/widget/null_data_widget.dart';
import 'package:raghad_pro/features/profile/controller/medical_hestory.dart';
import 'package:raghad_pro/features/profile/presentation/widget/base_settings.dart';
import 'package:raghad_pro/features/profile/presentation/widget/card_hestory.dart';
import 'package:raghad_pro/features/profile/presentation/widget/card_hestory_visit.dart';

class MedicalHistoryScreen extends GetView<MedicalHistoryController> {
  const MedicalHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseSubSettingsScreen(
      title: StringManager.medicalHistory.tr, 
      content: Padding(
        padding: AppSpacing.horizontal8,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: context.heightPct(0.02)),
            const PatientSummaryCard(),
            SizedBox(height: context.heightPct(0.06)),
            Text(
              StringManager.medicalHistoryRecord.tr,
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            SizedBox(height: context.heightPct(0.03)),
            Expanded(
              child: Obx(() {
               
                if (controller.isMedicalLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

               
                if (controller.medicalRecords.isEmpty) {
                  return Center(
                    child: NullDataWidget(
                      text:StringManager.noPerscriotion.tr, 
                      imagePath: Appassets.nulldata,
                    ),
                  );
                }

              
                return ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: controller.medicalRecords.length,
                  itemBuilder: (context, index) {
                    final record = controller.medicalRecords[index];
                    return MedicalVisitCard(
                      record: record,
                      formattedDate: controller.formatDate(record.visitDate),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}





























































































/*
class MedicalHistoryScreen extends GetView<MedicalHistoryController> {
  const MedicalHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseSubSettingsScreen(
      title: StringManager.medicalHistory, 
      content: Padding(
        padding: AppSpacing.horizontal8,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             SizedBox(height: context.heightPct(0.02)),
            const PatientSummaryCard(),
            SizedBox(height: context.heightPct(0.06)),
             Text(
              StringManager.medicalHistoryRecord,
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            SizedBox(height: context.heightPct(0.03)),
            Expanded(
              child: Obx(() {
                if (controller.isMedicalLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

              
                final isDataEmpty = controller.medicalRecords.isEmpty;
                final displayList = isDataEmpty ? Center(NullDataWidget(text: 'no record', imagePath:Appassets.nulldata,)) : controller.medicalRecords;

                return ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: displayList.length,
                  itemBuilder: (context, index) {
                    final record = displayList[index];
                    return MedicalVisitCard(
                      record: record,
                      formattedDate: controller.formatDate(record.visitDate),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }


}*/











  /*
  List<MedicalRecordModel> get _dummyRecords => [
        MedicalRecordModel(
          appointmentUuid: "1",
          doctorUuid: "d1",
          visitDate: DateTime.now().subtract(const Duration(days: 2)),
          diagnosis: "المريض يعاني من إجهاد عام وضغط دم مرتفع قليلاً بسبب السهر. تم وصف الراحة التامة مع تقليل الصوديوم في الوجبات ومتابعة القياس لمدة أسبوع.",
          visitType: "check", // ستظهر بلون أزرق (كشف جديد)
          doctorName: "أحمد الحريري",
          specialization: "أمراض القلب والأوعية الدموية",
          clinic: "عيادة القلب التخصصية",
        ),
        MedicalRecordModel(
          appointmentUuid: "2",
          doctorUuid: "d2",
          visitDate: DateTime.now().subtract(const Duration(days: 15)),
          diagnosis: "مراجعة دورية لفحص مستويات السكر العشوائي والتراكمي في الدم، النتائج مستقرة وجيدة جداً وضمن النطاق الآمن. يستمر على نفس الجرعات الحالية.",
          visitType: "review", // ستظهر بلون برتقالي (مراجعة)
          doctorName: "سارة النجار",
          specialization: "الغدد الصماء والسكري",
          clinic: "العيادة الداخلية الثامنة",
        ),
        MedicalRecordModel(
          appointmentUuid: "3",
          doctorUuid: "d3",
          visitDate: DateTime.now().subtract(const Duration(days: 40)),
          diagnosis: "التهاب حاد في الجيوب الأنفية نتيجة تقلبات الطقس الموسمية. تم صرف مضاد حيوي مناسب مع بخاخ أنفي مرطب ومسكن للآلام عند الحاجة لمدة 5 أيام.",
          visitType: "check", // ستظهر بلون أزرق (كشف جديد)
          doctorName: "محمود عبيد",
          specialization: "أذن وأنف وحنجرة",
          clinic: "مستشفى Medica - العيادات الخارجية",
        ),
      ];*/
















// // lib/features/profile/presentation/view/medical_history_screen.dart
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:raghad_pro/core/constanse/string_manager.dart';
// import 'package:raghad_pro/features/profile/controller/medical_hestory.dart';
// import 'package:raghad_pro/features/profile/presentation/widget/base_settings.dart';
// import 'package:raghad_pro/features/profile/presentation/widget/card_hestory.dart';
// import 'package:raghad_pro/features/profile/presentation/widget/card_hestory_visit.dart';


// class MedicalHistoryScreen extends GetView<MedicalHistoryController> {
//   const MedicalHistoryScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BaseSubSettingsScreen(
//       title:StringManager.settings,
//       content: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const SizedBox(height: 10),
//             const PatientSummaryCard(), // كارت يعرض الـ personal_info بجمالية وعناية
//             const SizedBox(height: 24),
//             const Text(
//               "السجل الطبي والزيارات السابقة",
//               style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF2C3E50)),
//             ),
//             const SizedBox(height: 12),
//             Expanded(
//               child: Obx(() {
//                 if (controller.isMedicalLoading.value) {
//                   return const Center(child: CircularProgressIndicator());
//                 }
//                 if (controller.medicalRecords.isEmpty) {
//                   return const Center(child: Text("لا توجد سجلات طبية مضافة بعد"));
//                 }
//                 return ListView.builder(
//                   physics: const BouncingScrollPhysics(),
//                   itemCount: controller.medicalRecords.length,
//                   itemBuilder: (context, index) {
//                     final record = controller.medicalRecords[index];
//                     return MedicalVisitCard(
//                       record: record,
//                       formattedDate: controller.formatDate(record.visitDate),
//                     );
//                   },
//                 );
//               }),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
// lib/features/profile/presentation/view/medical_history_screen.dart