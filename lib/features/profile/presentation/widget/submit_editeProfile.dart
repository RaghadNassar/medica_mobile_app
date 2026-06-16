import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:raghad_pro/core/constanse/app_spacing.dart';
import 'package:raghad_pro/core/constanse/string_manager.dart';
import 'package:raghad_pro/core/widget/custom_botton.dart';
import 'package:raghad_pro/features/profile/controller/profile_controller.dart';

class SubmitEditeprofile extends GetView<ProfileController> {
  const SubmitEditeprofile({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Obx(() {
          return controller.isLoadingUP.value
              ? const Center(
                  child: Padding(
                    padding: AppSpacing.vertical8,
                    child: CircularProgressIndicator(),
                  ),
                )
              : CustomBottomWidget(
                  text: StringManager.save, 
                  backgroundColor: Theme.of(context).primaryColor,
                  colortext: Theme.of(context).colorScheme.surface,
                  onTap: () {
                   
                    controller.updateProfileFinal();
                  },
                );
        }),
      ],
    );
  }
}