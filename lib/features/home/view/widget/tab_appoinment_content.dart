import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:raghad_pro/core/constanse/app_spacing.dart';
import 'package:raghad_pro/core/constanse/string_manager.dart';
import 'package:raghad_pro/core/helper/validation.dart';
import 'package:raghad_pro/core/theme/app_colors.dart';
import 'package:raghad_pro/core/utilis/size_config.dart';
import 'package:raghad_pro/core/widget/custom_text_filed.dart';
import 'package:raghad_pro/core/widget/custom_toggle_switch.dart';
import 'package:raghad_pro/features/home/controller/doctor_book_logic.dart';
import 'package:raghad_pro/features/home/controller/home_controller.dart';
import 'package:raghad_pro/features/home/view/widget/book_date_selector.dart';
import 'package:raghad_pro/features/home/view/widget/custom_booking_time.dart';
import 'package:skeletonizer/skeletonizer.dart';
/*

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
                        controller.selectedBookingType.value = value!,
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
                        controller.selectedBookingType.value = value!,
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

        SizedBox(height: context.heightPct(0.03)),
        
        
        Text(
         StringManager.whothisbook ,
          style: theme.textTheme.bodyMedium?.copyWith(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: context.heightPct(0.015)),
        
        Obx(() => Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () => controller.bookForSomeoneElse.value = false,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: !controller.bookForSomeoneElse.value ? AppColors.primaryTeal.withOpacity(0.1) : Colors.transparent,
                    border: Border.all(
                      color: !controller.bookForSomeoneElse.value ? AppColors.primaryTeal : Colors.grey[300]!,
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.person_pin_rounded, color: !controller.bookForSomeoneElse.value ? AppColors.primaryTeal : Colors.grey),
                      const SizedBox(width: 8),
                      const Text(StringManager.myself),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(width: context.widthPct(0.025)),
            Expanded(
              child: InkWell(
                onTap: () => controller.bookForSomeoneElse.value = true,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: controller.bookForSomeoneElse.value ? AppColors.primaryTeal.withOpacity(0.1) : Colors.transparent,
                    border: Border.all(
                      color: controller.bookForSomeoneElse.value ? AppColors.primaryTeal : Colors.grey[300]!,
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.person_add_alt_1_rounded, color: controller.bookForSomeoneElse.value ? AppColors.primaryTeal : Colors.grey),
                      const SizedBox(width: 8),
                      const Text(StringManager.anathoreperson),
                    ],
                  ),
                ),
              ),
            ),
          ],
        )),
        Obx(() {
          if (!controller.bookForSomeoneElse.value) return const SizedBox.shrink();
          return Form(
            key: controller.someoneFormKey, 
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: context.heightPct(0.03)),
                Text(
                 StringManager. newpatintinfo,
                  style: theme.textTheme.bodyMedium?.copyWith(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: context.heightPct(0.02)),
               
                Row(
                  children: [
                    Expanded(
                      child: CustomTextFiled(
                        labl: StringManager.username,
                        hinttext: StringManager.enterUsername,
                        prefixIcon: Icons.person,
                        textcontroler: controller.someoneNameController,
                        validate: (value) => Validator.validateRequiredField(value ?? '', StringManager.username),
                      ),
                    ),
                    SizedBox(width: context.widthPct(0.02)),
                    Expanded(
                      child: CustomTextFiled(
                        labl: StringManager.nickname,
                        hinttext: StringManager.enternickname,
                        prefixIcon: Icons.person_outline,
                        textcontroler: controller.someoneNickNameController,
                        validate: (value) => Validator.validateRequiredField(value ?? '', StringManager.nickname),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: context.heightPct(0.01)),
                CustomTextFiled(
                  labl: StringManager.phone_number,
                  hinttext: StringManager.enterphone_number,
                  prefixIcon: Icons.phone,
                  textInputType: TextInputType.phone,
                  textcontroler: controller.someonePhoneController,
                  validate: (value) => Validator.validateMobile(value ?? ''),
                ),
                SizedBox(height: context.heightPct(0.01)),
                GestureDetector(
                  onTap: () => controller.selectSomeoneBirthday(context),
                  child: AbsorbPointer(
                    child: CustomTextFiled(
                      labl: StringManager.date_of_birth,
                      hinttext: StringManager.enterdate_of_birth,
                      prefixIcon: Icons.calendar_month,
                      textcontroler: controller.someoneBirthdayController, 
                      validate: (value) => Validator.validateBirthDate(value),
                    ),
                  ),
                ),
                SizedBox(height: context.heightPct(0.01)),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 4.0, bottom: 8.0, right: 4.0),
                      child: Text(
                        StringManager.gender,
                        style: theme.textTheme.bodyMedium,
                      ),
                    ),
                    Obx(() {
                      int currentIdx = controller.someoneGender.value == StringManager.female ? 1 : 0;
                      return CustomToggleSwitch(
                        labels: const [StringManager.male, StringManager.female],
                        selectedIndex: currentIdx,
                        onSelect: (index) {
                          String genderResult = (index == 1) ? StringManager.female : StringManager.male;
                          controller.someoneGender.value = genderResult;
                        },
                      );
                    }),
                  ],
                ),
              ],
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
    required ValueChanged<String?> onChanged,
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
*/
// --- التبويب الثاني: حجز موعد جديد أو إعادة جدولة ---
class TabAppointmentContent extends GetView<DoctorBookingController> {
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
                    value: 'check', // القيمة البرمجية المطابقة للكونترولر
                    groupValue: controller.selectedBookingType.value,
                    onChanged: (value) => controller.selectedBookingType.value = value!,
                  ),
                ),
                SizedBox(width: context.widthPct(0.025)),
                Expanded(
                  child: _buildCustomRadioTile(
                    context: context,
                    title: StringManager.typeReviewValue,
                    value: 'review',
                    groupValue: controller.selectedBookingType.value,
                    onChanged: (value) => controller.selectedBookingType.value = value!,
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
            child: controller.doctorSlots.isEmpty && !controller.isSlotsLoading.value
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

        SizedBox(height: context.heightPct(0.03)),
        
        Text(
          StringManager.whothisbook ,
          style: theme.textTheme.bodyMedium?.copyWith(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: context.heightPct(0.015)),
        
        Obx(() => Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () => controller.bookForSomeoneElse.value = false,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: !controller.bookForSomeoneElse.value ? AppColors.primaryTeal.withOpacity(0.1) : Colors.transparent,
                    border: Border.all(
                      color: !controller.bookForSomeoneElse.value ? AppColors.primaryTeal : Colors.grey[300]!,
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.person_pin_rounded, color: !controller.bookForSomeoneElse.value ? AppColors.primaryTeal : Colors.grey),
                      const SizedBox(width: 8),
                      const Text(StringManager.myself),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(width: context.widthPct(0.025)),
            Expanded(
              child: InkWell(
                onTap: () => controller.bookForSomeoneElse.value = true,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: controller.bookForSomeoneElse.value ? AppColors.primaryTeal.withOpacity(0.1) : Colors.transparent,
                    border: Border.all(
                      color: controller.bookForSomeoneElse.value ? AppColors.primaryTeal : Colors.grey[300]!,
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.person_add_alt_1_rounded, color: controller.bookForSomeoneElse.value ? AppColors.primaryTeal : Colors.grey),
                      const SizedBox(width: 8),
                      const Text(StringManager.anathoreperson),
                    ],
                  ),
                ),
              ),
            ),
          ],
        )),
        Obx(() {
          if (!controller.bookForSomeoneElse.value) return const SizedBox.shrink();
          return Form(
            key: controller.someoneFormKey, 
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: context.heightPct(0.03)),
                Text(
                  StringManager.newpatintinfo,
                  style: theme.textTheme.bodyMedium?.copyWith(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: context.heightPct(0.02)),
               
                Row(
                  children: [
                    Expanded(
                      child: CustomTextFiled(
                        labl: StringManager.username,
                        hinttext: StringManager.enterUsername,
                        prefixIcon: Icons.person,
                        textcontroler: controller.someoneNameController,
                        validate: (value) => Validator.validateRequiredField(value ?? '', StringManager.username),
                      ),
                    ),
                    SizedBox(width: context.widthPct(0.02)),
                    Expanded(
                      child: CustomTextFiled(
                        labl: StringManager.nickname,
                        hinttext: StringManager.enternickname,
                        prefixIcon: Icons.person_outline,
                        textcontroler: controller.someoneNickNameController,
                        validate: (value) => Validator.validateRequiredField(value ?? '', StringManager.nickname),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: context.heightPct(0.01)),
                CustomTextFiled(
                  labl: StringManager.phone_number,
                  hinttext: StringManager.enterphone_number,
                  prefixIcon: Icons.phone,
                  textInputType: TextInputType.phone,
                  textcontroler: controller.someonePhoneController,
                  validate: (value) => Validator.validateMobile(value ?? ''),
                ),
                SizedBox(height: context.heightPct(0.01)),
                GestureDetector(
                  onTap: () => controller.selectSomeoneBirthday(context),
                  child: AbsorbPointer(
                    child: CustomTextFiled(
                      labl: StringManager.date_of_birth,
                      hinttext: StringManager.enterdate_of_birth,
                      prefixIcon: Icons.calendar_month,
                      textcontroler: controller.someoneBirthdayController, 
                      validate: (value) => Validator.validateBirthDate(value),
                    ),
                  ),
                ),
                SizedBox(height: context.heightPct(0.01)),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 4.0, bottom: 8.0, right: 4.0),
                      child: Text(
                        StringManager.gender,
                        style: theme.textTheme.bodyMedium,
                      ),
                    ),
                    Obx(() {
                      int currentIdx = controller.someoneGender.value == StringManager.female ? 1 : 0;
                      return CustomToggleSwitch(
                        labels: const [StringManager.male, StringManager.female],
                        selectedIndex: currentIdx,
                        onSelect: (index) {
                          String genderResult = (index == 1) ? StringManager.female : StringManager.male;
                          controller.someoneGender.value = genderResult;
                        },
                      );
                    }),
                  ],
                ),
              ],
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
    required ValueChanged<String?> onChanged,
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
                color: isSelected ? theme.colorScheme.primary : theme.colorScheme.onSurface,
              ),
            ),
            Container(
              height: 20,
              width: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? theme.colorScheme.primary : theme.colorScheme.outline.withOpacity(0.4),
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
      case DateTime.monday: return "الاثنين";
      case DateTime.tuesday: return "الثلاثاء";
      case DateTime.wednesday: return "الأربعاء";
      case DateTime.thursday: return "الخميس";
      case DateTime.friday: return "الجمعة";
      case DateTime.saturday: return "السبت";
      case DateTime.sunday: return "الأحد";
      default: return "";
    }
  }
}