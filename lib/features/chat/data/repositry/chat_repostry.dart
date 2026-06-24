// import 'dart:io';
// import 'package:dartz/dartz.dart';
// import 'package:dio/dio.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:raghad_pro/core/api/api_consumer.dart';
// import 'package:raghad_pro/core/api/end_point.dart';
// import 'package:raghad_pro/core/errors/exceptions.dart';
// import 'package:raghad_pro/features/chat/data/model/chat_model.dart'; // تأكدي من مسار موديل الـ ChatListItem

// class ChatRepository {
//   final ApiConsumer api;

//   ChatRepository(this.api);

//   // 1. جلب قائمة المحادثات وجهات الاتصال المحتملة من السيرفر (Laravel API)
//   Future<Either<String, List<ChatListItem>>> getChatList() async {
//     try {
//       final response = await api.get(EndPoint.getAllPotentialContacts); 
      
//       final Map<String, dynamic> rawData = response is Map<String, dynamic> ? response : {};
//       final List<dynamic> dataList = rawData[ApiKey.data] ?? [];
      
//       final chatList = dataList.map((json) => ChatListItem.fromJson(json)).toList();
//       return right(chatList);
//     } on ServerException catch (e) {
//       return left(e.errorModel.message);
//     } catch (e) {
//       return left("حدث خطأ أثناء جلب قائمة المحادثات");
//     }
//   }

//   // 2. جلب أو إنشاء غرفة المحادثة واستخراج كود الفايربيس (Firebase Room Key)
//   Future<Either<String, Map<String, dynamic>>> getOrCreateRoom({
//     required String senderId,
//     required String targetId,
//   }) async {
//     try {
//       final response = await api.post(
//         EndPoint.getOrCreateRoom, // تم استخدام الروابط من كود زميلك بدقة
//         data: {
//           "target_id": int.parse(targetId),
//           "sender_id": senderId,
//         },
//       );
      
//       final Map<String, dynamic> rawData = response is Map<String, dynamic> ? response : {};
      
//       if (rawData['success'] == true) {
//         return right({
//           'firebase_room_key': rawData['firebase_room_key'].toString(),
//           'current_user_id': rawData['current_user_id'].toString(),
//         });
//       }
//       return left('فشل إنشاء الغرفة من قبل السيرفر');
//     } on ServerException catch (e) {
//       return left(e.errorModel.message);
//     } catch (e) {
//       return left("حدث خطأ أثناء تهيئة غرفة المحادثة");
//     }
//   }

//   // 3. جلب جهات الاتصال المحتملة للمستخدم (Potential Contacts)
//   Future<Either<String, Map<String, dynamic>>> getPotentialContactsWithUser() async {
//     try {
//       final response = await api.get('/chat/potential-contacts'); // الروابط المطابقة لـ ApiEndpoints لديه
//       final Map<String, dynamic> rawData = response is Map<String, dynamic> ? response : {};
      
//       if (rawData['success'] == true) {
//         return right(rawData);
//       }
//       return right({'data': [], 'current_user': null});
//     } on ServerException catch (e) {
//       return left(e.errorModel.message);
//     } catch (e) {
//       return left("حدث خطأ أثناء جلب جهات الاتصال");
//     }
//   }

//   // 4. مزامنة الرسائل لـ لارافيل لتحديث القائمة وتخزينها بالـ Database
//   Future<Either<String, bool>> syncMessageToLaravel({
//     required String chatRoomId,
//     required String senderId,
//     required String type,
//     required String? text,
//     required String? fileUrl,
//   }) async {
//     try {
//       String cleanSenderId = senderId.toString().replaceAll('user_', '');
//       final dataMap = {
//         "firebase_room_key": chatRoomId,
//         "room_id": chatRoomId,
//         "sender_id": cleanSenderId,
//         "type": type,
//         "text": text ?? (type == "text" ? "" : "أرسل ملف"),
//         "file": fileUrl,
//         "file_url": fileUrl,
//       };

//       final response = await api.post('/chat/store-message', data: dataMap);
//       return right(true);
//     } on ServerException catch (e) {
//       return left(e.errorModel.message);
//     } catch (e) {
//       return left("فشلت مزامنة الرسالة مع السيرفر");
//     }
//   }

//   // 5. رفع الصور ومزامنتها باستخدام الـ ApiConsumer مع خاصية الـ isFormData
//   Future<Either<String, String>> uploadImageAndSync({
//     required String filePath,
//     required String chatRoomId,
//     required String senderId,
//   }) async {
//     try {
//       String cleanSenderId = senderId.toString().replaceAll('user_', '');
//       String fileName = filePath.split('/').last;
      
//       FormData formData = FormData.fromMap({
//         "file": await MultipartFile.fromFile(filePath, filename: fileName),
//         "type": "image",
//         "room_id": chatRoomId,
//         "sender_id": cleanSenderId,
//         "text": "أرسل صورة 🖼️",
//       });

//       final response = await api.post(
//         '/chat/upload',
//         data: formData,
//         isFormData: true, // تفعيل الـ Form Data المجهز بذكاء في الـ ApiConsumer الخاص بكِ
//       );

//       final Map<String, dynamic> rawData = response is Map<String, dynamic> ? response : {};
//       return right(rawData['url'].toString());
//     } on ServerException catch (e) {
//       return left(e.errorModel.message);
//     } catch (e) {
//       return left("حدث خطأ أثناء رفع الصورة");
//     }
//   }

//   // 6. رفع الملفات والمستندات ومزامنتها (Documents)
//   Future<Either<String, String>> uploadFileAndSync({
//     required String filePath,
//     required String fileName,
//     required String chatRoomId,
//     required String senderId,
//   }) async {
//     try {
//       String cleanSenderId = senderId.toString().replaceAll('user_', '');
      
//       FormData formData = FormData.fromMap({
//         "file": await MultipartFile.fromFile(filePath, filename: fileName),
//         "type": "document",
//         "room_id": chatRoomId,
//         "sender_id": cleanSenderId,
//         "text": fileName,
//       });

//       final response = await api.post(
//         '/chat/attachments/upload',
//         data: formData,
//         isFormData: true,
//       );

//       final Map<String, dynamic> rawData = response is Map<String, dynamic> ? response : {};
//       return right(rawData['url'].toString());
//     } on ServerException catch (e) {
//       return left(e.errorModel.message);
//     } catch (e) {
//       return left("حدث خطأ أثناء رفع الملف");
//     }
//   }

//   // 7. رفع التسجيلات الصوتية ومزامنتها (Audio)
//   Future<Either<String, String>> uploadAudioAndSync({
//     required String filePath,
//     required String chatRoomId,
//     required String senderId,
//   }) async {
//     try {
//       String cleanSenderId = senderId.toString().replaceAll('user_', '');
      
//       FormData formData = FormData.fromMap({
//         "file": await MultipartFile.fromFile(filePath, filename: "recording.aac"),
//         "type": "audio",
//         "room_id": chatRoomId,
//         "sender_id": cleanSenderId,
//         "text": "تسجيل صوتي 🎤",
//       });

//       final response = await api.post(
//         '/chat/upload',
//         data: formData,
//         isFormData: true,
//       );

//       final Map<String, dynamic> rawData = response is Map<String, dynamic> ? response : {};
//       return right(rawData['url'].toString());
//     } on ServerException catch (e) {
//       return left(e.errorModel.message);
//     } catch (e) {
//       return left("حدث خطأ أثناء رفع التسجيل الصوتي");
//     }
//   }

//   // 8. تحميل الملفات وحفظها محلياً في جهاز المستخدم
//   Future<Either<String, String>> downloadFile({required String url, required String fileName}) async {
//     try {
//       // تعديل مسارات الـ Sockets لضمان تحميل آمن ومطابق لكود السيرفر المربوط بـ Medica
//       String safeUrl = url.replaceAll(RegExp(r"https://your-socket-url"), "https://your-socket-path");
//       Directory tempDir = await getTemporaryDirectory();
//       String savePath = "${tempDir.path}/${fileName.replaceAll(RegExp(r"[^A-Za-z0-9.]"), "_")}";
      
//       // نستخدم الـ api الخاص بكِ لعمل الـ download بشكل مباشر ونظيف
//       // إذا كان الـ ApiConsumer يدعم الـ download، أو نقوم بعملية الـ download المباشرة الممسوكة
//       Dio nativeDio = Dio(); 
//       await nativeDio.download(Uri.encodeFull(safeUrl), savePath);
      
//       return right(savePath);
//     } catch (e) {
//       return left("حدث خطأ أثناء تحميل أو حفظ الملف");
//     }
//   }

//   // 9. دالة كاش الملفات الصوتية لتجنب تكرار تحميل الـ Record في المحادثة
//   Future<Either<String, String>> getCachedAudioPath(String messageId, String url) async {
//     try {
//       String safeUrl = url.replaceAll(RegExp(r"https://your-socket-url"), "https://your-socket-path");
//       final directory = await getTemporaryDirectory();
//       String localPath = '${directory.path}/cache_$messageId.${safeUrl.endsWith('.mp3') ? 'mp3' : 'm4a'}';
      
//       File cachedFile = File(localPath);
//       if (await cachedFile.exists() && await cachedFile.length() > 0) {
//         return right(localPath);
//       }

//       Dio nativeDio = Dio();
//       await nativeDio.download(safeUrl, localPath);
//       return right(localPath);
//     } catch (e) {
//       return left("حدث خطأ أثناء تحميل الكاش الصوتي");
//     }
//   }
// }
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:raghad_pro/features/chat/abd/apiEndpoints.dart';
import 'package:raghad_pro/features/chat/abd/apperrorhandler.dart';
import 'package:raghad_pro/features/chat/abd/networkclient.dart';
/*
class ChatRepository {
  final ApiConsumer api;

  ChatRepository(this.api);

  Future<Either<String, List<ChatListItem>>> getChatList() async {
    try {
      final response = await api.get(EndPoint.getAllPotentialContacts); 
      
      final Map<String, dynamic> rawData = response is Map<String, dynamic> ? response : {};
      final List<dynamic> dataList = rawData['data'] ?? [];
      
      final chatList = dataList.map((json) => ChatListItem.fromJson(json)).toList();
      return right(chatList);
    } on ServerException catch (e) {
      return left(e.errorModel.message);
    } catch (e) {
      return left("حدث خطأ أثناء جلب قائمة المحادثات");
    }
  }

  // 2. جلب أو إنشاء غرفة المحادثة واستخراج كود الفايربيس (Firebase Room Key)
  Future<Either<String, Map<String, dynamic>>> getOrCreateRoom({
    required String senderId,
    required String targetId,
  }) async {
    try {
      final response = await api.post(
        EndPoint.getOrCreateRoom, 
        data: {
          "target_id": int.parse(targetId),
          "sender_id": senderId,
        },
      );
      
      final Map<String, dynamic> rawData = response is Map<String, dynamic> ? response : {};
      
      if (rawData['success'] == true) {
        return right({
          'firebase_room_key': rawData['firebase_room_key'].toString(),
          'current_user_id': rawData['current_user_id'].toString(),
        });
      }
      return left('فشل إنشاء الغرفة من قبل السيرفر');
    } on ServerException catch (e) {
      return left(e.errorModel.message);
    } catch (e) {
      return left("حدث خطأ أثناء تهيئة غرفة المحادثة");
    }
  }

  // 3. جلب جهات الاتصال المحتملة للمستخدم (Potential Contacts)
  Future<Either<String, Map<String, dynamic>>> getPotentialContactsWithUser() async {
    try {
      final response = await api.get(EndPoint.getAllPotentialContacts); 
      final Map<String, dynamic> rawData = response is Map<String, dynamic> ? response : {};
      
      if (rawData['success'] == true) {
        return right(rawData);
      }
      return right({'data': [], 'current_user': null});
    } on ServerException catch (e) {
      return left(e.errorModel.message);
    } catch (e) {
      return left("حدث خطأ أثناء جلب جهات الاتصال");
    }
  }

  // 4. مزامنة الرسائل لـ لارافيل لتحديث القائمة وتخزينها بالـ Database
  Future<Either<String, bool>> syncMessageToLaravel({
    required String chatRoomId,
    required String senderId,
    required String type,
    required String? text,
    required String? fileUrl,
  }) async {
    try {
      String cleanSenderId = senderId.toString().replaceAll('user_', '');
      final dataMap = {
        "firebase_room_key": chatRoomId,
        "room_id": chatRoomId,
        "sender_id": cleanSenderId,
        "type": type,
        "text": text ?? (type == "text" ? "" : "أرسل ملف"),
        "file": fileUrl,
        "file_url": fileUrl,
      };

      await api.post(EndPoint.storeMessage, data: dataMap);
      return right(true);
    } on ServerException catch (e) {
      return left(e.errorModel.message);
    } catch (e) {
      return left("فشلت مزامنة الرسالة مع السيرفر");
    }
  }

  // 5. رفع الصور ومزامنتها باستخدام الـ ApiConsumer مع خاصية الـ isFormData
  Future<Either<String, String>> uploadImageAndSync({
    required String filePath,
    required String chatRoomId,
    required String senderId,
  }) async {
    try {
      String cleanSenderId = senderId.toString().replaceAll('user_', '');
      String fileName = filePath.split('/').last;
      
      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(filePath, filename: fileName),
        "type": "image",
        "room_id": chatRoomId,
        "sender_id": cleanSenderId,
        "text": "أرسل صورة 🖼️",
      });

      final response = await api.post(
        EndPoint.uploadFile,
        data: formData,
        isFormData: true, 
      );

      final Map<String, dynamic> rawData = response is Map<String, dynamic> ? response : {};
      return right(rawData['url'].toString());
    } on ServerException catch (e) {
      return left(e.errorModel.message);
    } catch (e) {
      return left("حدث خطأ أثناء رفع الصورة");
    }
  }

  // 6. رفع الملفات والمستندات ومزامنتها (Documents)
  Future<Either<String, String>> uploadFileAndSync({
    required String filePath,
    required String fileName,
    required String chatRoomId,
    required String senderId,
  }) async {
    try {
      String cleanSenderId = senderId.toString().replaceAll('user_', '');
      
      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(filePath, filename: fileName),
        "type": "document",
        "room_id": chatRoomId,
        "sender_id": cleanSenderId,
        "text": fileName,
      });

      final response = await api.post(
        EndPoint.uploadAttachment,
        data: formData,
        isFormData: true,
      );

      final Map<String, dynamic> rawData = response is Map<String, dynamic> ? response : {};
      return right(rawData['url'].toString());
    } on ServerException catch (e) {
      return left(e.errorModel.message);
    } catch (e) {
      return left("حدث خطأ أثناء رفع الملف");
    }
  }

  // 7. رفع التسجيلات الصوتية ومزامنتها (Audio)
  Future<Either<String, String>> uploadAudioAndSync({
    required String filePath,
    required String chatRoomId,
    required String senderId,
  }) async {
    try {
      String cleanSenderId = senderId.toString().replaceAll('user_', '');
      
      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(filePath, filename: "recording.aac"),
        "type": "audio",
        "room_id": chatRoomId,
        "sender_id": cleanSenderId,
        "text": "تسجيل صوتي 🎤",
      });

      final response = await api.post(
        EndPoint.uploadFile,
        data: formData,
        isFormData: true,
      );

      final Map<String, dynamic> rawData = response is Map<String, dynamic> ? response : {};
      return right(rawData['url'].toString());
    } on ServerException catch (e) {
      return left(e.errorModel.message);
    } catch (e) {
      return left("حدث خطأ أثناء رفع التسجيل الصوتي");
    }
  }

  // 8. تحميل الملفات وحفظها محلياً في جهاز المستخدم باستخدام Dio مخصص للتحميل الخارجي لضمان عدم تعارض الـ baseUrl
  Future<Either<String, String>> downloadFile({required String url, required String fileName}) async {
    try {
      // تعديل مسارات الـ Sockets لضمان تحميل سليم من السيرفر المحلي لمشروع Medica
      String safeUrl = url.replaceAll(RegExp(EndPoint.socketUrl), EndPoint.socketPath);
      Directory tempDir = await getTemporaryDirectory();
      String savePath = "${tempDir.path}/${fileName.replaceAll(RegExp(r"[^A-Za-z0-9.]"), "_")}";
      
      Dio nativeDio = Dio(); 
      await nativeDio.download(Uri.encodeFull(safeUrl), savePath);
      
      return right(savePath);
    } catch (e) {
      return left("حدث خطأ أثناء تحميل أو حفظ الملف");
    }
  }

  // 9. دالة كاش الملفات الصوتية لتجنب تكرار تحميل الـ Record في المحادثة
  Future<Either<String, String>> getCachedAudioPath(String messageId, String url) async {
    try {
      String safeUrl = url.replaceAll(RegExp(EndPoint.socketUrl), EndPoint.socketPath);
      final directory = await getTemporaryDirectory();
      String localPath = '${directory.path}/cache_$messageId.${safeUrl.endsWith('.mp3') ? 'mp3' : 'm4a'}';
      
      File cachedFile = File(localPath);
      if (await cachedFile.exists() && await cachedFile.length() > 0) {
        return right(localPath);
      }

      Dio nativeDio = Dio();
      await nativeDio.download(safeUrl, localPath);
      return right(localPath);
    } catch (e) {
      return left("حدث خطأ أثناء تحميل الكاش الصوتي");
    }
  }
}
*/

class ChatRepository {
  final Dio _dio = NetworkClient().dio;
  final String baseUrl = ApiEndpoints.baseUrl;


  Future<Map<String, dynamic>> getOrCreateRoom({
    required String senderId,
    required String targetId,
  }) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.getOrCreateRoom,
        data: {
          "target_id": int.parse(targetId),
          "sender_id": senderId,
        },
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        return {
          'firebase_room_key': response.data['firebase_room_key'].toString(),
          'current_user_id': response.data['current_user_id'].toString(),
        };
      }
      throw Exception('فشل إنشاء الغرفة');
    } catch (e) {
      String errorMessage = AppErrorHandler.getErrorMessage(e);
      debugPrint("❌ [ChatRepository Error]: $errorMessage");
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getPotentialContactsWithUser() async {
    try {
      final response = await _dio.get(ApiEndpoints.getAllPotentialContacts);
      if (response.statusCode == 200 && response.data['success'] == true) {
        return response.data;
      }
      return {'data': [], 'current_user': null};
    } catch (e) {
      String errorMessage = AppErrorHandler.getErrorMessage(e);
      debugPrint("❌ [ChatRepository Error]: $errorMessage");
      rethrow;
    }
  }

  Future<bool> syncMessageToLaravel({
    required String chatRoomId,
    required String senderId,
    required String type,
    required String? text,
    required String? fileUrl,
  }) async {
    try {
      String cleanSenderId = senderId.toString().replaceAll('user_', '');
      final dataMap = {
        "firebase_room_key": chatRoomId,
        "room_id": chatRoomId,
        "sender_id": cleanSenderId,
        "type": type,
        "text": text ?? (type == "text" ? "" : "أرسل ملف"),
        "file": fileUrl,
        "file_url": fileUrl,
      };

      final response = await _dio.post(ApiEndpoints.storeMessage, data: dataMap);
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      debugPrint("❌ [Laravel Sync Error]: ${AppErrorHandler.getErrorMessage(e)}");
      return false;
    }
  }

  Future<String?> uploadImageAndSync({
    required String filePath,
    required String chatRoomId,
    required String senderId,
  }) async {
    try {
      String cleanSenderId = senderId.toString().replaceAll('user_', '');
      String fileName = filePath.split('/').last;
      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(filePath, filename: fileName),
        "type": "image",
        "room_id": chatRoomId,
        "sender_id": cleanSenderId,
        "text": "أرسل صورة 🖼️",
      });

      final response = await _dio.post(ApiEndpoints.uploadFile, data: formData);
      return response.data['url'].toString();
    } catch (e) {
      debugPrint("❌ [UploadImage Error]: ${AppErrorHandler.getErrorMessage(e)}");
      return null;
    }
  }

  Future<String?> uploadFileAndSync({
    required String filePath,
    required String fileName,
    required String chatRoomId,
    required String senderId,
  }) async {
    try {
      String cleanSenderId = senderId.toString().replaceAll('user_', '');
      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(filePath, filename: fileName),
        "type": "document",
        "room_id": chatRoomId,
        "sender_id": cleanSenderId,
        "text": fileName,
      });

      final response = await _dio.post(ApiEndpoints.uploadAttachment, data: formData);
      return response.data['url'].toString();
    } catch (e) {
      debugPrint("❌ [UploadFile Error]: ${AppErrorHandler.getErrorMessage(e)}");
      return null;
    }
  }

  Future<String?> downloadFile({required String url, required String fileName}) async {
    try {
      String safeUrl = url.replaceAll(RegExp(ApiEndpoints.socketUrl), ApiEndpoints.socketPath);
      Directory tempDir = await getTemporaryDirectory();
      String savePath = "${tempDir.path}/${fileName.replaceAll(RegExp(r"[^A-Za-z0-9.]"), "_")}";
      await _dio.download(Uri.encodeFull(safeUrl), savePath);
      return savePath;
    } catch (e) {
      debugPrint("❌ [Download Error]: ${AppErrorHandler.getErrorMessage(e)}");
      return null;
    }
  }

  Future<String?> uploadAudioAndSync({
    required String filePath,
    required String chatRoomId,
    required String senderId,
  }) async {
    try {
      String cleanSenderId = senderId.toString().replaceAll('user_', '');
      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(filePath, filename: "recording.aac"),
        "type": "audio",
        "room_id": chatRoomId,
        "sender_id": cleanSenderId,
        "text": "تسجيل صوتي 🎤",
      });

      final response = await _dio.post(ApiEndpoints.uploadFile, data: formData);
      return response.data['url'].toString();
    } catch (e) {
      debugPrint("❌ [UploadAudio Error]: ${AppErrorHandler.getErrorMessage(e)}");
      return null;
    }
  }

  Future<String?> getCachedAudioPath(String messageId, String url) async {
    try {
      String safeUrl = url.replaceAll(RegExp(ApiEndpoints.socketUrl), ApiEndpoints.socketPath);
      final directory = await getTemporaryDirectory();
      String localPath = '${directory.path}/cache_$messageId.${safeUrl.endsWith('.mp3') ? 'mp3' : 'm4a'}';
      
      File cachedFile = File(localPath);
      if (await cachedFile.exists() && await cachedFile.length() > 0) return localPath;

      await _dio.download(safeUrl, localPath);
      return localPath;
    } catch (e) {
      debugPrint("❌ [AudioCache Error]: ${AppErrorHandler.getErrorMessage(e)}");
      return null;
    }
  }
}