import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:raghad_pro/core/constanse/app_spacing.dart';
import 'package:raghad_pro/core/constanse/string_manager.dart';
import 'package:raghad_pro/core/utilis/size_config.dart';
import 'package:raghad_pro/features/home/controller/home_controller.dart';
import 'package:raghad_pro/features/home/view/widget/book_date_selector.dart';
import 'package:raghad_pro/features/home/view/widget/custom_booking_time.dart';
import 'package:skeletonizer/skeletonizer.dart';

class TabAppointmentContent extends GetView<HomeController> {
  const TabAppointmentContent({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          StringManager.bookingType,
          style: theme.textTheme.bodyMedium
              ?.copyWith(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: context.heightPct(0.015)),
        Obx(() => Row(
              children: [
                Expanded(
                  child: _buildCustomRadioTile(
                    context: context,
                    title: StringManager.typeCheckValue,
                    value: StringManager.typeCheckValue,
                    groupValue: controller.selectedBookingType.value,
                    onChanged: (value) =>
                        controller.selectedBookingType.value = value,
                  ),
                ),
                SizedBox(width: context.widthPct(0.025)),
                Expanded(
                  child: _buildCustomRadioTile(
                    context: context,
                    title: StringManager.typeReviewValue,
                    value: StringManager.typeReviewValue,
                    groupValue: controller.selectedBookingType.value,
                    onChanged: (value) =>
                        controller.selectedBookingType.value = value,
                  ),
                ),
              ],
            )),
        SizedBox(height: context.heightPct(0.03)),
        Text(
          StringManager.selectAvailableDate,
          style: theme.textTheme.bodyMedium
              ?.copyWith(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: context.heightPct(0.02)),
        Obx(() {
          final List<Map<String, dynamic>> formattedDates =
              controller.availableDatesList.map((dateTime) {
            final String currentArabicDay = _getArabicDayName(dateTime);

            final bool isDoctorWorking = controller.doctorSchedules
                .any((schedule) => schedule.day == currentArabicDay);

            return {
              'day': DateFormat('E').format(dateTime).toUpperCase(),
              'date': DateFormat('d').format(dateTime),
              'isActive': isDoctorWorking,
            };
          }).toList();

          return BookingDateSelector(
            dates: formattedDates,
            selectedIndex: controller.selectedDateIndex.value,
            onDateSelected: (index) {
              if (formattedDates[index]['isActive'] == true) {
                controller.updateSelectedDate(index);
              }
            },
          );
        }),
        SizedBox(height: context.heightPct(0.03)),
        Text(
          StringManager.selectAvailableDate,
          style: theme.textTheme.bodyMedium
              ?.copyWith(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: context.heightPct(0.015)),
        Obx(() {
          return Skeletonizer(
            enabled: controller.isSlotsLoading.value,
            child: controller.doctorSlots.isEmpty &&
                    !controller.isSlotsLoading.value
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(15.0),
                      child: Text(StringManager.noAvailableSlots),
                    ),
                  )
                : BookingTimeGrid(
                    slots: controller.doctorSlots,
                    selectedTime: controller.selectedTime.value,
                    onTimeSelected: (time, isAvailable) {
                      if (isAvailable) {
                        controller.updateSelectedTime(time);
                      }
                    },
                  ),
          );
        }),
        SizedBox(height: context.heightPct(0.04)),
      ],
    );
  }

  Widget _buildCustomRadioTile({
    required BuildContext context,
    required String title,
    required String value,
    required String groupValue,
    required ValueChanged<String> onChanged,
  }) {
    final theme = Theme.of(context);
    final bool isSelected = value == groupValue;

    return GestureDetector(
      onTap: () => onChanged(value),
      child: Container(
        padding: AppSpacing.screenPadding121_61,
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: isSelected
                ? theme.colorScheme.primary
                : theme.colorScheme.outline.withOpacity(0.2),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurface,
              ),
            ),
            Container(
              height: 20,
              width: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? theme.colorScheme.primary
                      : theme.colorScheme.outline.withOpacity(0.4),
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        height: 10,
                        width: 10,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  String _getArabicDayName(DateTime date) {
    switch (date.weekday) {
      case DateTime.monday:
        return "الاثنين";
      case DateTime.tuesday:
        return "الثلاثاء";
      case DateTime.wednesday:
        return "الأربعاء";
      case DateTime.thursday:
        return "الخميس";
      case DateTime.friday:
        return "الجمعة";
      case DateTime.saturday:
        return "السبت";
      case DateTime.sunday:
        return "الأحد";
      default:
        return "";
    }
  }
}
/*
class TabAppointmentContent extends GetView<HomeController> {
  const TabAppointmentContent({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(StringManager.selectAvailableDate, style: theme.textTheme.bodyMedium?.copyWith(fontSize: 16, fontWeight: FontWeight.bold)),
        SizedBox(height: context.heightPct(0.015)),
        Obx(() => BookingDateSelector(
          dates: controller.mockDates,
          selectedIndex: controller.selectedDateIndex.value,
          onDateSelected: controller.updateSelectedDate,
        )),
        SizedBox(height: context.heightPct(0.03)),
        Text(StringManager.selectAvailableDate, style: theme.textTheme.bodyMedium?.copyWith(fontSize: 16, fontWeight: FontWeight.bold)),
        SizedBox(height: context.heightPct(0.015)),
        Obx(() => BookingTimeGrid(
          availableTimes: controller.mockTimes,
          selectedTime: controller.selectedTime.value,
          onTimeSelected: controller.updateSelectedTime,
        )),
      ],
    );
  }
}*/
// import 'package:intl/intl.dart';
// import 'package:skeletonizer/skeletonizer.dart'; // ستحتاجين حزمة intl لتنسيق عرض التواريخ بشكل جميل

// class TabAppointmentContent extends GetView<HomeController> {
//   const TabAppointmentContent({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
    
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         // 👈 إضافة قسم اختيار نوع الحجز
//         Text("نوع الحجز", style: theme.textTheme.bodyMedium?.copyWith(fontSize: 16, fontWeight: FontWeight.bold)),
//         SizedBox(height: context.heightPct(0.01)),
//         Obx(() => Row(
//           children: [
//             Expanded(
//               child: RadioListTile<String>(
//                 title: const Text("معاينة جديدة"),
//                 value: "check",
//                 groupValue: controller.selectedBookingType.value,
//                 activeColor: theme.primaryColor,
//                 onChanged: (value) => controller.selectedBookingType.value = value!,
//               ),
//             ),
//             Expanded(
//               child: RadioListTile<String>(
//                 title: const Text("مراجعة"),
//                 value: "review",
//                 groupValue: controller.selectedBookingType.value,
//                 activeColor: theme.primaryColor,
//                 onChanged: (value) => controller.selectedBookingType.value = value!,
//               ),
//             ),
//           ],
//         )),
        
//         SizedBox(height: context.heightPct(0.02)),
//         Text(StringManager.selectAvailableDate, style: theme.textTheme.bodyMedium?.copyWith(fontSize: 16, fontWeight: FontWeight.bold)),
//         SizedBox(height: context.heightPct(0.02)),
        
//         // شريط الأيام
//         Obx(() {
//           final List<Map<String, String>> formattedDates = controller.availableDatesList.map((dateTime) {
//             return {
//               'day': DateFormat('E').format(dateTime).toUpperCase(),
//               'date': DateFormat('d').format(dateTime),
//             };
//           }).toList();

//           return BookingDateSelector(
//             dates: formattedDates,
//             selectedIndex: controller.selectedDateIndex.value,
//             onDateSelected: controller.updateSelectedDate,
//           );
//         }),
        
//         SizedBox(height: context.heightPct(0.03)),
//         Text(StringManager.selectAvailableDate, style: theme.textTheme.bodyMedium?.copyWith(fontSize: 16, fontWeight: FontWeight.bold)),
//         SizedBox(height: context.heightPct(0.015)),
        
//         // شبكة عرض الأوقات
//         Obx(() {
//           final List<String> timesToShow = controller.doctorSlots.map((slot) => slot.time).toList();

//           return Skeletonizer(
//             enabled: controller.isSlotsLoading.value,
//             child: controller.doctorSlots.isEmpty && !controller.isSlotsLoading.value
//                 ? const Center(child: Padding(
//                     padding: EdgeInsets.all(15.0),
//                     child: Text("لا توجد فترات متاحة للحجز في هذا اليوم"),
//                   ))
//                 : BookingTimeGrid(
//                     availableTimes: timesToShow,
//                     selectedTime: controller.selectedTime.value,
//                     onTimeSelected: controller.updateSelectedTime,
//                   ),
//           );
//         }),
        
//         SizedBox(height: context.heightPct(0.04)),
        
//         // زر الحجز النهائي المحمي من الضغط المتكرر
//         Obx(() => SizedBox(
//           width: double.infinity,
//           height: 50,
//           child: ElevatedButton(
//             style: ElevatedButton.styleFrom(
//               backgroundColor: theme.colorScheme.primary,
//               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//             ),
//             onPressed: (controller.selectedTime.value == null || controller.isBookingLoading.value) 
//                 ? null 
//                 : controller.bookAppointmentFinal,
//             child: controller.isBookingLoading.value 
//                 ? const CircularProgressIndicator(color: Colors.white)
//                 : const Text("Book Now", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
//           ),
//         )),
//       ],
//     );
//   }
// }



 // // 4. زر الحجز النهائي المحمي من الضغط المتكرر
        // Obx(() => SizedBox(
        //       width: double.infinity,
        //       height: 52,
        //       child: ElevatedButton(
        //         style: ElevatedButton.styleFrom(
        //           backgroundColor: theme.colorScheme.primary,
        //           shape: RoundedRectangleBorder(
        //               borderRadius: BorderRadius.circular(14)),
        //           elevation: 0,
        //         ),
        //         onPressed: (controller.selectedTime.value == null ||
        //                 controller.isBookingLoading.value)
        //             ? null
        //             : controller.bookAppointmentFinal,
        //         child: controller.isBookingLoading.value
        //             ? const CircularProgressIndicator(color: Colors.white)
        //             : const Text("Book Now",
        //                 style: TextStyle(
        //                     color: Colors.white,
        //                     fontSize: 16,
        //                     fontWeight: FontWeight.bold)),
        //       ),
        //     )),