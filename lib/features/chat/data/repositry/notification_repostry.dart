import 'package:dartz/dartz.dart';
import 'package:raghad_pro/core/api/api_consumer.dart';
import 'package:raghad_pro/core/api/end_point.dart';
import 'package:raghad_pro/core/cache/cashe_helper_getStorage.dart';
import 'package:raghad_pro/core/errors/exceptions.dart';
import 'package:raghad_pro/features/chat/data/model/notification_model.dart';

class NotificationRepository {
  final ApiConsumer api;

  NotificationRepository(this.api);

  static const String _notificationsCacheKey = "my_notifications_list";
  static const String _countCacheKey = "notifications_count";

  /// 1. إرسال وتحديث توكن الـ FCM للسيرفر
  Future<Either<String, bool>> updateFcmToken({required String fcmToken, required String userId}) async {
    try {
      final response = await api.post(
        EndPoint.updateFcmToken, 
        data: {"fcm_token": fcmToken, "user_id": userId},
      );
      final Map<String, dynamic> raw = response is Map<String, dynamic> ? response : {};
      print('🔔 [NotificationRepository] updateFcmToken response: $raw');
      if (raw.isEmpty) return right(true);
      if (raw.containsKey(ApiKey.success) && raw[ApiKey.success] == true) return right(true);
      return right(false);
    } on ServerException catch (e) {
      return left(e.errorModel.message);
    } catch (e) {
      return left("حدث خطأ أثناء تحديث توكن الإشعارات");
    }
  }

  /// 2. جلب قائمة الإشعارات (مع الكاش والـ Either)
  Future<Either<String, List<AppNotification>>> fetchMyNotifications({bool forceRefresh = false}) async {
    if (!forceRefresh) {
      var cachedData = CacheHelperGetStorage.getData(key: _notificationsCacheKey);
      if (cachedData != null && cachedData is List) {
        List<AppNotification> cachedList = cachedData.map((json) => AppNotification.fromJson(json)).toList();
        return right(cachedList);
      }
    }

    try {
      final response = await api.get(EndPoint.myNotifications);
      final Map<String, dynamic> rawData = response is Map<String, dynamic> ? response : {};
      
      if (rawData['success'] == true) {
        List list = rawData['data'] ?? [];
        await CacheHelperGetStorage.saveData(key: _notificationsCacheKey, value: list);
        
        List<AppNotification> notifications = list.map((json) => AppNotification.fromJson(json)).toList();
        return right(notifications);
      }
      return const Right([]);
    } on ServerException catch (e) {
      var cachedData = CacheHelperGetStorage.getData(key: _notificationsCacheKey);
      if (cachedData != null && cachedData is List) {
        List<AppNotification> cachedList = cachedData.map((json) => AppNotification.fromJson(json)).toList();
        return right(cachedList);
      }
      return left(e.errorModel.message);
    } catch (e) {
      var cachedData = CacheHelperGetStorage.getData(key: _notificationsCacheKey);
      if (cachedData != null && cachedData is List) {
        List<AppNotification> cachedList = cachedData.map((json) => AppNotification.fromJson(json)).toList();
        return right(cachedList);
      }
      return left("حدث خطأ أثناء جلب الإشعارات");
    }
  }

  /// 3. جلب عدد الإشعارات غير المقروءة
  Future<Either<String, int>> fetchNotificationCount({bool forceRefresh = false}) async {
    if (!forceRefresh) {
      var cachedCount = CacheHelperGetStorage.getData(key: _countCacheKey);
      if (cachedCount != null) return right(cachedCount as int);
    }

    try {
      final response = await api.get(EndPoint.notificationCount);
      final Map<String, dynamic> rawData = response is Map<String, dynamic> ? response : {};

      if (rawData['success'] == true) {
        int count = rawData['count'] ?? 0;
        await CacheHelperGetStorage.saveData(key: _countCacheKey, value: count);
        return right(count);
      }
      return const Right(0);
    } on ServerException catch (e) {
      var cachedCount = CacheHelperGetStorage.getData(key: _countCacheKey);
      if (cachedCount != null) return right(cachedCount as int);
      return left(e.errorModel.message);
    } catch (e) {
      var cachedCount = CacheHelperGetStorage.getData(key: _countCacheKey);
      if (cachedCount != null) return right(cachedCount as int);
      return left("حدث خطأ أثناء جلب عداد الإشعارات");
    }
  }

  /// 4. تحديث حالة الإشعار إلى مقروء (✅ تم إصلاح استدعاء الدالة الديناميكية)
  Future<Either<String, bool>> markAsRead(String uuid) async {
    try {
      final response = await api.get(EndPoint.markAsReadUrl(uuid));
      return right(response != null);
    } on ServerException catch (e) {
      return left(e.errorModel.message);
    } catch (e) {
      return left("فشل تحديث حالة الإشعار");
    }
  }

  /// 5. حذف إشعار منفرد بالـ UUID (✅ تم إصلاح استدعاء الدالة الديناميكية)
  Future<Either<String, bool>> deleteNotification(String uuid) async {
    try {
      final response = await api.get(EndPoint.deleteNotificationUrl(uuid));
      return right(response != null);
    } on ServerException catch (e) {
      return left(e.errorModel.message);
    } catch (e) {
      return left("فشل حذف الإشعار");
    }
  }

  /// 6. حذف جميع الإشعارات بالكامل
  Future<Either<String, bool>> deleteAll() async {
    try {
      final response = await api.get(EndPoint.deleteAllNotifications);
      return right(response != null);
    } on ServerException catch (e) {
      return left(e.errorModel.message);
    } catch (e) {
      return left("فشل مسح الإشعارات");
    }
  }
}