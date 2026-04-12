import 'package:dio/dio.dart';
import 'package:raghad_pro/core/api/end_point.dart';
import 'package:raghad_pro/core/cache/cach_helper.dart';

class ApiInterceptor extends Interceptor {
  // send in  header
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers['Content-Type'] = 'application/json';
    final token = CacheHelper().getData(key: ApiKey.accessToken);
    if(token!=null){
      options.headers['Authorization'] = 'Bearer $token';
    }
   
    // options.headers['Accept-Language'] = 'ar';
    super.onRequest(options, handler);
  }
}
