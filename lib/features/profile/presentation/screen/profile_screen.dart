import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:raghad_pro/core/constanse/app_spacing.dart';
import 'package:raghad_pro/core/constanse/string_manager.dart';
import 'package:raghad_pro/core/theme/app_colors.dart';
import 'package:raghad_pro/core/utilis/size_config.dart';
import 'package:raghad_pro/core/widget/custom_botton.dart';
import 'package:raghad_pro/core/widget/dialoge_action.dart';
import 'package:raghad_pro/features/profile/controller/profile_controller.dart';
import 'package:raghad_pro/features/profile/presentation/widget/profile_background_header.dart';
import 'package:raghad_pro/features/profile/presentation/widget/profile_menu_list_widget.dart';

class ProfileScreen extends GetView<ProfileController> {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const ProfileBackgroundHeader(),
            
            Padding(
              padding: AppSpacing.screenPadding16_20,
              child: Column(
                children: [
                  SizedBox(height: context.heightPct(0.04)),
                  const ProfileMenuList(), // القائمة المنظمة
                  SizedBox(height: context.heightPct(0.08)),
                 Obx(() => controller.isLogoutLoading.value
                      ? const Center(child: CircularProgressIndicator())
                      : _buildSignOutButton(context, theme)),
                  SizedBox(height: context.heightPct(0.05)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

Widget _buildSignOutButton(BuildContext context, ThemeData theme) {
    return CustomBottomWidget(
      text: StringManager.signOutButtonText.tr,
     //icon: Icons.logout,
      backgroundColor: theme.colorScheme.surface,
      border: Border.all(color: AppColors.error, width: 1),
      colortext: AppColors.error,
      fontWeight: FontWeight.bold,
      textColor: AppColors.error,
      onTap: () {
       
        CustomActionDialog.show(
          context: context,
          icon: Icons.logout_rounded,
          iconColor: AppColors.error,
          iconBackgroundColor: AppColors.error.withOpacity(0.1),
          title: StringManager.logoutTitle,
          subtitle: StringManager.logoutConfirmation,
          confirmButtonText: StringManager.confirm, 
          onConfirm: () {
          
            controller.logoutUser(); 
          },
          isSecondaryButtonVisible: true,
          secondaryButtonText: StringManager.cancel, 
        );
      },
    );
  }
}