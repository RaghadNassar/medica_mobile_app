import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:raghad_pro/core/constanse/app_spacing.dart';
import 'package:raghad_pro/core/constanse/string_manager.dart';
import 'package:raghad_pro/core/theme/app_colors.dart';
import 'package:raghad_pro/core/utilis/size_config.dart';
import 'package:raghad_pro/core/widget/custom_botton.dart';
import 'package:raghad_pro/features/home/controller/doctor_book_logic.dart';


class BookingConfirmationScreen extends GetView<DoctorBookingController> {
  const BookingConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final doctor = controller.currentDoctor.value;
    final selectedSlot = controller.doctorSlots.firstWhere(
      (slot) => slot.time == controller.selectedTime.value,
    );

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(StringManager.bookingDetails.tr),
        centerTitle: true,
      ),
      bottomNavigationBar: _buildBottomWidget(doctor, selectedSlot),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: AppSpacing.edgeInsets18,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDoctorHeader(context, theme, doctor),
             Divider(
              height: 32,
              color: theme.colorScheme.primaryContainer.withOpacity(0.4),
              thickness: 0.1,
            ),
          //  SizedBox(height: context.heightPct(0.04)),
            _buildAppointmentDetails(theme, selectedSlot),
            Divider(
              height: 32,
              color: theme.colorScheme.primaryContainer.withOpacity(0.4),
              thickness: 0.1,
            ),
            _buildPatientInfo(theme),
            Divider(
              height: 32,
              color: theme.colorScheme.primaryContainer.withOpacity(0.4),
              thickness: 0.1,
            ),
           
           
            _buildPreparationNotes(theme),
            SizedBox(height: context.heightPct(0.04)),
             _buildPolicyNotes(theme),
              SizedBox(height: context.heightPct(0.09)),
          ],
        ),
      ),
    );
  }

  // --- Bottom Action Button ---
  Widget _buildBottomWidget(dynamic doctor, dynamic selectedSlot) {
    return SafeArea(
      child: Padding(
        padding: AppSpacing.edgeInsets18,
        child: Obx(() {
          final bool isLoading = controller.isBookingLoading.value ||
              controller.isUpdateBookingLoading.value;

          return CustomBottomWidget(
            text: isLoading
                ? StringManager.loading.tr
                : (controller.isRescheduling.value
                    ? StringManager.save.tr
                    : StringManager.confirmBooking.tr),
            colortext: AppColors.lightSurface,
            fontWeight: FontWeight.bold,
            onTap: isLoading
                ? null
                : () {
                    if (controller.isRescheduling.value) {
                      controller.rescheduleAppointment(
                        appointmentUuid: controller.appointmentUuidToModify.value,
                        doctorUuid: doctor!.uuid,
                        newDateTime: selectedSlot.fullDate,
                        type: controller.selectedBookingType.value,
                      );
                    } else {
                      if (controller.bookForSomeoneElse.value) {
                        controller.bookForSomeoneFinal();
                      } else {
                        controller.bookAppointmentFinal();
                      }
                    }
                  },
          );
        }),
      ),
    );
  }

  // --- 1. Doctor Info Header ---
  Widget _buildDoctorHeader(BuildContext context, ThemeData theme, dynamic doctor) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: context.widthPct(0.1),
          backgroundColor: theme.primaryColor.withOpacity(0.13),
          backgroundImage: doctor?.image != null && doctor!.image!.isNotEmpty
              ? NetworkImage(doctor.image!)
              : null,
          child: doctor?.image == null || doctor!.image!.isEmpty
              ? Icon(
                  Icons.person,
                  color: theme.primaryColor,
                  size: context.widthPct(0.09),
                )
              : null,
        ),
         SizedBox(width:  context.widthPct(0.09)),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                doctor?.name ?? '',
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              SizedBox(height: context.heightPct(0.005)),
              Text(
                doctor?.specialization ?? '',
                style: theme.textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ],
    );
  }

  // --- 2. Appointment Details Section ---
  Widget _buildAppointmentDetails(ThemeData theme, dynamic selectedSlot) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          StringManager.appointmentDetails.tr,
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Icon(Icons.calendar_month, color: theme.primaryColor),
            const SizedBox(width: 8),
            Text(
              selectedSlot.fullDate.split(' ')[0],
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Icon(Icons.access_time_filled, color: theme.primaryColor),
            const SizedBox(width: 8),
            Text(
              selectedSlot.time,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // --- 3. Patient Info Section ---
  Widget _buildPatientInfo(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          StringManager.patientInfo.tr,
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            const Icon(Icons.person, color: AppColors.accentTeal,),
            const SizedBox(width: 8),
            Text(
              controller.bookForSomeoneElse.value
                  ? controller.someoneNameController.text
                  : StringManager.currentPatientName.tr,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // --- 4. Policy Notes Section ---
  Widget _buildPolicyNotes(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Text(
        //   StringManager.notes.tr,
        //   style: theme.textTheme.bodyLarge?.copyWith(
        //     fontWeight: FontWeight.bold,
        //   ),
        // ),
        // const SizedBox(height: 12),
        // سياسة الإلغاء: العنوان باللون الأحمر، وباقي النص طبيعي
        _buildColoredTitleBulletPoint(
          theme: theme,
          title: "${StringManager.cancellationPolicyNoteTitle.tr}: ",
          body: StringManager.cancellationPolicyNoteBody.tr,
          titleColor: AppColors.error,
        ),
        const SizedBox(height: 8),
        _buildColoredTitleBulletPoint(
          theme: theme,
          title: "${StringManager.missedAppointmentNoteTitle.tr}: ",
          body: StringManager.missedAppointmentNoteBody.tr,
          titleColor: AppColors.warning,
        ),
      ],
    );
  }

  // --- 5. Preparation Notes Section ---
  Widget _buildPreparationNotes(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          StringManager.preparationNotes.tr,
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        _buildBulletPoint(theme, StringManager.prepNote1.tr),
        const SizedBox(height: 8),
        _buildBulletPoint(theme, StringManager.prepNote2.tr),
        const SizedBox(height: 8),
        _buildBulletPoint(theme, StringManager.prepNote3.tr),
      ],
    );
  }
Widget _buildColoredTitleBulletPoint({
  required ThemeData theme,
  required String title,
  required String body,
  required Color titleColor,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: titleColor,
          fontWeight: FontWeight.bold,
          height: 1.4,
        ),
      ),
      const SizedBox(height: 4),

      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 8),
            width: 5,
            height: 5,
            decoration: const BoxDecoration(
              color: Colors.black87,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              body,
              style: theme.textTheme.bodyMedium?.copyWith(
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    ],
  );
}
  // --- Reusable Standard Bullet Point Item ---
  Widget _buildBulletPoint(ThemeData theme, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 8),
          width: 5,
          height: 5,
          decoration: const BoxDecoration(
            color: Colors.black87,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: theme.textTheme.bodyMedium?.copyWith(
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}