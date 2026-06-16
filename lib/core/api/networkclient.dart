
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:raghad_pro/core/api/apiEndpoints.dart';
import 'package:raghad_pro/core/api/storagetoken.dart';

class NetworkClient {
  // 1. Singleton Pattern: ضمان نسخة واحدة فقط من Dio
  static final NetworkClient _instance = NetworkClient._internal();
  factory NetworkClient() => _instance;
  
  late final Dio dio;
  final StorageService _storage = StorageService(); // نستخدم الخزنة الخاصة بنا

  NetworkClient._internal() {
    // 2. إعدادات الـ Dio الأساسية
    dio = Dio(
      BaseOptions(
        baseUrl: ApiEndpoints.baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ),
    );

    // 3. Interceptors (نقطة التفتيش)
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // إضافة التوكن تلقائياً لكل طلب إذا كان موجوداً
          String? token = _storage.token;
          if (token != null) {
            options.headers["Authorization"] = "Bearer $token";
          }
          return handler.next(options);
        },
        onError: (DioException e, handler) {
          // هنا يمكنك معالجة أخطاء 401 (انتهاء صلاحية التوكن)
          if (e.response?.statusCode == 401) {
            _storage.clearAll(); // حذف التوكن المنتهي
            // يمكنك هنا عمل Get.offAll(() => LoginView()); للانتقال لصفحة الدخول
          }
          return handler.next(e);
        },
      ),
    );

    // 4. LogInterceptor: للـ Debugging فقط
    if (kDebugMode) {
      dio.interceptors.add(
        LogInterceptor(
          requestBody: true,
          responseBody: true,
          logPrint: (o) => debugPrint(o.toString()),
        ),
      );
    }
  }
}