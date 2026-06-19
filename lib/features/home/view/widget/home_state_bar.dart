import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:raghad_pro/core/utilis/size_config.dart';
import 'package:raghad_pro/core/widget/custom_state_card.dart';
import 'package:raghad_pro/features/home/controller/home_controller.dart';
 // تأكدي من مسار ملف الكرت الخاص بكِ

// class HomeStatsBar extends StatelessWidget {
//   const HomeStatsBar({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final HomeController controller = Get.find<HomeController>();

//     return Obx(() {
//       // إخفاء الوديجت تماماً أو عرض مساحة فارغة أثناء التحميل لتجنب تشوه الـ UI
//       if (controller.isSpecLoading.value || controller.stats == null) {
//         return const SizedBox.shrink();
//       }

//       final stats = controller.stats!;

//       return Row(
//         children: [
//           // 1. كرت القسم الأكثر طلباً
//           Expanded(
//             child: CustomStatCard(
//               icon: Icons.local_fire_department_rounded,
//               title: stats.mostRequested,
//               subtitle: "الأكثر طلباً",
//               backgroundColor: Colors.orange.withOpacity(0.08),
//               contentColor: Colors.orange[800],
//             ),
//           ),
//           SizedBox(width: context.widthPct(0.03)),
//         Expanded(
//             child: CustomStatCard(
//               icon: Icons.local_fire_department_rounded,
//               title: stats.leastRequested,
//               subtitle: "الاقل طلباً",
//               backgroundColor: Colors.red.withOpacity(0.08),
//               contentColor: Colors.red[800],
//             ),
//           ),
//           // 2. كرت متوسط الأسعار
//           Expanded(
//             child: CustomStatCard(
//               icon: Icons.analytics_rounded,
//               title: "${stats.avgPrice.toInt().toString()} ل.س",
//               subtitle: "متوسط الكشفيات",
//               backgroundColor: Colors.blue.withOpacity(0.08),
//               contentColor: Colors.blue[800],
//             ),
//           ),
//           SizedBox(width: context.widthPct(0.03)),

//           // 3. كرت الحد الأدنى للأسعار (لتشجيع المستخدم)
//           Expanded(
//             child: CustomStatCard(
//               icon: Icons.payments_rounded,
//               title: "${stats.minPrice.toInt().toString()} ل.س",
//               subtitle: "تبدأ الكشفيات من",
//               backgroundColor: Colors.green.withOpacity(0.08),
//               contentColor: Colors.green[800],
//             ),
//           ),
//         ],
//       );
//     });
//   }
// }