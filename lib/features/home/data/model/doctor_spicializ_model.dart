
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