// import 'package:raghad_pro/core/api/end_point.dart';

// class DoctorBySpecialtyResponse {
//   final bool success;
//   final List<DoctorBySpecialtyModel> data;

//   DoctorBySpecialtyResponse({required this.success, required this.data});

//   factory DoctorBySpecialtyResponse.fromJson(Map<String, dynamic> json) {
//     return DoctorBySpecialtyResponse(
//       success: json[ApiKey.success] ?? false,
//       data: (json[ApiKey.data] as List? ?? [])
//           .map((e) => DoctorBySpecialtyModel.fromJson(e))
//           .toList(),
//     );
//   }
// }

// class DoctorBySpecialtyModel {
//   final String uuid;
//   final String name;
//   final String specialization;
//   final String clinic;
//   final String? image;
//   final String visitTime;
//   final int patientsCount;   
//   final double rating;         
//   final int reviewersCount;  

//   DoctorBySpecialtyModel({
//     required this.uuid,
//     required this.name,
//     required this.specialization,
//     required this.clinic,
//     this.image,
//     required this.visitTime,
//     required this.patientsCount,
//     required this.rating,
//     required this.reviewersCount,
//   });

//   factory DoctorBySpecialtyModel.fromJson(Map<String, dynamic> json) {
//     return DoctorBySpecialtyModel(
//       uuid: json[ApiKey.uuid] ?? '',
//       name: json[ApiKey.name] ?? '',
//       specialization: json[ApiKey.specialization] ?? '',
//       clinic: json[ApiKey.clinic] ?? '',
//       image: json[ApiKey.image], 
     
//       visitTime: json[ApiKey.visit_time] ?? '00:00:00',
//       patientsCount: json[ApiKey.patients_count] ?? 0,
//       rating: (json[ApiKey.rating] ?? 0.0).toDouble(), 
//       reviewersCount: json[ApiKey.reviewers_count] ?? 0,
//     );
//   }
// }
// داخل ملف doctor_spicializ_model.dart
import 'package:raghad_pro/core/api/end_point.dart';
import 'package:raghad_pro/features/home/data/model/top_doctor_model.dart';

class DoctorBySpecialtyResponse {
  final bool success;
  final List<TopDoctorModel> data;

  DoctorBySpecialtyResponse({required this.success, required this.data});

  factory DoctorBySpecialtyResponse.fromJson(Map<String, dynamic> json) {
    return DoctorBySpecialtyResponse(
      success: json[ApiKey.success] ?? false,
      data: json[ApiKey.data] != null
          ? List<TopDoctorModel>.from(json[ApiKey.data].map((x) => TopDoctorModel.fromJson(x)))
          : [],
    );
  }
}