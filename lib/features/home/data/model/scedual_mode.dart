import 'package:raghad_pro/core/api/end_point.dart';
/*
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
}*/
/*
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
class ModificationDetailsModel {
  final String? startDate;
  final String? endDate;
  final bool? isPermanent;

  ModificationDetailsModel({this.startDate, this.endDate, this.isPermanent});

  factory ModificationDetailsModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) return ModificationDetailsModel();
    return ModificationDetailsModel(
      startDate: json['start_date'],
      endDate: json['end_date'],
      isPermanent: json['is_permanent'],
    );
  }
}

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
  final ModificationDetailsModel? modificationDetails; // الحقل الجديد

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
    this.modificationDetails,
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
      modificationDetails: json['modification_details'] != null 
          ? ModificationDetailsModel.fromJson(json['modification_details'])
          : null,
    );
  }
}*/
class DoctorScheduleModel {
  final String uuid;
  final bool isModified;
  final String statusNote;
  final ScheduleDetailsModel originalSchedule;
  final ScheduleDetailsModel? modifiedSchedule;

  DoctorScheduleModel({
    required this.uuid,
    required this.isModified,
    required this.statusNote,
    required this.originalSchedule,
    this.modifiedSchedule,
  });

  // =========================================================
  // Getters للوصول للمسميات القديمة مباشرة دون كسر الكود السابق
  // =========================================================
  
  // يجلب الدوام المعتمد حالياً (المعدل إن وجد، وإلا الأصلي)
  ScheduleDetailsModel get activeSchedule =>
      (isModified && modifiedSchedule != null) ? modifiedSchedule! : originalSchedule;

  String get doctorUuid => activeSchedule.doctorUuid;
  String get doctorName => activeSchedule.doctorName;
  String get specialization => activeSchedule.specialization;
  String get clinic => activeSchedule.clinic;
  String get day => activeSchedule.day;
  String get startTime => activeSchedule.startTime;
  String get endTime => activeSchedule.endTime;

  factory DoctorScheduleModel.fromJson(Map<String, dynamic> json) {
    return DoctorScheduleModel(
      uuid: json['uuid'] ?? '',
      isModified: json['is_modified'] ?? false,
      statusNote: json['status_note'] ?? '',
      originalSchedule: ScheduleDetailsModel.fromJson(json['original_schedule'] ?? {}),
      modifiedSchedule: json['modified_schedule'] != null
          ? ScheduleDetailsModel.fromJson(json['modified_schedule'])
          : null,
    );
  }
}

class ScheduleDetailsModel {
  final String day;
  final String startTime;
  final String endTime;
  final String clinic;
  final String doctorUuid;
  final String doctorName;
  final String specialization;
  final String? swapType;
  final String? startDate;
  final String? endDate;
  final bool? isPermanent;

  ScheduleDetailsModel({
    required this.day,
    required this.startTime,
    required this.endTime,
    required this.clinic,
    required this.doctorUuid,
    required this.doctorName,
    required this.specialization,
    this.swapType,
    this.startDate,
    this.endDate,
    this.isPermanent,
  });

  factory ScheduleDetailsModel.fromJson(Map<String, dynamic> json) {
    return ScheduleDetailsModel(
      day: json['day'] ?? '',
      startTime: json['start_time'] ?? '',
      endTime: json['end_time'] ?? '',
      clinic: json['clinic'] ?? '',
      doctorUuid: json['doctor_uuid'] ?? '',
      doctorName: json['doctor_name'] ?? '',
      specialization: json['specialization'] ?? '',
      swapType: json['swap_type'],
      startDate: json['start_date'],
      endDate: json['end_date'],
      isPermanent: json['is_permanent'],
    );
  }
}