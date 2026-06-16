// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:get/get.dart';

// // تحويل الكلاس إلى GetxService ليدخل ضمن دورة حياة GetX النظيفة
// class NotificationService extends GetxService {
//   final FirebaseMessaging _messaging = FirebaseMessaging.instance;
//   final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();

//   static const String _channelId = 'medica_center_notifications';
//   static const String _channelName = 'Medica Care Tones';

//   // 1. دالة الإقلاع والتهيئة لـ GetX (تستبدل الـ Singleton التقليدي)
//   Future<NotificationService> init() async {
//     await _requestPermissions();
//     await _initLocalNotifications();
//     await _setupForegroundPresentation();
//     _setupNotificationListeners();
//     await _getAndActionToken();
//     return this;
//   }

//   // طلب الصلاحيات بأسلوب نظيف
//   Future<void> _requestPermissions() async {
//     await _messaging.requestPermission(
//       alert: true,
//       badge: true,
//       sound: true,
//     );
//   }

//   // تهيئة الإشعارات المحلية لتظهر والتطبيق مفتوح (Foreground Heads-up)
//   Future<void> _initLocalNotifications() async {
//     const AndroidInitializationSettings initializationSettingsAndroid =
//         AndroidInitializationSettings('@mipmap/ic_launcher');
    
//     const InitializationSettings initializationSettings =
//         InitializationSettings(android: initializationSettingsAndroid);

//     await _localNotifications.initialize(
//       initializationSettings,
//       onDidReceiveNotificationResponse: _onNotificationTapped,
//     );

//     // إنشاء قناة الأندرويد المخصصة للصوت والظهور العالي
//     const AndroidNotificationChannel channel = AndroidNotificationChannel(
//       _channelId,
//       _channelName,
//       importance: Importance.max,
//       playSound: true,
//       enableVibration: true,
//     );

//     await _localNotifications
//         .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
//         ?.createNotificationChannel(channel);
//   }

//   // ضبط إعدادات الفايربيز للمقدمة
//   Future<void> _setupForegroundPresentation() async {
//     await _messaging.setForegroundNotificationPresentationOptions(
//       alert: true,
//       badge: true,
//       sound: true,
//     );
//   }

//   // جلب التوكن لإرساله إلى Laravel مستقبلاً
//   Future<void> _getAndActionToken() async {
//     String? token = await _messaging.getToken();
//     print("🔥 [Medica FCM Token]: $token");
//     if (token != null) {
//       await _sendTokenToLaravel(token);
//     }
//   }

//   // دالة إرسال التوكن للباك إيند (طبقة البيانات - API Call)
//   Future<void> _sendTokenToLaravel(String token) async {
//     try {
//       // هنا سيتم الربط مع سيرفر زميلك (Laravel) لاحقاً
//       // var response = await http.post(...);
//     } catch (e) {
//       print("❌ Laravel Connection Error: $e");
//     }
//   }

//   // رادارات الاستماع للإشعارات
//   void _setupNotificationListeners() {
//     // الحالة الأولى: التطبيق مفتوح
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       RemoteNotification? notification = message.notification;
      
//       if (notification != null) {
//         // أولاً: إظهار الإشعار المنسدل عبر حزمة النظام المحترفة
//         _showLocalNotification(notification);

//         // ثانياً: استخدام ألوان الـ Theme الخاص بكِ تلقائياً داخل Get.snackbar كإشعار إضافي أو بديل جذاب
//         Get.snackbar(
//           notification.title ?? '',
//           notification.body ?? '',
//           snackPosition: SnackPosition.TOP,
//           backgroundColor: Get.theme.cardColor.withOpacity(0.95), // استخدام لون الكارد من الثيم الخاص بكِ
//           colorText: Get.theme.textTheme.bodyLarge?.color, // استخدام لون النص من الثيم الخاص بكِ
//           icon: Icon(Icons.notifications_active, color: Get.theme.primaryColor, size: 28), // لون الأيقونة يتبع اللون الأساسي للتطبيق
//           margin: const EdgeInsets.all(12),
//           duration: const Duration(seconds: 4),
//         );
//       }
//     });

//     // الحالة الثانية: الضغط على الإشعار والتطبيق مغلق
//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//       _handleNotificationRouting(message.data);
//     });
//   }

//   void _showLocalNotification(RemoteNotification notification) {
//     _localNotifications.show(
//       notification.hashCode,
//       notification.title,
//       notification.body,
//       const NotificationDetails(
//         android: AndroidNotificationDetails(
//           _channelId,
//           _channelName,
//           importance: Importance.max,
//           priority: Priority.high,
//           icon: '@mipmap/ic_launcher',
//         ),
//       ),
//     );
//   }

//   void _onNotificationTapped(NotificationResponse details) {
//     print("📌 تم الضغط على الإشعار المحلي: ${details.payload}");
//   }

//   void _handleNotificationRouting(Map<String, dynamic> data) {
//     // التوجيه بأسلوب MVC + GetX النظيف بناءً على البيانات القادمة من لارافل
//     // Get.toNamed(Routes.NOTIFICATIONS);
//   }
// }