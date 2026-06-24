import 'package:dio/dio.dart';

class AppErrorHandler {
  static String getErrorMessage(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout: return "خطأ في الاتصال بالسيرفر";
        case DioExceptionType.badResponse: 
           return error.response?.data['message'] ?? "خطأ في السيرفر";
        default: return "تأكد من اتصالك بالإنترنت";
      }
    }
    return "حدث خطأ غير متوقع"; 
  }
}