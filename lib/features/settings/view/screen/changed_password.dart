import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:raghad_pro/core/constanse/string_manager.dart';
import 'package:raghad_pro/core/utilis/size_config.dart';
import 'package:raghad_pro/features/profile/controller/profile_controller.dart';
import 'package:raghad_pro/features/profile/presentation/widget/base_settings.dart';
import 'package:raghad_pro/features/settings/view/widget/change_password_card.dart';
import 'package:raghad_pro/features/settings/view/widget/forget_password_card.dart';

class ChangePasswordScreen extends GetView<ProfileController> {
  const ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    
    controller.currentPasswordController.clear();
    controller.passwordUPController.clear();
    controller.confirmpasswordUPController.clear();

    return BaseSubSettingsScreen(
      title: StringManager.changePassword.tr,
      content: Form(
        key: controller.formKeyprofile,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: context.heightPct(0.02)),
              Text(
                StringManager.changePassword.tr,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
               SizedBox(height:context.heightPct(0.01)),

              Text(
               StringManager.pleasEnterYourCurrent.tr, 
                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey),
              ),
              SizedBox(height:context.heightPct(0.02)),

      
             
              ChangePasswordCard(controller: controller),
              
              SizedBox(height:context.heightPct(0.03)),

      
            
              const ForgotPasswordCard(),
              
              SizedBox(height:context.heightPct(0.01)),

            ],
          ),
        ),
      ),
    );
  }
}

























// class ChangePasswordScreen extends GetView<ProfileController> {
//   const ChangePasswordScreen({super.key});

//   @override
//   Widget build(BuildContext context) {

//     controller.currentPasswordController.clear();
//     controller.passwordUPController.clear();
//     controller.confirmpasswordUPController.clear();

//     return BaseSubSettingsScreen(
//       title: StringManager.changePassword.tr,
//       content: AuthScaffold(
//         child: Form(
//           key: controller.formKeyprofile,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               SizedBox(height: context.heightPct(0.02)),
//               Text(
//                 StringManager.changePassword.tr,
//                 style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 4),
//               Text(
//                 "أدخل كلمة المرور الحالية وكلمة المرور الجديدة", 
//                 style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey),
//               ),
//               const SizedBox(height: 24),


//               Obx(() => CustomTextFiled(
//                     labl: StringManager.currentPassword.tr,
//                     hinttext: StringManager.enterPassword.tr,
//                     prefixIcon: Icons.lock_outline,
//                     suffixIcon: controller.isPasswordHiddenUp.value ? Icons.visibility_off : Icons.visibility,
//                     textcontroler: controller.currentPasswordController,
//                     obscureText: controller.isPasswordHiddenUp.value,
//                     onTapSuffixIcon: () => controller.togglePasswordVisibilityUp(),
//                     validate: (value) {
//                       if (value == null || value.isEmpty) {
//                         return StringManager.enterPassword.tr; 
//                       }
//                       return Validator.validatePassword(value);
//                     },
//                   )),
//               const SizedBox(height: 16),


//               Obx(() => CustomTextFiled(
//                     labl: StringManager.password.tr,
//                     hinttext: StringManager.enterPassword.tr,
//                     prefixIcon: Icons.lock_outline,
//                     suffixIcon: controller.isPasswordHiddenUp.value ? Icons.visibility_off : Icons.visibility,
//                     textcontroler: controller.passwordUPController,
//                     obscureText: controller.isPasswordHiddenUp.value,
//                     onTapSuffixIcon: () => controller.togglePasswordVisibilityUp(),
//                     validate: (value) {
//                       if (value == null || value.isEmpty) {
//                         return StringManager.enterPassword.tr;
//                       }
//                       return Validator.validatePassword(value);
//                     },
//                   )),
//               const SizedBox(height: 16),

              
//               Obx(() => CustomTextFiled(
//                     labl: StringManager.confirm_password.tr,
//                     hinttext: StringManager.enterconfirm_password.tr,
//                     prefixIcon: Icons.lock_outline,
//                     suffixIcon: controller.isPasswordHiddenUp.value ? Icons.visibility_off : Icons.visibility,
//                     textcontroler: controller.confirmpasswordUPController,
//                     obscureText: controller.isPasswordHiddenUp.value,
//                     onTapSuffixIcon: () => controller.togglePasswordVisibilityUp(),
//                     validate: (value) {
//                       if (value == null || value.isEmpty) {
//                         return StringManager.enterconfirm_password.tr;
//                       }
//                       return Validator.validateConfirmPassword(
//                         value, 
//                         controller.passwordUPController.text,
//                       );
//                     },
//                   )),
              
//               const SizedBox(height: 32),

              
//               Obx(() {
//                 return controller.isLoadingUP.value
//                     ? const Center(child: CircularProgressIndicator())
//                     : CustomBottomWidget(
//                         text: "تحديث كلمة المرور", 
//                         backgroundColor: Theme.of(context).primaryColor,
//                         colortext: Theme.of(context).colorScheme.surface,
//                         onTap: () {
//                           controller.updateProfileFinal();
//                         },
//                       );
//               }),
//               const SizedBox(height: 32),
//               Container(
//                 width: double.infinity,
//                 padding: const EdgeInsets.all(20),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(16),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.03),
//                       blurRadius: 10,
//                       offset: const Offset(0, 4),
//                     ),
//                   ],
//                 ),
//                 child: Column(
//                   crossAxisAlignment:CrossAxisAlignment.start ,
//                   children: [
//                     Text(
//                       "نسيت كلمة المرور؟",
//                       style: Theme.of(context).textTheme.titleLarge?.copyWith(
//                             fontWeight: FontWeight.bold,
//                           ),
//                     ),
//                     const SizedBox(height: 8),
//                     Text(
//                       "إذا لم تتذكر كلمة المرور الحالية، يمكنك إعادة تعيينها عبر البريد الإلكتروني أو رقم الهاتف.",
//                       textAlign: TextAlign.center,
//                       style: Theme.of(context).textTheme.bodySmall?.copyWith(
//                             color: Colors.grey[400],
//                             height: 1.4,
//                           ),
//                     ),
//                     const SizedBox(height: 20),
                    
//                     // الزر الداخلي ذو الخلفية الرمادية الفاتحة والحواف الدائرية المحيطة بالنص
//                     GestureDetector(
//                       onTap: () {
//                         // الانتقال إلى صفحة نسيت كلمة المرور (عدّلي الاسم حسب الـ Routes لديكِ)
//                         Get.toNamed('/forgot-password'); 
//                       },
//                       child: Container(
//                         width: double.infinity,
//                         padding: const EdgeInsets.symmetric(vertical: 14),
//                         decoration: BoxDecoration(
//                           color: const Color(0xFFF5F7F8), // لون رمادي ناعم جداً مطابق للصورة
//                           borderRadius: BorderRadius.circular(30), // حواف دائرية بالكامل (Pill Shape)
//                         ),
//                         child: Center(
//                           child: Text(
//                             "إعادة التعيين عبر البريد أو الهاتف",
//                             style: TextStyle(
//                               color: Theme.of(context).primaryColor, // اللون الفيروزي الأساسي للتطبيق
//                               fontWeight: FontWeight.bold,
//                               fontSize: 15,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }