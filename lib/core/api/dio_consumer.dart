import 'package:dio/dio.dart';
import 'package:raghad_pro/core/api/api_consumer.dart';
import 'package:raghad_pro/core/api/api_interceptor.dart';
import 'package:raghad_pro/core/api/end_point.dart';
import 'package:raghad_pro/core/errors/exceptions.dart';

class DioConsumer extends ApiConsumer {
  final Dio dio;

  DioConsumer({required this.dio}) {
    dio.options.baseUrl = EndPoint.baseUrl;
    dio.interceptors.add(ApiInterceptor());
    dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
    ));
  }
  @override

  Future delet(String path,
      {dynamic? data, Map<String, dynamic>? queryParamiters,bool isFormData=false}) async {
    try {
      final Response =
          await dio.delete(path,  data:isFormData?FormData.fromMap(data): data, queryParameters: queryParamiters);
      return Response.data;
    } on DioException catch (e) {
      handelDioException(e);
    }
  }

  @override
  Future get(String path,
      {Object? data, Map<String, dynamic>? queryParamiters}) async {
    try {
      final Response =
          await dio.get(path, data: data, queryParameters: queryParamiters);
      return Response.data;
    } on DioException catch (e) {
      handelDioException(e);
      // TODO
    }
  }

  @override
  Future patch(String path,
      {dynamic? data, Map<String, dynamic>? queryParamiters,bool isFormData=false}) async {
    try {
      final Response =
          await dio.patch(path, data:isFormData?FormData.fromMap(data): data, queryParameters: queryParamiters);
      return Response.data;
    } on DioException catch (e) {
      handelDioException(e);
      // TODO
    }
  }

  @override
  Future post(String path,
      {dynamic? data, Map<String, dynamic>? queryParamiters, bool isFormData = false}) async {
    try {
      final Response =
          await dio.post(path, data:isFormData? FormData.fromMap(data): data, queryParameters: queryParamiters);
      return Response.data;
    } on DioException catch (e) {
      handelDioException(e);
      // TODO
    }
  }
}
