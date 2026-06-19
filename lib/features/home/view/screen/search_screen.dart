import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:raghad_pro/core/constanse/app_route.dart';
import 'package:raghad_pro/core/constanse/string_manager.dart';
import 'package:raghad_pro/core/utilis/size_config.dart';
import 'package:raghad_pro/core/widget/custom_card_top_doctor.dart';
import 'package:raghad_pro/core/widget/custom_tap.dart';
import 'package:raghad_pro/core/widget/custom_text_filed.dart';
import 'package:raghad_pro/features/home/controller/home_controller.dart';
import 'package:raghad_pro/features/home/controller/search_controller.dart';
import 'package:raghad_pro/features/home/view/widget/search_resualt.dart';
import 'package:raghad_pro/features/profile/presentation/widget/base_settings.dart';

// class PatientSearchScreen extends GetView<PatientSearchController> {
//   PatientSearchScreen({super.key});
  
//   final homeController = Get.find<HomeController>();

//   @override
//   Widget build(BuildContext context) {
//     return BaseSubSettingsScreen(
//       title: StringManager.searchScreen,
//       content: Column(
//         children: [
//           // 1. حقل إدخال نص البحث
//           CustomTextFiled(
//             textcontroler: controller.searchTextController,
//             hinttext: StringManager.searchDoctor, 
//             prefixIcon: Icons.search,
//             suffixIcon: Icons.close,
//             readOnly: false, 
//             onTap: () {
//               controller.searchTextController.clear();
//               controller.clearSearchResults();
//             },
//             onChanged: controller.onSearchTextChanged,
//           ),
//            SizedBox(height: context.heightPct(0.02)),
      

//           Obx(() => CustomGenericTabs(
//                 tabLabels: const [StringManager.all, StringManager.doctors, StringManager.specialties],
//                 selectedIndex: controller.activeSearchTab.value,
//                 onTabSelected: (index) => controller.updateSearchTab(index),
//               )),
//            SizedBox(height: context.heightPct(0.02)),
      
          
//           Expanded(
//             child: SearchResultsView(
//               searchController: controller,
//               homeController: homeController,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
class PatientSearchScreen extends GetView<PatientSearchController> {
  const PatientSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseSubSettingsScreen(
      title: StringManager.searchScreen,
      content: Column(
        children: [
          // 1. حقل إدخال نص البحث الذكي
          CustomTextFiled(
            textcontroler: controller.searchTextController,
            hinttext: StringManager.searchDoctor, 
            prefixIcon: Icons.search,
            suffixIcon: Icons.close,
            readOnly: false, 
            onTap: () {
              controller.searchTextController.clear();
              controller.clearSearchResults();
            },
            onChanged: controller.onSearchTextChanged,
          ),
          SizedBox(height: context.heightPct(0.02)),

          // 2. تابات الفلترة الديناميكية لنتائج البحث
          Obx(() => CustomGenericTabs(
                tabLabels: const [StringManager.all, StringManager.doctors, StringManager.specialties],
                selectedIndex: controller.activeSearchTab.value,
                onTabSelected: (index) => controller.updateSearchTab(index),
              )),
          SizedBox(height: context.heightPct(0.02)),
      
          // 3. عرض نتائج البحث المفصولة هندسياً تبعاً لحالة الـ Controller
          Expanded(
            child: SearchResultsView(
              searchController: controller,
            ),
          ),
        ],
      ),
    );
  }
}