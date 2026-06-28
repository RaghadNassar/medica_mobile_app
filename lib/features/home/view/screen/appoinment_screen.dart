import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:raghad_pro/core/constanse/app_assets.dart';
import 'package:raghad_pro/core/constanse/app_spacing.dart';
import 'package:raghad_pro/core/constanse/string_manager.dart';
import 'package:raghad_pro/core/theme/app_colors.dart';
import 'package:raghad_pro/core/widget/custom_skeletinizor.dart';
import 'package:raghad_pro/core/widget/custom_tap.dart';
import 'package:raghad_pro/core/widget/dialoge_action.dart';
import 'package:raghad_pro/core/widget/null_data_widget.dart';
import 'package:raghad_pro/features/home/controller/doctor_book_logic.dart';
import 'package:raghad_pro/features/home/controller/patient_book_controller.dart';
import 'package:raghad_pro/features/home/data/model/get_booking.dart';
import 'package:raghad_pro/features/home/data/model/top_doctor_model.dart';
import 'package:raghad_pro/features/home/view/screen/detail_screen.dart';
import 'package:raghad_pro/features/home/view/widget/book_card.dart';
import 'package:raghad_pro/features/profile/presentation/widget/base_settings.dart'; // تأكدي من مسار ملف الـ CustomBottomWidget

class AppoinmentScreen extends GetView<PatientAppointmentController> {
  const AppoinmentScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BaseSubSettingsScreen(
      title: StringManager.appointmentScreen.tr,
      content: Column(
        children: [
          Obx(() => Padding(
                padding: AppSpacing.screenPadding121_61,
                child: CustomGenericTabs(
                  tabLabels: [
                    StringManager.tabBooked.tr,
                    StringManager.tabWaiting.tr,
                    StringManager.tabChanged.tr,
                    StringManager.tabCompleted.tr,
                  ],
                  selectedIndex: controller.appointmentTabControllerIndex.value,
                  onTabSelected: (index) =>
                      controller.changeAppointmentTab(index),
                ),
              )),
          Expanded(
            child: Obx(() {
              final bool isLoading = controller.isAppointmentsLoading.value;
              final List<BookingModel> currentList = _getFilteredAppointments();

              if (!isLoading && currentList.isEmpty) {
                return NullDataWidget(
                  text: StringManager.noAppointmentsInThisSpecialization.tr,
                  imagePath: Appassets.nulldata2,
                );
              }

              return CustomSkeletonizer(
                isLoading: isLoading,
                child: RefreshIndicator(
                  onRefresh: () => controller.getPatientAppointments(),
                  child: ListView.builder(
                    itemCount: isLoading ? 3 : currentList.length,
                    padding: AppSpacing.screenPadding4,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      final appointment = isLoading ? null : currentList[index];

                      return AppointmentCard(
                        appointment: appointment,
                        showActions: isLoading
                            ? false
                            : controller.appointmentTabControllerIndex.value !=
                                3,
                        onCancel: isLoading || appointment == null
                            ? null
                            : () => _showCancelDialog(context, appointment),
                        onReschedule: isLoading || appointment == null
                            ? null
                            : () => _handleReschedule(appointment),
                      );
                    },
                  ),
                ),
              );
            }),
          )
         
        ],
      ),
    );
  }

  void _showCancelDialog(BuildContext context, BookingModel appt) {
    CustomActionDialog.show(
      context: context,
      icon: Icons.warning_amber_rounded,
      iconColor: AppColors.warning,
      iconBackgroundColor: AppColors.warning.withOpacity(0.1),
      title: StringManager.cancelConfirmTitle.tr,
      subtitle: StringManager.cancelConfirmSubtitle.tr,
      hintText: StringManager.cancelConfirmHint.tr,
      confirmButtonText: StringManager.cancelConfirmBtn.tr,
      onConfirm: () {
        Get.back();
        controller.cancelAppointment(appt.appointmentUuid);
      },
    );
  }

  void _handleReschedule(BookingModel appt) {
    final doctor = TopDoctorModel(
      uuid: appt.doctor.uuid,
      name: appt.doctor.name,
      specialization: appt.doctor.specialization,
      clinic: appt.doctor.clinic,
      image: appt.doctor.image ?? '',
      visitTime: appt.doctor.visitTime,
      patientsCount: appt.doctor.patientsCount,
      averageRating: appt.doctor.rating,
      reviewersCount: appt.doctor.reviewersCount,
    );

    Get.find<DoctorBookingController>().initDoctorDetailsForReschedule(
      doctor: doctor,
      appointmentUuid: appt.appointmentUuid,
      oldAppointmentDateTime: appt.dateTime,
    );

    Get.to(() => const DoctorDetailsScreen());
  }

  List<BookingModel> _getFilteredAppointments() {
    switch (controller.appointmentTabControllerIndex.value) {
      case 0:
        return controller.bookedAppointments;
      case 1:
        return controller.waitingAppointments;
      case 2:
        return controller.changedAppointments;
      case 3:
        return controller.visitedAppointments;
      default:
        return controller.bookedAppointments;
    }
  }
}























 // Expanded(
          //   child: Obx(() {
          //     if (controller.isAppointmentsLoading.value) {
          //       return const Center(child: CircularProgressIndicator());
          //     }

          //     final List<BookingModel> currentList = _getFilteredAppointments();

          //     if (currentList.isEmpty) {
          //       return NullDataWidget(
          //         text: StringManager.noAppointmentsInThisSpecialization,
          //         imagePath: Appassets.nulldata2,
          //       );
          //     }

          //     return RefreshIndicator(
          //       onRefresh: () => controller.getPatientAppointments(),
          //       child: ListView.builder(
          //         itemCount: currentList.length,
          //         padding: AppSpacing.screenPadding4,
          //         itemBuilder: (context, index) {
          //           final appointment = currentList[index];
          //           return AppointmentCard(
          //             appointment: appointment,
          //             showActions: controller.appointmentTabControllerIndex.value != 3,
          //             onCancel:    () => _showCancelDialog(context, appointment),
          //             onReschedule: () => _handleReschedule(appointment),
          //           );
          //         },
          //       ),
          //     );
          //   }),
          // ),



















// class AppoinmentScreen extends GetView<HomeController> {
//   const AppoinmentScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);

//     return BaseSubSettingsScreen(
//       title: StringManager.appointmentScreen,
//       content: Column(
//         children: [
//           Obx(() => Padding(
//                 padding: AppSpacing.screenPadding121_61,
//                 child: CustomGenericTabs(
//                   tabLabels: const ["book", "waiting", "changed", "completed"],
//                   selectedIndex: controller.appointmentTabControllerIndex.value,
//                   onTabSelected: (index) {
//                     controller.changeAppointmentTab(index);
//                   },
//                 ),
//               )),
//           Expanded(
//             child: Obx(() {
//               if (controller.isAppointmentsLoading.value) {
//                 return const Center(child: CircularProgressIndicator());
//               }

//               final List<BookingModel> currentList = _getFilteredAppointments();

//               if (currentList.isEmpty) {
//                 return NullDataWidget(
//                   text: StringManager.noAppointmentsInThisSpecialization,
//                   imagePath: Appassets.doctorIcon,
//                 );
//               }

//               return RefreshIndicator(
//                 onRefresh: () => controller.getPatientAppointments(),
//                 child: ListView.builder(
//                   itemCount: currentList.length,
//                   padding: AppSpacing.screenPadding4,
//                   itemBuilder: (context, index) {
//                     final appointment = currentList[index];
//                     return AppointmentCard(
//                       appointment: appointment,
//                       showActions:
//                           controller.appointmentTabControllerIndex.value != 3,
//                       onCancel: () {
//                         CustomActionDialog.show(
//                           context: context,
//                           icon: Icons.warning_amber_rounded,
//                           iconColor: AppColors.warning,
//                           iconBackgroundColor:
//                               AppColors.warning.withOpacity(0.1),
//                           title: "تأكيد الإلغاء",
//                           subtitle:
//                               "هل أنت متأكد من رغبتك في إلغاء هذا الموعد نهائياً؟",
//                           hintText: "لا يمكن التراجع عن هذه العملية لاحقاً.",
//                           confirmButtonText: "نعم، إلغاء",
//                           onConfirm: () {
//                             Get.back();
//                             controller
//                                 .cancelAppointment(appointment.appointmentUuid);
//                           },
//                         );
//                       },
//                       onReschedule: () {
//                         final topDoctor = TopDoctorModel(
//                           uuid: appointment.doctor.uuid,
//                           name: appointment.doctor.name,
//                           specialization: appointment.doctor.specialization,
//                           clinic: appointment.doctor.clinic,
//                           image: appointment.doctor.image ?? '',
//                           visitTime: appointment.doctor.visitTime,
//                           patientsCount: appointment.doctor.patientsCount,
//                           averageRating: appointment.doctor.rating,
//                           reviewersCount: appointment.doctor.reviewersCount,
//                         );

//                         // 💡 التعديل هنا: مررنا تاريخ الموعد الحالي (appointment.dateTime) ليعرف التطبيق أي يوم يفتح
//                         controller.initDoctorDetailsForReschedule(
//                           doctor: topDoctor,
//                           appointmentUuid: appointment.appointmentUuid,
//                           oldAppointmentDateTime: appointment.dateTime,
//                         );

//                         Get.to(() => const DoctorDetailsScreen());
//                       },
//                     );
//                   },
//                 ),
//               );
//             }),
//           ),
//         ],
//       ),
//     );
//   }

//   List<BookingModel> _getFilteredAppointments() {
//     switch (controller.appointmentTabControllerIndex.value) {
//       case 0:
//         return controller.bookedAppointments;
//       case 1:
//         return controller.waitingAppointments;
//       case 2:
//         return controller.changedAppointments;
//       case 3:
//         return controller.visitedAppointments;
//       default:
//         return controller.bookedAppointments;
//     }
//   }
// }
