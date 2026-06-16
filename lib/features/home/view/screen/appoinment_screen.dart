import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:raghad_pro/core/constanse/app_assets.dart';
import 'package:raghad_pro/core/constanse/app_spacing.dart';
import 'package:raghad_pro/core/constanse/string_manager.dart';
import 'package:raghad_pro/core/theme/app_colors.dart';
import 'package:raghad_pro/core/utilis/size_config.dart';
import 'package:raghad_pro/core/widget/custom_tap.dart';
import 'package:raghad_pro/core/widget/dialoge_action.dart';
import 'package:raghad_pro/core/widget/null_data_widget.dart';
import 'package:raghad_pro/features/home/controller/home_controller.dart';
import 'package:raghad_pro/core/widget/custom_botton.dart';
import 'package:raghad_pro/features/home/data/model/get_booking.dart';
import 'package:raghad_pro/features/home/data/model/top_doctor_model.dart';
import 'package:raghad_pro/features/home/view/screen/detail_screen.dart';
import 'package:raghad_pro/features/profile/presentation/widget/base_settings.dart'; // تأكدي من مسار ملف الـ CustomBottomWidget

// class AppoinmentScreen extends GetView<HomeController> {
//   const AppoinmentScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
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
//           context: context,
//           icon: Icons.warning_amber_rounded,
//           iconColor: AppColors.warning,
//           iconBackgroundColor: AppColors.warning.withOpacity(0.1),
//           title: "تأكيد الإلغاء",
//           subtitle: "هل أنت متأكد من رغبتك في إلغاء هذا الموعد نهائياً؟",
//           hintText: "لا يمكن التراجع عن هذه العملية لاحقاً.",
//           confirmButtonText: "نعم، إلغاء",
//           onConfirm: () {
//             Get.back(); // إغلاق ديالوج التأكيد أولاً
//             // استدعاء دالة الحذف وتمرير الـ uuid الخاص بالموعد الحالي
//             controller.cancelAppointment(appointment.appointmentUuid);
//           },
//         );
//                       },
//                       onReschedule: () {

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

//   // دالة مساعدة لفلترة القائمة بشكل منظم يمنع تراكم الأكواد داخل الـ build
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
class AppoinmentScreen extends GetView<HomeController> {
  const AppoinmentScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BaseSubSettingsScreen(
      title: StringManager.appointmentScreen,
      content: Column(
        children: [
          Obx(() => Padding(
                padding: AppSpacing.screenPadding121_61,
                child: CustomGenericTabs(
                  tabLabels: const ["book", "waiting", "changed", "completed"],
                  selectedIndex: controller.appointmentTabControllerIndex.value,
                  onTabSelected: (index) {
                    controller.changeAppointmentTab(index);
                  },
                ),
              )),
          Expanded(
            child: Obx(() {
              if (controller.isAppointmentsLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              final List<BookingModel> currentList = _getFilteredAppointments();

              if (currentList.isEmpty) {
                return NullDataWidget(
                  text: StringManager.noAppointmentsInThisSpecialization,
                  imagePath: Appassets.doctorIcon,
                );
              }

              return RefreshIndicator(
                onRefresh: () => controller.getPatientAppointments(),
                child: ListView.builder(
                  itemCount: currentList.length,
                  padding: AppSpacing.screenPadding4,
                  itemBuilder: (context, index) {
                    final appointment = currentList[index];
                    return AppointmentCard(
                      appointment: appointment,
                      showActions:
                          controller.appointmentTabControllerIndex.value != 3,
                      onCancel: () {
                        CustomActionDialog.show(
                          context: context,
                          icon: Icons.warning_amber_rounded,
                          iconColor: AppColors.warning,
                          iconBackgroundColor:
                              AppColors.warning.withOpacity(0.1),
                          title: "تأكيد الإلغاء",
                          subtitle:
                              "هل أنت متأكد من رغبتك في إلغاء هذا الموعد نهائياً؟",
                          hintText: "لا يمكن التراجع عن هذه العملية لاحقاً.",
                          confirmButtonText: "نعم، إلغاء",
                          onConfirm: () {
                            Get.back();
                            controller
                                .cancelAppointment(appointment.appointmentUuid);
                          },
                        );
                      },
                      onReschedule: () {
                       final topDoctor = TopDoctorModel(
    uuid: appointment.doctor.uuid, // الـ uuid الخاص بالطبيب من الموعد
    name: appointment.doctor.name, // اسم الطبيب من الموعد
    specialization: appointment.doctor.specialization ?? '', // التخصص
    clinic: '', 
    image: appointment.doctor.image ?? '', // الصورة
    visitTime: '0', 
    patientsCount: 0, 
    averageRating: 0.0, 
    reviewersCount: 0, 
  );

  // 2️⃣ تهيئة الكنترولر وإخباره أن المستخدم قادم بغرض "تعديل موعد"
  controller.initDoctorDetailsForReschedule(
    doctor: topDoctor,
    appointmentUuid: appointment.appointmentUuid, // الـ uuid الخاص بالموعد المراد تعديله
  );

  // 3️⃣ الانتقال بالكامل كصفحة مستقلة إلى صفحة الطبيب الأصلية (حيث توجد التابات والساعات الجاهزة)
  Get.to(() => const DoctorDetailsScreen());
                      },
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
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

class AppointmentCard extends StatelessWidget {
  final BookingModel appointment;
  final bool showActions;
  final VoidCallback? onCancel;
  final VoidCallback? onReschedule;

  const AppointmentCard({
    super.key,
    required this.appointment,
    required this.showActions,
    this.onCancel,
    this.onReschedule,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final String formattedDate =
        "${appointment.dateTime.day}/${appointment.dateTime.month}/${appointment.dateTime.year}";
    final String formattedTime =
        "${appointment.dateTime.hour}:${appointment.dateTime.minute.toString().padLeft(2, '0')}";

    Color statusColor;
    String statusText;
    switch (appointment.status) {
      case 'has booked':
        statusColor = AppColors.success;
        statusText = "Confirmed";
        break;
      case 'is waiting':
        statusColor = AppColors.warning;
        statusText = "Waiting";
        break;
      case 'has changed':
        statusColor = AppColors.info;
        statusText = "Changed";
        break;
      default:
        statusColor = AppColors.success;
        statusText = "Visited";
    }

    return Card(
      color: theme.colorScheme.surface,
      margin: EdgeInsets.only(bottom: context.heightPct(0.02)),
      elevation: 0.6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: theme.colorScheme.primaryContainer.withOpacity(0.15),
        ),
      ),
      child: Padding(
        padding: AppSpacing.screenPadding16_20,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: context.widthPct(0.07),
                  backgroundColor: theme.primaryColor.withOpacity(0.1),
                  backgroundImage: appointment.doctor.image.isNotEmpty
                      ? NetworkImage(appointment.doctor.image)
                      : null,
                  child: appointment.doctor.image.isEmpty
                      ? Icon(
                          Icons.person,
                          color: theme.primaryColor,
                          size: context.widthPct(0.07),
                        )
                      : null,
                ),
                SizedBox(width: context.widthPct(0.03)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        appointment.doctor.name,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: context.heightPct(0.005)),
                      Text(appointment.doctor.specialization,
                          style: theme.textTheme.bodyMedium),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: context.heightPct(0.019)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildInfoRow(
                  context,
                  Icons.calendar_today_outlined,
                  formattedDate,
                  theme.colorScheme.onSurface.withOpacity(0.7),
                ),
                _buildInfoRow(
                  context,
                  Icons.access_time_rounded,
                  formattedTime,
                  theme.colorScheme.onSurface.withOpacity(0.7),
                ),
                Row(
                  children: [
                    Container(
                      width: context.widthPct(0.02),
                      height: context.widthPct(0.02),
                      decoration: BoxDecoration(
                        color: statusColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: context.widthPct(0.015)),
                    Text(
                      statusText,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: statusColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                )
              ],
            ),
            if (showActions) ...[
              SizedBox(height: context.heightPct(0.02)),
              Row(
                children: [
                  Expanded(
                    child: CustomBottomWidget(
                      text: StringManager.cancel,
                      colortext: theme.primaryColor,
                      textColor: theme.primaryColor,
                      backgroundColor: Colors.transparent,
                      border: Border.all(
                        color: theme.primaryColor.withOpacity(0.4),
                      ),
                      borderradius: 12,
                      hight: context.heightPct(0.05),
                      fontSize: 13,
                      onTap: onCancel,
                    ),
                  ),
                  SizedBox(width: context.widthPct(0.03)),
                  Expanded(
                    child: CustomBottomWidget(
                      text: "Reschedule",
                      colortext: theme.scaffoldBackgroundColor,
                      textColor: theme.scaffoldBackgroundColor,
                      backgroundColor: theme.primaryColor,
                      borderradius: 12,
                      hight: context.heightPct(0.05),
                      fontSize: 13,
                      border: Border.all(color: Colors.transparent),
                      onTap: onReschedule,
                    ),
                  ),
                ],
              )
            ]
          ],
        ),
      ),
    );
  }

  // ميثود مساعدة لبناء عناصر صفوف البيانات والمؤشرات بشكل نظيف ومتكرر
  Widget _buildInfoRow(
      BuildContext context, IconData icon, String text, Color color) {
    return Row(
      children: [
        Icon(icon, size: context.widthPct(0.04), color: color.withOpacity(0.6)),
        SizedBox(width: context.widthPct(0.015)),
        Text(
          text,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: color,
                fontSize: 13,
              ),
        ),
      ],
    );
  }
}
