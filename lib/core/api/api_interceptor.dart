import 'package:dio/dio.dart';
import 'package:raghad_pro/core/api/end_point.dart';
import 'package:raghad_pro/core/cache/cashe_helper_getStorage.dart';

class ApiInterceptor extends Interceptor {
  // send in  header
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers['Content-Type'] = 'application/json';
    final token = CacheHelperGetStorage.getData(key: ApiKey.token);
    if(token!=null){
      options.headers['Authorization'] = 'Bearer $token';
    }
   
    // options.headers['Accept-Language'] = 'ar';
    super.onRequest(options, handler);
  // return handler.next(options);
  }
}
