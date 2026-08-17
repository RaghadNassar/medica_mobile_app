//api exception
import 'package:dio/dio.dart';
import 'package:raghad_pro/core/errors/error_model.dart';

class ServerException implements Exception {
  final ErrorModel errorModel;
  ServerException({required this.errorModel});

  @override
  String toString() => errorModel.message;
}

void handleDioException(DioException e) {
  switch (e.type) {
    case DioExceptionType.connectionTimeout:
      throw ServerException(
          errorModel: ErrorModel.fromLocalError("انتهت مهلة الاتصال بالسيرفر"));
    case DioExceptionType.sendTimeout:
      throw ServerException(
          errorModel: ErrorModel.fromLocalError("انتهت مهلة إرسال البيانات"));
    case DioExceptionType.receiveTimeout:
      throw ServerException(
          errorModel: ErrorModel.fromLocalError("انتهت مهلة استقبال البيانات من السيرفر"));
    case DioExceptionType.cancel:
      throw ServerException(
          errorModel: ErrorModel.fromLocalError("تم إلغاء الطلب"));
    case DioExceptionType.connectionError:
      throw ServerException(
          errorModel: ErrorModel.fromLocalError("لا يوجد اتصال بالإنترنت، يرجى التحقق من الشبكة"));
    case DioExceptionType.badCertificate:
      throw ServerException(
          errorModel: ErrorModel.fromLocalError("شهادة الأمان الخاصة بالسيرفر غير صالحة"));
    case DioExceptionType.unknown:
      throw ServerException(
          errorModel: ErrorModel.fromLocalError("حدث خطأ غير معروف في الاتصال"));

    case DioExceptionType.badResponse:
      if (e.response != null && e.response!.data != null) {
        if (e.response!.data is Map<String, dynamic>) {
          throw ServerException(
              errorModel: ErrorModel.fromJson(e.response!.data as Map<String, dynamic>));
        } else {
          // التعامل مع ردود HTML أو النصوص العادية
          throw ServerException(
            errorModel: ErrorModel.fromLocalError(
                "خطأ في السيرفر (${e.response!.statusCode})"),
          );
        }
      } else {
        throw ServerException(
            errorModel: ErrorModel.fromLocalError("استجابة فارغة من السيرفر"));
      }
  }
}










/*
class ServerException implements Exception {
  final ErrorModel errorModel;
  ServerException({required this.errorModel});
}

void handelDioException(DioException e) {
  switch (e.type) {
    case DioExceptionType.connectionTimeout:
      throw ServerException(
          errorModel: ErrorModel.fromLocalError("انتهت مهلة الاتصال بالسيرفر"));
    case DioExceptionType.sendTimeout:
      throw ServerException(
          errorModel: ErrorModel.fromLocalError("انتهت مهلة إرسال البيانات"));
    case DioExceptionType.receiveTimeout:
      throw ServerException(
          errorModel: ErrorModel.fromLocalError(
              "انتهت مهلة استقبال البيانات من السيرفر"));
    case DioExceptionType.cancel:
      throw ServerException(
          errorModel: ErrorModel.fromLocalError("تم إلغاء الطلب"));
    case DioExceptionType.connectionError:
      throw ServerException(
          errorModel: ErrorModel.fromLocalError(
              "لا يوجد اتصال بالإنترنت، يرجى التحقق من الشبكة"));
    case DioExceptionType.badCertificate:
      throw ServerException(
          errorModel: ErrorModel.fromLocalError(
              "شهادة الأمان الخاصة بالسيرفر غير صالحة"));
    case DioExceptionType.unknown:
      throw ServerException(
          errorModel:
              ErrorModel.fromLocalError("حدث خطأ غير معروف في الاتصال"));

    case DioExceptionType.badResponse:
      if (e.response != null && e.response!.data != null) {
        if (e.response!.data is Map<String, dynamic>) {
          throw ServerException(
              errorModel: ErrorModel.fromJson(e.response!.data));
        } else {
          throw ServerException(
            errorModel: ErrorModel.fromLocalError(
                "خطأ في السيرفر: كود ${e.response!.statusCode}"),
          );
        }
      } else {
        throw ServerException(
            errorModel: ErrorModel.fromLocalError("استجابة فارغة من السيرفر"));
      }
  }
}*/


































/*

  void handelDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        // TODO: Handle this case.
        throw ServerException(errorModel: ErrorModel.fromJson(e.response!.data));
      case DioExceptionType.sendTimeout:
       throw ServerException(errorModel: ErrorModel.fromJson(e.response!.data));
      // TODO: Handle this case.
      case DioExceptionType.receiveTimeout:
       throw ServerException(errorModel: ErrorModel.fromJson(e.response!.data));
      // TODO: Handle this case.
      case DioExceptionType.badCertificate:
       throw ServerException(errorModel: ErrorModel.fromJson(e.response!.data));
      // TODO: Handle this case
      case DioExceptionType.cancel:
       throw ServerException(errorModel: ErrorModel.fromJson(e.response!.data));
      // TODO: Handle this case.
      case DioExceptionType.connectionError:
       throw ServerException(errorModel: ErrorModel.fromJson(e.response!.data));
      // TODO: Handle this case.
      case DioExceptionType.unknown:
       throw ServerException(errorModel: ErrorModel.fromJson(e.response!.data));
      // TODO: Handle this case.
      case DioExceptionType.badResponse:
       switch(e.response!.statusCode){
          case 400:
          throw ServerException(errorModel: ErrorModel.fromJson(e.response!.data));
          case 401:
          throw ServerException(errorModel: ErrorModel.fromJson(e.response!.data));
          case 403:
          throw ServerException(errorModel: ErrorModel.fromJson(e.response!.data));
          case 404:
          throw ServerException(errorModel: ErrorModel.fromJson(e.response!.data));
          case 409:
          throw ServerException(errorModel: ErrorModel.fromJson(e.response!.data));
          case 422:
          throw ServerException(errorModel: ErrorModel.fromJson(e.response!.data));
          case 504:
          throw ServerException(errorModel: ErrorModel.fromJson(e.response!.data));
          
       }
      // TODO: Handle this case.
    }
  }*/