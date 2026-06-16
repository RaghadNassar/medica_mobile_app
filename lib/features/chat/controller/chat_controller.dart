import 'dart:io';
import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';
import 'package:raghad_pro/core/api/end_point.dart';
import 'package:raghad_pro/core/cache/cashe_helper_getStorage.dart';
import 'package:raghad_pro/core/helper/alert_helper.dart'; // استيراد الـ AlertHelper الخاص بكِ
import 'package:raghad_pro/features/chat/data/model/message_model.dart';
import 'package:raghad_pro/features/chat/data/repositry/chat_repostry.dart';
import 'package:record/record.dart';
/*
class ChatController extends GetxController with WidgetsBindingObserver {
  final ChatRepository chatRepository;

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final TextEditingController textController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final ImagePicker _picker = ImagePicker();
  final AudioRecorder _audioRecorder = AudioRecorder();
  final AudioPlayer _audioPlayer = AudioPlayer();

  var messages = <MessageModel>[].obs;
  var isUploading = false.obs;
  var isRecording = false.obs;
  final isTextFieldNotEmpty = false.obs;

  var playingMessageId = ''.obs;
  final Map<String, String> _localAudioCacheMap = {};
  var audioPosition = Duration.zero.obs;
  var audioDuration = Duration.zero.obs;

  var editingMessageId = ''.obs;

  String chatRoomId = "";
  String currentUserId = "";
  String? _localAudioPath;

  var isPeerOnlineInRoom = false.obs;
  var isPeerOnlineInApp = false.obs;
  var peerLastSeenStr = "غير نشط".obs;
  String targetUserId = "";
  String chatName = "";

  ChatController({required this.chatRepository});

  @override
  void onInit() async {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);

    await _ensureLoggedIn();
    _initAudioStreams();

    if (Get.arguments != null) {
      if (Get.arguments['chatName'] != null) {
        chatName = Get.arguments['chatName'].toString();
      }

      if (Get.arguments['currentUserId'] != null) {
        currentUserId = "user_${Get.arguments['currentUserId']}";
      } else {
        final cachedId = CacheHelperGetStorage.getData(key: ApiKey.uuid);
        currentUserId = cachedId != null ? "user_$cachedId" : "user_1";
      }

      if (Get.arguments['targetId'] != null) {
        String targetId = Get.arguments['targetId'].toString();
        targetUserId = targetId;

        _updateAppPresence(true);
        await initializeDynamicChat(targetId);
      }
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      _setUserRoomPresence(false);
      _updateAppPresence(false);
    } else if (state == AppLifecycleState.resumed) {
      _setUserRoomPresence(true);
      _updateAppPresence(true);
    }
  }

  Future<void> _ensurePeerExists(String peerId) async {
    DocumentReference peerRef = _db.collection('UsersStatus').doc(peerId);
    DocumentSnapshot peerDoc = await peerRef.get();

    if (!peerDoc.exists) {
      await peerRef.set({
        'isOnline': false,
        'lastSeen': FieldValue.serverTimestamp(),
      });
    }
  }

  void updateTypedText(String text) {
    isTextFieldNotEmpty.value = text.trim().isNotEmpty;
  }

  void _initAudioStreams() {
    _audioPlayer.onDurationChanged.listen((d) => audioDuration.value = d);
    _audioPlayer.onPositionChanged.listen((p) => audioPosition.value = p);
    _audioPlayer.onPlayerComplete.listen((event) {
      playingMessageId.value = '';
      audioPosition.value = Duration.zero;
      audioDuration.value = Duration.zero;
    });
  }

  Future<void> _ensureLoggedIn() async {
    if (_auth.currentUser == null) {
      try {
        await _auth.signInAnonymously();
      } catch (e) {
        print("Auth error: $e");
      }
    }
  }

  void _updateAppPresence(bool isOnline) async {
    if (currentUserId.isEmpty) return;
    try {
      await _db.collection('UsersStatus').doc(currentUserId).set({
        'isOnline': isOnline,
        'lastSeen': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      print("❌ فشل تحديث حالة الاتصال العامة بالتطبيق: $e");
    }
  }

 /* void _setUserRoomPresence(bool isPresent) async {
    if (chatRoomId.isEmpty || currentUserId.isEmpty) return;
    try {
      await _db.collection('ChatRooms').doc(chatRoomId).update({
        'presence.$currentUserId': {
          'status': isPresent ? 'online' : 'offline',
          'lastSeen': DateTime.now().millisecondsSinceEpoch
        }
      });
    } catch (e) {
      await _db.collection('ChatRooms').doc(chatRoomId).set({
        'presence': {
          currentUserId: {
            'status': isPresent ? 'online' : 'offline',
            'lastSeen': DateTime.now().millisecondsSinceEpoch
          }
        }
      }, SetOptions(merge: true));
    }
  }*/
  void _setUserRoomPresence(bool isPresent) async {
  if (chatRoomId.isEmpty || currentUserId.isEmpty) return;
  
  try {
    // 💡 تصحيح: إزالة الأقواس المربعة التي كانت تسبب فشل الكتابة في فايربيس
    await _db.collection('ChatRooms').doc(chatRoomId).update({
      'presence.$currentUserId': {
        'status': isPresent ? 'online' : 'offline',
        'lastSeen': DateTime.now().millisecondsSinceEpoch
      }
    });
  } catch (e) {
    await _db.collection('ChatRooms').doc(chatRoomId).set({
      'presence': {
        currentUserId: {
          'status': isPresent ? 'online' : 'offline',
          'lastSeen': DateTime.now().millisecondsSinceEpoch
        }
      }
    }, SetOptions(merge: true));
  }
}

  void _listenToPeerAppStatus() {
    _db.collection('ChatRooms').doc(chatRoomId).snapshots().listen((snapshot) {
      if (!snapshot.exists || snapshot.data() == null) return;

      final data = snapshot.data() as Map<String, dynamic>;
      final presence = data['presence'] as Map<String, dynamic>?;

      if (presence != null) {
        String? peerId = presence.keys
            .firstWhere((id) => id != currentUserId, orElse: () => "");

        if (peerId.isNotEmpty) {
          var peerInfo = presence[peerId];
          bool isOnline = false;
          String lastSeenText = "غير نشط";

          if (peerInfo is Map) {
            isOnline = peerInfo['status'] == 'online';
            if (!isOnline && peerInfo['lastSeen'] != null) {
              final timestamp = (peerInfo['lastSeen'] as num).toInt();
              lastSeenText = _formatLastSeen(
                  DateTime.fromMillisecondsSinceEpoch(timestamp));
            }
          } else if (peerInfo is String) {
            isOnline = peerInfo == 'online';
          }

          isPeerOnlineInApp.value = isOnline;
          peerLastSeenStr.value = isOnline ? "متصل الآن" : lastSeenText;
        }
      }
    });
  }

  String _formatLastSeen(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    final timeFormatter = DateFormat('h:mm a', 'ar');

    if (difference.inDays == 0 && now.day == dateTime.day) {
      return "آخر ظهور اليوم الساعة ${timeFormatter.format(dateTime)}";
    } else if (difference.inDays == 1 ||
        (difference.inDays == 0 && now.day != dateTime.day)) {
      return "آخر ظهور أمس الساعة ${timeFormatter.format(dateTime)}";
    } else {
      final dateFormatter = DateFormat('yyyy/MM/dd', 'ar');
      return "آخر ظهور بتاريخ ${dateFormatter.format(dateTime)} الساعة ${timeFormatter.format(dateTime)}";
    }
  }

  // تهيئة الغرفة اللحظية بالاعتماد على دالة الـ fold والـ Alert الموحد
  Future<void> initializeDynamicChat(String targetId) async {
    isUploading.value = true;
    try {
      await _ensurePeerExists(targetId);

      String rawUserId = currentUserId.replaceAll(RegExp(r'[^0-9]'), '');
      String senderId = rawUserId.isEmpty ? "1" : rawUserId;

      final result = await chatRepository.getOrCreateRoom(
        senderId: senderId,
        targetId: targetId,
      );

      result.fold(
        (errorMessage) {
          AlertHelper.showSnackbar(
            title: "خطأ تهيئة المحادثة",
            message: errorMessage,
            type: AlertType.error,
          );
        },
        (roomData) {
          chatRoomId = roomData['firebase_room_key'];
          currentUserId = roomData['current_user_id'];
          print("🎯 تم ربط وتجهيز الغرفة بنجاح في Medica: $chatRoomId");
          listenToMessages();
        },
      );
    } catch (e) {
      print("❌ فشل تهيئة الغرفة: $e");
    } finally {
      isUploading.value = false;
    }
  }

  void listenToMessages() {
    if (chatRoomId.isEmpty) return;

    _setUserRoomPresence(true);
    _listenToPeerAppStatus();

    _db
        .collection('ChatRooms')
        .doc(chatRoomId)
        .snapshots()
        .listen((roomSnapshot) {
      if (roomSnapshot.exists && roomSnapshot.data() != null) {
        var data = roomSnapshot.data() as Map<String, dynamic>;
        if (data['presence'] != null &&
            data['presence'][targetUserId] != null) {
          isPeerOnlineInRoom.value = data['presence'][targetUserId] == 'online';
        } else {
          isPeerOnlineInRoom.value = false;
        }
      }
    });

    _db
        .collection('ChatRooms')
        .doc(chatRoomId)
        .collection('Messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .listen((snapshot) {
      messages.value =
          snapshot.docs.map((doc) => MessageModel.fromFirestore(doc)).toList();
      _markIncomingMessagesAsRead(snapshot.docs);
    });
  }

  void _markIncomingMessagesAsRead(List<QueryDocumentSnapshot> docs) {
    if (chatRoomId.isEmpty) return;
    WriteBatch batch = _db.batch();
    bool hasUpdates = false;

    for (var doc in docs) {
      var data = doc.data() as Map<String, dynamic>;
      if (data['senderId'] != currentUserId && data['status'] != 'read') {
        batch.update(doc.reference, {'status': 'read'});
        hasUpdates = true;
      }
    }

    if (hasUpdates) {
      batch.commit();
    }
  }

  void startEditing(MessageModel message) {
    if (message.type == MessageType.text) {
      editingMessageId.value = message.messageId ?? '';
      textController.text = message.text;
      isTextFieldNotEmpty.value = true;
    }
  }

  void cancelEditing() {
    editingMessageId.value = '';
    textController.clear();
    isTextFieldNotEmpty.value = false;
  }

  Future<void> updateMessage(String messageId, String newText) async {
    if (newText.trim().isEmpty) return;
    try {
      await _db
          .collection('ChatRooms')
          .doc(chatRoomId)
          .collection('Messages')
          .doc(messageId)
          .update({
        'text': newText.trim(),
        'isEdited': true,
      });
    } catch (e) {
      AlertHelper.showSnackbar(
        title: "خطأ",
        message: "فشل تعديل الرسالة محلياً",
        type: AlertType.error,
      );
    }
  }

  Future<void> deleteMessage(String messageId) async {
    try {
      await _db
          .collection('ChatRooms')
          .doc(chatRoomId)
          .collection('Messages')
          .doc(messageId)
          .update({
        'type': 'deleted',
        'text': 'تم حذف هذه الرسالة',
      });
    } catch (e) {
      AlertHelper.showSnackbar(
        title: "خطأ",
        message: "فشل حذف الرسالة محلياً",
        type: AlertType.error,
      );
    }
  }

  Future<void> _syncMessageToLaravel({
    required String type,
    required String? text,
    required String? fileUrl,
  }) async {
    print("🔄 جاري محاولة مزامنة الرسالة للارافيل...");

    final result = await chatRepository.syncMessageToLaravel(
      chatRoomId: chatRoomId.toString(),
      senderId: currentUserId.toString(),
      type: type,
      text: text,
      fileUrl: fileUrl,
    );

    result.fold(
        (errorMessage) => print("❌ [Laravel Sync Error]: $errorMessage"),
        (success) =>
            print("✅ [Laravel Sync] تم الحفظ بنجاح في لارافيل Medica"));
  }

  Future<void> sendMessage() async {
    String msgText = textController.text.trim();
    if (msgText.isNotEmpty) {
      if (editingMessageId.value.isNotEmpty) {
        String targetMsgId = editingMessageId.value;
        cancelEditing();
        await updateMessage(targetMsgId, msgText);
        return;
      }

      try {
        textController.clear();
        isTextFieldNotEmpty.value = false;

        MessageStatus finalStatus =
            isPeerOnlineInRoom.value ? MessageStatus.read : MessageStatus.sent;

        await _db
            .collection('ChatRooms')
            .doc(chatRoomId)
            .collection('Messages')
            .add(MessageModel(
              senderId: currentUserId,
              text: msgText,
              timestamp: DateTime.now(),
              type: MessageType.text,
              status: finalStatus,
            ).toMap());

        _scrollToBottom();
        _syncMessageToLaravel(type: 'text', text: msgText, fileUrl: null);
      } catch (e) {
        AlertHelper.showSnackbar(
          title: "خطأ",
          message: "فشل إرسال الرسالة",
          type: AlertType.error,
        );
        textController.text = msgText;
        isTextFieldNotEmpty.value = true;
      }
    }
  }

  // رفع وإرسال الصور متضمناً الـ fold للـ Repo والـ AlertHelper النظيف
  Future<void> uploadAndSendImage(ImageSource source) async {
    try {
      final XFile? pickedFile =
          await _picker.pickImage(source: source, imageQuality: 70);

      if (pickedFile != null) {
        isUploading.value = true;

        final result = await chatRepository.uploadImageAndSync(
          filePath: pickedFile.path,
          chatRoomId: chatRoomId.toString(),
          senderId: currentUserId.toString(),
        );

        result.fold(
          (errorMessage) {
            AlertHelper.showSnackbar(
              title: "خطأ في الرفع",
              message: errorMessage,
              type: AlertType.error,
            );
          },
          (downloadUrl) async {
            MessageStatus finalStatus = isPeerOnlineInRoom.value
                ? MessageStatus.read
                : MessageStatus.sent;

            await _db
                .collection('ChatRooms')
                .doc(chatRoomId)
                .collection('Messages')
                .add(MessageModel(
                  senderId: currentUserId,
                  text: "أرسل صورة 🖼️",
                  timestamp: DateTime.now(),
                  type: MessageType.image,
                  fileUrl: downloadUrl,
                  status: finalStatus,
                ).toMap());

            _scrollToBottom();
            print("✅ تم رفع وإرسال الصورة بنجاح عبر الريبوزتري والهيكلية النظيفة!");
          },
        );
      }
    } catch (e) {
      print("❌ خطأ أثناء معالجة الصورة: $e");
    } finally {
      isUploading.value = false;
    }
  }

  // رفع وإرسال الملفات العامة متضمناً الـ fold للـ Repo والـ AlertHelper
  Future<void> pickAndSendGeneralFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx', 'txt', 'xlsx'],
      );

      if (result != null && result.files.single.path != null) {
        isUploading.value = true;
        String filePath = result.files.single.path!;
        String fileName = result.files.single.name;

        final uploadResult = await chatRepository.uploadFileAndSync(
          filePath: filePath,
          fileName: fileName,
          chatRoomId: chatRoomId.toString(),
          senderId: currentUserId.toString(),
        );

        uploadResult.fold(
          (errorMessage) {
            AlertHelper.showSnackbar(
              title: "خطأ رفع الملف",
              message: errorMessage,
              type: AlertType.error,
            );
          },
          (downloadUrl) async {
            MessageStatus finalStatus = isPeerOnlineInRoom.value
                ? MessageStatus.read
                : MessageStatus.sent;

            await _db
                .collection('ChatRooms')
                .doc(chatRoomId)
                .collection('Messages')
                .add(MessageModel(
                  senderId: currentUserId,
                  text: fileName,
                  timestamp: DateTime.now(),
                  type: MessageType.file,
                  fileUrl: downloadUrl,
                  status: finalStatus,
                ).toMap());

            _scrollToBottom();
            print("✅ تم رفع الملف وإرساله بنجاح!");
          },
        );
      }
    } catch (e) {
      AlertHelper.showSnackbar(
        title: "خطأ ملفات",
        message: "فشل معالجة الملف: $e",
        type: AlertType.error,
      );
    } finally {
      isUploading.value = false;
    }
  }

  // فتح الملفات وتحميلها متضمناً الـ fold للـ Repo والـ AlertHelper
  Future<void> openRemoteFile(String url, String fileName) async {
    isUploading.value = true;
    AlertHelper.showSnackbar(
      title: "جاري التحضير",
      message: "جاري تجهيز الملف...",
      type: AlertType.warning, // أو أي نوع مخصص للانتظار لديكِ
    );

    final downloadResult =
        await chatRepository.downloadFile(url: url, fileName: fileName);

    downloadResult.fold(
      (errorMessage) {
        AlertHelper.showSnackbar(
          title: "تنبيه التحميل",
          message: errorMessage,
          type: AlertType.error,
        );
      },
      (localPath) async {
        try {
          final result = await OpenFilex.open(localPath);
          if (result.type != ResultType.done) {
            throw Exception(result.message);
          }
        } catch (e) {
          AlertHelper.showSnackbar(
            title: "تنبيه فتح الملف",
            message: "لم نتمكن من فتح الملف. تأكد من وجود تطبيق قارئ مناسب.",
            type: AlertType.error,
          );
        }
      },
    );
    isUploading.value = false;
  }

  Future<void> startAudioRecording() async {
    try {
      if (Platform.isAndroid || Platform.isIOS) {
        final directory = await getTemporaryDirectory();
        _localAudioPath =
            '${directory.path}/audio_${DateTime.now().millisecondsSinceEpoch}.ogg';

        await _audioRecorder.start(
          const RecordConfig(
            encoder: AudioEncoder.opus,
            bitRate: 64000,
            sampleRate: 16000,
            numChannels: 1,
          ),
          path: _localAudioPath!,
        );
        isRecording.value = true;
      }
    } catch (e) {
      AlertHelper.showSnackbar(
        title: "خطأ في المايك",
        message: "تعذر بدء التسجيل اللحظي: $e",
        type: AlertType.error,
      );
    }
  }

  // إيقاف ورفع الريكورد الصوتي متضمناً الـ fold للـ Repo والـ AlertHelper
  Future<void> stopAndSendAudioRecording() async {
    try {
      final path = await _audioRecorder.stop();
      isRecording.value = false;

      if (path != null && _localAudioPath != null) {
        File audioFile = File(_localAudioPath!);
        if (await audioFile.exists() && await audioFile.length() > 0) {
          isUploading.value = true;

          final uploadResult = await chatRepository.uploadAudioAndSync(
            filePath: _localAudioPath!,
            chatRoomId: chatRoomId.toString(),
            senderId: currentUserId.toString(),
          );

          uploadResult.fold(
            (errorMessage) {
              AlertHelper.showSnackbar(
                title: "خطأ رفع الصوت",
                message: errorMessage,
                type: AlertType.error,
              );
            },
            (downloadUrl) async {
              var messageRef = _db
                  .collection('ChatRooms')
                  .doc(chatRoomId)
                  .collection('Messages')
                  .doc();
              _localAudioCacheMap[messageRef.id] = _localAudioPath!;

              MessageStatus finalStatus = isPeerOnlineInRoom.value
                  ? MessageStatus.read
                  : MessageStatus.sent;

              await messageRef.set(MessageModel(
                senderId: currentUserId,
                text: "تسجيل صوتي 🎤",
                timestamp: DateTime.now(),
                type: MessageType.audio,
                fileUrl: downloadUrl,
                status: finalStatus,
              ).toMap());

              _scrollToBottom();
              print("✅ تم رفع وإرسال التسجيل الصوتي بنجاح!");
            },
          );
        }
      }
    } catch (e) {
      AlertHelper.showSnackbar(
        title: "خطأ صوتي",
        message: "فشل حفظ أو رفع التسجيل: $e",
        type: AlertType.error,
      );
    } finally {
      isUploading.value = false;
    }
  }

  // تشغيل وجلب الريكورد الصوتي عبر الـ الكاش والكلاس الجديد لـ fold والـ AlertHelper
  Future<void> playOrPauseAudio(String messageId, String url) async {
    try {
      if (playingMessageId.value == messageId) {
        await _audioPlayer.pause();
        playingMessageId.value = '';
        return;
      }

      await _audioPlayer.stop();
      audioPosition.value = Duration.zero;
      audioDuration.value = Duration.zero;
      playingMessageId.value = messageId;

      final cacheResult =
          await chatRepository.getCachedAudioPath(messageId, url);

      cacheResult.fold(
        (errorMessage) {
          playingMessageId.value = '';
          AlertHelper.showSnackbar(
            title: "خطأ تشغيل الصوت",
            message: errorMessage,
            type: AlertType.error,
          );
        },
        (localPath) async {
          await _audioPlayer.play(DeviceFileSource(localPath));
        },
      );
    } catch (e) {
      print("❌ خطأ في تشغيل الصوت: $e");
      playingMessageId.value = '';
    }
  }

  void seekAudio(Duration position) {
    _audioPlayer.seek(position);
  }

  void _scrollToBottom() {
    if (scrollController.hasClients) {
      scrollController.animateTo(0,
          duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
    }
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    _setUserRoomPresence(false);
    _updateAppPresence(false);

    textController.dispose();
    scrollController.dispose();
    _audioRecorder.dispose();
    _audioPlayer.dispose();
    super.onClose();
  }
}*/


// سيعطيك القدرة على استخدام MediaType


class ChatController extends GetxController with WidgetsBindingObserver{

  final ChatRepository _chatRepository = ChatRepository(); // إضافة الريبوزتري

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;


  
  final TextEditingController textController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final ImagePicker _picker = ImagePicker();
  final AudioRecorder _audioRecorder = AudioRecorder(); 
  final AudioPlayer _audioPlayer = AudioPlayer(); 

  var messages = <MessageModel>[].obs;
  var isUploading = false.obs;
  var isRecording = false.obs; 
  final isTextFieldNotEmpty = false.obs;
  
  // متغيرات تتبع حالة مشغل الصوت الشبيه بالواتساب
  var playingMessageId = ''.obs; 
  var audioPosition = Duration.zero.obs;
  var audioDuration = Duration.zero.obs;

  // متغيرات تتبع وضع التعديل
  var editingMessageId = ''.obs; 

  // متغيرات المعرفات النقية والمستقرة للغرفة والمستخدم الحالي
  String chatRoomId = ""; 
  String currentUserId = ""; 
  String? _localAudioPath;

  Timer? _presenceTimer;

  final Map<String, String> _localAudioCacheMap = {};
 
  // 🎯 المتغيرات الجديدة الخاصة بالتحكم الاحترافي بحالات القراءة والتواجد وآخر ظهور
  var isPeerOnlineInRoom = false.obs;     // هل الطرف الآخر متواجد حالياً داخل نفس غرفة الشات؟
  var isPeerOnlineInApp = false.obs;      // هل الطرف الآخر متصل بالإنترنت وفاتح التطبيق بشكل عام؟
  var peerLastSeenStr = "غير نشط".obs;    // النص المنسق لعرض وقت آخر ظهور للطرف الآخر
  String targetUserId = "";               // معرف الطرف الآخر المستهدف لبناء تتبع الحالة بدقة
  String chatName = "";                   // حفظ اسم الطرف الآخر لعرضه في الواجهة

  @override
  void onInit() async {
    super.onInit();
    
    WidgetsBinding.instance.addObserver(this); // 2. سجل المراقب لالتقاط تغيرات حالة التطبيق (نشط، غير نشط، في الخلفية)

    await _ensureLoggedIn(); 
    _initAudioStreams(); 



    // التقاط المعرفات ديناميكياً من شاشة القائمة وبناء البيانات
    if (Get.arguments != null) {
      if (Get.arguments['chatName'] != null) {
        chatName = Get.arguments['chatName'].toString();
      }

      if (Get.arguments['currentUserId'] != null) {
        currentUserId = "user_${Get.arguments['currentUserId']}";
      }
      
      if (Get.arguments['targetId'] != null) {
      //  String targetId = "1"; 
        String targetId = Get.arguments['targetId'].toString();
        // بناء المعرف الخاص بالطرف الآخر بالتوافق مع بنيتك (طبيب أو مستخدم آخر)
        targetUserId = targetId; 
       // targetUserId = "1"; // للتجريب الثابت مع المريض 001، يمكنك تعديله لاحقاً ليتوافق مع الـ ID الديناميكي القادم من القائمة
        // 🎯 تحديث حالة المستخدم الحالي بأنه "نشط حالياً داخل التطبيق" فور دخوله الشاشة
        _updateAppPresence(true);

        // استدعاء دالة تهيئة الغرفة وجلب البيانات الحقيقية من لارافيل
        await initializeDynamicChat(targetId);
      }
    }
  }



// 3. معالجة تغير حالة التطبيق
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused || state == AppLifecycleState.detached) {
      // التطبيق انتقل للخلفية أو أُغلق (رسالة فورية للويب)
      _setUserRoomPresence(false);
      _updateAppPresence(false);
    } else if (state == AppLifecycleState.resumed) {
       print("🔄 التطبيق عاد للواجهة، تحديث الحالة...$state");
      // التطبيق عاد للواجهة
      _setUserRoomPresence(true);
      _updateAppPresence(true);
    }
  }


Future<void> _ensurePeerExists(String peerId) async {


  DocumentReference peerRef = _db.collection('UsersStatus').doc(peerId);
  DocumentSnapshot peerDoc = await peerRef.get();

  // إذا لم يكن المستند موجوداً، نقوم بإنشائه بحالة افتراضية
  if (!peerDoc.exists) {
    await peerRef.set({
      'isOnline': false,
      'lastSeen': FieldValue.serverTimestamp(),
    });
    print("✅ تم إنشاء مستند الطرف الآخر $peerId لعدم وجوده.");
  }
}

  
  void updateTypedText(String text) {
    isTextFieldNotEmpty.value = text.trim().isNotEmpty;
  }

  void _initAudioStreams() {
    _audioPlayer.onDurationChanged.listen((d) {
      audioDuration.value = d;
    });
    _audioPlayer.onPositionChanged.listen((p) {
      audioPosition.value = p;
    });
    _audioPlayer.onPlayerComplete.listen((event) {
      playingMessageId.value = '';
      audioPosition.value = Duration.zero;
      audioDuration.value = Duration.zero;
    });
  }

  Future<void> _ensureLoggedIn() async {
    if (_auth.currentUser == null) {
      try {
        await _auth.signInAnonymously();
      } catch (e) {
        print("Auth error: $e");
      }
    }
  }

  // 🎯 دالة تحديث حالة الاتصال العامة للمستخدم الحالي داخل التطبيق (متصل / غير متصل)
  void _updateAppPresence(bool isOnline) async {
    if (currentUserId.isEmpty) return;
    try {
      await _db.collection('UsersStatus').doc(currentUserId).set({
        'isOnline': isOnline,
        'lastSeen': FieldValue.serverTimestamp(), // استخدام وقت السيرفر الفعلي لضمان الدقة وتجنب تلاعب الهواتف
      }, SetOptions(merge: true));
    } catch (e) {
      print("❌ فشل تحديث حالة الاتصال العامة بالتطبيق: $e");
    }
  }


   void _setUserRoomPresence(bool isPresent) async {
  if (chatRoomId.isEmpty || currentUserId.isEmpty) return;
  
  try {
    // نرسل Map وليس String
    await _db.collection('ChatRooms').doc(chatRoomId).update({
      ['presence.$currentUserId']: {
        'status': isPresent ? 'online' : 'offline',
        'lastSeen': DateTime.now().millisecondsSinceEpoch // توقيت دقيق
      }
    });
  } catch (e) {
    // في حال فشل الـ update (المستند غير موجود)، استخدم set
    await _db.collection('ChatRooms').doc(chatRoomId).set({
      'presence': {
        currentUserId: {
          'status': isPresent ? 'online' : 'offline',
          'lastSeen': DateTime.now().millisecondsSinceEpoch
        }
      }
    }, SetOptions(merge: true));
  }
}

void _listenToPeerAppStatus() {
  _db.collection('ChatRooms').doc(chatRoomId).snapshots().listen((snapshot) {
    if (!snapshot.exists || snapshot.data() == null) return;

    final data = snapshot.data() as Map<String, dynamic>;
    final presence = data['presence'] as Map<String, dynamic>?;

    if (presence != null) {
      // استخراج معرف الطرف الآخر (تأكد أن ID الخاص بك ليس "1" فقط)
      String? peerId = presence.keys.firstWhere((id) => id != currentUserId, orElse: () => "");

      if (peerId.isNotEmpty) {
        var peerInfo = presence[peerId];
        bool isOnline = false;
        String lastSeenText = "غير نشط";

        // 🎯 المنطق المطور للتعامل مع التداخل في البيانات
        if (peerInfo is Map) {
          // إذا كانت البيانات Map، فهي الصيغة الجديدة
          isOnline = peerInfo['status'] == 'online';
          
          if (!isOnline && peerInfo['lastSeen'] != null) {
            // التعامل مع lastSeen
            final timestamp = (peerInfo['lastSeen'] as num).toInt();
            lastSeenText = _formatLastSeen(DateTime.fromMillisecondsSinceEpoch(timestamp));
          }
        } 
        else if (peerInfo is String) {
          // إذا كانت البيانات String (بقايا قديمة)، عاملها كحالة بسيطة
          isOnline = peerInfo == 'online';
          lastSeenText = "غير نشط"; // لا يوجد وقت هنا
        }

        // تحديث الواجهة
        isPeerOnlineInApp.value = isOnline;
        peerLastSeenStr.value = isOnline ? "متصل الآن" : lastSeenText;
      }
    }
  });
}

  // دالة مساعدة ذكية لتنسيق زمن "آخر ظهور" ليماثل تجربة تطبيق الواتساب العالمي باللغة العربية
  String _formatLastSeen(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    final timeFormatter = DateFormat('h:mm a', 'ar'); // تنسيق الوقت بـ: 12:45 م مثلاً

    if (difference.inDays == 0 && now.day == dateTime.day) {
      return "آخر ظهور اليوم الساعة ${timeFormatter.format(dateTime)}";
    } else if (difference.inDays == 1 || (difference.inDays == 0 && now.day != dateTime.day)) {
      return "آخر ظهور أمس الساعة ${timeFormatter.format(dateTime)}";
    } else {
      final dateFormatter = DateFormat('yyyy/MM/dd', 'ar');
      return "آخر ظهور بتاريخ ${dateFormatter.format(dateTime)} الساعة ${timeFormatter.format(dateTime)}";
    }
  }

     Future<void> initializeDynamicChat(String targetId) async {
  isUploading.value = true;
  try {
    // 1. ضمان وجود المستخدم في الطرف الآخر (إذا كان ضرورياً)
    await _ensurePeerExists(targetId);

    // 2. معالجة الـ ID كما كنت تفعل
    String rawUserId = currentUserId.replaceAll(RegExp(r'[^0-9]'), '');
    String senderId = rawUserId.isEmpty ? "1" : rawUserId;

    // 3. استدعاء الريبوزتري بدلاً من الـ Dio المباشر
    final roomData = await _chatRepository.getOrCreateRoom(
      senderId: senderId,
      targetId: targetId,
    );

    // 4. تحديث البيانات باستخدام القيم القادمة من الريبوزتري
    chatRoomId = roomData['firebase_room_key'];
    currentUserId = roomData['current_user_id'];

    print("🎯 تم ربط وتجهيز الغرفة بنجاح: $chatRoomId");

    // 5. الاستماع للرسائل
    listenToMessages();

  } catch (e) {
    print("❌ فشل تهيئة الغرفة: $e");
    Get.snackbar("خطأ في الاتصال", "تعذر مزامنة بيانات الغرفة");
  } finally {
    isUploading.value = false;
  }
}



  // استماع يعتمد على الـ String العادي المستقر للغرفة ومعالجة مضافة لحالات الحضور والقراءة اللحظية
  void listenToMessages() {
    if (chatRoomId.isEmpty) return;

    // 1. تفعيل وضع التواجد للمستخدم الحالي داخل هذه الغرفة فور فتحها ليعلم الطرف الآخر بوجودنا
    _setUserRoomPresence(true);

    // 2. تفعيل المستمع اللحظي لحالة اتصال الطرف الآخر العامة بالتطبيق لتحديث الـ AppBar فوراً
    _listenToPeerAppStatus();

    // 3. الاستماع لمعرفة ما إذا كان الطرف الآخر متواجد معنا داخل "نفس الغرفة" حالياً لضبط حالة الرسائل الصادرة بدقة
    _db.collection('ChatRooms').doc(chatRoomId).snapshots().listen((roomSnapshot) {
      if (roomSnapshot.exists && roomSnapshot.data() != null) {
        var data = roomSnapshot.data() as Map<String, dynamic>;
        if (data['presence'] != null && data['presence'][targetUserId] != null) {
          isPeerOnlineInRoom.value = data['presence'][targetUserId] == 'online';
        } else {
          isPeerOnlineInRoom.value = false;
        }
      }
    });

    // 4. البدء بالاستماع اللحظي للرسائل في الفايربيس كالمعتاد
    _db.collection('ChatRooms')
        .doc(chatRoomId)
        .collection('Messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .listen((snapshot) {
          messages.value = snapshot.docs
              .map((doc) => MessageModel.fromFirestore(doc))
              .toList();
          
          // تحديث وقراءة الرسائل الواردة إلينا فقط طالما أننا متواجدون داخل الغرفة الآن
          _markIncomingMessagesAsRead(snapshot.docs);
        });
  }

  // تعديل الدالة لتقوم فقط بتحديث الرسائل التي أرسلها الطرف الآخر ولم تُقرأ بعد لتتحول لـ read فوراً
  void _markIncomingMessagesAsRead(List<QueryDocumentSnapshot> docs) {
    if (chatRoomId.isEmpty) return;
    WriteBatch batch = _db.batch();
    bool hasUpdates = false;

    for (var doc in docs) {
      var data = doc.data() as Map<String, dynamic>;
      if (data['senderId'] != currentUserId && data['status'] != 'read') {
        batch.update(doc.reference, {'status': 'read'});
        hasUpdates = true;
      }
    }

    if (hasUpdates) {
      batch.commit();
    }
  }

  void startEditing(MessageModel message) {
    if (message.type == MessageType.text) {
      editingMessageId.value = message.messageId ?? '';
      textController.text = message.text;
      isTextFieldNotEmpty.value = true;
    }
  }

  void cancelEditing() {
    editingMessageId.value = '';
    textController.clear();
    isTextFieldNotEmpty.value = false;
  }

  // التعديل أصبح مستقراً 100% بالاعتماد على الـ String العادي للغرفة
  Future<void> updateMessage(String messageId, String newText) async {
    if (newText.trim().isEmpty) return;
    try {
      await _db.collection('ChatRooms')
          .doc(chatRoomId)
          .collection('Messages')
          .doc(messageId)
          .update({
        'text': newText.trim(),
        'isEdited': true,
      });
    } catch (e) {
      Get.snackbar("خطأ", "فشل تعديل الرسالة");
    }
  }

  // الحذف يعمل بكفاءة ودون أي تعليق في المسار
  Future<void> deleteMessage(String messageId) async {
    try {
      await _db.collection('ChatRooms')
          .doc(chatRoomId)
          .collection('Messages')
          .doc(messageId)
          .update({
        'type': 'deleted', 
        'text': 'تم حذف هذه الرسالة',
      });
    } catch (e) {
      Get.snackbar("خطأ", "فشل حذف الرسالة");
    }
  }

Future<void> _syncMessageToLaravel({
  required String type,
  required String? text,
  required String? fileUrl,
}) async {
  
  // إضافة طباعة للتأكد من أن الدالة تُستدعى أصلاً
  print("🔄 جاري محاولة مزامنة الرسالة للارافيل...");

  try {
    bool success = await _chatRepository.syncMessageToLaravel(
      chatRoomId: chatRoomId.toString(),
      senderId: currentUserId.toString(),
      type: type,
      text: text,
      fileUrl: fileUrl,
    );

    if (success) {
      print("✅ [Laravel Sync] تم الحفظ بنجاح في لارافيل");
    } else {
      // إذا وصلت هنا، فالطلب تم ولكن السيرفر رفضه (تحقق من الـ Print في الريبوزتري)
      print("❌ [Laravel Sync] السيرفر رفض الطلب (Check API logs)");
    }
  } catch (e) {
    print("❌ [Laravel Sync] خطأ غير متوقع: $e");
  }
}



  // معالجة حالة الإرسال بدقة: إما أن تخرج الرسالة كـ read فوراً إذا كان الطرف الآخر معنا في الغرفة، أو تخرج كـ sent
  Future<void> sendMessage() async {
    String msgText = textController.text.trim();
    if (msgText.isNotEmpty) {
      if (editingMessageId.value.isNotEmpty) {
        String targetMsgId = editingMessageId.value;
        cancelEditing(); 
        await updateMessage(targetMsgId, msgText);
        return;
      }

      try {
        textController.clear();
        isTextFieldNotEmpty.value = false;
        
        // تحديد الحالة البدئية للرسالة بناءً على تواجد الطرف الآخر لحظياً داخل الغرفة معاً
        MessageStatus finalStatus = isPeerOnlineInRoom.value ? MessageStatus.read : MessageStatus.sent;
        
        await _db.collection('ChatRooms')
            .doc(chatRoomId)
            .collection('Messages')
            .add(MessageModel(
              senderId: currentUserId,
              text: msgText,
              timestamp: DateTime.now(),
              type: MessageType.text,
              status: finalStatus, 
            ).toMap());
            
        _scrollToBottom();
        _syncMessageToLaravel(type: 'text', text: msgText, fileUrl: null);

      } catch (e) {
        Get.snackbar("خطأ", "فشل إرسال الرسالة");
        textController.text = msgText;
        isTextFieldNotEmpty.value = true;
      }
    }
  }

Future<void> uploadAndSendImage(ImageSource source) async {
  try {
    final XFile? pickedFile = await _picker.pickImage(source: source, imageQuality: 70);
    
    if (pickedFile != null) {
      isUploading.value = true;
      
      // 1. الرفع للارافيل والحصول على الرابط عبر الريبوزتري
      String? downloadUrl = await _chatRepository.uploadImageAndSync(
        filePath: pickedFile.path,
        chatRoomId: chatRoomId.toString(),
        senderId: currentUserId.toString(),
      );

      if (downloadUrl != null) {
        // 2. الرفع لفايربيس (كما كنت تفعل)
        MessageStatus finalStatus = isPeerOnlineInRoom.value ? MessageStatus.read : MessageStatus.sent;

        await _db.collection('ChatRooms')
            .doc(chatRoomId)
            .collection('Messages')
            .add(MessageModel(
              senderId: currentUserId,
              text: "أرسل صورة 🖼️", 
              timestamp: DateTime.now(),
              type: MessageType.image, 
              fileUrl: downloadUrl,
              status: finalStatus,    
            ).toMap());

        _scrollToBottom();
        print("✅ تم رفع وإرسال الصورة بنجاح عبر الريبوزتري!");
      } else {
        Get.snackbar("خطأ", "فشل رفع الصورة إلى السيرفر");
      }
    }
  } catch (e) {
    print("❌ خطأ أثناء معالجة الصورة: $e");
  } finally {
    isUploading.value = false;
  }
}

Future<void> pickAndSendGeneralFile() async {
  try {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx', 'txt', 'xlsx'],
    );

    if (result != null && result.files.single.path != null) {
      isUploading.value = true;
      String filePath = result.files.single.path!;
      String fileName = result.files.single.name;

      // 1. الرفع للارافيل عبر الريبوزتري
      String? downloadUrl = await _chatRepository.uploadFileAndSync(
        filePath: filePath,
        fileName: fileName,
        chatRoomId: chatRoomId.toString(),
        senderId: currentUserId.toString(),
      );

      if (downloadUrl != null) {
        // 2. الرفع لفايربيس
        MessageStatus finalStatus = isPeerOnlineInRoom.value ? MessageStatus.read : MessageStatus.sent;

        await _db.collection('ChatRooms')
            .doc(chatRoomId)
            .collection('Messages')
            .add(MessageModel(
              senderId: currentUserId,
              text: fileName,
              timestamp: DateTime.now(),
              type: MessageType.file,
              fileUrl: downloadUrl,
              status: finalStatus,
            ).toMap());

        _scrollToBottom();
        print("✅ تم رفع الملف وإرساله بنجاح!");
      } else {
        Get.snackbar("خطأ", "فشل رفع الملف إلى السيرفر");
      }
    }
  } catch (e) {
    Get.snackbar("خطأ ملفات", "فشل معالجة الملف: $e");
  } finally {
    isUploading.value = false;
  }
}



Future<void> openRemoteFile(String url, String fileName) async {
  isUploading.value = true;
  
  Get.snackbar(
    "جاري التحضير", 
    "جاري تجهيز الملف...",
    backgroundColor: Colors.blue.withOpacity(0.8),
    colorText: Colors.white,
    snackPosition: SnackPosition.BOTTOM,
  );

  try {
    // 1. طلب التحميل من الريبوزتري
    String? localPath = await _chatRepository.downloadFile(
      url: url,
      fileName: fileName,
    );

    if (localPath != null) {
      // 2. محاولة فتح الملف باستخدام OpenFilex
      final result = await OpenFilex.open(localPath);
      
      if (result.type != ResultType.done) {
        throw Exception(result.message);
      }
    } else {
      throw Exception("فشل التحميل");
    }

  } catch (e) {
    Get.snackbar(
      "تنبيه فتح الملف", 
      "لم نتمكن من فتح الملف. تأكد من وجود تطبيق قارئ مناسب على هاتفك.",
      backgroundColor: Colors.amber.withOpacity(0.9),
      snackPosition: SnackPosition.BOTTOM
    );
  } finally {
    isUploading.value = false;
  }
}

//   Future<void> startAudioRecording() async {
//     try {
//       if (Platform.isAndroid || Platform.isIOS) {
//         final directory = await getTemporaryDirectory();
//         _localAudioPath = '${directory.path}/audio_${DateTime.now().millisecondsSinceEpoch}.ogg';

//         await _audioRecorder.start(
//           const RecordConfig(
//             encoder: AudioEncoder.aacLc, // الـ AAC مدعوم من كل أجهزة أندرويد بلا استثناء
// sampleRate: 44100,         // التردد القياسي والأكثر استقراراً
// numChannels: 1
//             // encoder: AudioEncoder.opus,
//             // bitRate: 64000,    // 64kbps كافية جداً للصوت البشري وأسهل في الفك عبر الويب
//             // sampleRate: 16000, // 16kHz هي التردد المثالي لرسائل الواتساب والصوت وتمنع تشوه الحزم
//             // numChannels: 1,    // تسجيل أحادي (Mono) يسهل على المتصفح فك تشفيره فوراً
//           ), 
//           path: _localAudioPath!,
//         );
        
//         isRecording.value = true;
//       }
//     } catch (e) {
//       Get.snackbar("خطأ في المايك", "تعذر بدء التسجيل اللحظي: $e");
//     }
//   }
Future<void> startAudioRecording() async {
  try {
    // 1. التحقق من الصلاحيات أولاً بشكل صريح قبل أي شيء
    final hasPermission = await _audioRecorder.hasPermission();
    if (!hasPermission) {
      Get.snackbar("تنبيه", "يرجى إعطاء صلاحية الوصول للميكروفون من إعدادات الهاتف");
      return; // نوقف الدالة هنا لأن المايك ليس لديه صلاحية
    }

    if (Platform.isAndroid || Platform.isIOS) {
      final directory = await getTemporaryDirectory();
      
      // 2. تعديل الامتداد إلى .m4a ليتوافق تماماً مع الـ AAC الناتيف بالأندرويد
      _localAudioPath = '${directory.path}/audio_${DateTime.now().millisecondsSinceEpoch}.m4a';

      // 3. نقوم بتحديث الـ UI بأننا "بدأنا" المحاولة لتجهيز الأزرار
      isRecording.value = true;

      // 4. استدعاء دالة التسجيل بالإعدادات القياسية المستقرة
      await _audioRecorder.start(
        const RecordConfig(
          encoder: AudioEncoder.aacLc, // مدعوم عالمياً في أندرويد و iOS
          sampleRate: 44100,           // التردد القياسي الأكثر استقراراً ومنعاً لتشوه الحزم
          numChannels: 1,              // تسجيل أحادي (Mono) خفيف ومثالي للمحادثات الطبية والويب
          bitRate: 128000,             // دقة ممتازة ونقية جداً للصوت
        ), 
        path: _localAudioPath!,
      );
      
      print("🎯 بدأ التسجيل بنجاح، المسار: $_localAudioPath");
    }
  } catch (e) {
    // 5. الحماية القصوى: إذا فشل نظام أندرويد نرجع الواجهة فوراً لحالتها الطبيعية ولا تعلق
    isRecording.value = false;
    print("❌ فشل الأندرويد في بدء الـ PCM Reader: $e");
    Get.snackbar("خطأ في المايك", "الميكروفون مشغول حالياً أو تعذر بدء التسجيل اللحظي");
  }
}

Future<void> stopAndSendAudioRecording() async {
  try {
    final path = await _audioRecorder.stop();
    isRecording.value = false;

    if (path != null && _localAudioPath != null) {
      File audioFile = File(_localAudioPath!);
      if (await audioFile.exists() && await audioFile.length() > 0) {
        isUploading.value = true;

        // 1. الرفع للارافيل والحصول على الرابط عبر الريبوزتري
        String? downloadUrl = await _chatRepository.uploadAudioAndSync(
          filePath: _localAudioPath!,
          chatRoomId: chatRoomId.toString(),
          senderId: currentUserId.toString(),
        );

        if (downloadUrl != null) {
          // 2. الرفع لفايربيس
          var messageRef = _db.collection('ChatRooms')
              .doc(chatRoomId)
              .collection('Messages')
              .doc(); 

          _localAudioCacheMap[messageRef.id] = _localAudioPath!;

          MessageStatus finalStatus = isPeerOnlineInRoom.value ? MessageStatus.read : MessageStatus.sent;

          await messageRef.set(MessageModel(
            senderId: currentUserId,
            text: "تسجيل صوتي 🎤",
            timestamp: DateTime.now(),
            type: MessageType.audio,
            fileUrl: downloadUrl,
            status: finalStatus,
          ).toMap());

          _scrollToBottom();
          print("✅ تم رفع وإرسال التسجيل الصوتي بنجاح!");
        } else {
          Get.snackbar("خطأ", "فشل رفع التسجيل الصوتي للسيرفر");
        }
      }
    }
  } catch (e) {
    Get.snackbar("خطأ صوتي", "فشل حفظ أو رفع التسجيل: $e");
  } finally {
    isUploading.value = false;
  }
}

Future<void> playOrPauseAudio(String messageId, String url) async {
  try {
    // 1. منطق الإيقاف
    if (playingMessageId.value == messageId) {
      await _audioPlayer.pause();
      playingMessageId.value = '';
      return;
    }

    // 2. تجهيز اللاعب
    await _audioPlayer.stop();
    audioPosition.value = Duration.zero;
    audioDuration.value = Duration.zero;
    playingMessageId.value = messageId;

    // (حافظ على إعدادات الـ AudioContext هنا كما هي في كودك)
    
    // 3. الحصول على المسار من الريبوزتري (سواء كان محلياً أو بعد التحميل)
    String? localPath = await _chatRepository.getCachedAudioPath(messageId, url);

    if (localPath != null) {
      await _audioPlayer.play(DeviceFileSource(localPath));
    } else {
      throw Exception("فشل الحصول على ملف الصوت");
    }

  } catch (e) {
    print("❌ خطأ في تشغيل الصوت: $e");
    playingMessageId.value = '';
    Get.snackbar("خطأ", "تعذر تشغيل التسجيل الصوتي");
  }
}

  void seekAudio(Duration position) {
    _audioPlayer.seek(position);
  }

  void _scrollToBottom() {
    if (scrollController.hasClients) {
      scrollController.animateTo(0, 
        duration: const Duration(milliseconds: 300), 
        curve: Curves.easeOut);
    }
  }

  // 🎯 عند مغادرة الصفحة أو إغلاق الكنترولر: يتم إلغاء التواجد داخل الغرفة، وتغيير حالة الاتصال بالتطبيق لـ Offline وتسجيل وقت الخروج كآخر ظهور فوراً.
  @override
  void onClose() {

    WidgetsBinding.instance.removeObserver(this); // 4. لا تنسَ الإلغاء

    _setUserRoomPresence(false); // مغادرة غرفة الشات في الفايربيس
    _updateAppPresence(false);   // الخروج من التطبيق وحفظ الطابع الزمني لآخر ظهور
    
    textController.dispose();
    scrollController.dispose();
    _audioRecorder.dispose(); 
    _audioPlayer.dispose(); 
    super.onClose();
  }
}
