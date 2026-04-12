//api exception
import 'package:dio/dio.dart';
import 'package:raghad_pro/core/errors/error_model.dart';

class ServerException implements Exception{
   final ErrorModel errorModel;
   ServerException({required this.errorModel});
}


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
  }