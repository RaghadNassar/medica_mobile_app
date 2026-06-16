import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:raghad_pro/core/api/api_consumer.dart';
import 'package:raghad_pro/core/constanse/string_manager.dart';
import 'package:raghad_pro/core/helper/alert_helper.dart';
import 'package:raghad_pro/core/theme/app_colors.dart';
import 'package:raghad_pro/core/widget/dialoge_action.dart';
import 'package:raghad_pro/features/chat/view/screen/chatList_screen.dart';
import 'package:raghad_pro/features/home/controller/search_controller.dart';
import 'package:raghad_pro/features/home/data/model/get_booking.dart';
import 'package:raghad_pro/features/home/data/model/scedual_mode.dart';
import 'package:raghad_pro/features/home/data/model/search_model.dart';
import 'package:raghad_pro/features/home/data/model/slote_model.dart';
import 'package:raghad_pro/features/home/data/model/spizialize_model.dart';
import 'package:raghad_pro/features/home/data/model/top_doctor_model.dart';
import 'package:raghad_pro/features/home/data/repositry/repostry_home.dart';
import 'package:raghad_pro/features/home/view/screen/appoinment_screen.dart';
import 'package:raghad_pro/features/home/view/screen/home_screen.dart';
import 'package:raghad_pro/features/profile/presentation/screen/profile_screen.dart';
import 'package:raghad_pro/features/profile/controller/profile_controller.dart';
import 'package:raghad_pro/features/profile/data/repostry/user_repostry.dart';

// binding
class MainNavigationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RepostryHome>(() => RepostryHome(Get.find<ApiConsumer>()));
    Get.lazyPut<HomeController>(() => HomeController(Get.find<RepostryHome>()));
    // Register profile dependencies so Profile widgets can find their controller
    Get.lazyPut<ProfileRepostry>(
        () => ProfileRepostry(Get.find<ApiConsumer>()));
    Get.lazyPut<ProfileController>(
        () => ProfileController(Get.find<ProfileRepostry>()));
    Get.lazyPut<PatientSearchController>(
        () => PatientSearchController(Get.find<RepostryHome>()));
  }
}

// controller
class HomeController extends GetxController {
  final RepostryHome repostryHome;
  HomeController(this.repostryHome);

  StreamSubscription? _firebaseSubscription;
//====================primary=================================
//banar promo
  final PageController bannerPageController = PageController();
  final RxInt currentBannerPage = 0.obs;
  Timer? _bannerTimer;
//top doctor
  var isTopDoctorsLoading = true.obs;
  var topDoctors = <TopDoctorModel>[].obs;
//homepage
  final RxInt currentIndex = 0.obs;
  final List screens = [
    const HomeScreen(),
    const ClinicalChatWidget(isDark: false),
    //const ChatView(),
    const AppoinmentScreen(),
    const ProfileScreen(),
  ];
//detail screen
  final RxInt activeTabIndex = 0.obs;
  var userRating = 0.0.obs;
  final RxInt selectedDateIndex = 0.obs;
  final RxnString selectedTime = RxnString();
//rate post
  var isRatingLoading = false.obs;
//قمت بالتعديلvar currentDoctor = Rxn<DoctorBySpecialtyModel>();
  var currentDoctor = Rxn<TopDoctorModel>();
// ==================== Appointment Screen Logic ====================
  var isAppointmentsLoading = false.obs;
  var allAppointments = <BookingModel>[].obs;
  final RxInt appointmentTabControllerIndex = 0.obs;
  var isCancelBookingLoading = false.obs;
  var isUpdateBookingLoading = false.obs;
  final RxBool isRescheduling = false.obs;        
  final RxString appointmentUuidToModify = ''.obs;
// get appoinment
  getPatientAppointments() async {
    isAppointmentsLoading.value = true;
    final response = await repostryHome.getPatientAppointments();

    response.fold(
      (errorMessage) {
        isAppointmentsLoading.value = false;
      },
      (bokingResponse) {
        isAppointmentsLoading.value = false;

        allAppointments.assignAll(bokingResponse.data);
      },
    );
  }

// filtter
  List<BookingModel> get bookedAppointments {
    return allAppointments.where((app) => app.status == 'has booked').toList();
  }

  List<BookingModel> get waitingAppointments {
    return allAppointments.where((app) => app.status == 'is waiting').toList();
  }

  List<BookingModel> get changedAppointments {
    return allAppointments.where((app) => app.status == 'has changed').toList();
  }

  List<BookingModel> get visitedAppointments {
    return allAppointments.where((app) => app.status == 'has visited').toList();
  }

  //cancel book
  cancelAppointment(String appointmentUuid) async {
    isCancelBookingLoading.value = true;

    final response = await repostryHome.deleteAppointment(appointmentUuid);

    response.fold(
      (errorMessage) {
        isCancelBookingLoading.value = false;
        AlertHelper.showSnackbar(
          title: "فشل الإلغاء",
          message: errorMessage,
          type: AlertType.error,
        );
      },
      (successMessage) async {
        isCancelBookingLoading.value = false;

        allAppointments
            .removeWhere((app) => app.appointmentUuid == appointmentUuid);
        allAppointments.refresh();
        //   هي للفيربيز 
        try {
          await FirebaseFirestore.instance.collection('appointments').add({
            'user_uuid': currentDoctor.value?.uuid ?? '', 
            'status': "cancelled",
            'appointment_uuid': appointmentUuid,
            'date_time': DateTime.now().toString(), 
          });
          print(" [Firebase Sync] تم إرسال إشارة إلغاء الموعد للفايربيس بنجاح!");
        } catch (e) {
          print(" [Firebase Cancel Sync Error]: $e");
        }
        await syncAppointmentsSilently();
      },
    );
  }
// ريفرش للواجهة 
  syncAppointmentsSilently() async {
    try {
    
      final response = await repostryHome.getPatientAppointments();

      response.fold(
        (error) => print(" [Background Sync] فشلت المزامنة الصامتة: $error"),
        (bokingResponse) {
         
          allAppointments.assignAll(bokingResponse.data);
        },
      );
    } catch (e) {
      print(" [Background Sync Error]: $e");
    }
  }
  // update upoinment 
  rescheduleAppointment({
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

     
      int index = allAppointments.indexWhere((app) => app.appointmentUuid == appointmentUuid);
      
      if (index != -1) {
       
        allAppointments[index] = updatedAppointment; 
        
       
        allAppointments.refresh();
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

     
      await syncAppointmentsSilently();
    },
  );
}


void initDoctorDetailsForReschedule({required TopDoctorModel doctor, required String appointmentUuid}) {
  isRescheduling.value = true;
  appointmentUuidToModify.value = appointmentUuid;
  initDoctorDetails(doctor);
}
  void changeAppointmentTab(int index) {
    appointmentTabControllerIndex.value = index;
  }

  void initDoctorDetails(TopDoctorModel doctor) {
    if (appointmentUuidToModify.isEmpty) {
    isRescheduling.value = false;
  }
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

//   للباك
  void initDoctorDetailsFromSearch(SearchDoctorItem searchDoctor) {
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

//spicialization
  var isSpecLoading = true.obs;
  var specializations = <SpecializationModel>[].obs;
  SpecializationStats? stats;
//doctor spicialize
  var isDoctorsBySpecLoading = false.obs;
  var doctorsBySpecialty = <TopDoctorModel>[].obs;
//schedual
  var isSchedulesLoading = false.obs;
  var doctorSchedules = <DoctorScheduleModel>[].obs;
// Slots Variables
  final RxString selectedBookingType = 'check'.obs;
  var isSlotsLoading = false.obs;
  var doctorSlots = <DoctorSlotModel>[].obs;
  var availableDatesList = <DateTime>[].obs;
  var isBookingLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    getSpecializations();
    _startBannerAutoSlider();
    getTopDoctors();
    generateAvailableDates();
    getPatientAppointments();
  }

  void initFirebaseRealtime(String doctorUuid, String dateStr) {
  
  _firebaseSubscription?.cancel();

  print(" [RealTime] المريض يستمع الآن لمواعيد الطبيب: $doctorUuid في تاريخ: $dateStr");

  
  _firebaseSubscription = FirebaseFirestore.instance
      .collection('appointments')
      .where('user_uuid', isEqualTo: doctorUuid)
     // .where('doctor_uuid', isEqualTo: doctorUuid) 
      // ملاحظة هندسية: إذا كنتِ تخزنين حقل التاريخ في الفايربيس باسم 'date' مثلاً، يفضل تفعيل السطر التالي:
      // .where('date', isEqualTo: dateStr) 
      .snapshots()
      .listen((querySnapshot) {
        
    print("⚡ [RealTime] تم رصد حركة حجز/تعديل عند هذا الطبيب! جاري تحديث الـ Slots المتاحة فوراً...");
    
   
    getDoctorSlotsDynamic(doctorUuid, dateStr);
    
  }, onError: (e) => print("❌ [Firebase RealTime Error]: $e"));
}

//bannar
  void _startBannerAutoSlider() {
    _bannerTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (stats != null) {
        if (currentBannerPage.value < 3) {
          currentBannerPage.value++;
        } else {
          currentBannerPage.value = 0;
        }

        if (bannerPageController.hasClients) {
          bannerPageController.animateToPage(
            currentBannerPage.value,
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
          );
        }
      }
    });
  }

  void updateBannerPage(int page) {
    currentBannerPage.value = page;
  }

  /*@override
  void onClose() {
    _bannerTimer?.cancel();
    bannerPageController.dispose();
    super.onClose();
  }
*/
  @override
  void onClose() {
    _bannerTimer?.cancel();
    bannerPageController.dispose();
    _firebaseSubscription?.cancel(); 
    print("🗑 [RealTime] تم إلغاء اشتراك فحص المواعيد المباشر بنجاح.");
    super.onClose();
  }

  //homepage
  void changeIndex(int index) {
    currentIndex.value = index;
  }

// detail screen

  void updateActiveTab(int index) {
    activeTabIndex.value = index;
  }

// spicialization
  getSpecializations() async {
    isSpecLoading.value = true;
    final response = await repostryHome.getSpecializations();

    response.fold(
      (errorMessage) {
        isSpecLoading.value = false;
        print("Error: $errorMessage");
      },
      (specializationData) {
        isSpecLoading.value = false;
        specializations.assignAll(specializationData.data);
        stats = specializationData.stats;
      },
    );
  }

// top doctor
  getTopDoctors() async {
    isTopDoctorsLoading.value = true;
    final response = await repostryHome.getTopDoctors();

    response.fold(
      (errorMessage) {
        isTopDoctorsLoading.value = false;
        print("Top Doctors Error: $errorMessage");
      },
      (topDoctorsData) {
        isTopDoctorsLoading.value = false;
        topDoctors.assignAll(topDoctorsData.data);
      },
    );
  }

// doctor by spicialization
  getDoctorsBySpecialty(String specialtyId) async {
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

// doctor schedual
  getDoctorSchedules(String doctorUuid) async {
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
        doctorSchedules.assignAll(schedulesData.data);
      },
    );
  }

  Map<String, String> get formattedWorkingHours {
    Map<String, String> hoursMap = {};
    for (var schedule in doctorSchedules) {
      hoursMap[schedule.day] = "${schedule.startTime} - ${schedule.endTime}";
    }
    return hoursMap;
  }

// get slote
  getDoctorSlotsDynamic(String doctorUuid, String date) async {
    isSlotsLoading.value = true;
    doctorSlots.clear();
    selectedTime.value = null; 

    final response =
        await repostryHome.getDoctorSlots(doctorUuid: doctorUuid, date: date);

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

  IconData getIconForSpecialty(String name) {
    if (name.contains("القلبية")) return Icons.favorite_rounded;
    if (name.contains("الأطفال")) return Icons.child_care_rounded;
    if (name.contains("العصبية")) return Icons.psychology_rounded;
    if (name.contains("العظمية")) return Icons.accessibility_new_rounded;
    if (name.contains("الأسنان"))
      return Icons.attribution_rounded; // أو أيقونة سن مناسبة
    if (name.contains("العينية")) return Icons.visibility_rounded;
    return Icons.medical_services_rounded;
  }

  Color getColorForSpecialty(String name) {
    if (name.contains("القلبية")) return AppColors.error.withOpacity(0.1);
    if (name.contains("الأطفال")) return AppColors.warning.withOpacity(0.1);
    if (name.contains("العصبية")) return Colors.purple.withOpacity(0.1);
    if (name.contains("العظمية")) return AppColors.info.withOpacity(0.1);
    if (name.contains("الأسنان")) return AppColors.primaryTeal.withOpacity(0.1);
    if (name.contains("العينية")) return AppColors.success.withOpacity(0.1);
    return Colors.blueGrey.withOpacity(0.1);
  }

  Color getIconColorForSpecialty(String name) {
    if (name.contains("القلبية")) return AppColors.error;
    if (name.contains("الأطفال")) return AppColors.warning;
    if (name.contains("العصبية")) return Colors.purple;
    if (name.contains("العظمية")) return AppColors.info;
    if (name.contains("الأسنان")) return AppColors.primaryTeal;
    if (name.contains("العينية")) return AppColors.success;
    return Colors.blueGrey;
  }

  // bokking date time
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
      String selectedDateStr =
          availableDatesList[index].toString().split(' ')[0]; // YYYY-MM-DD
      getDoctorSlotsDynamic(currentDoctor.value!.uuid, selectedDateStr);
      //للريل تايم
      initFirebaseRealtime(currentDoctor.value!.uuid, selectedDateStr);
    }
  }

  void bookAppointmentFinal() async {
    if (selectedTime.value == null) {
      Get.snackbar(
        "تنبيه",
        "الرجاء اختيار وقت محدد للحجز أولاً",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.amber.withOpacity(0.3),
      );
      return;
    }

    final selectedSlot =
        doctorSlots.firstWhere((slot) => slot.time == selectedTime.value);

    isBookingLoading.value = true;

    final response = await repostryHome.bookAppointment(
      doctorUuid: currentDoctor.value!.uuid,
      dateTime: selectedSlot.fullDate,
      type: selectedBookingType.value,
    );

    response.fold(
      (errorMessage) {
        isBookingLoading.value = false;
        AlertHelper.showSnackbar(
          title: " خطء في الحجز",
          message: errorMessage,
          type: AlertType.error,
        );
      },
      (appointmentData)async {
        isBookingLoading.value = false;
        await syncAppointmentsSilently();
        try {
        await FirebaseFirestore.instance.collection('appointments').add({
          'user_uuid': currentDoctor.value!.uuid,
          'status': "has booked",
          'appointment_uuid': appointmentData.appointment!.uuid, 
          'date_time': selectedSlot.fullDate,
        });
        print(" [Firebase Sync] تم إرسال إشارة الحجز للفايربيس بنجاح ليتحدث لدى بقية المرضى!");
      } catch (e) {
        print(" [Firebase Sync Error]: $e");
      }

        CustomActionDialog.show(
          context: Get.context!,
          icon: Icons.check,
          iconColor: AppColors.primaryTeal,
          iconBackgroundColor: AppColors.primaryTeal.withOpacity(0.1),
          title: StringManager.bookingSuccess,
          subtitle:
              "${StringManager.bookingConfirmedWith}\n${selectedTime.value}",
          hintText: StringManager.reminderMessage,
          confirmButtonText: StringManager.ok,
          onConfirm: () {
            Get.back();
          },
        );
      },
    );
  }

// rate
  submitRating() async {
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

  // دالة لتغيير الوقت المختار
  void updateSelectedTime(String? time) {
    selectedTime.value = time;
  }

  // دالة حجز الموعد النهائي
  void bookAppointment() {
    if (selectedTime.value != null) {}
  }
}









  // void initFirebaseRealtime(String doctorUuid, String dateStr) {
  //   // نلغي أي اشتراك قديم مسجل لتفادي تكرار الاستماع وتوفير كاش الذاكرة والإنترنت
  //   _firebaseSubscription?.cancel();

  //   print(
  //       "📡 [RealTime] المريض يستمع الآن لمواعيد الطبيب: $doctorUuid في تاريخ: $dateStr");

  //   _firebaseSubscription = FirebaseFirestore.instance
  //       .collection('appointments')
  //       .where('doctor_uuid',
  //           isEqualTo: doctorUuid) // الاستماع لمواعيد هذا الطبيب لمنع التضارب
  //       .snapshots()
  //       .listen((querySnapshot) {
  //     // بمجرد حدوث أي حجز جديد عند هذا الطبيب على الفايربيس، يتم تحديث الأوقات تلقائياً في واجهة المريض
  //     print(
  //         "⚡ [RealTime] تم رصد حجز جديد! جاري تحديث الـ Slots المتاحة فوراً...");
  //     getDoctorSlotsDynamic(doctorUuid, dateStr);
  //   }, onError: (e) => print("❌ [Firebase RealTime Error]: $e"));
  // }




// void bookAppointmentFinal() async {
//   if (selectedTime.value == null) {
//     Get.snackbar("تنبيه", "الرجاء اختيار وقت محدد للحجز أولاً", snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.amber.withOpacity(0.3));
//     return;
//   }

//   final selectedSlot = doctorSlots.firstWhere((slot) => slot.time == selectedTime.value);

//   isBookingLoading.value = true;

//   final response = await repostryHome.bookAppointment(
//     doctorUuid: currentDoctor.value!.uuid,
//     dateTime: selectedSlot.fullDate,
//     type: selectedBookingType.value,
//   );

//   response.fold(
//     (errorMessage) {
//       isBookingLoading.value = false;

//     },
//     (appointmentData) {
//       isBookingLoading.value = false;

//     },
//   );
// }

/*
 هي البيانات التجريبية كانت 
  // البيانات التجريبية - جاهزة للاستبدال بـ API call لاحقاً
  final List<Map<String, String>> mockDates = [
    {'day': 'TUE', 'date': '20'},
    {'day': 'WED', 'date': '21'},
    {'day': 'THU', 'date': '22'},
    {'day': 'FRI', 'date': '23'},
    {'day': 'SAT', 'date': '24'},
    {'day': 'MON', 'date': '25'},
  ];

  final List<String> mockTimes = [
    '09:00 AM',
    '10:00 AM',
    '11:00 AM',
    '01:00 PM',
    '02:00 PM',
    '03:00 PM',
    '04:00 PM',
    '05:00 PM',
    '07:00 PM'
  ];

  final Map<String, String> workingHours = {
    'Monday': '09:00 AM - 05:00 PM',
    'Tuesday': '09:00 AM - 05:00 PM',
    'Wednesday': '09:00 AM - 05:00 PM',
    'Thursday': '09:00 AM - 05:00 PM',
    'Friday': '09:00 AM - 01:00 PM',
    'Saturday': 'Closed',
  };

*/

// @override
// void onInit() {
//   getSpecializations(); // جلب البيانات فور تشغيل الـ Controller
//   super.onInit();
// }

/*void initDoctorDetails(DoctorBySpecialtyModel doctor) {
    currentDoctor.value = doctor;

    getDoctorSchedules(doctor.uuid);
  }*/
//ohhhhh
/*void initDoctorDetails(DoctorBySpecialtyModel doctor) {
  currentDoctor.value = doctor;
  selectedDateIndex.value = 0; // إعادة التعيين لأول يوم
  selectedTime.value = null;   // تفريغ الوقت المختار مسبقاً
  
  getDoctorSchedules(doctor.uuid);
  generateAvailableDates();
  
  // جلب فترات أول يوم متاح تلقائياً عند فتح الصفحة
  if (availableDatesList.isNotEmpty) {
    String initialDate = availableDatesList[0].toString().split(' ')[0]; // YYYY-MM-DD
    getDoctorSlotsDynamic(doctor.uuid, initialDate);
  }
}*/

/*import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:raghad_pro/core/api/api_consumer.dart';
import 'package:raghad_pro/core/theme/app_colors.dart';
import 'package:raghad_pro/features/home/data/model/doctor_spicializ_model.dart';
import 'package:raghad_pro/features/home/data/model/scedual_mode.dart';
import 'package:raghad_pro/features/home/data/model/spizialize_model.dart';
import 'package:raghad_pro/features/home/data/model/top_doctor_model.dart';
import 'package:raghad_pro/features/home/data/repositry/repostry_home.dart';
import 'package:raghad_pro/features/home/view/screen/appoinment_screen.dart';
import 'package:raghad_pro/features/home/view/screen/home_screen.dart';
import 'package:raghad_pro/features/profile/presentation/screen/profile_screen.dart';

// binding
class MainNavigationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RepostryHome>(() => RepostryHome(Get.find<ApiConsumer>()));
    Get.lazyPut<HomeController>(() => HomeController(Get.find<RepostryHome>()));
  }
}

// controller
class HomeController extends GetxController {
  final RepostryHome repostryHome;
  HomeController(this.repostryHome);

//====================asasy=================================
// banar promo
  final PageController bannerPageController = PageController();
  final RxInt currentBannerPage = 0.obs;
  Timer? _bannerTimer;
//top doctor 
  var isTopDoctorsLoading = true.obs;
  var topDoctors = <TopDoctorModel>[].obs;
//   homepage
  final RxInt currentIndex = 0.obs;
  final List screens = [
    const HomeScreen(), 
    const AppoinmentScreen(), 
    const ProfileScreen(), 
  ];
// detail screen
  final RxInt activeTabIndex = 0.obs;
  var userRating = 0.0.obs;
  final RxInt selectedDateIndex = 0.obs;
  final RxnString selectedTime = RxnString();
//spicialization
  var isSpecLoading = true.obs;
  var specializations = <SpecializationModel>[].obs;
  SpecializationStats? stats; 
//doctor spicialize
  var isDoctorsBySpecLoading = false.obs;
  var doctorsBySpecialty = <DoctorBySpecialtyModel>[].obs; 
//schedual
  var isSchedulesLoading = false.obs;
  var doctorSchedules = <DoctorScheduleModel>[].obs;  

  // 🌟 (مكان التغيير 1): إعلان القوائم التفاعلية الحية ومؤشر تحميل الحجز
  var dynamicDates = <Map<String, String>>[].obs;
  var dynamicTimes = <String>[].obs;
  var isBookingLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    getSpecializations();
    _startBannerAutoSlider();
    getTopDoctors();
  }

//bannar
  void _startBannerAutoSlider() {
    _bannerTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (stats != null) {
        if (currentBannerPage.value < 3) {
          currentBannerPage.value++;
        } else {
          currentBannerPage.value = 0;
        }

        if (bannerPageController.hasClients) {
          bannerPageController.animateToPage(
            currentBannerPage.value,
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
          );
        }
      }
    });
  }

  void updateBannerPage(int page) {
    currentBannerPage.value = page;
  }

  @override
  void onClose() {
    _bannerTimer?.cancel();
    bannerPageController.dispose();
    super.onClose();
  }

//homepage
  void changeIndex(int index) {
    currentIndex.value = index;
  }

// detail screen   
  void updateActiveTab(int index) {
    activeTabIndex.value = index;
  }

  getSpecializations() async {
    isSpecLoading.value = true;
    final response = await repostryHome.getSpecializations();

    response.fold(
      (errorMessage) {
        isSpecLoading.value = false;
        print("Error: $errorMessage");
      },
      (specializationData) {
        isSpecLoading.value = false;
        specializations.assignAll(specializationData.data);
        stats = specializationData.stats;
      },
    );
  }

  getTopDoctors() async {
    isTopDoctorsLoading.value = true;
    final response = await repostryHome.getTopDoctors();

    response.fold(
      (errorMessage) {
        isTopDoctorsLoading.value = false;
        print("Top Doctors Error: $errorMessage");
      },
      (topDoctorsData) {
        isTopDoctorsLoading.value = false;
        topDoctors.assignAll(topDoctorsData.data);
      },
    );
  }

  getDoctorsBySpecialty(String specialtyId) async {
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

  // 🌟 (مكان التغيير 2): تعديل جلب الجدول لتصفير المواعيد القديمة واستدعاء منشئ التواريخ الحية
  getDoctorSchedules(String doctorUuid) async {
    isSchedulesLoading.value = true;
    doctorSchedules.clear();
    dynamicDates.clear();
    dynamicTimes.clear();
    selectedTime.value = null;
    selectedDateIndex.value = 0;
    
    final response = await repostryHome.getDoctorSchedules(doctorUuid);

    response.fold(
      (errorMessage) {
        isSchedulesLoading.value = false;
        print("Schedules Error: $errorMessage");
      },
      (schedulesData) {
        isSchedulesLoading.value = false;
        doctorSchedules.assignAll(schedulesData.data);
        
        // توليد التواريخ المتوافقة مع أيام عمل الطبيب الحقيقية فوراً
        _generateDatesFromSchedule();
      },
    );
  }

  Map<String, String> get formattedWorkingHours {
    Map<String, String> hoursMap = {};
    for (var schedule in doctorSchedules) {
      hoursMap[schedule.day] = "${schedule.startTime} - ${schedule.endTime}";
    }
    return hoursMap;
  }

  // 🌟 (مكان التغيير 3): دالة ذكية لتشكيل الـ 14 يوماً القادمة بناءً على أيام الطبيب المتاحة فقط
 // 🌟 الدالة المحدثة لتوليد التواريخ بدعم كامل للغة العربية القادمة من الـ API
  void _generateDatesFromSchedule() {
    if (doctorSchedules.isEmpty) return;

    // 1. تنظيف واقتصاص النصوص القادمة من السيرفر لضمان المطابقة (مثال: "الاثنين ")
    List<String> allowedDaysFromApi = doctorSchedules
        .map((e) => e.day.trim())
        .toList();

    List<Map<String, String>> tempDates = [];
    DateTime today = DateTime.now();

    // 2. فحص الـ 14 يوماً القادمة في الرزنامة
    for (int i = 0; i < 14; i++) {
      DateTime futureDate = today.add(Duration(days: i));
      
      // جلب اسم اليوم بالعربي لهذا التاريخ المستقبلي
      String currentArabicDayName = _getArabicDayName(futureDate.weekday);

      // 3. المقارنة الفعالية: هل هذا اليوم موجود ضمن قائمة دوام الدكتور القادمة من الـ API؟
      if (allowedDaysFromApi.contains(currentArabicDayName)) {
        tempDates.add({
          'day': _getShortArabicDayName(futureDate.weekday), // نصوص عربية مختصرة للـ UI (ث، خ، ج...) أو مسميات أخرى تفضلينها
          'date': futureDate.day.toString(),          
          'fullDate': "${futureDate.year}-${futureDate.month.toString().padLeft(2, '0')}-${futureDate.day.toString().padLeft(2, '0')}" 
        });
      }
    }

    dynamicDates.assignAll(tempDates);

    // تنشيط اليوم الأول المتاح تلقائياً وعرض ساعاته
    if (dynamicDates.isNotEmpty) {
      updateSelectedDate(0);
    }
  }

  // 🌟 دالة مساعدة لتحويل رقم اليوم البرمجي إلى نص عربي مطابق تماماً لبيانات الباك إند
  String _getArabicDayName(int weekday) {
    switch (weekday) {
      case DateTime.monday: return 'الاثنين';
      case DateTime.tuesday: return 'الثلاثاء';
      case DateTime.wednesday: return 'الأربعاء';
      case DateTime.thursday: return 'الخميس';
      case DateTime.friday: return 'الجمعة';
      case DateTime.saturday: return 'السبت';
      case DateTime.sunday: return 'الأحد';
      default: return '';
    }
  }

  // 🌟 دالة مساعدة لعرض الاختصارات في واجهة التطبيق العلوية (BookingDateSelector) لتبدو أنيقة
  String _getShortArabicDayName(int weekday) {
    switch (weekday) {
      case DateTime.monday: return 'اثنين';
      case DateTime.tuesday: return 'ثلاثاء';
      case DateTime.wednesday: return 'أربعاء';
      case DateTime.thursday: return 'خميس';
      case DateTime.friday: return 'جمعة';
      case DateTime.saturday: return 'سبت';
      case DateTime.sunday: return 'أحد';
      default: return '';
    }
  }

  // 🌟 تعديل دالة تحديث اليوم لتعمل مع النظام العربي الجديد
  void updateSelectedDate(int index) {
    selectedDateIndex.value = index;
    selectedTime.value = null; 
    
    if (dynamicDates.isEmpty) return;

    String fullDateStr = dynamicDates[index]['fullDate']!;
    DateTime selectedDate = DateTime.parse(fullDateStr);
    
    // الحصول على اسم اليوم بالعربي للتاريخ المختار
    String arabicDayName = _getArabicDayName(selectedDate.weekday);

    // البحث في قائمة السيرفر عن جدول هذا اليوم
    var daySchedule = doctorSchedules.firstWhereOrNull((e) => e.day.trim() == arabicDayName);

    if (daySchedule != null) {
      dynamicTimes.assignAll(_generateTimeSlots(daySchedule.startTime, daySchedule.endTime));
    } else {
      dynamicTimes.clear();
    }
  }

  // دالة تقسيم فترة الدوام الكبيرة إلى كتل زمنية بالساعات
  List<String> _generateTimeSlots(String start, String end) {
    List<String> slots = [];
    try {
      int startHour = int.parse(start.split(':')[0]);
      int endHour = int.parse(end.split(':')[0]);
      
      if (start.contains("PM") && startHour != 12) startHour += 12;
      if (end.contains("PM") && endHour != 12) endHour += 12;
      if (start.contains("AM") && startHour == 12) startHour = 0;
      if (end.contains("AM") && endHour == 12) endHour = 0;

      for (int h = startHour; h < endHour; h++) {
        int displayHour = h % 12 == 0 ? 12 : h % 12;
        String amPm = h >= 12 ? "PM" : "AM";
        slots.add("${displayHour.toString().padLeft(2, '0')}:00 $amPm");
      }
    } catch (e) {
      slots = ['09:00 AM', '10:00 AM', '11:00 AM', '12:00 PM', '01:00 PM', '02:00 PM'];
    }
    return slots;
  }

  // 🌟 (مكان التغيير 5): دالة حجز الموعد الفعلي ورفعها للباك إند بالصيغة المطلوبة
  void bookDoctorAppointment(String doctorUuid) async {
    if (selectedTime.value == null) {
      Get.snackbar("تنبيه", "الرجاء اختيار الوقت المتاح أولاً", backgroundColor: Colors.amber);
      return;
    }

    isBookingLoading.value = true;

    // دمج التاريخ المختار + الوقت المختار بصيغة السيرفر: YYYY-MM-DD HH:mm:ss
    String chosenDate = dynamicDates[selectedDateIndex.value]['fullDate']!;
    String chosenTime = _convertTimeTo24H(selectedTime.value!);
    String finalDateTimeStr = "$chosenDate $chosenTime"; 

    final response = await repostryHome.bookAppointment(
      doctorUuid: doctorUuid,
      dateTime: finalDateTimeStr,
      type: "check", // 💡 تمرير قيمة الفحص المطلوبة من الباك إند هنا برمجياً
    );

    response.fold(
      (errorMessage) {
        isBookingLoading.value = false;
        Get.snackbar("خطأ الحجز", errorMessage, backgroundColor: Colors.red, colorText: Colors.white);
      },
      (appointmentData) {
        isBookingLoading.value = false;
        Get.snackbar("نجاح العملية", appointmentData.message, backgroundColor: Colors.green, colorText: Colors.white);
        
        // هنا يمكنك تصفير الموعد المختار أو الرجوع للخلف:
        selectedTime.value = null;
      },
    );
  }

  String _convertTimeTo24H(String time12) {
    try {
      final parts = time12.split(' ');
      final timeParts = parts[0].split(':');
      int hour = int.parse(timeParts[0]);
      String minute = timeParts[1];
      String amPm = parts[1];

      if (amPm == "PM" && hour != 12) hour += 12;
      if (amPm == "AM" && hour == 12) hour = 0;

      return "${hour.toString().padLeft(2, '0')}:$minute:00";
    } catch (e) {
      return "10:00:00";
    }
  }

  String _getEnglishDayName(int weekday) {
    switch (weekday) {
      case DateTime.monday: return 'Monday';
      case DateTime.tuesday: return 'Tuesday';
      case DateTime.wednesday: return 'Wednesday';
      case DateTime.thursday: return 'Thursday';
      case DateTime.friday: return 'Friday';
      case DateTime.saturday: return 'Saturday';
      case DateTime.sunday: return 'Sunday';
      default: return '';
    }
  }

  String _getShortDayName(int weekday) {
    switch (weekday) {
      case DateTime.monday: return 'MON';
      case DateTime.tuesday: return 'TUE';
      case DateTime.wednesday: return 'WED';
      case DateTime.thursday: return 'THU';
      case DateTime.friday: return 'FRI';
      case DateTime.saturday: return 'SAT';
      case DateTime.sunday: return 'SUN';
      default: return '';
    }
  }

  void updateSelectedTime(String? time) {
    selectedTime.value = time;
  }

  IconData getIconForSpecialty(String name) {
    if (name.contains("القلبية")) return Icons.favorite_rounded;
    if (name.contains("الأطفال")) return Icons.child_care_rounded;
    if (name.contains("العصبية")) return Icons.psychology_rounded;
    if (name.contains("العظمية")) return Icons.accessibility_new_rounded;
    if (name.contains("الأسنان")) return Icons.attribution_rounded; 
    if (name.contains("العينية")) return Icons.visibility_rounded;
    return Icons.medical_services_rounded;
  }

  Color getColorForSpecialty(String name) {
    if (name.contains("القلبية")) return AppColors.error.withOpacity(0.1);
    if (name.contains("الأطفال")) return AppColors.warning.withOpacity(0.1);
    if (name.contains("العصبية")) return Colors.purple.withOpacity(0.1);
    if (name.contains("العظمية")) return AppColors.info.withOpacity(0.1);
    if (name.contains("الأسنان")) return AppColors.primaryTeal.withOpacity(0.1);
    if (name.contains("العينية")) return AppColors.success.withOpacity(0.1);
    return Colors.blueGrey.withOpacity(0.1);
  }

  Color getIconColorForSpecialty(String name) {
    if (name.contains("القلبية")) return AppColors.error;
    if (name.contains("الأطفال")) return AppColors.warning;
    if (name.contains("العصبية")) return Colors.purple;
    if (name.contains("العظمية")) return AppColors.info;
    if (name.contains("الأسنان")) return AppColors.primaryTeal;
    if (name.contains("العينية")) return AppColors.success;
    return Colors.blueGrey;
  }

  // 🌟 تم إيقاف الموكس القديمة واستبدالها بالقوائم الديناميكية في الأعلى لربط الـ UI الحقيقي
  final List<Map<String, String>> mockDates = [];
  final List<String> mockTimes = [];
  final Map<String, String> workingHours = {};

  void bookAppointment() {}
}*/
