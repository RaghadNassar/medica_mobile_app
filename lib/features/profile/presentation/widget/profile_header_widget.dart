import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:raghad_pro/core/constanse/app_assets.dart';
import 'package:raghad_pro/core/constanse/app_spacing.dart';
import 'package:raghad_pro/core/utilis/size_config.dart';
import 'package:raghad_pro/features/auth/controler/auth_logic.dart';
import 'package:raghad_pro/features/profile/controller/profile_controller.dart';
import 'package:raghad_pro/features/profile/presentation/widget/profile_image_with_edit.dart';
import 'package:raghad_pro/features/profile/presentation/widget/user_info_widget.dart';
/*
class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: AppSpacing.vertical10,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ProfileImageWithEdit(
            imagePath: Appassets.onboarding1,
            onEditTap: () => print("Edit Image Clicked"),
          ),

           SizedBox(width: context.widthPct(0.05)),

          Expanded(child: UserInformation(theme: theme)),
        ],
      ),
    );
  }
}
*/
/*
class ProfileHeader extends GetView<ProfileController> {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: AppSpacing.vertical10,
      child: Obx(() {
        // أخذ معلومات المريض الشخصية إذا جهزت
        final info = controller.patientProfile.value?.data.personalInfo;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ProfileImageWithEdit(
              // إذا كان هناك صورة مخزنة بالسيرفر نعرضها، وإلا نعرض الصورة الافتراضية
              imagePath: (info?.image != null && info!.image!.isNotEmpty) 
                  ? info.image! 
                  : Appassets.onboarding1,
              onEditTap: () => print("Edit Image Clicked"),
            ),

            SizedBox(width: context.widthPct(0.05)),

            Expanded(
              child: UserInformation(
                theme: theme,
                name: info?.name ?? '',
                email: info?.email ?? '',
              ),
            ),
          ],
        );
      }),
    );
  }
}*/
class ProfileHeader extends GetView<ProfileController> {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: AppSpacing.vertical10,
      child: Obx(() {
        final info = controller.patientProfile.value?.data.personalInfo;
        
        // 📸 التحقق من وجود رابط الصورة القادم من الباك إند
        final String? serverImage = (info?.image != null && info!.image!.isNotEmpty) 
            ? info.image 
            : null;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ProfileImageWithEdit(
              imagePath: serverImage, // ممررة كـ String? (قد تكون null)
              onEditTap: () => print("Edit Image Clicked"),
            ),

            SizedBox(width: context.widthPct(0.05)),

            Expanded(
              child: UserInformation(
                theme: theme,
                name: info?.name ?? '',
                email: info?.email ?? '',
              ),
            ),
          ],
        );
      }),
    );
  }
}