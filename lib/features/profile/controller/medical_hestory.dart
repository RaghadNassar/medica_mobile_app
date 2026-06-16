import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:raghad_pro/core/api/api_consumer.dart';
import 'package:raghad_pro/core/helper/alert_helper.dart';
import 'package:raghad_pro/features/profile/data/model/hestory_medical.dart';
import 'package:raghad_pro/features/profile/data/repostry/user_repostry.dart';

class MedicalHistoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileRepostry>(() => ProfileRepostry(Get.find<ApiConsumer>()));
    Get.lazyPut<MedicalHistoryController>(() => MedicalHistoryController(Get.find<ProfileRepostry>()));
  }
}

class MedicalHistoryController extends GetxController {
  final ProfileRepostry repostry;
  MedicalHistoryController(this.repostry);

  var isMedicalLoading = false.obs;
  var medicalRecords = <MedicalRecordModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    getMedicalRecords();
  }

  Future<void> getMedicalRecords() async {
    isMedicalLoading.value = true;
    final response = await repostry.getMedicalHistory();

    response.fold(
      (errorMessage) {
        isMedicalLoading.value = false;
        AlertHelper.showSnackbar(
          title: "خطأ في السجلات",
          message: errorMessage,
          type: AlertType.error,
        );
      },
      (records) {
        isMedicalLoading.value = false;
        medicalRecords.assignAll(records);
      },
    );
  }

  String formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }
}