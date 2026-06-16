import 'package:get/get.dart';
import 'package:raghad_pro/core/api/api_consumer.dart';
import 'package:raghad_pro/core/api/end_point.dart';
import 'package:raghad_pro/core/cache/cashe_helper_getStorage.dart';
import 'package:raghad_pro/core/helper/alert_helper.dart'; // استيراد الـ AlertHelper الخاص بكِ
import 'package:raghad_pro/features/chat/controller/chat_controller.dart';
import 'package:raghad_pro/features/chat/data/model/chat_model.dart';
import 'package:raghad_pro/features/chat/data/repositry/chat_repostry.dart';
/*
class ChatBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChatRepository>(() => ChatRepository(Get.find<ApiConsumer>()), fenix: true);

    Get.lazyPut<ChatListController>(() => ChatListController(chatRepository: Get.find<ChatRepository>()));

    Get.lazyPut<ChatController>(() => ChatController(chatRepository: Get.find<ChatRepository>()), fenix: true);
    
   /* Get.lazyPut<ChatRepository>(() => ChatRepository(Get.find<ApiConsumer>()));

    Get.lazyPut<ChatListController>(() => ChatListController(chatRepository: Get.find<ChatRepository>()));

    Get.lazyPut<ChatController>(() => ChatController(chatRepository: Get.find<ChatRepository>()), fenix: true);*/
  }
}

class ChatListController extends GetxController {
  final ChatRepository chatRepository;
  ChatListController({required this.chatRepository});

  var isLoading = false.obs;
  var activeChatId = "".obs;
  var allChats = <ChatListItem>[].obs;
  var filteredChats = <ChatListItem>[].obs;
  String currentUserId = ""; 

  

  @override
  void onInit() {
    super.onInit();
    fetchChats();
  }

  void fetchChats() async {
    isLoading.value = true;
    
    final result = await chatRepository.getPotentialContactsWithUser();

    result.fold(
      (errorMessage) {
        isLoading.value = false;
        
        AlertHelper.showSnackbar(
          title: "تنبيه",
          message: errorMessage,
          type: AlertType.error,
        );
      },
      (responseMap) async {
       
        if (responseMap['current_user'] != null) {
          currentUserId = responseMap['current_user']['id'].toString();
          await CacheHelperGetStorage.saveData(key: ApiKey.uuid, value: currentUserId);
          print("✅ [Cache Support] تم حفظ الـ ID المحدث في كاش Medica: $currentUserId");
        }

        List<dynamic> rawData = responseMap['data'] ?? [];
        List<ChatListItem> loadedChats = rawData.map((json) => ChatListItem.fromJson(json)).toList();

        allChats.assignAll(loadedChats);
        filteredChats.assignAll(loadedChats);
      },
    );

    isLoading.value = false;
  }  void filterSearch(String query) {
    if (query.isEmpty) {
      filteredChats.assignAll(allChats);
    } else {
      filteredChats.assignAll(
        allChats.where((chat) => 
          chat.name.toLowerCase().contains(query.toLowerCase()) || 
          chat.role.toLowerCase().contains(query.toLowerCase())
        ).toList()
      );
    }
  }

  // الانتقال لغرفة الشات وتصفير الـ unreadCount محلياً
  void navigateToChat(ChatListItem chat) {
    activeChatId.value = chat.id;

    final index = allChats.indexWhere((element) => element.id == chat.id);
    if (index != -1) {
      allChats[index] = ChatListItem(
        id: chat.id,
        name: chat.name,
        role: chat.role,
        lastMessage: chat.lastMessage,
        time: chat.time,
        avatarUrl: chat.avatarUrl,
        unreadCount: 0, 
        isActive: chat.isActive,
      );
    }

    final filteredIndex = filteredChats.indexWhere((element) => element.id == chat.id);
    if (filteredIndex != -1) {
      filteredChats[filteredIndex] = allChats[index];
    }

    allChats.refresh();
    filteredChats.refresh();

    // الانتقال للواجهة وتمرير المعرفات المستخرجة من الكاش والسيرفر
    Get.toNamed('/chat-view', arguments: {
      'targetId': chat.id,              
      'currentUserId': currentUserId.isEmpty 
          ? CacheHelperGetStorage.getData(key: ApiKey.uuid)?.toString() ?? "" 
          : currentUserId,
      'chatName': chat.name,
      'avatarUrl': chat.avatarUrl,
      'isActive': chat.isActive,
    });
  }
}
*/


class ChatListController extends GetxController {
  final ChatRepository _chatRepository = ChatRepository();

  var isLoading = false.obs;
  var activeChatId = "".obs;
  
  var allChats = <ChatListItem>[].obs;
  var filteredChats = <ChatListItem>[].obs;

  // 🎯 استقبال الـ id الحالي للطبيب ديناميكياً من الـ current_user
  String currentUserId = ""; 

  @override
  void onInit() {
    super.onInit();
    fetchChats();
  }

  void fetchChats() async {
    isLoading.value = true;
    try {
      final responseMap = await _chatRepository.getPotentialContactsWithUser();

      // 🎯 التقاط معرّف الطبيب الحالي الحقيقي (id: 7)
      if (responseMap['current_user'] != null) {
        currentUserId = responseMap['current_user']['id'].toString();
        print("✅ تم التقاط ID الطبيب الحالي من السيرفر: $currentUserId");
      }

      List<dynamic> rawData = responseMap['data'] ?? [];
      List<ChatListItem> loadedChats = rawData.map((json) => ChatListItem.fromJson(json)).toList();

      allChats.assignAll(loadedChats);
      filteredChats.assignAll(loadedChats);
        } catch (e) {
      print("Error fetching chats in Controller: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void filterSearch(String query) {
    if (query.isEmpty) {
      filteredChats.assignAll(allChats);
    } else {
      filteredChats.assignAll(
        allChats.where((chat) => chat.name.toLowerCase().contains(query.toLowerCase()) || 
                                 chat.role.toLowerCase().contains(query.toLowerCase())).toList()
      );
    }
  }

  void navigateToChat(ChatListItem chat) {
    activeChatId.value = chat.id;

    final index = allChats.indexWhere((element) => element.id == chat.id);
    if (index != -1) {
      allChats[index] = ChatListItem(
        id: chat.id,
        name: chat.name,
        role: chat.role,
        lastMessage: chat.lastMessage,
        time: chat.time,
        avatarUrl: chat.avatarUrl,
        unreadCount: 0, 
        isActive: chat.isActive,
      );
    }

    final filteredIndex = filteredChats.indexWhere((element) => element.id == chat.id);
    if (filteredIndex != -1) {
      filteredChats[filteredIndex] = allChats[index];
    }

    allChats.refresh();
    filteredChats.refresh();

    // تمرير المعرفات الحقيقية والديناميكية بالكامل
    Get.toNamed('/chat-view', arguments: {
      'targetId': chat.id,              
      'currentUserId': currentUserId, // يمرر المعرف "7" المأخوذ من السيرفر تلقائياً
      'chatName': chat.name,
      'avatarUrl': chat.avatarUrl,
      'isActive': chat.isActive,
    });
  }
}