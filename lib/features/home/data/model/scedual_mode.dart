import 'package:raghad_pro/core/api/end_point.dart';

class DoctorScheduleModel {
  final String doctorUuid;
  final String day;
  final String startTime;
  final String endTime;
  final String doctorName;
  final String specialization;
  final String clinic;
  final bool isModified;
  final String statusNote;

  DoctorScheduleModel({
    required this.doctorUuid,
    required this.day,
    required this.startTime,
    required this.endTime,
    required this.doctorName,
    required this.specialization,
    required this.clinic,
    required this.isModified,
    required this.statusNote,
  });

  factory DoctorScheduleModel.fromJson(Map<String, dynamic> json) {
    return DoctorScheduleModel(
      doctorUuid: json[ApiKey.doctor_uuid] ?? '',
      day: json[ApiKey.day] ?? '',
      startTime: json[ApiKey.start_time] ?? '',
      endTime: json[ApiKey.end_time] ?? '',
      doctorName: json[ApiKey.doctor_name] ?? '',
      specialization: json[ApiKey.specialization] ?? '',
      clinic: json[ApiKey.clinic] ?? '',
      isModified: json[ApiKey.is_modified] ?? false,
      statusNote: json[ApiKey.status_note] ?? '',
    );
  }
}

class DoctorScheduleResponse {
  final bool success;
  final List<DoctorScheduleModel> data;

  DoctorScheduleResponse({required this.success, required this.data});

  factory DoctorScheduleResponse.fromJson(Map<String, dynamic> json) {
    return DoctorScheduleResponse(
      success: json[ApiKey.success] ?? false,
      data: (json[ApiKey.data] as List?)
              ?.map((e) => DoctorScheduleModel.fromJson(e))
              .toList() ?? [],
    );
  }
}