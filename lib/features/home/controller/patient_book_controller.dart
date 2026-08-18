import 'dart:async';

import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:raghad_pro/core/api/end_point.dart';
import 'package:raghad_pro/core/cache/cashe_helper_getStorage.dart';
import 'package:raghad_pro/core/helper/alert_helper.dart';
import 'package:raghad_pro/features/home/data/model/get_booking.dart';
import 'package:raghad_pro/features/home/data/repositry/repostry_home.dart';
// هاد خاص بالحجوزات وعرضا 

class PatientAppointmentController extends GetxController {
  final RepostryHome repostryHome;
  PatientAppointmentController(this.repostryHome);

//firstor
StreamSubscription? _appointmentsFirebaseSubscription;

  var isAppointmentsLoading = false.obs;
  var allAppointments = <BookingModel>[].obs;
  final RxInt appointmentTabControllerIndex = 0.obs;
  var isCancelBookingLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    getPatientAppointments();
    //firstor
    
    _initAppointmentsListener();
    print(" [PatientAppointmentController] onInit تم التنفيذ");
  }

  void changeAppointmentTab(int index) {
    appointmentTabControllerIndex.value = index;
  }

  Future<void> getPatientAppointments() async {
    isAppointmentsLoading.value = true;
    final response = await repostryHome.getPatientAppointments();

    response.fold(
      (errorMessage) {
        isAppointmentsLoading.value = false;
        print("Get Appointments Error: $errorMessage");
      },
      (bokingResponse) {
        isAppointmentsLoading.value = false;
        allAppointments.assignAll(bokingResponse.data);
      },
    );
  }

  
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
  List<BookingModel> get cancelledAppointments {
  return allAppointments.where((app) => app.status == 'canceled')
      .toList();
      
}

  Future<void> cancelAppointment(String appointmentUuid) async {
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
       
        final String patientUuid =
      CacheHelperGetStorage.getString(key: ApiKey.uuid) ?? '';

  try {
    await FirebaseFirestore.instance.collection('appointments').add({
      'patient_uuid': patientUuid, 
      'user_uuid':    patientUuid,
      'status':       'cancelled',
      'appointment_uuid': appointmentUuid,
      'date_time':    DateTime.now().toString(),
    });
  } catch (e) {
    print('[Firebase Cancel Sync Error]: $e');
  }

  await syncAppointmentsSilently();
      },
    );
  }
 
  void _initAppointmentsListener() {
  final String? patientUuid = CacheHelperGetStorage.getString(key: ApiKey.uuid);
  
  print(" [Firebase] patient_uuid من التخزين: $patientUuid");
  
  if (patientUuid == null || patientUuid.isEmpty) {
    print(" [Firebase] لا يوجد patient_uuid!");
    return;
  }

  print(" [Firebase] بدء الاستماع للمريض: $patientUuid");

  _appointmentsFirebaseSubscription = FirebaseFirestore.instance
      .collection('appointments')
      .where('patient_uuid', isEqualTo: patientUuid)
      .snapshots()
      .listen(
        (snapshot) {
          print(" [Firebase] تم رصد تغيير! عدد المستندات: ${snapshot.docs.length}");
          syncAppointmentsSilently();
        },
        onError: (e) => print(' [Firebase Error]: $e'),
      );
}


  Future<void> syncAppointmentsSilently() async {
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

   @override
  void onClose() {
    _appointmentsFirebaseSubscription?.cancel();
    super.onClose();
  }
}



































































































/*
class PatientAppointmentController extends GetxController {
  final RepostryHome repostryHome;
  PatientAppointmentController(this.repostryHome);

  StreamSubscription? _appointmentsFirebaseSubscription;
  // 🚀 أضيفي هذا المتغير لحفظ اشتراك الفحص الدوري وإلغائه لاحقاً
  StreamSubscription? _pollingSubscription; 

  var isAppointmentsLoading = false.obs;
  var allAppointments = <BookingModel>[].obs;
  final RxInt appointmentTabControllerIndex = 0.obs;
  var isCancelBookingLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    getPatientAppointments();
    
    // 🟢 استدعاء دالة الفحص الدوري الصامت
    startSilentPolling();
    
    _initAppointmentsListener();
    print("✅ [PatientAppointmentController] onInit تم التنفيذ");
  }

  // 🔄 دالة الفحص الدوري الصامت كل 5 ثوانٍ
  void startSilentPolling() {
    _pollingSubscription = Stream.periodic(const Duration(seconds: 5)).listen((_) {
      print("🔄 [Polling] جاري التحقق من السيرفر بشكل صامت لحدث جديد...");
      syncAppointmentsSilently(); 
    });
  }

  void changeAppointmentTab(int index) {
    appointmentTabControllerIndex.value = index;
  }

  Future<void> getPatientAppointments() async {
    isAppointmentsLoading.value = true;
    final response = await repostryHome.getPatientAppointments();

    response.fold(
      (errorMessage) {
        isAppointmentsLoading.value = false;
        print("Get Appointments Error: $errorMessage");
      },
      (bokingResponse) {
        isAppointmentsLoading.value = false;
        allAppointments.assignAll(bokingResponse.data);
      },
    );
  }

  List<BookingModel> get bookedAppointments => allAppointments.where((app) => app.status == 'has booked').toList();
  List<BookingModel> get waitingAppointments => allAppointments.where((app) => app.status == 'is waiting').toList();
  List<BookingModel> get changedAppointments => allAppointments.where((app) => app.status == 'has changed').toList();
  List<BookingModel> get visitedAppointments => allAppointments.where((app) => app.status == 'has visited').toList();
  List<BookingModel> get cancelledAppointments => allAppointments.where((app) => app.status == 'canceled').toList();

  Future<void> cancelAppointment(String appointmentUuid) async {
    isCancelBookingLoading.value = true;
    final response = await repostryHome.deleteAppointment(appointmentUuid);

    response.fold(
      (errorMessage) {
        isCancelBookingLoading.value = false;
        AlertHelper.showSnackbar(title: "فشل الإلغاء", message: errorMessage, type: AlertType.error);
      },
      (successMessage) async {
        isCancelBookingLoading.value = false;
        final String patientUuid = CacheHelperGetStorage.getString(key: ApiKey.uuid) ?? '';

        try {
          await FirebaseFirestore.instance.collection('appointments').add({
            'patient_uuid': patientUuid, 
            'user_uuid':    patientUuid,
            'status':       'cancelled',
            'appointment_uuid': appointmentUuid,
            'date_time':    DateTime.now().toString(),
          });
        } catch (e) {
          print('[Firebase Cancel Sync Error]: $e');
        }

        await syncAppointmentsSilently();
      },
    );
  }

  void _initAppointmentsListener() {
    final String? patientUuid = CacheHelperGetStorage.getString(key: ApiKey.uuid);
    if (patientUuid == null || patientUuid.isEmpty) return;

    _appointmentsFirebaseSubscription = FirebaseFirestore.instance
        .collection('appointments')
        .where('patient_uuid', isEqualTo: patientUuid)
        .snapshots()
        .listen(
          (snapshot) {
            print("🔔 [Firebase] تم رصد تغيير! مزامنة البيانات...");
            syncAppointmentsSilently();
          },
          onError: (e) => print('❌ [Firebase Error]: $e'),
        );
  }

 Future<void> syncAppointmentsSilently() async {
    try {
      final response = await repostryHome.getPatientAppointments();
      response.fold(
        (error) => print("⚠️ [Background Sync] فشلت المزامنة الصامتة: $error"),
        (bokingResponse) {
          // 1. تحديث البيانات الأساسية
          allAppointments.assignAll(bokingResponse.data);
          
          // 🚀 2. السحر هنا: إجبار GetX على إنعاش وتحديث كافة الواجهات والـ Getters المرتبطة بالمصفوفة فوراً!
          allAppointments.refresh(); 
          
          print("🔄 [Polling] تم تحديث البيانات بنجاح وإجبار الواجهة على التحديث اللحظي!");
        },
      );
    } catch (e) {
      print("⚠️ [Background Sync Error]: $e");
    }
  }

  @override
  void onClose() {
    // 🗑️ تنظيف كافّة الاشتراكات لمنع تعليق الذاكرة (Memory Leak)
    _appointmentsFirebaseSubscription?.cancel();
    _pollingSubscription?.cancel(); 
    print("🗑️ [RealTime] تم تنظيف الـ Polling والـ Firebase بنجاح.");
    super.onClose();
  }
}*/