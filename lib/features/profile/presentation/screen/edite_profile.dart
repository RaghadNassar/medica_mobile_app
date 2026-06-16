import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:raghad_pro/core/constanse/string_manager.dart';
import 'package:raghad_pro/core/utilis/size_config.dart';
import 'package:raghad_pro/features/auth/view/widget/auth_scaffold.dart';
import 'package:raghad_pro/features/home/view/widget/edit_icon_button.dart';
import 'package:raghad_pro/features/profile/controller/profile_controller.dart';
import 'package:raghad_pro/features/profile/presentation/widget/base_settings.dart';
import 'package:raghad_pro/features/profile/presentation/widget/input_profile.dart';
import 'package:raghad_pro/features/profile/presentation/widget/profile_image_with_edit.dart';
import 'package:raghad_pro/features/profile/presentation/widget/submit_editeProfile.dart';

class UpdateProfile extends GetView<ProfileController> {
  const UpdateProfile({super.key});

  @override
  Widget build(BuildContext context) {
    controller.fillControllersWithCurrentData();

    return BaseSubSettingsScreen(
      title: StringManager.updateProfile,
      content: AuthScaffold(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: context.heightPct(0.02)),
            Obx(() {
              if (controller.pickedImage.value != null) {
                double imageSize = context.widthPct(0.22);
                return SizedBox(
                  height: imageSize + 10,
                  width: imageSize + 10,
                  child: Stack(
                    alignment: Alignment.topLeft,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(imageSize / 2),
                        child: Image.file(
                         File(controller.pickedImage.value!.path),
                          height: imageSize,
                          width: imageSize,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: EditIconButton(
                          onTap: () => controller.pickProfileImage(),
                          theme: Theme.of(context),
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                String? currentNetworkImage =
                    controller.patientProfile.value?.data.personalInfo.image;
                return ProfileImageWithEdit(
                  imagePath: currentNetworkImage,
                  onEditTap: () => controller.pickProfileImage(),
                );
              }
            }),
            SizedBox(height: context.heightPct(0.04)),
            const InputEditProfile(),
            SizedBox(height: context.heightPct(0.02)),
            const SubmitEditeprofile(),
          ],
        ),
      ),
    );
  }
}
