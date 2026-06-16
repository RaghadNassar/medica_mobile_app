import 'package:raghad_pro/core/api/end_point.dart';

class AppointmentResponse {
  final String message;
  final AppointmentModel? appointment;

  AppointmentResponse({required this.message, this.appointment});

  factory AppointmentResponse.fromJson(Map<String, dynamic> json) {
    return AppointmentResponse(
      message: json[ApiKey.message] ?? '',
      appointment: json[ApiKey.appointment] != null 
          ? AppointmentModel.fromJson(json[ApiKey.appointment]) 
          : null,
    );
  }
}

class AppointmentModel {
  final String uuid;
  final String name;
  final String gender;
  final int age;
  final String? image;
  final String status;
  final String dateTime;

  AppointmentModel({
    required this.uuid,
    required this.name,
    required this.gender,
    required this.age,
    this.image,
    required this.status,
    required this.dateTime,
  });

  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    return AppointmentModel(
      uuid: json[ApiKey.uuid] ?? '',
      name: json[ApiKey.name] ?? '',
      gender: json[ApiKey.gender] ?? 'male',
      age: json[ApiKey.age] ?? 0,
      image: json[ApiKey.image],
      status: json[ApiKey.status] ?? '',
      dateTime: json[ApiKey.date_time] ?? '',
    );
  }
}