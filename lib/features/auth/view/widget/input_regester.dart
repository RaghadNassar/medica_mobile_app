import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:raghad_pro/core/constanse/app_spacing.dart';
import 'package:raghad_pro/core/constanse/string_manager.dart';
import 'package:raghad_pro/core/helper/validation.dart';
import 'package:raghad_pro/core/utilis/size_config.dart';
import 'package:raghad_pro/core/widget/custom_text_filed.dart';
import 'package:raghad_pro/core/widget/custom_toggle_switch.dart';
import 'package:raghad_pro/features/auth/controler/regester_controller.dart';

class InputRegester extends GetView<RegisterController> {
  const InputRegester({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        child: controller.currentStep.value == 0 
            ? Form(key: controller.formKeyStepOne, child: _buildStepOneFields(context)) 
            : Form(key: controller.formKeyStepTwo, child: _buildStepTwoFields(context)),
      );
    });
  }
    Widget _buildStepOneFields(BuildContext context) {
    return Column(
      key: const ValueKey(0),
      children: [
        Row(
          children: [
            Expanded(
              child: CustomTextFiled(
                labl: StringManager.username.tr,
                hinttext: StringManager.usernameeg.tr, 
                prefixIcon: Icons.person,
                textcontroler: controller.nameController,
                validate: (value) => Validator.validateRequiredField(value??'' ,StringManager.username),
              ),
            ),
            SizedBox(width: context.widthPct(0.02)),
            Expanded(
              child: CustomTextFiled(
                labl: StringManager.nickname.tr,
                hinttext:StringManager.nick.tr , 
                prefixIcon: Icons.person_outline,
                textcontroler: controller.nickNameController,
                validate: (value) => Validator.validateRequiredField(value??'',StringManager.nickname ),
              ),
            ),
          ],
        ),
        CustomTextFiled(
          labl: StringManager.email.tr,
          hinttext: StringManager.emaile.tr, 
          prefixIcon: Icons.email,
          textInputType: TextInputType.emailAddress,
          textcontroler: controller.emailController,
          validate: (value) => Validator.validateEmail(value ?? ''),
        ),
        Obx(() => CustomTextFiled(
          labl: StringManager.password.tr,
          hinttext: StringManager.enterPassword.tr,
          prefixIcon: Icons.lock,
          suffixIcon: controller.isPasswordHidden.value ? Icons.visibility_off : Icons.visibility,
          textcontroler: controller.passwordController,
          obscureText: controller.isPasswordHidden.value,
          onTapSuffixIcon: () => controller.togglePassword(),
          validate: (value) => Validator.validatePassword(value ?? ''),
        )),
        Obx(() => CustomTextFiled(
          labl: StringManager.confirm_password.tr,
          hinttext: StringManager.enterconfirm_password.tr,
          prefixIcon: Icons.lock_clock,
          suffixIcon: controller.isPasswordHidden.value ? Icons.visibility_off : Icons.visibility,
          textcontroler: controller.confirmPasswordController,
          obscureText: controller.isPasswordHidden.value,
          onTapSuffixIcon: () => controller.toggleConfirmPassword(),
          validate: (value)=> Validator.validateConfirmPassword(
            value, 
            controller.passwordController.text,
          ),
        )),
      ],
    );
  }

  Widget _buildStepTwoFields(BuildContext context) {
    return Column(
      key: const ValueKey(1),
      children: [
        CustomTextFiled(
          labl: StringManager.phone_number.tr,
          hinttext: StringManager.phoneex.tr, 
          prefixIcon: Icons.phone,
          textInputType: TextInputType.phone,
          textcontroler: controller.phoneController,
          validate: (value)=> Validator.validateMobile(value??''),
        ),
        GestureDetector(
          onTap: () => controller.selectDate(context),
          child: AbsorbPointer(
            child: CustomTextFiled(
              labl: StringManager.date_of_birth.tr,
              hinttext: StringManager.date.tr,
              prefixIcon: Icons.calendar_month,
              textcontroler: controller.dateOfBirthController,
              validate:(value) => Validator.validateBirthDate(value),
            ),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: AppSpacing.only2,
              child: Text(
                StringManager.gender,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            Obx(() {
              int currentIdx = controller.selectedGender.value == StringManager.female ? 1 : 0;
              return CustomToggleSwitch(
                labels:  [StringManager.male.tr, StringManager.female.tr],
                selectedIndex: currentIdx,
                onSelect: (index) {
                  String genderResult = (index == 1) ? StringManager.female : StringManager.male;
                  controller.changeGender(genderResult);
                },
              );
            }),
          ],
        ),
        SizedBox(height: context.heightPct(0.02)),
      ],
    );
  }
}


















// class InputRegester extends GetView<AuthLogic> {
//   const InputRegester({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Form(
//       key: controller.formKeyUP,
//       child: Column(
//         children: [
//           Row(
//             children: [
//               Expanded(
//                 child: CustomTextFiled(
//                   labl: StringManager.username,
//                   hinttext: StringManager.enterUsername,
//                   prefixIcon: Icons.person,
//                   textcontroler: controller.nameController,
//                   validate: (value) => Validator.validateRequiredField(value??'' ,StringManager.username),
//                 ),
//               ),
//               SizedBox(width: context.widthPct(0.01)),
//               Expanded(
//                 child: CustomTextFiled(
//                   labl: StringManager.nickname,
//                   hinttext: StringManager.enternickname,
//                   prefixIcon: Icons.person,
//                   textcontroler: controller.nickNameController,
//                   validate: (value) => Validator.validateRequiredField(value??'',StringManager.nickname ),
//                 ),
//               ),
//             ],
//           ),

//           CustomTextFiled(
//             labl: StringManager.email,
//             hinttext: StringManager.enterEmail,
//             prefixIcon: Icons.email,
//             textInputType: TextInputType.emailAddress,
//             textcontroler: controller.emailUpController,
//             validate: (value) => Validator.validateEmail(value ?? ''),
//           ),

//           Obx(() => CustomTextFiled(
//                 labl: StringManager.password,
//                 hinttext: StringManager.enterPassword,
//                 prefixIcon: Icons.lock,
//                 suffixIcon: controller.isPasswordHiddenUp.value
//                     ? Icons.visibility_off
//                     : Icons.visibility,
//                 textcontroler: controller.passwordUPController,
//                 obscureText: controller.isPasswordHiddenUp.value,
//                 onTapSuffixIcon: () => controller.togglePasswordVisibilityUp(),
//                 validate: (value) => Validator.validatePassword(value ?? ''),
//               )),

//           Obx(() => CustomTextFiled(
//                 labl: StringManager.confirm_password,
//                 hinttext: StringManager.enterconfirm_password,
//                 prefixIcon: Icons.lock,
//                 suffixIcon: controller.isPasswordHiddenUp.value
//                     ? Icons.visibility_off
//                     : Icons.visibility,
//                 textcontroler: controller.confirmpasswordUPController,
//                 obscureText: controller.isPasswordHiddenUp.value,
//                 onTapSuffixIcon: () => controller.togglePasswordVisibilityUp(),
//                 validate: (value)=> Validator.validateConfirmPassword(
//                   value, 
//                   controller.passwordUPController.text,
//                 ),
//               )),

//           CustomTextFiled(
//             labl: StringManager.phone_number,
//             hinttext: StringManager.enterphone_number,
//             prefixIcon: Icons.phone,
//             textInputType: TextInputType.phone,
//             textcontroler: controller.phone,
//             validate: (value)=> Validator.validateMobile(value??''),
//           ),

          
//           GestureDetector(
//             onTap: () => controller.selectDate(context),
//             child: AbsorbPointer(
//               child: CustomTextFiled(
//                 labl: StringManager.date_of_birth,
//                 hinttext: StringManager.enterdate_of_birth,
//                 prefixIcon: Icons.calendar_month,
//                 textcontroler: controller.dateOfBridth,
//                 validate:(value) => Validator.validateBirthDate(value),
//               ),
//             ),
//           ),

//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Padding(
//                 padding:
//                     const EdgeInsets.only(left: 4.0, bottom: 8.0, right: 4.0),
//                 child: Text(
//                   StringManager.gender,
//                   style: Theme.of(context).textTheme.bodyMedium
//                 ),
//               ),
//               Obx(() {
//                 int currentIdx =
//                     controller.selectedGender.value == StringManager.female
//                         ? 1
//                         : 0;

//                 return CustomToggleSwitch(
//                   labels: const [StringManager.male, StringManager.female],
//                   selectedIndex: currentIdx,
//                   onSelect: (index) {
//                     String genderResult = (index == 1) ? StringManager.female :StringManager.male;
//                     controller.changeGender(genderResult);
//                   },
//                 );
//               }),
//             ],
//           ),
//           SizedBox(height: context.heightPct(0.05)),
//         ],
//       ),
//     );
//   }
// }
