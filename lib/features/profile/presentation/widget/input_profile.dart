import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:raghad_pro/core/constanse/string_manager.dart';
import 'package:raghad_pro/core/helper/validation.dart';
import 'package:raghad_pro/core/utilis/size_config.dart';
import 'package:raghad_pro/core/widget/custom_text_filed.dart';
import 'package:raghad_pro/core/widget/custom_toggle_switch.dart';
import 'package:raghad_pro/features/profile/controller/profile_controller.dart';

class InputEditProfile extends GetView<ProfileController> {
  const InputEditProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: controller.formKeyprofile,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: CustomTextFiled(
                  labl: StringManager.username,
                  hinttext: StringManager.enterUsername,
                  prefixIcon: Icons.person,
                  textcontroler: controller.nameController,
                 // validate: (value) => Validator.validateRequiredField(value??'' ,StringManager.username),
                ),
              ),
              SizedBox(width: context.widthPct(0.01)),
              Expanded(
                child: CustomTextFiled(
                  labl: StringManager.nickname,
                  hinttext: StringManager.enternickname,
                  prefixIcon: Icons.person,
                  textcontroler: controller.nickNameController,
               //   validate: (value) => Validator.validateRequiredField(value??'',StringManager.nickname ),
                ),
              ),
            ],
          ),

          CustomTextFiled(
            labl: StringManager.email,
            hinttext: StringManager.enterEmail,
            prefixIcon: Icons.email,
            textInputType: TextInputType.emailAddress,
            textcontroler: controller.emailUpController,
            //validate: (value) => Validator.validateEmail(value ?? ''),
          ),
          //    Obx(() => CustomTextFiled(
          //       labl: StringManager.currentPassword,
          //       hinttext: StringManager.enterPassword,
          //       prefixIcon: Icons.lock,
          //       suffixIcon: controller.isPasswordHiddenUp.value
          //           ? Icons.visibility_off
          //           : Icons.visibility,
          //       textcontroler: controller.currentPasswordController,
          //       obscureText: controller.isPasswordHiddenUp.value,
          //       onTapSuffixIcon: () => controller.togglePasswordVisibilityUp(),
          //      // validate: (value) => Validator.validatePassword(value ?? ''),
          //     )),

          // Obx(() => CustomTextFiled(
          //       labl: StringManager.password,
          //       hinttext: StringManager.enterPassword,
          //       prefixIcon: Icons.lock,
          //       suffixIcon: controller.isPasswordHiddenUp.value
          //           ? Icons.visibility_off
          //           : Icons.visibility,
          //       textcontroler: controller.passwordUPController,
          //       obscureText: controller.isPasswordHiddenUp.value,
          //       onTapSuffixIcon: () => controller.togglePasswordVisibilityUp(),
          //      // validate: (value) => Validator.validatePassword(value ?? ''),
          //     )),

          // Obx(() => CustomTextFiled(
          //       labl: StringManager.confirm_password,
          //       hinttext: StringManager.enterconfirm_password,
          //       prefixIcon: Icons.lock,
          //       suffixIcon: controller.isPasswordHiddenUp.value
          //           ? Icons.visibility_off
          //           : Icons.visibility,
          //       textcontroler: controller.confirmpasswordUPController,
          //       obscureText: controller.isPasswordHiddenUp.value,
          //       onTapSuffixIcon: () => controller.togglePasswordVisibilityUp(),
          //     //  validate: (value)=> Validator.validateConfirmPassword(
          //       //  value, 
          //       //  controller.passwordUPController.text,
          //      // ),
          //     )),
          Obx(() => CustomTextFiled(
                labl: StringManager.currentPassword,
                hinttext: StringManager.enterPassword,
                prefixIcon: Icons.lock,
                suffixIcon: controller.isPasswordHiddenUp.value
                    ? Icons.visibility_off
                    : Icons.visibility,
                textcontroler: controller.currentPasswordController,
                obscureText: controller.isPasswordHiddenUp.value,
                onTapSuffixIcon: () => controller.togglePasswordVisibilityUp(),
                validate: (value) {
                  if (controller.passwordUPController.text.isEmpty) {
                    return null;
                  }
                  if (value == null || value.isEmpty) {
                    return StringManager.enterPassword; 
                  }
                  return Validator.validatePassword(value);
                },
              )),

          Obx(() => CustomTextFiled(
                labl: StringManager.password,
                hinttext: StringManager.enterPassword,
                prefixIcon: Icons.lock,
                suffixIcon: controller.isPasswordHiddenUp.value
                    ? Icons.visibility_off
                    : Icons.visibility,
                textcontroler: controller.passwordUPController,
                obscureText: controller.isPasswordHiddenUp.value,
                onTapSuffixIcon: () => controller.togglePasswordVisibilityUp(),
                validate: (value) {
                  if (controller.currentPasswordController.text.isEmpty && (value == null || value.isEmpty)) {
                    return null;
                  }
                  if (value == null || value.isEmpty) {
                    return StringManager.enterPassword;
                  }
                  return Validator.validatePassword(value);
                },
              )),

          Obx(() => CustomTextFiled(
                labl: StringManager.confirm_password,
                hinttext: StringManager.enterconfirm_password,
                prefixIcon: Icons.lock,
                suffixIcon: controller.isPasswordHiddenUp.value
                    ? Icons.visibility_off
                    : Icons.visibility,
                textcontroler: controller.confirmpasswordUPController,
                obscureText: controller.isPasswordHiddenUp.value,
                onTapSuffixIcon: () => controller.togglePasswordVisibilityUp(),
                validate: (value) {
                  if (controller.passwordUPController.text.isEmpty) {
                    return null;
                  }
                  if (value == null || value.isEmpty) {
                    return StringManager.enterconfirm_password;
                  }
                  return Validator.validateConfirmPassword(
                    value, 
                    controller.passwordUPController.text,
                  );
                },
              )),

          CustomTextFiled(
            labl: StringManager.phone_number,
            hinttext: StringManager.enterphone_number,
            prefixIcon: Icons.phone,
            textInputType: TextInputType.phone,
            textcontroler: controller.phone,
           // validate: (value)=> Validator.validateMobile(value??''),
          ),

          
          GestureDetector(
            onTap: () => controller.selectDate(context),
            child: AbsorbPointer(
              child: CustomTextFiled(
                labl: StringManager.date_of_birth,
                hinttext: StringManager.enterdate_of_birth,
                prefixIcon: Icons.calendar_month,
                textcontroler: controller.dateOfBridth,
               // validate:(value) => Validator.validateBirthDate(value),
              ),
            ),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.only(left: 4.0, bottom: 8.0, right: 4.0),
                child: Text(
                  StringManager.gender,
                  style: Theme.of(context).textTheme.bodyMedium
                ),
              ),
              Obx(() {
                int currentIdx =
                    controller.selectedGender.value == StringManager.female
                        ? 1
                        : 0;

                return CustomToggleSwitch(
                  labels: const [StringManager.male, StringManager.female],
                  selectedIndex: currentIdx,
                  onSelect: (index) {
                    String genderResult = (index == 1) ? StringManager.female :StringManager.male;
                    controller.changeGender(genderResult);
                  },
                );
              }),
            ],
          ),
          SizedBox(height: context.heightPct(0.05)),
        ],
      ),
    );
  }
}

