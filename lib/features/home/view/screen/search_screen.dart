import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:raghad_pro/core/constanse/app_spacing.dart';
import 'package:raghad_pro/core/constanse/string_manager.dart';
import 'package:raghad_pro/core/utilis/size_config.dart';
import 'package:raghad_pro/core/widget/custom_tap.dart';
import 'package:raghad_pro/core/widget/custom_text_filed.dart';
import 'package:raghad_pro/features/home/controller/search_controller.dart';
import 'package:raghad_pro/features/home/view/widget/search_resualt.dart';

class PatientSearchScreen extends GetView<PatientSearchController> {
  const PatientSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text(StringManager.searchScreen.tr),
        centerTitle: true,
      ),
      body: Padding(
        padding: AppSpacing.edgeInsets18,
        child: Column(
          children: [
            
            CustomTextFiled(
              textcontroler: controller.searchTextController,
              hinttext: StringManager.searchDoctor.tr, 
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
        
            
            Obx(() => CustomGenericTabs(
                  tabLabels:  [StringManager.all.tr, StringManager.doctors.tr, StringManager.specialties.tr],
                  selectedIndex: controller.activeSearchTab.value,
                  onTabSelected: (index) => controller.updateSearchTab(index),
                )),
            SizedBox(height: context.heightPct(0.02)),
        
            
            Expanded(
              child: SearchResultsView(
                searchController: controller,
              ),
            ),
          ],
        ),
      ),
    );
  }

  
}













































































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