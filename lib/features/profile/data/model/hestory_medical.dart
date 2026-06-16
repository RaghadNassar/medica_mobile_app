import 'package:raghad_pro/core/api/end_point.dart';

class MedicalRecordModel {
  final String appointmentUuid;
  final String doctorUuid;
  final DateTime visitDate;
  final String diagnosis;
  final String? prescription;
  final String visitType;
  final String doctorName;
  final String specialization;
  final String clinic;

  MedicalRecordModel({
    required this.appointmentUuid,
    required this.doctorUuid,
    required this.visitDate,
    required this.diagnosis,
    this.prescription,
    required this.visitType,
    required this.doctorName,
    required this.specialization,
    required this.clinic,
  });

  factory MedicalRecordModel.fromJson(Map<String, dynamic> json) {
    return MedicalRecordModel( appointmentUuid: json[ApiKey.appointment_uuid],
      doctorUuid: json[ApiKey.doctor_uuid],
      visitDate: DateTime.parse(json[ApiKey.visit_date]),
      diagnosis: json[ApiKey.diagnosis],
      prescription: json[ApiKey.prescription],
      visitType: json[ApiKey.visit_type],
      doctorName: json[ApiKey.doctor_name],
      specialization: json[ApiKey.specialization],
      clinic: json[ApiKey.clinic],);
  }
}
