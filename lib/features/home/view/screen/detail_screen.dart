import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:raghad_pro/core/constanse/app_spacing.dart';
import 'package:raghad_pro/core/constanse/string_manager.dart';
import 'package:raghad_pro/core/theme/app_colors.dart';
import 'package:raghad_pro/core/widget/custom_botton.dart';
import 'package:raghad_pro/features/home/controller/doctor_book_logic.dart';
import 'package:raghad_pro/features/home/view/screen/book_confirm_screen.dart';
import 'package:raghad_pro/features/home/view/widget/doctor_detail_body_content.dart';
import 'package:raghad_pro/features/home/view/widget/doctor_detail_header.dart';

class DoctorDetailsScreen extends StatefulWidget {
  const DoctorDetailsScreen({super.key});

  @override
  State<DoctorDetailsScreen> createState() => _DoctorDetailsScreenState();
}

class _DoctorDetailsScreenState extends State<DoctorDetailsScreen> {
  late final DoctorBookingController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = Get.find<DoctorBookingController>();
  }

  @override
  void dispose() {
    _ctrl.stopListening();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: AppSpacing.edgeInsets18,
          child: Obx(() {
            final bool isLoading = _ctrl.isBookingLoading.value ||
                _ctrl.isUpdateBookingLoading.value;
            final bool isTimeSelected = _ctrl.selectedTime.value != null;

            return CustomBottomWidget(
              text: isLoading
                  ? StringManager.loading.tr
                  : (_ctrl.isRescheduling.value
                      ? StringManager.save.tr
                      : StringManager.bookNow.tr),
              colortext: AppColors.lightSurface,
              fontWeight: FontWeight.bold,
              // onTap: (!isTimeSelected || isLoading)
              //     ? null
              //     : () {
              //         final selectedSlot = _ctrl.doctorSlots.firstWhere(
              //           (slot) => slot.time == _ctrl.selectedTime.value,
              //         );

              //         if (_ctrl.isRescheduling.value) {
              //           _ctrl.rescheduleAppointment(
              //             appointmentUuid: _ctrl.appointmentUuidToModify.value,
              //             doctorUuid: _ctrl.currentDoctor.value!.uuid,
              //             newDateTime: selectedSlot.fullDate,
              //             type: _ctrl.selectedBookingType.value,
              //           );
              //         } else {
              //           if (_ctrl.bookForSomeoneElse.value) {
              //             if (_ctrl.someoneFormKey.currentState!.validate()) {
              //               _ctrl.bookForSomeoneFinal();
              //             }
              //           } else {
              //             _ctrl.bookAppointmentFinal();
              //           }
              //         }
              //       },
              onTap: (!isTimeSelected || isLoading)
    ? null
    : () {
        final selectedSlot = _ctrl.doctorSlots.firstWhere(
          (slot) => slot.time == _ctrl.selectedTime.value,
        );

        if (!_ctrl.isRescheduling.value && _ctrl.bookForSomeoneElse.value) {
          if (!_ctrl.someoneFormKey.currentState!.validate()) {
            return; // إيقاف العملية إذا كانت البيانات غير مكتملة
          }
        }
       // _ctrl.stopListening();

        // الانتقال إلى صفحة تأكيد الحجز
        Get.to(() => const BookingConfirmationScreen());
      },
            );
          }),
        ),
      ),
      body: const CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: [
          DoctorDetailsHeaderSection(),
          DoctorDetailsBodyContent(),
        ],
      ),
    );
  }
}

















































/*
class DoctorDetailsScreen extends StatelessWidget {
  const DoctorDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<DoctorBookingController>()
        ? Get.find<DoctorBookingController>()
        : Get.put(DoctorBookingController(Get.find<RepostryHome>()));

    return Scaffold(
       backgroundColor: Theme.of(context).colorScheme.surface, // Use the surface color from the theme
      //backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: AppSpacing.edgeInsets18,
          child: Obx(() {
            final bool isLoading = controller.isBookingLoading.value ||
                controller.isUpdateBookingLoading.value;

            final bool isTimeSelected = controller.selectedTime.value != null;

            return CustomBottomWidget(
              text: isLoading
                  ? StringManager.loading.tr
                  : (controller.isRescheduling.value
                      ? StringManager.save.tr
                      : StringManager.bookNow.tr),
              colortext: AppColors.lightSurface,
              fontWeight: FontWeight.bold,
              onTap: (!isTimeSelected || isLoading)
                  ? null
                  : () {
                      final selectedSlot = controller.doctorSlots.firstWhere(
                        (slot) => slot.time == controller.selectedTime.value,
                      );

                      if (controller.isRescheduling.value) {
                        controller.rescheduleAppointment(
                          appointmentUuid:
                              controller.appointmentUuidToModify.value,
                          doctorUuid: controller.currentDoctor.value!.uuid,
                          newDateTime: selectedSlot.fullDate,
                          type: controller.selectedBookingType.value,
                        );
                      } else {
                        if (controller.bookForSomeoneElse.value) {
                          if (controller.someoneFormKey.currentState!
                              .validate()) {
                            controller.bookForSomeoneFinal();
                          }
                        } else {
                          controller.bookAppointmentFinal();
                        }
                      }
                    },
            );
          }),
        ),
      ),
      body: const CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: [
          DoctorDetailsHeaderSection(),
          DoctorDetailsBodyContent(),
        ],
      ),
    );
  }
}
*/

























































// class DoctorDetailsScreen extends GetView<HomeController> {
//   const DoctorDetailsScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Theme.of(context).scaffoldBackgroundColor,
//       bottomNavigationBar: SafeArea(
//         child: Padding(
//             padding: AppSpacing.edgeInsets18,
//             child: Obx(() {
//               final bool isLoading = controller.isBookingLoading.value ||
//                   controller.isUpdateBookingLoading.value;

//               final bool isTimeSelected = controller.selectedTime.value != null;

//               return CustomBottomWidget(
//                 text: isLoading
//                     ? "loading"
//                     : (controller.isRescheduling.value
//                         ? StringManager.save
//                         : StringManager.bookNow),
//                 colortext: AppColors.lightSurface,
//                 fontWeight: FontWeight.bold,
//                 onTap: (!isTimeSelected || isLoading)
//                     ? null
//                     : () {
//                         final selectedSlot = controller.doctorSlots.firstWhere(
//                           (slot) => slot.time == controller.selectedTime.value,
//                         );

//                         if (controller.isRescheduling.value) {
//                           controller.rescheduleAppointment(
//                             appointmentUuid:
//                                 controller.appointmentUuidToModify.value,
//                             doctorUuid: controller.currentDoctor.value!.uuid,
//                             newDateTime: selectedSlot.fullDate,
//                             type: controller.selectedBookingType.value,
//                           );
//                         } else {
//                           if (controller.bookForSomeoneElse.value) {
//                             if (controller.someoneFormKey.currentState!
//                                 .validate()) {
//                               controller.bookForSomeoneFinal();
//                             }
//                           } else {
//                             controller.bookAppointmentFinal();
//                           }
//                         }
//                       },
//               );
//             })
//           //  Obx(() => CustomBottomWidget(
//           //       text: StringManager.bookNow,
//           //       colortext: AppColors.lightSurface,
//           //       fontWeight: FontWeight.bold,
//           //       //
//           //       onTap: controller.selectedTime.value == null
//           //           ? null
//           //           : () => controller.bookAppointmentFinal(),
//           //     )),
//         ),
//       ),
//       body: const CustomScrollView(
//         physics: BouncingScrollPhysics(),
//         slivers: [
//           DoctorDetailsHeaderSection(),
//           DoctorDetailsBodyContent(),
//         ],
//       ),
//     );
//   }
// }


/*
class DoctorDetailsScreen extends GetView<HomeController> {
  const DoctorDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final DoctorBySpecialtyModel? selectedDoctor = Get.arguments;
    if (selectedDoctor != null) {
      controller.initDoctorDetails(selectedDoctor);
    }
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: AppSpacing.edgeInsets18,
          child: Obx(() => CustomBottomWidget(
                text: StringManager.bookNow,
                colortext: AppColors.lightSurface,
                fontWeight: FontWeight.bold,
                onTap: controller.selectedTime.value == null
                    ? null
                    : () => controller.bookAppointment(),
              )),
        ),
      ),
      body: const CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: [
          DoctorDetailsHeaderSection(),
          DoctorDetailsBodyContent(),
        ],
      ),
    );
  }
}*/
// التفعيل الذكي: إذا لم يتم اختيار وقت أو كان هناك تحميل، يكون الزر معطلاً (null)
    // onTap: (!isTimeSelected || isLoading)
    //     ? null
    //     : () {
    //         // جلب الـ fullDate الخاص بالـ Slot الذي تم اختياره حالياً
    //         final selectedSlot = controller.doctorSlots.firstWhere(
    //           (slot) => slot.time == controller.selectedTime.value,
    //         );

    //         if (controller.isRescheduling.value) {
    //          
    //           controller.rescheduleAppointment(
    //             appointmentUuid: controller.appointmentUuidToModify.value,
    //             doctorUuid: controller.currentDoctor.value!.uuid,
    //             newDateTime: selectedSlot.fullDate, // التاريخ والوقت المحدث
    //             type: controller.selectedBookingType.value,
    //           );
    //         } else {
    //          
    //           controller.bookAppointmentFinal();
    //         }
    //       },