// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:raghad_pro/core/constanse/app_spacing.dart';
// import 'package:raghad_pro/core/constanse/string_manager.dart';
// import 'package:raghad_pro/core/widget/custom_menu_container.dart';
// import 'package:raghad_pro/core/widget/app_dialog.dart'; // 👈 تأكدي من استدعاء ملف الديالوغ الجديد هنا
// import 'package:raghad_pro/features/profile/controller/profile_controller.dart';
// import 'package:raghad_pro/features/profile/presentation/widget/profile_menu_item.dart';

// class SettingsScreen extends GetView<ProfileController> {
//   const SettingsScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
   

//     return Scaffold(
//       backgroundColor: theme.scaffoldBackgroundColor,
//       appBar: AppBar(
//         title: const Text(StringManager.settings),
//         centerTitle: true,
//       ),
//       body: Padding(
//         padding: AppSpacing.edgeInsets18,
//         child: CustomMenuContainer(
//           children: [
//             ProfileMenuItem(
//               icon: Icons.language_outlined,
//               title: StringManager.changeLanguage,
//               onTap: () =>
//                   _showLanguageCustomDialog(context, controller, theme),
//             ),
//             Divider(
//               height: 1,
//               indent: 60,
//               endIndent: 16,
//               color: theme.colorScheme.primaryContainer.withOpacity(0.3),
//             ),
//             Obx(() => ProfileMenuItem(
//                   icon: controller.isDarkMode.value
//                       ? Icons.dark_mode_outlined
//                       : Icons.light_mode_outlined,
//                   title: StringManager.theme,
//                   onTap: () =>
//                       controller.toggleTheme(!controller.isDarkMode.value),
//                 )),
//           ],
//         ),
//       ),
//     );
//   }

//   // 👈 دالة استدعاء الديالوغ العام الموحد والجديد
//   void _showLanguageCustomDialog(
//       BuildContext context, ProfileController controller, ThemeData theme) {
//     Get.dialog(
//       CustomAppDialog(
//         // 1. تمرير الأيقونة العلوية بشكل مرن
//         topWidget: Icon(
//           Icons.translate,
//           size: 40,
//           color: theme.primaryColor,
//         ),
//         // 2. عنوان الديالوغ مأخوذ من الـ StringManager
//         title: StringManager.changeLanguage,
//         // 3. تمرير الأزرار المخصصة للغة باستخدام الـ الودجت الفرعية المشتركة
//         buttons: [
//           DialogActionButton(
//             text: StringManager.arabic,
//             onTap: () {
//               controller.changeLanguage(StringManager.arabic);
//               Get.back();
//             },
//           ),
//           DialogActionButton(
//             text: StringManager.english,
//             onTap: () {
//               controller.changeLanguage(StringManager.english);
//               Get.back();
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }
