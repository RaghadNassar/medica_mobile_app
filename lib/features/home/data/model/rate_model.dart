import 'package:raghad_pro/core/api/end_point.dart';

class RatingResponse {
  final bool success;
  final String message;
  final RatingData? data;

  RatingResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory RatingResponse.fromJson(Map<String, dynamic> json) {
    return RatingResponse(
      success: json[ApiKey.success] ?? false,
      message: json[ApiKey.message] ?? '',
      data: json[ApiKey.data] != null ? RatingData.fromJson(json[ApiKey.data]) : null,
    );
  }
}

class RatingData {
  final int patientId;
  final int doctorId;
  final int stars;
  final String? comment;
  final String ratingDate;

  RatingData({
    required this.patientId,
    required this.doctorId,
    required this.stars,
    this.comment,
    required this.ratingDate,
  });

  factory RatingData.fromJson(Map<String, dynamic> json) {
    return RatingData(
      patientId: json[ApiKey.patient_id] ?? 0,
      doctorId: json[ApiKey.doctor_id] ?? 0,
      stars: json[ApiKey.stars] ?? 0,
      comment: json[ApiKey.comment],
      ratingDate: json[ApiKey.rating_date] ?? '',
    );
  }
}