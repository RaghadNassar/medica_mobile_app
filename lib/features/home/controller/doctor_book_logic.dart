import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:raghad_pro/core/constanse/string_manager.dart';
import 'package:raghad_pro/core/helper/alert_helper.dart';
import 'package:raghad_pro/core/theme/app_colors.dart';
import 'package:raghad_pro/core/widget/dialoge_action.dart';
import 'package:raghad_pro/features/home/controller/patient_book_controller.dart';
import 'package:raghad_pro/features/home/data/model/scedual_mode.dart';
import 'package:raghad_pro/features/home/data/model/slote_model.dart';
import 'package:raghad_pro/features/home/data/model/top_doctor_model.dart';
import 'package:raghad_pro/features/home/data/repositry/repostry_home.dart';

// detatil screen
class DoctorBookingController extends GetxController {
  final RepostryHome repostryHome;
  DoctorBookingController(this.repostryHome);

  StreamSubscription? _firebaseSubscription;

  
  final RxInt activeTabIndex = 0.obs;
  var userRating = 0.0.obs;
  final RxInt selectedDateIndex = 0.obs;
  final RxnString selectedTime = RxnString();
  var isRatingLoading = false.obs;
  var currentDoctor = Rxn<TopDoctorModel>();

  var isUpdateBookingLoading = false.obs;
  final RxBool isRescheduling = false.obs;        
  final RxString appointmentUuidToModify = ''.obs;

  var isDoctorsBySpecLoading = false.obs;
  var doctorsBySpecialty = <TopDoctorModel>[].obs;
  var isSchedulesLoading = false.obs;
  var doctorSchedules = <DoctorScheduleModel>[].obs;
  final RxString selectedBookingType = 'check'.obs;
  var isSlotsLoading = false.obs;
  var doctorSlots = <DoctorSlotModel>[].obs;
  var availableDatesList = <DateTime>[].obs;
  var isBookingLoading = false.obs;

  
  final someoneFormKey = GlobalKey<FormState>();
  var bookForSomeoneElse = false.obs;
  final someoneNameController = TextEditingController();
  final someoneNickNameController = TextEditingController();
  final someonePhoneController = TextEditingController();
  final someoneBirthdayController = TextEditingController(); 
  var someoneGender = StringManager.male.obs;
  

  void updateActiveTab(int index) {
    activeTabIndex.value = index;
  }

  void updateSelectedTime(String? time) {
    selectedTime.value = time;
  }

  void changeGender(String gender) {
   
    someoneGender.value = gender;
  }

  void generateAvailableDates() {
    availableDatesList.clear();
    DateTime today = DateTime.now();
    for (int i = 0; i < 7; i++) {
      availableDatesList.add(today.add(Duration(days: i)));
    }
  }

  void updateSelectedDate(int index) {
    selectedDateIndex.value = index;
    if (currentDoctor.value != null && availableDatesList.isNotEmpty) {
      String selectedDateStr = availableDatesList[index].toString().split(' ')[0];
      getDoctorSlotsDynamic(currentDoctor.value!.uuid, selectedDateStr);
      initFirebaseRealtime(currentDoctor.value!.uuid, selectedDateStr);
    }
  }

//كلاود
/*Future<void> pickCustomDate(BuildContext context) async {

  final Set<int> workingWeekdays = doctorSchedules
      .map((s) => _arabicDayToWeekday(s.day))
      .toSet();

  if (workingWeekdays.isEmpty) {
    AlertHelper.showSnackbar(
      message: StringManager.noAvailableSlots.tr,
      type: AlertType.warning,
    );
    return;
  }

  final DateTime? picked = await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime.now(),
    lastDate: DateTime.now().add(const Duration(days: 90)), 
    
    selectableDayPredicate: (DateTime day) {
      return workingWeekdays.contains(day.weekday);
    },
  );

  if (picked == null) return;
  if (currentDoctor.value == null) return;

  final String dateStr = picked.toString().split(' ')[0]; // YYYY-MM-DD

  final bool alreadyExists = availableDatesList
      .any((d) => d.toString().split(' ')[0] == dateStr);

  if (!alreadyExists) {
    availableDatesList.add(picked);
    availableDatesList.sort(); 
  }

  final int index = availableDatesList
      .indexWhere((d) => d.toString().split(' ')[0] == dateStr);

  if (index != -1) {
    selectedDateIndex.value = index;
    getDoctorSlotsDynamic(currentDoctor.value!.uuid, dateStr);
    initFirebaseRealtime(currentDoctor.value!.uuid, dateStr);
  }
}*/
/*
Future<void> pickCustomDate(BuildContext context) async {
  final Set<int> workingWeekdays = doctorSchedules
      .map((s) => _arabicDayToWeekday(s.day))
      .toSet();

  if (workingWeekdays.isEmpty) {
    AlertHelper.showSnackbar(
      message: StringManager.noAvailableSlots.tr,
      type: AlertType.warning,
    );
    return;
  }

  
  DateTime initialDate = DateTime.now();
  for (int i = 0; i < 90; i++) {
    final candidate = DateTime.now().add(Duration(days: i));
    if (workingWeekdays.contains(candidate.weekday)) {
      initialDate = candidate;
      break;
    }
  }

  final DateTime? picked = await showDatePicker(
    context: context,
    initialDate: initialDate, 
    firstDate: DateTime.now(),
    lastDate: DateTime.now().add(const Duration(days: 90)),
    selectableDayPredicate: (DateTime day) {
      return workingWeekdays.contains(day.weekday);
    },
  );

  if (picked == null || currentDoctor.value == null) return;

  final String dateStr = picked.toString().split(' ')[0];

  final bool alreadyExists = availableDatesList
      .any((d) => d.toString().split(' ')[0] == dateStr);

  if (!alreadyExists) {
    availableDatesList.add(picked);
    availableDatesList.sort();
  }

  final int index = availableDatesList
      .indexWhere((d) => d.toString().split(' ')[0] == dateStr);

  if (index != -1) {
    selectedDateIndex.value = index;
    getDoctorSlotsDynamic(currentDoctor.value!.uuid, dateStr);
    initFirebaseRealtime(currentDoctor.value!.uuid, dateStr);
  }
}*/
//deep
Future<void> pickCustomDate(BuildContext context) async {
  final Set<int> workingWeekdays = doctorSchedules
      .map((s) => _arabicDayToWeekday(s.day))
      .toSet();

  if (workingWeekdays.isEmpty) {
    AlertHelper.showSnackbar(
      message: StringManager.noAvailableSlots.tr,
      type: AlertType.warning,
    );
    return;
  }

  DateTime initialDate = DateTime.now();
  
  
  if (!workingWeekdays.contains(initialDate.weekday)) {
    for (int i = 1; i < 7; i++) {
      final candidate = DateTime.now().add(Duration(days: i));
      if (workingWeekdays.contains(candidate.weekday)) {
        initialDate = candidate;
        break;
      }
    }
  }

  final DateTime? picked = await showDatePicker(
    context: context,
    initialDate: initialDate,
    firstDate: DateTime.now(),
    lastDate: DateTime(2100), 
    selectableDayPredicate: (DateTime day) {
      return workingWeekdays.contains(day.weekday);
    },
  );

  if (picked == null || currentDoctor.value == null) return;

  final String dateStr = picked.toString().split(' ')[0];

  final bool alreadyExists = availableDatesList
      .any((d) => d.toString().split(' ')[0] == dateStr);

  if (!alreadyExists) {
    availableDatesList.add(picked);
    availableDatesList.sort();
  }

  final int index = availableDatesList
      .indexWhere((d) => d.toString().split(' ')[0] == dateStr);

  if (index != -1) {
    selectedDateIndex.value = index;
    getDoctorSlotsDynamic(currentDoctor.value!.uuid, dateStr);
    initFirebaseRealtime(currentDoctor.value!.uuid, dateStr);
  }
}

// هي لحتى اقدر مرر مودل  التفاصيل تبع الدكتور 
  void initDoctorDetails(TopDoctorModel doctor) {
    if (appointmentUuidToModify.isEmpty) {
      isRescheduling.value = false;
    }
    isRescheduling.value = false;
    appointmentUuidToModify.value = '';
    currentDoctor.value = doctor;
    selectedDateIndex.value = 0;
    selectedTime.value = null;

    getDoctorSchedules(doctor.uuid);
    generateAvailableDates();

    if (availableDatesList.isNotEmpty) {
      String initialDate = availableDatesList[0].toString().split(' ')[0];
      getDoctorSlotsDynamic(doctor.uuid, initialDate);
      initFirebaseRealtime(doctor.uuid, initialDate);
    }
  }
// هي لحتى اقدر مرر مودل  التفاصيل تبع الدكتور  بس للبحث 
  void initDoctorDetailsFromSearch(dynamic searchDoctor) {
    if (appointmentUuidToModify.isEmpty) {
      isRescheduling.value = false;
    }
    currentDoctor.value = TopDoctorModel(
      uuid: searchDoctor.uuid,
      name: searchDoctor.name,
      specialization: searchDoctor.specialization,
      clinic: searchDoctor.clinic,
      patientsCount: searchDoctor.patientsCount,
      averageRating: searchDoctor.averageRating,
      reviewersCount: searchDoctor.reviewersCount,
      visitTime: searchDoctor.visitTime,
      image: searchDoctor.image ?? '',
    );

    selectedDateIndex.value = 0;
    selectedTime.value = null;

    getDoctorSchedules(searchDoctor.uuid);
    generateAvailableDates();

    if (availableDatesList.isNotEmpty) {
      String initialDate = availableDatesList[0].toString().split(' ')[0];
      getDoctorSlotsDynamic(searchDoctor.uuid, initialDate);
      initFirebaseRealtime(searchDoctor.uuid, initialDate);
    }
  }
//هي لحتى اقدر مرر مودل  التفاصيل تبع الدكتور  بس لتعديل حجز
  void initDoctorDetailsForReschedule({
    required TopDoctorModel doctor,
    required String appointmentUuid,
    required DateTime oldAppointmentDateTime,
  })async {
    isRescheduling.value = true;
    appointmentUuidToModify.value = appointmentUuid;
    currentDoctor.value = doctor;
    selectedTime.value = null;

   await getDoctorSchedules(doctor.uuid);
     generateAvailableDates();

    String oldDateStr = oldAppointmentDateTime.toString().split(' ')[0];
    int targetIndex = availableDatesList.indexWhere(
      (date) => date.toString().split(' ')[0] == oldDateStr
    );

    if (targetIndex != -1) {
      selectedDateIndex.value = targetIndex;
      getDoctorSlotsDynamic(doctor.uuid, oldDateStr);
      initFirebaseRealtime(doctor.uuid, oldDateStr);
    } else {
      selectedDateIndex.value = 0;
      if (availableDatesList.isNotEmpty) {
        String initialDate = availableDatesList[0].toString().split(' ')[0];
        getDoctorSlotsDynamic(doctor.uuid, initialDate);
        initFirebaseRealtime(doctor.uuid, initialDate);
      }
    }
  }

// هي لجلب الدكاترة ضمن اختصاص 
  Future<void> getDoctorsBySpecialty(String specialtyId) async {
    isDoctorsBySpecLoading.value = true;
    doctorsBySpecialty.clear();
    final response = await repostryHome.getDoctorsBySpecialty(specialtyId);

    response.fold(
      (errorMessage) {
        isDoctorsBySpecLoading.value = false;
        print("Doctors by Specialty Error: $errorMessage");
      },
      (doctorsData) {
        isDoctorsBySpecLoading.value = false;
        doctorsBySpecialty.assignAll(doctorsData.data);
      },
    );
  }
// هي لبرنامج دوام الدكتور 
  Future<void> getDoctorSchedules(String doctorUuid) async {
    isSchedulesLoading.value = true;
    doctorSchedules.clear();
    final response = await repostryHome.getDoctorSchedules(doctorUuid);

    response.fold(
      (errorMessage) {
        isSchedulesLoading.value = false;
        print("Schedules Error: $errorMessage");
      },
      (schedulesData) {
        isSchedulesLoading.value = false;
        doctorSchedules.assignAll(
  schedulesData.data.where((schedule) => schedule.doctorUuid == doctorUuid),
);
       // doctorSchedules.assignAll(schedulesData.data);
      },
    );
  }
//هي لتنسيق البرنامج
  Map<String, String> get formattedWorkingHours {
    Map<String, String> hoursMap = {};
    for (var schedule in doctorSchedules) {
      hoursMap[schedule.day] = "${schedule.startTime} - ${schedule.endTime}";
    }
    return hoursMap;
  }
//هي جلب المواعيد
  Future<void> getDoctorSlotsDynamic(String doctorUuid, String date) async {
    isSlotsLoading.value = true;
    doctorSlots.clear();
    selectedTime.value = null; 

    final response = await repostryHome.getDoctorSlots(doctorUuid: doctorUuid, date: date);

    response.fold(
      (errorMessage) {
        isSlotsLoading.value = false;
        print("Slots Error: $errorMessage");
        Get.snackbar("خطأ", errorMessage, snackPosition: SnackPosition.BOTTOM);
      },
      (slotsData) {
        isSlotsLoading.value = false;
        doctorSlots.assignAll(slotsData.data);
      },
    );
  }
// هي دالة الحجز 
  Future<void> bookAppointmentFinal() async {
    if (selectedTime.value == null) {
      Get.snackbar(
        "تنبيه",
        "الرجاء اختيار وقت محدد للحجز أولاً",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.warning.withOpacity(0.3),
      );
      return;
    }

    final selectedSlot = doctorSlots.firstWhere((slot) => slot.time == selectedTime.value);
    isBookingLoading.value = true;

    final response = await repostryHome.bookAppointment(
      doctorUuid: currentDoctor.value!.uuid,
      dateTime: selectedSlot.fullDate,
     // type: selectedBookingType.value,
     type: "check",
    );

    response.fold(
      (errorMessage) {
        isBookingLoading.value = false;
        AlertHelper.showSnackbar(
          title: "خطأ في الحجز",
          message: errorMessage,
          type: AlertType.error,
        );
      },
      (appointmentData) async {
        isBookingLoading.value = false;
          if(Get.isRegistered<PatientAppointmentController>()){
           await Get.find<PatientAppointmentController>().syncAppointmentsSilently();
        }
// هون المزامنة مع الفيربيز
        try {
          await FirebaseFirestore.instance.collection('appointments').add({
            'user_uuid': currentDoctor.value!.uuid,
            'status': "has booked",
            'appointment_uuid': appointmentData.appointment!.uuid, 
            'date_time': selectedSlot.fullDate,
          });
          print(" [Firebase Sync] تم إرسال إشارة الحجز للفايربيس بنجاح!");
        } catch (e) {
          print(" [Firebase Sync Error]: $e");
        }

        CustomActionDialog.show(
          context: Get.context!,
          icon: Icons.check,
          iconColor: AppColors.primaryTeal,
          iconBackgroundColor: AppColors.primaryTeal.withOpacity(0.1),
          title: StringManager.bookingSuccess,
          subtitle: "${StringManager.bookingConfirmedWith}\n${selectedTime.value}",
          hintText: StringManager.reminderMessage,
          confirmButtonText: StringManager.ok,
          onConfirm: () {
            Get.back();
          },
        );
      },
    );
  }

  Future<void> rescheduleAppointment({
    required String appointmentUuid,
    required String doctorUuid,
    required String newDateTime,
    required String type,
  }) async {
    isUpdateBookingLoading.value = true;

    final response = await repostryHome.updateAppointment(
      appointmentUuid: appointmentUuid,
      doctorUuid: doctorUuid,
      dateTime: newDateTime,
      type: type,
    );

    response.fold(
      (errorMessage) {
        isUpdateBookingLoading.value = false;
        AlertHelper.showSnackbar(
          title: "فشل التعديل",
          message: errorMessage,
          type: AlertType.error,
        );
      },
      (updatedAppointment) async {
        isUpdateBookingLoading.value = false;

        if (Get.isRegistered<PatientAppointmentController>()) {
          var appCtrl = Get.find<PatientAppointmentController>();
          int index = appCtrl.allAppointments.indexWhere((app) => app.appointmentUuid == appointmentUuid);
          if (index != -1) {
            appCtrl.allAppointments[index] = updatedAppointment; 
            appCtrl.allAppointments.refresh();
          }
        }

        if (Get.isBottomSheetOpen ?? false) Get.back();

        CustomActionDialog.show(
          context: Get.context!,
          icon: Icons.check_circle_outline_rounded,
          iconColor: AppColors.primaryTeal,
          iconBackgroundColor: AppColors.primaryTeal.withOpacity(0.1),
          title: "تمت إعادة الجدولة",
          subtitle: "تم تعديل وقت موعدك بنجاح واختفى من القائمة الحالية.",
          confirmButtonText: StringManager.ok,
          onConfirm: () => Get.back(),
        );

        try {
          await FirebaseFirestore.instance.collection('appointments').add({
            'user_uuid': doctorUuid, 
            'status': "rescheduled",
            'appointment_uuid': appointmentUuid,
            'date_time': newDateTime, 
          });
          print(" [Firebase Sync] تم إرسال إشارة تعديل الموعد للفايربيس بنجاح!");
        } catch (e) {
          print(" [Firebase Reschedule Sync Error]: $e");
        }

        if(Get.isRegistered<PatientAppointmentController>()){
           await Get.find<PatientAppointmentController>().syncAppointmentsSilently();
        }
      },
    );
  }

  Future<void> selectSomeoneBirthday(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 20)), 
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      String formattedDate = "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
      someoneBirthdayController.text = formattedDate;
    }
  }

  Future<void> bookForSomeoneFinal() async {
    if (selectedTime.value == null) {
      AlertHelper.showSnackbar(
        title: "تنبيه", 
        message: "الرجاء اختيار وقت الحجز أولاً", 
        type: AlertType.warning
      );
      return;
    }

    final selectedSlot = doctorSlots.firstWhere((slot) => slot.time == selectedTime.value);
    isBookingLoading.value = true;
    String genderToSend = (someoneGender.value == StringManager.female) ? 'female' : 'male';

    final response = await repostryHome.bookForSomeone(
      name: someoneNameController.text.trim(),
      nickName: someoneNickNameController.text.trim(),
      phone: someonePhoneController.text.trim(),
      gender: genderToSend,
      birthday: someoneBirthdayController.text.trim(),
      doctorUuid: currentDoctor.value!.uuid, 
      dateTime: selectedSlot.fullDate,       
      type: selectedBookingType.value,       
    );

    response.fold(
      (errorMessage) {
        isBookingLoading.value = false;
        AlertHelper.showSnackbar(
          title: "فشل الحجز للغير", 
          message: errorMessage, 
          type: AlertType.error
        );
      },
      (appointmentResponse) async {
        isBookingLoading.value = false;
        if(Get.isRegistered<PatientAppointmentController>()){
           await Get.find<PatientAppointmentController>().syncAppointmentsSilently();
        }

        try {
          await FirebaseFirestore.instance.collection('appointments').add({
            'user_uuid': currentDoctor.value!.uuid,
            'status': "has booked",
            'appointment_uuid': appointmentResponse.patientData?.uuid ?? '', 
            'date_time': selectedSlot.fullDate,
          });
        } catch (e) {
          print(" [Firebase Sync Error]: $e");
        }

        someoneNameController.clear();
        someoneNickNameController.clear();
        someonePhoneController.clear();
        someoneBirthdayController.clear();
        someoneGender.value = StringManager.male;
        bookForSomeoneElse.value = false; 

        CustomActionDialog.show(
          context: Get.context!,
          icon: Icons.check,
          iconColor: AppColors.primaryTeal,
          iconBackgroundColor: AppColors.primaryTeal.withOpacity(0.1),
          title: "تم الحجز بنجاح",
          subtitle: "${appointmentResponse.message}\nللمريض: ${appointmentResponse.patientData?.name}",
          confirmButtonText: StringManager.ok,
          onConfirm: () => Get.back(),
        );
      },
    );
  }

  Future<void> submitRating() async {
    final response = await repostryHome.rateDoctor(
      doctorUuid: currentDoctor.value!.uuid,
      stars: userRating.value.toInt(),
    );

    response.fold(
      (errorMessage) {
        isRatingLoading.value = false;
        CustomActionDialog.show(
          context: Get.context!,
          icon: Icons.error_outline_rounded,
          iconColor: AppColors.error,
          iconBackgroundColor: AppColors.error.withOpacity(0.1),
          title: "فشل التقييم",
          subtitle: errorMessage,
          hintText: "",
          confirmButtonText: StringManager.ok,
          onConfirm: () => Get.back(),
        );
      },
      (ratingResponse) {
        isRatingLoading.value = false;
        CustomActionDialog.show(
          context: Get.context!,
          icon: Icons.check_circle_outline_rounded,
          iconColor: AppColors.primaryTeal,
          iconBackgroundColor: AppColors.primaryTeal.withOpacity(0.1),
          title: "تم بنجاح",
          subtitle: ratingResponse.message,
          hintText: "",
          confirmButtonText: StringManager.ok,
          onConfirm: () {
            Get.back();
            userRating.value = 0.0;
          },
        );
      },
    );
  }

  void initFirebaseRealtime(String doctorUuid, String dateStr) {
    _firebaseSubscription?.cancel();
    print(" [RealTime] المريض يستمع الآن لمواعيد الطبيب: $doctorUuid في تاريخ: $dateStr");

    _firebaseSubscription = FirebaseFirestore.instance
        .collection('appointments')
        .where('user_uuid', isEqualTo: doctorUuid)
        .snapshots()
        .listen((querySnapshot) {
      print(" [RealTime] تم رصد حركة حجز/تعديل عند هذا الطبيب! جاري تحديث الـ Slots...");
      getDoctorSlotsDynamic(doctorUuid, dateStr);
    }, onError: (e) => print(" [Firebase RealTime Error]: $e"));
  }
  //claud
  int _arabicDayToWeekday(String arabicDay) {
  const Map<String, int> map = {
    'الأحد':    DateTime.sunday,
    'الاثنين':  DateTime.monday,
    'الثلاثاء': DateTime.tuesday,
    'الأربعاء': DateTime.wednesday,
    'الخميس':   DateTime.thursday,
    'الجمعة':   DateTime.friday,
    'السبت':    DateTime.saturday,
  };
  return map[arabicDay] ?? DateTime.monday;
}

  @override
  void onClose() {
    _firebaseSubscription?.cancel(); 
    someoneNameController.dispose();
    someoneNickNameController.dispose();
    someonePhoneController.dispose();
    someoneBirthdayController.dispose();
    print("🗑 [RealTime] تم إلغاء اشتراك فحص المواعيد المباشر وتنظيف الذاكرة بنجاح.");
    super.onClose();
  }
}