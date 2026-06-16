import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:raghad_pro/core/theme/app_colors.dart';
import 'dart:ui' as ui;

import 'package:raghad_pro/features/chat/controller/chatList_controller.dart';
/*
// استيراد مسارات الألوان والـ Controllers الخاصة بمشروعك
// تأكدي من تعديل المسارات أدناه بحسب الهيكلية الفعلية لمشروعك (مثلاً Medica Center)
// import 'package:new_test_getx/controller/ChatListController.dart'; 

class ClinicalChatWidget extends StatelessWidget {
  final bool isDark;

  const ClinicalChatWidget({
    super.key, 
    required this.isDark,
  });

  // دالة مساعدة لاستخراج الحرف الأول من الاسم بشكل نظيف
  String _getInitials(String name) {
    if (name.isEmpty) return "؟";
    
    String cleanName = name
        .replaceAll(RegExp(r'^(Dr\.|Prof\.|Mrs\.|Ms\.|السيد|الدكتور|الدكتورة)\s+'), '')
        .trim();
        
    if (cleanName.isEmpty) cleanName = name;
    
    return cleanName.substring(0, 1).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    // استدعاء أو إيجاد الـ الـ الـ Controller المستعمل لإدارة قائمة المحادثات
    final ChatListController chatController = Get.put(ChatListController(chatRepository: Get.find()));

    return Directionality(
      textDirection: ui.TextDirection.rtl,
      child: Container(
        color: isDark ? AppColors.darkBackground : const Color(0xFFF8FAFC),
        child: Column(
          children: [
            // 1. حقل البحث
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurface : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(isDark ? 0.2 : 0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    )
                  ],
                ),
                child: TextField(
                  onChanged: (value) => chatController.filterSearch(value),
                  style: TextStyle(color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
                  decoration: InputDecoration(
                    hintText: "بحث عن زميل...",
                    hintStyle: TextStyle(
                      color: isDark ? Colors.grey.shade500 : Colors.grey.shade400, 
                      fontSize: 14,
                      fontFamily: 'Cairo',
                    ),
                    prefixIcon: const Icon(Icons.search, color: AppColors.primaryTeal),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
            ),
            
            // 2. قائمة المحادثات
            Expanded(
              child: Obx(() {
                if (chatController.isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(color: AppColors.primaryTeal),
                  );
                }
                
                if (chatController.filteredChats.isEmpty) {
                  return Center(
                    child: Text(
                      "لا توجد محادثات مطابقة للبحث",
                      style: TextStyle(
                        color: isDark ? AppColors.darkTextPrimary.withOpacity(0.5) : Colors.grey,
                        fontFamily: 'Cairo',
                      ),
                    ),
                  );
                }
                
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  physics: const BouncingScrollPhysics(),
                  itemCount: chatController.filteredChats.length,
                  itemBuilder: (context, index) {
                    final chat = chatController.filteredChats[index];
                    
                    final bool isCurrentlySelected = chatController.activeChatId.value == chat.id;
                    final bool hasValidImage = chat.avatarUrl.isNotEmpty && 
                                               chat.avatarUrl != "group_placeholder" && 
                                               chat.avatarUrl != "null";

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkSurface : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: isCurrentlySelected 
                            ? Border.all(color: AppColors.primaryTeal, width: 2.0) 
                            : Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder.withOpacity(0.5)),
                        boxShadow: [
                          BoxShadow(
                            color: isCurrentlySelected
                                ? AppColors.primaryTeal.withOpacity(isDark ? 0.15 : 0.1)
                                : Colors.black.withOpacity(isDark ? 0.15 : 0.02),
                            blurRadius: isCurrentlySelected ? 12 : 8,
                            offset: const Offset(0, 4),
                          )
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: InkWell(
                          onTap: () => chatController.navigateToChat(chat),
                          child: Padding(
                            padding: const EdgeInsets.all(14.0),
                            child: Row(
                              children: [
                                // منطقة الصورة الشخصية / الحرف الأول
                                Stack(
                                  children: [
                                    CircleAvatar(
                                      radius: 28,
                                      backgroundColor: hasValidImage 
                                          ? AppColors.primaryTeal.withOpacity(0.1)
                                          : AppColors.primaryTeal.withOpacity(0.15),
                                      backgroundImage: hasValidImage
                                          ? NetworkImage(chat.avatarUrl)
                                          : null,
                                      child: !hasValidImage
                                          ? (chat.avatarUrl == "group_placeholder"
                                              ? const Icon(Icons.groups, color: AppColors.primaryTeal, size: 28)
                                              : Text(
                                                  _getInitials(chat.name),
                                                  style: const TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily: 'Cairo',
                                                    color: AppColors.primaryTeal,
                                                  ),
                                                ))
                                          : null,
                                    ),
                                    // نقطة حالة الاتصال (Active)
                                    if (chat.isActive)
                                      Positioned(
                                        bottom: 0,
                                        right: 2,
                                        child: Container(
                                          width: 14,
                                          height: 14,
                                          decoration: BoxDecoration(
                                            color: Colors.green,
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: isDark ? AppColors.darkSurface : Colors.white, 
                                              width: 2,
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                const SizedBox(width: 14),
                                
                                // تفاصيل الاسم، الدور، والرسالة الأخيرة
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Flexible(
                                            child: Text(
                                              chat.name,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'Cairo',
                                                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 6),
                                          Text(
                                            "(${chat.role})",
                                            maxLines: 1,
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontFamily: 'Cairo',
                                              color: isCurrentlySelected ? AppColors.primaryTeal : Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        chat.lastMessage,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontFamily: 'Cairo',
                                          color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 10),
                                
                                // الوقت وعدد الرسائل غير المقروءة
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      chat.time,
                                      maxLines: 1,
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontFamily: 'Cairo',
                                        color: isCurrentlySelected ? AppColors.primaryTeal : Colors.grey,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    if (chat.unreadCount > 0)
                                      Container(
                                        padding: const EdgeInsets.all(6),
                                        decoration: const BoxDecoration(
                                          color: AppColors.primaryTeal,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Text(
                                          "${chat.unreadCount}",
                                          style: const TextStyle(
                                            color: Colors.white, 
                                            fontSize: 10, 
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      )
                                    else
                                      const SizedBox(height: 22, width: 22),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

*/
class ClinicalChatWidget extends StatelessWidget {
  final bool isDark;

  const ClinicalChatWidget({
    super.key,
    required this.isDark,
  });

  // دالة مساعدة داخل الـ Widget لاستخراج الحرف الأول من الاسم بشكل نظيف
  String getInitials(String name) {
    if (name.isEmpty) return "؟";
    
    // تنظيف الاسم من الألقاب الشهيرة إذا كانت تعيق الحرف الأول الحقيقي (اختياري)
    String cleanName = name
        .replaceAll(RegExp(r'^(Dr\.|Prof\.|Mrs\.|Ms\.|السيد|الدكتور|الدكتورة)\s+'), '')
        .trim();
        
    if (cleanName.isEmpty) cleanName = name; // العودة للاسم الأصلي إن فرغ
    
    return cleanName.substring(0, 1).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final ChatListController chatController = Get.put(ChatListController());

    return Directionality(
      textDirection: ui.TextDirection.rtl,
      child: Container(
        color: isDark ? AppColors.darkBackground : const Color(0xFFF8FAFC),
        child: Column(
          children: [
            // 1. حقل البحث
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurface : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(isDark ? 0.2 : 0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    )
                  ],
                ),
                child: TextField(
                  onChanged: (value) => chatController.filterSearch(value),
                  style: TextStyle(color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
                  decoration: InputDecoration(
                    hintText: "بحث عن زميل...",
                    hintStyle: TextStyle(
                      color: isDark ? Colors.grey.shade500 : Colors.grey.shade400, 
                      fontSize: 14,
                      fontFamily: 'Cairo',
                    ),
                    prefixIcon: const Icon(Icons.search, color: AppColors.primaryTeal),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
            ),
            
            // 2. قائمة المحادثات
            Expanded(
              child: Obx(() {
                if (chatController.isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(color: AppColors.primaryTeal),
                  );
                }
                
                if (chatController.filteredChats.isEmpty) {
                  return Center(
                    child: Text(
                      "لا توجد محادثات مطابقة للبحث",
                      style: TextStyle(
                        color: isDark ? AppColors.darkTextPrimary.withOpacity(0.5) : Colors.grey,
                        fontFamily: 'Cairo',
                      ),
                    ),
                  );
                }
                
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  physics: const BouncingScrollPhysics(),
                  itemCount: chatController.filteredChats.length,
                  itemBuilder: (context, index) {
                    final chat = chatController.filteredChats[index];
                    
                    // فحص ديناميكي: هل هذه هي المحادثة المحددة حالياً؟
                    final bool isCurrentlySelected = chatController.activeChatId.value == chat.id;
                    
                    // فحص وجود الصورة الشخصية وصلاحيتها
                    final bool hasValidImage = chat.avatarUrl.isNotEmpty && 
                                              chat.avatarUrl != "group_placeholder" && 
                                              chat.avatarUrl != "null";

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkSurface : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: isCurrentlySelected 
                            ? Border.all(color: AppColors.primaryTeal, width: 2.0) 
                            : Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder.withOpacity(0.5)),
                        boxShadow: [
                          BoxShadow(
                            color: isCurrentlySelected
                                ? AppColors.primaryTeal.withOpacity(isDark ? 0.15 : 0.1)
                                : Colors.black.withOpacity(isDark ? 0.15 : 0.02),
                            blurRadius: isCurrentlySelected ? 12 : 8,
                            offset: const Offset(0, 4),
                          )
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: InkWell(
                          onTap: () => chatController.navigateToChat(chat),
                          child: Padding(
                            padding: const EdgeInsets.all(14.0),
                            child: Row(
                              children: [
                                // 🌟 منطقة الصورة الشخصية / الحرف الأول
                                Stack(
                                  children: [
                                    CircleAvatar(
                                      radius: 28,
                                      backgroundColor: hasValidImage 
                                          ? AppColors.primaryTeal.withOpacity(0.1)
                                          : AppColors.primaryTeal.withOpacity(0.15),
                                      backgroundImage: hasValidImage
                                          ? NetworkImage(chat.avatarUrl)
                                          : null,
                                      child: !hasValidImage
                                          ? (chat.avatarUrl == "group_placeholder"
                                              ? const Icon(Icons.groups, color: AppColors.primaryTeal, size: 28)
                                              : Text(
                                                  getInitials(chat.name),
                                                  style: const TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily: 'Cairo',
                                                    color: AppColors.primaryTeal,
                                                  ),
                                                ))
                                          : null,
                                    ),
                                    // نقطة الأونلاين (تظهر إذا كان الطبيب متصلاً حالياً)
                                    if (chat.isActive)
                                      Positioned(
                                        bottom: 0,
                                        right: 2,
                                        child: Container(
                                          width: 14,
                                          height: 14,
                                          decoration: BoxDecoration(
                                            color: Colors.green,
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: isDark ? AppColors.darkSurface : Colors.white, 
                                              width: 2,
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                const SizedBox(width: 14),
                                
                                // تفاصيل الاسم، الدور، والرسالة الأخيرة
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Flexible(
                                            child: Text(
                                              chat.name,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'Cairo',
                                                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 6),
                                          Text(
                                            "(${chat.role})",
                                            maxLines: 1,
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontFamily: 'Cairo',
                                              color: isCurrentlySelected ? AppColors.primaryTeal : Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        chat.lastMessage,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontFamily: 'Cairo',
                                          color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 10),
                                
                                // الوقت وعدد الرسائل غير المقروءة
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      chat.time,
                                      maxLines: 1,
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontFamily: 'Cairo',
                                        color: isCurrentlySelected ? AppColors.primaryTeal : Colors.grey,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    if (chat.unreadCount > 0)
                                      Container(
                                        padding: const EdgeInsets.all(6),
                                        decoration: const BoxDecoration(
                                          color: AppColors.primaryTeal,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Text(
                                          "${chat.unreadCount}",
                                          style: const TextStyle(
                                            color: Colors.white, 
                                            fontSize: 10, 
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      )
                                    else
                                      const SizedBox(height: 22, width: 22),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
