import 'package:raghad_pro/core/api/end_point.dart';

class BookingResponse {
  final bool success;
  final String message;
  final List<BookingModel> data;

  BookingResponse({required this.success, required this.message, required this.data});

  factory BookingResponse.fromJson(Map<String, dynamic> json) {
    return BookingResponse(
      success: json[ApiKey.success] ?? false,
      message: json[ApiKey.message] ?? '',
      data: json[ApiKey.data] != null
          ? List<BookingModel>.from(json[ApiKey.data].map((x) => BookingModel.fromJson(x)))
          : [],
    );
  }
}

class BookingModel {
  final String appointmentUuid;
  final DateTime dateTime;
  final String type;
  final String status;
  final BookingDoctorModel doctor;

  BookingModel({
    required this.appointmentUuid,
    required this.dateTime,
    required this.type,
    required this.status,
    required this.doctor,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      appointmentUuid: json[ApiKey.appointment_uuid] ?? '',
      dateTime: json[ApiKey.date_time] != null 
          ? DateTime.parse(json[ApiKey.date_time]) 
          : DateTime.now(),
      type: json[ApiKey.type] ?? '',
      status: json[ApiKey.status] ?? '',
      doctor: BookingDoctorModel.fromJson(json[ApiKey.doctor] ?? {}),
    );
  }
}

class BookingDoctorModel {
  final String uuid;
  final String name;
  final String specialization;
  final String image;

  BookingDoctorModel({
    required this.uuid,
    required this.name,
    required this.specialization,
    required this.image,
  });

  factory BookingDoctorModel.fromJson(Map<String, dynamic> json) {
    return BookingDoctorModel(
      uuid: json[ApiKey.uuid] ?? '',
      name: json[ApiKey.name] ?? '',
      specialization: json[ApiKey.specialization] ?? '',
      image: json[ApiKey.image] ?? '',
    );
  }
}