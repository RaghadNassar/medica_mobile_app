import 'package:raghad_pro/core/api/end_point.dart';

class SpecializationResponse {
  final bool success;
  final SpecializationStats stats;
  final List<SpecializationModel> data;

  SpecializationResponse({
    required this.success,
    required this.stats,
    required this.data,
  });

  factory SpecializationResponse.fromJson(Map<String, dynamic> json) {
    return SpecializationResponse(
      success: json[ApiKey.success] ?? false,
      stats: SpecializationStats.fromJson(json[ApiKey.stats] ?? {}),
      data: (json[ApiKey.data] as List?)
              ?.map((item) => SpecializationModel.fromJson(item))
              .toList() ?? [],
    );
  }
}

class SpecializationStats {
  final int totalCount;
  final double maxPrice;
  final double minPrice;
  final double avgPrice;
  final String mostRequested;
  final String leastRequested;

  SpecializationStats({
    required this.totalCount,
    required this.maxPrice,
    required this.minPrice,
    required this.avgPrice,
    required this.mostRequested,
    required this.leastRequested,
  });

  factory SpecializationStats.fromJson(Map<String, dynamic> json) {
    return SpecializationStats(
      totalCount: json[ApiKey.total_specializations_count] ?? 0,
      maxPrice: (json[ApiKey.max_check_up_price] as num?)?.toDouble() ?? 0.0,
      minPrice: (json[ApiKey.min_check_up_price] as num?)?.toDouble() ?? 0.0,
      avgPrice: (json[ApiKey.average_check_up_price] as num?)?.toDouble() ?? 0.0,
      mostRequested: json[ApiKey.most_requested_specialization] ?? '',
      leastRequested: json[ApiKey.least_requested_specialization] ?? '',
    );
  }
}

class SpecializationModel {
  final String uuid;
  final String name;
  final double checkUpPrice;
  final int appointmentsCount;

  SpecializationModel({
    required this.uuid,
    required this.name,
    required this.checkUpPrice,
    required this.appointmentsCount,
  });

  factory SpecializationModel.fromJson(Map<String, dynamic> json) {
    return SpecializationModel(
      uuid: json[ApiKey.uuid] ?? '',
      name: json[ApiKey.name] ?? '',
      checkUpPrice: (json[ApiKey.check_up_price] as num?)?.toDouble() ?? 0.0,
      appointmentsCount: json[ApiKey.appointments_count] ?? 0,
    );
  }
}