import 'package:raghad_pro/core/api/end_point.dart';

class TopDoctorResponse {
  final bool success;
  final String message;
  final List<TopDoctorModel> data;

  TopDoctorResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory TopDoctorResponse.fromJson(Map<String, dynamic> json) {
    return TopDoctorResponse(
      success: json[ApiKey.success] ?? false,
      message: json[ApiKey.message] ?? '',
      data: json[ApiKey.data] != null
          ? List<TopDoctorModel>.from(
              json[ApiKey.data].map((x) => TopDoctorModel.fromJson(x)))
          : [],
    );
  }
}

class TopDoctorModel {
  final String uuid;
  final String name;
  final String specialization;
  final String clinic;
  final String? image;
  final String visitTime;
  final int patientsCount;
  final double averageRating;
  final int reviewersCount;

  TopDoctorModel({
    required this.uuid,
    required this.name,
    required this.specialization,
    required this.clinic,
    this.image,
    required this.visitTime,
    required this.patientsCount,
    required this.averageRating,
    required this.reviewersCount,
  });

  factory TopDoctorModel.fromJson(Map<String, dynamic> json) {
    return TopDoctorModel(
      uuid: json[ApiKey.uuid] ?? '',
      name: json[ApiKey.name] ?? '',
      specialization: json[ApiKey.specialization] ?? '',
      clinic: json[ApiKey.clinic] ?? '',
      image: json[ApiKey.image] ?? '',
      visitTime: json[ApiKey.visit_time] ?? '',
      patientsCount: json[ApiKey.patients_count] ?? 0,
      averageRating: (json[ApiKey.rating] as num?)?.toDouble() ?? 0.0, 
      reviewersCount: json[ApiKey.reviewers_count] ?? 0,
    );
  }
}


















/*
class TopDoctorModel {
  final String uuid;
  final String name;
  final String specialization;
  final String clinic;
  final String? image;
  final String visitTime;
  final int patientsCount;
  final double averageRating;
  final int reviewersCount;

  TopDoctorModel({
    required this.uuid,
    required this.name,
    required this.specialization,
    required this.clinic,
    this.image,
    required this.visitTime,
    required this.patientsCount,
    required this.averageRating,
    required this.reviewersCount,
  });

  factory TopDoctorModel.fromJson(Map<String, dynamic> json) {
    return TopDoctorModel(
      // التعديل السحري هنا: الباك إند بالبحث يرسل 'doctor_uuid'، وفي الصفحة الرئيسية يرسل ApiKey.uuid العادي
      uuid: json[ApiKey.doctor_uuid] ?? json[ApiKey.uuid] ?? '', 
      name: json[ApiKey.name] ?? '',
      // الباك إند قد يرسل الاختصاص كـ String (في البحث) أو كـ Map (في كود آخر)، هنا نضمن قراءته كـ String بكل الأحوال
      specialization: json[ApiKey.specialization] is Map 
          ? (json[ApiKey.specialization][ApiKey.name] ?? '')
          : (json[ApiKey.specialization] ?? ''),
      clinic: json[ApiKey.clinic] ?? '',
      image: json[ApiKey.image] ?? '',
      visitTime: json[ApiKey.visit_time] ?? '',
      patientsCount: json[ApiKey.patients_count] ?? 0,
      averageRating: (json[ApiKey.rating] as num?)?.toDouble() ?? 0.0, 
      reviewersCount: json[ApiKey.reviewers_count] ?? 0,
    );
  }
}*/