
import 'package:raghad_pro/core/api/end_point.dart';

class DoctorSlotModel {
  final String time;
  final String fullDate;
  final bool isAvailable;
  final String statusText;

  DoctorSlotModel({
    required this.time,
    required this.fullDate,
    required this.isAvailable,
    required this.statusText,
  });

 factory DoctorSlotModel.fromJson(Map<String, dynamic> json) {
  return DoctorSlotModel(
    time: json[ApiKey.time] ?? '',
    fullDate: json[ApiKey.fullDate] ?? '',
    isAvailable: json[ApiKey.isAvailable] ?? false,
    statusText: json[ApiKey.statusText] ?? '',
  );
}
}

class DoctorSlotsResponse {
  final bool success;
  final String message;
  final List<DoctorSlotModel> data;

  DoctorSlotsResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory DoctorSlotsResponse.fromJson(Map<String, dynamic> json) {
    return DoctorSlotsResponse(
      success: json[ApiKey.success] ?? false,
      message: json[ApiKey.message] ?? '',
      data: (json[ApiKey.data] as List?)
              ?.map((e) => DoctorSlotModel.fromJson(e))
              .toList() ?? [],
    );
  }
}