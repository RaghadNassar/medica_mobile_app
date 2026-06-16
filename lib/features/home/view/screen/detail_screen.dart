import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:raghad_pro/core/constanse/app_spacing.dart';
import 'package:raghad_pro/core/constanse/string_manager.dart';
import 'package:raghad_pro/core/theme/app_colors.dart';
import 'package:raghad_pro/core/widget/custom_botton.dart';
import 'package:raghad_pro/features/home/controller/home_controller.dart';
import 'package:raghad_pro/features/home/view/widget/doctor_detail_body_content.dart';
import 'package:raghad_pro/features/home/view/widget/doctor_detail_header.dart';

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
class DoctorDetailsScreen extends GetView<HomeController> {
  const DoctorDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: AppSpacing.edgeInsets18,
          child:
          Obx(() {
  // 1️⃣ التحقق المشترك: هل الـ Loading يعمل لأي من العمليتين؟
  final bool isLoading = controller.isBookingLoading.value || controller.isUpdateBookingLoading.value;
  
  // 2️⃣ التحقق هل تم اختيار وقت؟
  final bool isTimeSelected = controller.selectedTime.value != null;

  return CustomBottomWidget(
    // تغيير النص ديناميكياً بناءً على حالة الحجز أو التعديل
    text: isLoading 
        ? "جاري التحميل..." 
        : (controller.isRescheduling.value ? "تأكيد تعديل الموعد" : StringManager.bookNow),
    colortext: AppColors.lightSurface,
    fontWeight: FontWeight.bold,
    
    // التفعيل الذكي: إذا لم يتم اختيار وقت أو كان هناك تحميل، يكون الزر معطلاً (null)
    onTap: (!isTimeSelected || isLoading)
        ? null
        : () {
            // جلب الـ fullDate الخاص بالـ Slot الذي تم اختياره حالياً
            final selectedSlot = controller.doctorSlots.firstWhere(
              (slot) => slot.time == controller.selectedTime.value,
            );

            if (controller.isRescheduling.value) {
              // 🚀 تنفيذ دالة التعديل وإرسال البيانات للباكيند
              controller.rescheduleAppointment(
                appointmentUuid: controller.appointmentUuidToModify.value,
                doctorUuid: controller.currentDoctor.value!.uuid,
                newDateTime: selectedSlot.fullDate, // التاريخ والوقت المحدث
                type: controller.selectedBookingType.value,
              );
            } else {
              // 🗓️ تنفيذ دالة الحجز العادي لأول مرة
              controller.bookAppointmentFinal();
            }
          },
  );
})
          //  Obx(() => CustomBottomWidget(
          //       text: StringManager.bookNow,
          //       colortext: AppColors.lightSurface,
          //       fontWeight: FontWeight.bold,
          //       //
          //       onTap: controller.selectedTime.value == null
          //           ? null
          //           : () => controller.bookAppointmentFinal(),
          //     )),
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
