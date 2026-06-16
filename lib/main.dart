import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:raghad_pro/app.dart';
import 'package:raghad_pro/core/cache/cashe_helper_getStorage.dart';
import 'package:raghad_pro/features/chat/controller/notification_controller.dart';
import 'package:dio/dio.dart';
import 'package:raghad_pro/core/api/api_consumer.dart';
import 'package:raghad_pro/core/api/dio_consumer.dart';
import 'package:raghad_pro/features/chat/data/repositry/notification_repostry.dart';
import 'package:raghad_pro/firebase_options.dart';


@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Firebase.apps before init: ${Firebase.apps.map((a) => a.name).toList()}');
  try {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  } on FirebaseException catch (e) {
    if (e.code != 'duplicate-app') rethrow;
  }
  print("🔥 إشعار في الخلفية: ${message.messageId}");
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CacheHelperGetStorage.init();


  try {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    } else {
      Firebase.app(); 
    }
  } on FirebaseException catch (e) {
    if (e.code != 'duplicate-app') rethrow;
  }

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

 
  if (!Get.isRegistered<Dio>()) {
    Get.put<Dio>(Dio(), permanent: true);
  }
  if (!Get.isRegistered<ApiConsumer>()) {
    Get.put<ApiConsumer>(DioConsumer(dio: Get.find<Dio>()), permanent: true);
  }

  
  if (!Get.isRegistered<NotificationRepository>()) {
    Get.put<NotificationRepository>(
      NotificationRepository(Get.find<ApiConsumer>()), 
      permanent: true,
    );
  }

  
  if (!Get.isRegistered<NotificationLogic>()) {
    await Get.putAsync<NotificationLogic>(
      () => NotificationLogic(Get.find<NotificationRepository>()).init(),
      permanent: true,
    );
  }

  // 4. تهيئة بقية الخدمات الأخرى للتطبيق
 // await Get.putAsync(() => RealTimeService().init());

  runApp(const MyApp());
}
/*
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Firebase.apps before init: ${Firebase.apps.map((a) => a.name).toList()}');
  try {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
} on FirebaseException catch (e) {
  if (e.code != 'duplicate-app') rethrow;
}
  //await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  print("🔥 إشعار في الخلفية: ${message.messageId}");
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CacheHelperGetStorage.init();

  // 💡 الفحص الذكي: لو الفايربيس مهيأ مسبقاً لا تقم بتهيئته مجدداً وتفادى الانهيار
  try {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    } else {
      Firebase.app(); // استخدام النسخة الموجودة في الذاكرة
    }
  } on FirebaseException catch (e) {
    if (e.code != 'duplicate-app') rethrow;
  }

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // سجّل الاعتمادات الأساسية إذا لم تكن مسجّلة (لتفادي تضارب مع InitialBinding)
  if (!Get.isRegistered<Dio>()) {
    Get.put<Dio>(Dio(), permanent: true);
  }
  if (!Get.isRegistered<ApiConsumer>()) {
    Get.put<ApiConsumer>(DioConsumer(dio: Get.find<Dio>()), permanent: true);
  }

  // جهّز NotificationRepository و NotificationLogic ثم نفّذ تهيئة الإشعارات
  final notificationRepo = NotificationRepository(Get.find<ApiConsumer>());
  final notificationLogic = NotificationLogic(notificationRepo);
  await notificationLogic.initNotificationSettings();
  
  // سجّلهما في DI لتكون متاحة طوال عمر التطبيق
  if (!Get.isRegistered<NotificationRepository>()) {
    Get.put<NotificationRepository>(notificationRepo, permanent: true);
  }
  if (!Get.isRegistered<NotificationLogic>()) {
    Get.put<NotificationLogic>(notificationLogic, permanent: true);
  }

  await Get.putAsync(() => RealTimeService().init());
  runApp(const MyApp());
}*/







/*
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CacheHelperGetStorage.init();
 // await CacheHelperGetStorage.init();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // سجّل الاعتمادات الأساسية إذا لم تكن مسجّلة (لتفادي تضارب مع InitialBinding)
    if (!Get.isRegistered<Dio>()) {
      Get.put<Dio>(Dio(), permanent: true);
    }
    if (!Get.isRegistered<ApiConsumer>()) {
      Get.put<ApiConsumer>(DioConsumer(dio: Get.find<Dio>()), permanent: true);
    }

    // جهّز NotificationRepository و NotificationLogic ثم نفّذ تهيئة الإشعارات
    final notificationRepo = NotificationRepository(Get.find<ApiConsumer>());
    final notificationLogic = NotificationLogic(notificationRepo);
    await notificationLogic.initNotificationSettings();
    // سجّلهما في DI لتكون متاحة طوال عمر التطبيق
    if (!Get.isRegistered<NotificationRepository>()) {
      Get.put<NotificationRepository>(notificationRepo, permanent: true);
    }
    if (!Get.isRegistered<NotificationLogic>()) {
      Get.put<NotificationLogic>(notificationLogic, permanent: true);
    }

    await Get.putAsync(() => RealTimeService().init());
  runApp(const MyApp());
}*/


















/*class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => SplashCubit(),
        ),
        BlocProvider(
          create: (context) => SubjectBloc(),
        ),
      ],
      child: Container(),
    )(
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
      //  theme: lightTheme,
       // darkTheme: darkTheme,
       // themeMode: ThemeMode.light,
       // routerConfig: router,
      ),
    );
  }
}*/
