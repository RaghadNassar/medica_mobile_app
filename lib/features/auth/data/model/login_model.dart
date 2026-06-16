
import 'package:raghad_pro/core/api/end_point.dart';

class LoginModel {
  final UserModel user;
  final String token;

  LoginModel({
    required this.user,
    required this.token,
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    return LoginModel(
      user: UserModel.fromJson(json[ApiKey.user] ?? {}),
      token: json[ApiKey.token] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      ApiKey.user: user.toJson(),
      ApiKey.token: token,
    };
  }
}
// user model
class UserModel {
  final String uuid;
  final String name;
  final String email;
  final String role;
  final Map<String, dynamic>? info; // تم تعريفه كـ Map لأن السيرفر يرجعه ككائن فارغ حالياً {}

  UserModel({
    required this.uuid,
    required this.name,
    required this.email,
    required this.role,
    this.info,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uuid: json[ApiKey.uuid] ?? '',
      name: json[ApiKey.name] ?? '',
      email: json[ApiKey.email] ?? '',
      role: json[ApiKey.role] ?? '',
      info: json[ApiKey.info] is Map ? json[ApiKey.info] : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      ApiKey.uuid: uuid,
      ApiKey.name: name,
      ApiKey.email: email,
      ApiKey.role: role,
      ApiKey.info: info,
    };
  }
}