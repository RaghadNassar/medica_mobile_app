import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:raghad_pro/core/api/api_consumer.dart';
import 'package:raghad_pro/core/api/end_point.dart';
import 'package:raghad_pro/core/cache/cashe_helper_getStorage.dart';
import 'package:raghad_pro/core/helper/alert_helper.dart';
import 'package:raghad_pro/core/constanse/app_route.dart';
import 'package:raghad_pro/features/chat/data/model/notification_model.dart';
import 'package:raghad_pro/features/chat/data/repositry/notification_repostry.dart';

class NotificationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NotificationRepository>(
        () => NotificationRepository(Get.find<ApiConsumer>()));
    Get.lazyPut<NotificationLogic>(
        () => NotificationLogic(Get.find<NotificationRepository>()));
  }
}

class NotificationLogic extends GetxService {
  final NotificationRepository repository;
  NotificationLogic(this.repository);

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  static const String channelId = 'med_connect_channel';

  final RxList<AppNotification> serverNotifications = <AppNotification>[].obs;
  final RxList<Map<String, String>> activeNotifications =
      <Map<String, String>>[].obs;

  final RxInt unreadCount = 0.obs;
  final RxBool isLoading = false.obs;

  final AndroidNotificationChannel _channel = const AndroidNotificationChannel(
    channelId,
    'Doctor Notifications',
    description: 'إشعارات المواعيد الطبية الهامة',
    importance: Importance.max,
    playSound: true,
  );
  Future<NotificationLogic> init() async {
    await _messaging.requestPermission(alert: true, badge: true, sound: true);

    await _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    const AndroidInitializationSettings androidInit =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initSettings =
        InitializationSettings(android: androidInit);

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse details) {
        _navigateToScreen();
      },
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_channel);

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _navigateToScreen();
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      if (notification != null) {
        unreadCount.value++;

        final newNotif = AppNotification(
          uuid: message.data['uuid']?.toString() ??
              DateTime.now().millisecondsSinceEpoch.toString(),
          title: notification.title ?? 'إشعار جديد',
          body: notification.body ?? '',
          type: message.data['type']?.toString() ?? 'GeneralNotification',
          extraData: message.data['extra_data']?.toString(),
          isRead: false,
          createdAt:
              '${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')}',
        );

        serverNotifications.insert(0, newNotif);

        activeNotifications.insert(0, {
          'title': notification.title ?? 'إشعار جديد',
          'body': notification.body ?? '',
          'time':
              '${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')}',
        });

        _localNotifications.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              _channel.id,
              _channel.name,
              channelDescription: _channel.description,
              importance: Importance.max,
              priority: Priority.high,
            ),
          ),
        );
      }
    });
    String? token = await _messaging.getToken();
    if (token != null) {
      await sendTokenToServer(token);
    }

    await loadNotificationsFromServer();

    return this;
  }

  Future<void> checkInitialMessage() async {
    RemoteMessage? initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      _navigateToScreen();
    }
  }

  void _navigateToScreen() {
    Get.offAllNamed(AppRoutes.home);
    // Get.toNamed(AppRoutes.home);
  }

  Future<void> sendTokenToServer(String token) async {
    // 💡 تنبيه رغد: تأكدي من مطابقة اسم حقل الكاش 'user_uuid' لما هو مستخدم في صفحة الـ Login عندكِ
    // String? currentUuid = CacheHelperGetStorage.getData(key: 'user_uuid');
    String? currentUuid = CacheHelperGetStorage.getData(key: ApiKey.uuid);
    if (currentUuid != null) {
      final response =
          await repository.updateFcmToken(fcmToken: token, userId: currentUuid);

      response.fold(
        (errorMessage) {
          print("⚠️ [NotificationLogic] فشل مزامنة التوكن: $errorMessage");
        },
        (isSuccess) {
          if (isSuccess)
            print("✅ [NotificationLogic] تم ربط الـ Token بنجاح بالسيرفر");
        },
      );
    } else {
      print(
          "❌ [NotificationLogic] لم يتم العثور على UUID مخزن في الكاش، لم يتم إرسال التوكن.");
    }
  }

  void clearLocalNotificationsList() {
    activeNotifications.clear();
    serverNotifications.clear();
  }

  // Future<void> loadNotificationsFromServer() async {
  //   isLoading.value = true;

  //   final notificationsResponse =
  //       await repository.fetchMyNotifications(forceRefresh: true);
  //   notificationsResponse.fold(
  //     (errorMessage) {
  //       isLoading.value = false;
  //       AlertHelper.showSnackbar(
  //         title: "خطأ في جلب البيانات",
  //         message: errorMessage,
  //         type: AlertType.error,
  //       );
  //     },
  //     (notificationsList) {
  //       serverNotifications.assignAll(notificationsList);
  //     },
  //   );

  //   final countResponse =
  //       await repository.fetchNotificationCount(forceRefresh: true);
  //   countResponse.fold(
  //     (errorMessage) {
  //       isLoading.value = false;
  //       print("⚠️ فشل تحديث العداد من السيرفر: $errorMessage");
  //     },
  //     (count) {
  //       unreadCount.value = count;
  //     },
  //   );

  //   isLoading.value = false;
  // }

  Future<void> loadNotificationsFromServer() async {
    if (serverNotifications.isEmpty) {
      isLoading.value = true;

      final cachedResponse =
          await repository.fetchMyNotifications(forceRefresh: false);
      cachedResponse.fold(
        (_) => null,
        (cachedList) {
          if (cachedList.isNotEmpty) {
            serverNotifications.assignAll(cachedList);
            isLoading.value = false;
          }
        },
      );
    }

    final notificationsResponse =
        await repository.fetchMyNotifications(forceRefresh: true);

    notificationsResponse.fold(
      (errorMessage) {
        isLoading.value = false;

        if (serverNotifications.isEmpty) {
          AlertHelper.showSnackbar(
            title: "خطأ في جلب البيانات",
            message: errorMessage,
            type: AlertType.error,
          );
        }
      },
      (notificationsList) {
        serverNotifications.assignAll(notificationsList);
      },
    );

    // 3. تحديث عداد الإشعارات غير المقروءة
    final countResponse =
        await repository.fetchNotificationCount(forceRefresh: true);
    countResponse.fold(
      (errorMessage) => print("⚠️ فشل تحديث العداد من السيرفر: $errorMessage"),
      (count) {
        unreadCount.value = count;
      },
    );

    isLoading.value = false;
  }

  Future<void> markNotificationAsRead(String uuid) async {
    final response = await repository.markAsRead(uuid);

    response.fold(
      (errorMessage) {
        AlertHelper.showSnackbar(
          title: "تنبيه",
          message: errorMessage,
          type: AlertType.error,
        );
      },
      (isSuccess) {
        if (isSuccess) {
          int index = serverNotifications.indexWhere((n) => n.uuid == uuid);
          if (index != -1 && !serverNotifications[index].isRead) {
            serverNotifications[index].isRead = true;
            serverNotifications.refresh();
            if (unreadCount.value > 0) {
              unreadCount.value--;
            }
          }
        }
      },
    );
  }

  /// حذف إشعار منفرد بالـ UUID وعرض Snackbar النجاح
  Future<void> removeSingleNotification(String uuid) async {
    final response = await repository.deleteNotification(uuid);

    response.fold(
      (errorMessage) {
        AlertHelper.showSnackbar(
          title: "فشل الحذف",
          message: errorMessage,
          type: AlertType.error,
        );
      },
      (isSuccess) {
        if (isSuccess) {
          int index = serverNotifications.indexWhere((n) => n.uuid == uuid);
          if (index != -1) {
            if (!serverNotifications[index].isRead && unreadCount.value > 0) {
              unreadCount.value--;
            }
            serverNotifications.removeAt(index);

            AlertHelper.showSnackbar(
              title: "نجاح",
              message: "تم حذف الإشعار بنجاح",
              type: AlertType.success,
            );
          }
        }
      },
    );
  }

  /// مسح صندوق الإشعارات بالكامل من قاعدة البيانات والسيرفر
  Future<void> clearAllNotificationsFromServer() async {
    final response = await repository.deleteAll();

    response.fold(
      (errorMessage) {
        AlertHelper.showSnackbar(
          title: "فشل مسح البيانات",
          message: errorMessage,
          type: AlertType.error,
        );
      },
      (isSuccess) {
        if (isSuccess) {
          serverNotifications.clear();
          activeNotifications.clear();
          unreadCount.value = 0;

          AlertHelper.showSnackbar(
            title: "نجاح",
            message: "تم مسح صندوق التنبيهات بالكامل",
            type: AlertType.success,
          );
        }
      },
    );
  }
}
