import 'package:raghad_pro/core/api/end_point.dart';
class AppointmentResponse {
  final String message;
  final bool? success; 
  final AppointmentModel? appointment;
  final PatientDataModel? patientData;

  AppointmentResponse({
    required this.message, 
    this.success,
    this.appointment, 
    this.patientData,
  });

  factory AppointmentResponse.fromJson(Map<String, dynamic> json) {
    return AppointmentResponse(
      message: json[ApiKey.message] ?? json['message'] ?? '',
      success: json['success'],
      appointment: json[ApiKey.appointment] != null 
          ? AppointmentModel.fromJson(json[ApiKey.appointment]) 
          : null,
      patientData: json['patient_data'] != null
          ? PatientDataModel.fromJson(json['patient_data'])
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

class PatientDataModel {
  final String uuid;
  final String name;
  final String? nickName;
  final String? image;
  final String gender;
  final String phone;
  final String? email;
  final String role;
  final String? birthday;

  PatientDataModel({
    required this.uuid,
    required this.name,
    this.nickName,
    this.image,
    required this.gender,
    required this.phone,
    this.email,
    required this.role,
    this.birthday,
  });

  factory PatientDataModel.fromJson(Map<String, dynamic> json) {
    return PatientDataModel(
      uuid: json['uuid'] ?? '',
      name: json['name'] ?? '',
      nickName: json['nick_name'],
      image: json['image'],
      gender: json['gender'] ?? 'male',
      phone: json['phone'] ?? '',
      email: json['email'],
      role: json['role'] ?? 'patient',
      birthday: json['birthday'],
    );
  }
}


























































/*
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
*/