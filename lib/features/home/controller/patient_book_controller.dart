import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:raghad_pro/core/helper/alert_helper.dart';
import 'package:raghad_pro/features/home/data/model/get_booking.dart';
import 'package:raghad_pro/features/home/data/repositry/repostry_home.dart';

class PatientAppointmentController extends GetxController {
  final RepostryHome repostryHome;
  PatientAppointmentController(this.repostryHome);

  var isAppointmentsLoading = false.obs;
  var allAppointments = <BookingModel>[].obs;
  final RxInt appointmentTabControllerIndex = 0.obs;
  var isCancelBookingLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    getPatientAppointments();
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

  // دوال الفلترة الأربعة بدون أي تعديل أو نسيان
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
        allAppointments.removeWhere((app) => app.appointmentUuid == appointmentUuid);
        allAppointments.refresh();
        
        try {
          await FirebaseFirestore.instance.collection('appointments').add({
            'user_uuid': '', // يتم معالجتها ديناميكياً بحسب الطبيب
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
}