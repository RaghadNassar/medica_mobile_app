import 'package:raghad_pro/core/api/end_point.dart';

class ProfileModel {
  final bool success;
  final ProfileData data;

  ProfileModel({required this.success, required this.data});

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      success: json[ApiKey.success] ?? false,
      data: ProfileData.fromJson(json[ApiKey.data] ?? {}),
    );
  }
}

class ProfileData {
  final PatientInfo personalInfo;
  final List<dynamic> medicalHistory; 

  ProfileData({required this.personalInfo, required this.medicalHistory});

  factory ProfileData.fromJson(Map<String, dynamic> json) {
    return ProfileData(
      personalInfo: PatientInfo.fromJson(json[ApiKey.personal_info] ?? {}),
      medicalHistory: json[ApiKey.medical_history] ?? [],
    );
  }
}

class PatientInfo {
  final int id;
  final String uuid;
  final String name;
  // final String nickname;
  final String email;
  final String number;
  final String gender;
  final String birthday;
  final String? image;
  final int active;
  final String? fcmToken;
  final String createdAt;

  PatientInfo({
    required this.id,
    required this.uuid,
    required this.name,
   // required this.nickname,

    required this.email,
    required this.number,
    required this.gender,
    required this.birthday,
    this.image,
    required this.active,
    this.fcmToken,
    required this.createdAt,
  });

  factory PatientInfo.fromJson(Map<String, dynamic> json) {
    return PatientInfo(
      id: json[ApiKey.id] ?? 0,
      uuid: json[ApiKey.uuid] ?? '',
      name: json[ApiKey.name] ?? '',
    //  nickname: json[ApiKey.nickName] ?? '',
      email: json[ApiKey.email] ?? '',
      number: json[ApiKey.number] ?? '',
      gender: json[ApiKey.gender] ?? '',
      birthday: json[ApiKey.birthday] ?? '',
      image: json[ApiKey.image],
      active: json[ApiKey.active] ?? 0,
      fcmToken: json[ApiKey.fcm_token],
      createdAt: json[ApiKey.created_at] ?? '',
    );
  }
}