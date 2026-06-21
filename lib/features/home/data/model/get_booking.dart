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
      appointmentUuid: json[ApiKey.appointment_uuid] ?? json['appointment_uuid'] ?? '',
      dateTime: json[ApiKey.date_time] != null 
          ? DateTime.parse(json[ApiKey.date_time]) 
          : (json['date_time'] != null ? DateTime.parse(json['date_time']) : DateTime.now()),
      type: json[ApiKey.type] ?? json['type'] ?? '',
      status: json[ApiKey.status] ?? json['status'] ?? '',
      doctor: BookingDoctorModel.fromJson(json[ApiKey.doctor] ?? json['doctor'] ?? {}),
    );
  }
  
}

class BookingDoctorModel {
  final String uuid;
  final String name;
  final String specialization;
  final String? image; 
  final String clinic;
  final String visitTime;
  final int patientsCount;
  final double rating;
  final int reviewersCount;

  BookingDoctorModel({
    required this.uuid,
    required this.name,
    required this.specialization,
    this.image,
    required this.clinic,
    required this.visitTime,
    required this.patientsCount,
    required this.rating,
    required this.reviewersCount,
  });

  factory BookingDoctorModel.fromJson(Map<String, dynamic> json) {
    return BookingDoctorModel(
      uuid: json[ApiKey.uuid] ?? json['uuid'] ?? '',
      name: json[ApiKey.name] ?? json['name'] ?? '',
      specialization: json[ApiKey.specialization] ?? json['specialization'] ?? '',
      image: json[ApiKey.image] ?? json['image'], 
      clinic: json['clinic'] ?? '',
      visitTime: json['visit_time'] ?? '00:20:00',
      patientsCount: json['patients_count'] ?? 0,
      
      rating: (json['rating'] ?? 0.0).toDouble(), 
      reviewersCount: json['reviewers_count'] ?? 0,
    );
  }
}