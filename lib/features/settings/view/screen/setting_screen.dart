import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:raghad_pro/core/constanse/app_route.dart';
import 'package:raghad_pro/core/constanse/app_spacing.dart';
import 'package:raghad_pro/core/constanse/string_manager.dart';
import 'package:raghad_pro/core/utilis/size_config.dart';
import 'package:raghad_pro/core/widget/custom_menu_container.dart';
import 'package:raghad_pro/core/widget/app_dialog.dart';
import 'package:raghad_pro/features/profile/presentation/widget/profile_menu_item.dart';
import 'package:raghad_pro/features/settings/controller/settings_logic.dart';

class SettingsScreen extends GetView<SettingsController> {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(StringManager.settings.tr),
        centerTitle: true,
      ),
      body: Padding(
        padding: AppSpacing.edgeInsets18,
        child: Column(
          children: [
             SizedBox(height: context.heightPct(0.02),),
            CustomMenuContainer(
              children: [
                ProfileMenuItem(
                  icon: Icons.language_outlined,
                  title: StringManager.changeLanguage.tr,
                  onTap: () =>
                      _showLanguageCustomDialog(context, controller, theme),
                ),
                Divider(
                  height: 1,
                  indent: 60,
                  endIndent: 16,
                  color: theme.colorScheme.primaryContainer.withOpacity(0.3),
                ),
                Obx(() => ProfileMenuItem(
                      icon: controller.isDarkMode.value
                          ? Icons.dark_mode_outlined
                          : Icons.light_mode_outlined,
                      title: StringManager.theme.tr,
                      onTap: () =>
                          controller.toggleTheme(!controller.isDarkMode.value),
                    )),
              ],
            ),
          SizedBox(height: context.heightPct(0.02),),
            CustomMenuContainer(
              children: [
                ProfileMenuItem(
                  icon: Icons.lock_outline,
                  title: StringManager.changePassword.tr,
                  onTap: () => Get.toNamed(AppRoutes.changepassword),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showLanguageCustomDialog(
      BuildContext context, SettingsController controller, ThemeData theme) {
    Get.dialog(
      CustomAppDialog(
        topWidget: Icon(
          Icons.translate,
          size: 40,
          color: theme.primaryColor,
        ),
        title: StringManager.changeLanguage.tr,
        buttons: [
          DialogActionButton(
            text: StringManager.arabic.tr,
            onTap: () {
              controller.changeLanguage('ar');
              Get.back();
            },
          ),
          DialogActionButton(
            text: StringManager.english.tr,
            onTap: () {
              controller.changeLanguage('en');
              Get.back();
            },
          ),
        ],
      ),
    );
  }
}
