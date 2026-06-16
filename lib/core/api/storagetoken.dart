
import 'package:get_storage/get_storage.dart';

class StorageService {
  final _box = GetStorage();
  
  static const String _tokenKey = 'token';
  static const String _uuidKey = 'user_uuid'; 
  static const String _unreadNotificationsKey = 'unread_notification_ids'; // 👈 المفتاح الجديد لإشعاراتك المحلية

  // حفظ التوكن
  void saveToken(String token) => _box.write(_tokenKey, token);
  String? get token => _box.read(_tokenKey);

  // 🚀 حفظ وجلب الـ UUID الجديد
  void saveUuid(String uuid) => _box.write(_uuidKey, uuid);
  String? get uuid => _box.read(_uuidKey);

  // 📥 [إضافة جديدة] حفظ وجلب الـ IDs غير المقروءة لإدارة الخدمة محلياً
  void saveUnreadNotificationIds(List<String> ids) => _box.write(_unreadNotificationsKey, ids);
  
  List<String> get unreadNotificationIds {
    final storedList = _box.read(_unreadNotificationsKey);
    if (storedList is List) {
      return List<String>.from(storedList);
    }
    return [];
  }

  // حذف البيانات عند تسجيل الخروج
  void clearToken() {
    _box.remove(_tokenKey);
    _box.remove(_uuidKey); 
    _box.remove(_unreadNotificationsKey); // 👈 مسح كاش الإشعارات عند الخروج
  }

  bool get hasToken => _box.hasData(_tokenKey);
  void clearAll() => _box.erase();
}