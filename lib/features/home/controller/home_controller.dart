import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:raghad_pro/core/api/api_consumer.dart';
import 'package:raghad_pro/core/constanse/app_assets.dart';
import 'package:raghad_pro/core/theme/app_colors.dart';
import 'package:raghad_pro/features/home/controller/doctor_book_logic.dart';
import 'package:raghad_pro/features/home/controller/main_controller.dart';
import 'package:raghad_pro/features/home/controller/patient_book_controller.dart';
import 'package:raghad_pro/features/home/controller/search_controller.dart';
import 'package:raghad_pro/features/home/data/model/banar_image_static.dart';
import 'package:raghad_pro/features/home/data/model/spizialize_model.dart';
import 'package:raghad_pro/features/home/data/model/top_doctor_model.dart';
import 'package:raghad_pro/features/home/data/repositry/repostry_home.dart';

import 'package:raghad_pro/features/profile/controller/profile_controller.dart';
import 'package:raghad_pro/features/profile/data/repostry/user_repostry.dart';


class MainNavigationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RepostryHome>(() => RepostryHome(Get.find<ApiConsumer>()));
    Get.lazyPut<HomeNavigationController>(() => HomeNavigationController());
    Get.lazyPut<HomeDashboardController>(() => HomeDashboardController(Get.find<RepostryHome>()));
    Get.lazyPut<PatientAppointmentController>(() => PatientAppointmentController(Get.find<RepostryHome>()),fenix: true);
    Get.lazyPut<DoctorBookingController>(
    () => DoctorBookingController(Get.find<RepostryHome>()),
    fenix: true,
  );
    
    Get.lazyPut<ProfileRepostry>(() => ProfileRepostry(Get.find<ApiConsumer>()));
    Get.lazyPut<ProfileController>(() => ProfileController(Get.find<ProfileRepostry>()),fenix: true);
    Get.lazyPut<PatientSearchController>(() => PatientSearchController(Get.find<RepostryHome>()),fenix: true);
  }
}


class HomeDashboardController extends GetxController {
  final RepostryHome repostryHome;
  HomeDashboardController(this.repostryHome);

  final PageController bannerPageController = PageController();
  final RxInt currentBannerPage = 0.obs;
  Timer? _bannerTimer;

    
  var isTopDoctorsLoading = true.obs;
  var topDoctors = <TopDoctorModel>[].obs;
  var isSpecLoading = true.obs;
  var specializations = <SpecializationModel>[].obs;
  SpecializationStats? stats;

  final List<BannerImageData> medicalBanners = [
    BannerImageData(image: Appassets.pannar5),
    BannerImageData(image: Appassets.pannar6),
    BannerImageData(image: Appassets.pannar2),
    BannerImageData(image: Appassets.pannar3),
    BannerImageData(image: Appassets.pannar4),
  ];

  @override
  void onInit() {
    super.onInit();
    getSpecializations();
    _startBannerAutoSlider();
    getTopDoctors();
  }

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

  getSpecializations() async {
    isSpecLoading.value = true;
    final response = await repostryHome.getSpecializations();

    response.fold(
      (errorMessage) {
        isSpecLoading.value = false;
        print("Specializations Error: $errorMessage");
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
/*
  Color getIconColorForSpecialty(String name) {
    if (name.contains("القلبية")) return AppColors.error;
    if (name.contains("الأطفال")) return AppColors.warning;
    if (name.contains("العصبية")) return Colors.purple;
    if (name.contains("العظمية")) return AppColors.info;
    if (name.contains("الأسنان")) return AppColors.primaryTeal;
    if (name.contains("العينية")) return AppColors.success;
    return Colors.blueGrey;
  }
*/
Color getIconColorForSpecialty(String name) {
  return AppColors.primaryTeal; // يرجع لون التركواز لكل الأقسام تلقائياً
}
  @override
  void onClose() {
    _bannerTimer?.cancel();
    bannerPageController.dispose();
    super.onClose();
  }
}





















































































































/*
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
}*/
// class MainNavigationBinding extends Bindings {
//   @override
//   void dependencies() {
//     // الأجزاء المشتركة والـ API
//     Get.lazyPut<RepostryHome>(() => RepostryHome(Get.find<ApiConsumer>()));
    
//     // حقن المتحكمات الثلاثة الجديدة المفصولة لحماية الذاكرة
//     Get.lazyPut<HomeNavigationController>(() => HomeNavigationController());
//     Get.lazyPut<HomeDashboardController>(() => HomeDashboardController(Get.find<RepostryHome>()));
//     Get.lazyPut<PatientAppointmentController>(() => PatientAppointmentController(Get.find<RepostryHome>()));
    
//     // كود البروفايل والبحث بدون أي تغيير
//     Get.lazyPut<ProfileRepostry>(() => ProfileRepostry(Get.find<ApiConsumer>()));
//     Get.lazyPut<ProfileController>(() => ProfileController(Get.find<ProfileRepostry>()));
//     Get.lazyPut<PatientSearchController>(() => PatientSearchController(Get.find<RepostryHome>()));
//   }
// }
/*
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

  List<BannerImageData> medicalBanners = [
  BannerImageData(
    image: Appassets.pannar5,
  ),
  BannerImageData(
    image: Appassets.pannar6,
  ),
  BannerImageData(
    image: Appassets.pannar2,
  ),
  BannerImageData(
    image: Appassets.pannar3,
  ),
  BannerImageData(
    image: Appassets.pannar4,
  ),
];
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
void initDoctorDetailsForReschedule({
  required TopDoctorModel doctor,
  required String appointmentUuid,
  required DateTime oldAppointmentDateTime,
}) {
  
  isRescheduling.value = true;
  appointmentUuidToModify.value = appointmentUuid;
  
  
  currentDoctor.value = doctor;
  selectedTime.value = null;

  
  getDoctorSchedules(doctor.uuid);
  generateAvailableDates();

  
  String oldDateStr = oldAppointmentDateTime.toString().split(' ')[0]; // YYYY-MM-DD
  
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
// void initDoctorDetailsForReschedule({required TopDoctorModel doctor, required String appointmentUuid}) {
//   isRescheduling.value = true;
//   appointmentUuidToModify.value = appointmentUuid;
//   initDoctorDetails(doctor);
// }
  void changeAppointmentTab(int index) {
    appointmentTabControllerIndex.value = index;
  }

  void initDoctorDetails(TopDoctorModel doctor) {
    if (appointmentUuidToModify.isEmpty) {
    isRescheduling.value = false;
  }
  // هي لتعديل الموعد تذكري
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
        
    print(" [RealTime] تم رصد حركة حجز/تعديل عند هذا الطبيب! جاري تحديث الـ Slots المتاحة فوراً...");
    
   
    getDoctorSlotsDynamic(doctorUuid, dateStr);
    
  }, onError: (e) => print(" [Firebase RealTime Error]: $e"));
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

  
  void updateSelectedTime(String? time) {
    selectedTime.value = time;
  }

  
  void bookAppointment() {
    if (selectedTime.value != null) {}
  }

  // حجز لشخص اخر
 // الكي الخاص بالتحقق من حقول المريض الجديد
final someoneFormKey = GlobalKey<FormState>();

// متغير لمعرفة هل الحجز للحساب الشخصي أم لشخص آخر (تلقائياً false)
var bookForSomeoneElse = false.obs;

// الـ Controllers الخاصة بحقول إدخال المريض الجديد
final someoneNameController = TextEditingController();
final someoneNickNameController = TextEditingController();
final someonePhoneController = TextEditingController();
final someoneBirthdayController = TextEditingController(); // تم تحويله لـ Controller لتوافقه مع الـ CustomTextFiled

// متغير حالة الجنس (تلقائياً Male أو يمكنكِ استخدام StringManager.male)
var someoneGender = StringManager.male.obs;

// دالة لاختيار تاريخ ميلاد المريض الجديد
// دالة اختيار تاريخ ميلاد المريض الجديد
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

  // دالة الحجز لشخص آخر المصلحة والمعدلة بالكامل بدون أخطاء قواعدية
  Future<void> bookForSomeoneFinal() async {
    // 1. تصحيح فحص الـ Null: نقارن بـ null مباشرة لأن المتغير عبارة عن RxnString
    if (selectedTime.value == null) {
      AlertHelper.showSnackbar(
        title: "تنبيه", 
        message: "الرجاء اختيار وقت الحجز أولاً", 
        type: AlertType.warning
      );
      return;
    }

    // 2. تصحيح واستخراج الـ selectedSlot الفعلي لتجنب اعتراض الـ Variable غير المعرف
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
      dateTime: selectedSlot.fullDate,       // الآن تعمل بكفاءة وبدون أخطاء
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
        await syncAppointmentsSilently();

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
}


*/

