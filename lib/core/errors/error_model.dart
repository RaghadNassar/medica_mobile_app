
import 'package:raghad_pro/core/api/end_point.dart';

class ErrorModel {
   String? message;
   ErrorModel({this.message});
   factory ErrorModel.fromJson(Map<String, dynamic> json) {
     return ErrorModel(message: json[ApiKey.message]);
   }
}