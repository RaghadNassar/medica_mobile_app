import 'package:raghad_pro/core/api/end_point.dart';


class SearchResponseModel {
  final bool success;
  final String message;
  final List<SearchDoctorItem> doctors;
  final List<SearchSpecializationItem> specializations;

  SearchResponseModel({
    required this.success,
    required this.message,
    required this.doctors,
    required this.specializations,
  });

  factory SearchResponseModel.fromJson(Map<String, dynamic> json, String searchType) {
    List<SearchDoctorItem> docsList = [];
    List<SearchSpecializationItem> specsList = [];
    
    final rawData = json[ApiKey.data];

    if (rawData != null) {
      if (searchType == 'all') {
        if (rawData['doctors'] != null) {
          docsList = (rawData['doctors'] as List).map((e) => SearchDoctorItem.fromJson(e)).toList();
        }
        if (rawData['specializations'] != null) {
          specsList = (rawData['specializations'] as List).map((e) => SearchSpecializationItem.fromJson(e)).toList();
        }
      } else if (searchType == 'doctors') {
        docsList = (rawData as List).map((e) => SearchDoctorItem.fromJson(e)).toList();
      } else if (searchType == 'specializations') {
        specsList = (rawData as List).map((e) => SearchSpecializationItem.fromJson(e)).toList();
      }
    }

    return SearchResponseModel(
      success: json[ApiKey.success] ?? false,
      message: json[ApiKey.message] ?? '',
      doctors: docsList,
      specializations: specsList,
    );
  }
}

// كائن طبيب مصغر خاص بالبحث فقط
class SearchDoctorItem {
  final String uuid;
  final String name;
  final String specialization;
  final String clinic;
  final String? image; // 📸 الحقل الحاسم الذي سقط سهواً (nullable لأنها قد تأتي null من السيرفر)
  final String visitTime; // ⏱️ ممررة كـ String لقراءة الـ "00:20:00" الحقيقية
  final int patientsCount;
  final double averageRating;
  final int reviewersCount;

  SearchDoctorItem({
    required this.uuid, 
    required this.name, 
    required this.specialization,
    required this.clinic,
    this.image, // 📸
    required this.visitTime, // ⏱️
    required this.patientsCount,
    required this.averageRating,
    required this.reviewersCount,
  });

  factory SearchDoctorItem.fromJson(Map<String, dynamic> json) {
    return SearchDoctorItem(
      uuid: json['uuid'] ?? '',
      name: json['name'] ?? '',
      specialization: json['specialization'] ?? '',
      clinic: json['clinic'] ?? '',
      image: json['image'], // 📸 قراءة الرابط القادم من السيرفر مباشرة
      visitTime: json['visit_time'] ?? '00:30:00', // ⏱️ قراءة الوقت الحقيقي، مع قيمة افتراضية احتياطاً
      patientsCount: json['patients_count'] ?? 0,
      averageRating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      reviewersCount: json['reviewers_count'] ?? 0,
    );
  }
}

// كائن اختصاص مصغر خاص بالبحث فقط
class SearchSpecializationItem {
  final String uuid;
  final String name;

  SearchSpecializationItem({required this.uuid, required this.name});

  factory SearchSpecializationItem.fromJson(Map<String, dynamic> json) {
    return SearchSpecializationItem(
      uuid: json['uuid'] ?? json['id']?.toString() ?? '',
      name: json['name'] ?? '',
    );
  }
}
/*
class SearchResponseModel {
  final bool success;
  final String message;
  final List<TopDoctorModel> doctors;
  final List<SpecializationModel> specializations;

  SearchResponseModel({
    required this.success,
    required this.message,
    required this.doctors,
    required this.specializations,
  });

  factory SearchResponseModel.fromJson(Map<String, dynamic> json, String searchType) {
    List<TopDoctorModel> docsList = [];
    List<SpecializationModel> specsList = [];
    
    final rawData = json[ApiKey.data];

    if (rawData != null) {
      if (searchType == 'all') {
        
        if (rawData[ApiKey.doctors] != null) {
          docsList = (rawData[ApiKey.doctors] as List)
              .map((e) => TopDoctorModel.fromJson(e))
              .toList();
        }
        if (rawData[ApiKey.specializations] != null) {
          specsList = (rawData[ApiKey.specializations] as List)
              .map((e) => SpecializationModel.fromJson(e))
              .toList();
        }
      } else if (searchType == ApiKey.doctors) {
       
        docsList = (rawData as List)
            .map((e) => TopDoctorModel.fromJson(e))
            .toList();
      } else if (searchType == ApiKey.specializations) {
      
        specsList = (rawData as List)
            .map((e) => SpecializationModel.fromJson(e))
            .toList();
      }
    }

    return SearchResponseModel(
      success: json[ApiKey.success] ?? false,
      message: json[ApiKey.message] ?? '',
      doctors: docsList,
      specializations: specsList,
    );
  }
}*/