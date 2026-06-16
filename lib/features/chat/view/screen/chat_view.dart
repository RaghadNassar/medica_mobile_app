

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:raghad_pro/core/api/apiEndpoints.dart';
import 'package:raghad_pro/core/theme/app_colors.dart';
import 'package:raghad_pro/features/chat/controller/chat_controller.dart';
import 'package:raghad_pro/features/chat/data/model/message_model.dart';


class ChatView extends StatelessWidget {
  
  const ChatView({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final ChatController controller = Get.put(ChatController());

    // استقبال معطيات المحادثة الممررة ديناميكياً
    final Map<String, dynamic> args = Get.arguments ?? {};
    final String chatName = args['chatName'] ?? "المحادثة الفورية";
    final String avatarUrl = args['avatarUrl'] ?? "";
    final bool isActive = args['isActive'] ?? false;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
appBar: AppBar(
  backgroundColor: AppColors.primaryTeal,
  elevation: 0,
  iconTheme: const IconThemeData(color: Colors.white),
  automaticallyImplyLeading: false,
  title: SizedBox(
    width: double.infinity,
    height: kToolbarHeight,
    child: Stack(
      alignment: Alignment.center,
      children: [
        // زر الرجوع
        Positioned(
          left: 0,
          child: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Get.back(),
          ),
        ),

        // الصورة الشخصية مع مؤشر الحالة (التحسين: Obx واحد يغطي الحالة فقط)
        Positioned(
          right: 0,
          child: Stack(
            children: [
              CircleAvatar(
                radius: 19,
                backgroundColor: Colors.white.withOpacity(0.2),
                backgroundImage: (avatarUrl.isNotEmpty && avatarUrl != "group_placeholder")
                    ? NetworkImage(avatarUrl)
                    : null,
                child: (avatarUrl == "group_placeholder")
                    ? const Icon(Icons.groups, color: Colors.white, size: 20)
                    : (avatarUrl.isEmpty ? const Icon(Icons.person, color: Colors.white, size: 20) : null),
              ),
              
              // استخدام Obx هنا سيجعل النقطة تظهر وتختفي لحظياً دون إعادة بناء كل الـ AppBar
              Obx(() => controller.isPeerOnlineInApp.value 
                ? Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: Colors.greenAccent,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.primaryTeal, width: 2),
                      ),
                    ),
                  )
                : const SizedBox.shrink() // استخدام SizedBox.shrink بدلاً من لا شيء لتجنب مشاكل الـ Layout
              ),
            ],
          ),
        ),

        // اسم الطرف الآخر وحالته
        Positioned(
          right: 48,
          left: 48,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                chatName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  fontFamily: 'Cairo',
                ),
              ),
              // الـ Obx هنا يراقب نص الحالة واللون معاً
              Obx(() => Text(
                controller.peerLastSeenStr.value, 
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: controller.isPeerOnlineInApp.value ? Colors.greenAccent : Colors.white70,
                  fontSize: 10,
                  fontFamily: 'Cairo',
                ),
              )),
            ],
          ),
        ),
      ],
    ),
  ),
),

      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              if (controller.messages.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.chat_bubble_outline, size: 44, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                      const SizedBox(height: 12),
                      Text(
                        "لا توجد رسائل سابقة. ابدأ المحادثة الآن",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                        ),
                      ),
                    ],
                  ),
                );
              }
              return ListView.builder(
                controller: controller.scrollController,
                reverse: true,
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: controller.messages.length,
                itemBuilder: (context, index) {
                  final message = controller.messages[index];
                  bool isMe = message.senderId == controller.currentUserId;
                  return _buildMessageBubble(context, controller, message, isMe, isDark);
                },
              );
            }),
          ),
          Obx(() => controller.isUploading.value
              ? LinearProgressIndicator(color: AppColors.primaryTeal)
              : const SizedBox.shrink()),
          _buildInputArea(context, controller, isDark),
        ],
      ),
    );
  }

  Widget _buildStatusIcon(MessageStatus status, bool isDark) {
    switch (status) {
      case MessageStatus.sending:
        return Icon(Icons.access_time_rounded, size: 13, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary);
      case MessageStatus.sent:
        return Icon(Icons.done, size: 14, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary);
      case MessageStatus.delivered:
        return Icon(Icons.done_all, size: 14, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary);
      case MessageStatus.read:
        return Icon(Icons.done_all, size: 14, color: AppColors.accentOrange);
    }
  }

  Widget _buildMessageBubble(BuildContext context, ChatController controller, MessageModel message, bool isMe, bool isDark) {
    String originalUrl = message.fileUrl ?? "";
    String safeUrl = originalUrl.replaceAll(RegExp(ApiEndpoints.socketUrl), ApiEndpoints.socketPath);

    // التعامل مع الرسائل المحذوفة بشكل فوري في الواجهة لراحة الطبيب والمريض
    if (message.type.toString().contains('deleted') || message.text == 'تم حذف هذه الرسالة') {
      return Align(
        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 3),
          padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
          decoration: BoxDecoration(
            color: isDark ? Colors.grey.withOpacity(0.1) : Colors.grey.withOpacity(0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.block, size: 14, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
              const SizedBox(width: 5),
              Text(
                "تم حذف هذه الرسالة",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontStyle: FontStyle.italic,
                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                ),
              ),
            ],
          ),
        ),
      );
    }

    Color bubbleColor;
    if (isMe) {
      bubbleColor = isDark ? AppColors.darkSurface : AppColors.primaryTeal.withOpacity(0.15);
    } else {
      bubbleColor = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    }

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: GestureDetector(
        // 🎯 تفعيل الضغط المطول لإظهار خيارات الحذف والتعديل للرسائل الخاصة بالمستخدم فقط
        onLongPress: () {
          if (isMe && message.type == MessageType.text) {
            _showOptionsBottomSheet(context, controller, message, isDark);
          } else if (isMe) {
            // خيار الحذف فقط لرسائل الميديا والصوتيات
            _showDeleteOnlyBottomSheet(context, controller, message, isDark);
          }
        },
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 3),
          padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
          constraints: BoxConstraints(maxWidth: Get.width * 0.78),
          decoration: BoxDecoration(
            color: bubbleColor,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(12),
              topRight: const Radius.circular(12),
              bottomLeft: Radius.circular(isMe ? 12 : 2),
              bottomRight: Radius.circular(isMe ? 2 : 12),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(isDark ? 0.15 : 0.04),
                blurRadius: 1.5,
                offset: const Offset(0, 1),
              )
            ],
          ),
          child: Column(
            crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
             if (message.type == MessageType.image)
  GestureDetector(
    onTap: () {
      // 🎯 جلب الرابط المضمون والكامل عند الضغط للتكبير
      String finalUrl = message.fileUrl ?? '';
      
      // إذا كان الرابط المخزن مجرد اسم ملف وليس رابط كامل، نصلحه تلقائياً
      if (finalUrl.isNotEmpty && !finalUrl.startsWith('http')) {
        // finalUrl = 'http://10.113.180.45:8000/storage/chat/$finalUrl';

           finalUrl = '${ApiEndpoints.socketPath}/storage/chat/$finalUrl';

      }

      if (finalUrl.isNotEmpty) {
        Get.to(() => Scaffold(
          appBar: AppBar(backgroundColor: Colors.black, iconTheme: const IconThemeData(color: Colors.white)),
          backgroundColor: Colors.black,
          body: Center(
            child: Image.network(
              finalUrl,
              headers: const {"Connection": "Keep-Alive", "Accept": "image/*"},
              errorBuilder: (context, error, stackTrace) => const Center(
                child: Icon(Icons.broken_image, color: Colors.white, size: 80),
              ),
            ),
          ),
        ));
      }
    },
    child: ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Builder(
        builder: (context) {
          // 🎯 التعديل الذهبي: القراءة مباشرة من message.fileUrl المطابق لكود الرفع الخاص بك
          String imageUrl = message.fileUrl ?? '';
          
          // تأمين الحالات التي يرجع فيها السيرفر اسم الملف فقط بدلاً من الرابط الكامل
          if (imageUrl.isNotEmpty && !imageUrl.startsWith('http')) {
            // imageUrl = 'http://10.113.180.45:8000/storage/chat/$imageUrl';

              imageUrl = '${ApiEndpoints.socketPath}/storage/chat/$imageUrl';
          }

          print("🖼️ [UI Render Check] الرابط الذي تحاول الواجهة عرضه الآن هو: $imageUrl");

          if (imageUrl.isEmpty) {
            return _buildBrokenImagePlaceholder(isDark);
          }

          return Image.network(
            imageUrl, // 👈 استبدال safeUrl بـ imageUrl المضمونة
            width: 220,
            height: 220,
            fit: BoxFit.cover,
            headers: const {"Connection": "Keep-Alive", "Accept": "image/*"},
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Container(
                width: 220,
                height: 220,
                color: (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary).withOpacity(0.1),
                child: Center(child: CircularProgressIndicator(color: AppColors.primaryTeal)),
              );
            },
            errorBuilder: (context, error, stackTrace) {
              print("❌ [UI errorBuilder] فشل تحميل الصورة من الرابط: $imageUrl. السبب: $error");
              return _buildBrokenImagePlaceholder(isDark);
            },
          );
        },
      ),
    ),
  )

              else if (message.type == MessageType.audio)
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  width: 235,
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (message.fileUrl != null) {
                            controller.playOrPauseAudio(message.messageId ?? '', message.fileUrl!);
                          }
                        },
                        child: Obx(() {
                          bool isCurrentPlaying = controller.playingMessageId.value == message.messageId;
                          return CircleAvatar(
                            radius: 17,
                            backgroundColor: AppColors.primaryTeal,
                            child: Icon(
                              isCurrentPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                              color: Colors.white,
                              size: 20,
                            ),
                          );
                        }),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Obx(() {
                          bool isCurrentPlaying = controller.playingMessageId.value == message.messageId;
                          double maxDuration = isCurrentPlaying ? controller.audioDuration.value.inMilliseconds.toDouble() : 1.0;
                          double currentPos = isCurrentPlaying ? controller.audioPosition.value.inMilliseconds.toDouble() : 0.0;

                          if (currentPos > maxDuration) currentPos = maxDuration;
                          if (maxDuration <= 0) maxDuration = 1.0;

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SliderTheme(
                                data: SliderTheme.of(context).copyWith(
                                  thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 5),
                                  trackHeight: 2.5,
                                  activeTrackColor: AppColors.primaryTeal,
                                  inactiveTrackColor: (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary).withOpacity(0.3),
                                  thumbColor: AppColors.primaryTeal,
                                ),
                                child: Slider(
                                  min: 0.0,
                                  max: maxDuration,
                                  value: currentPos,
                                  onChanged: (value) {
                                    if (isCurrentPlaying) {
                                      controller.seekAudio(Duration(milliseconds: value.toInt()));
                                    }
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                child: Text(
                                  isCurrentPlaying
                                      ? "${_printDuration(controller.audioPosition.value)} / ${_printDuration(controller.audioDuration.value)}"
                                      : "00:00",
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 10, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                                ),
                              )
                            ],
                          );
                        }),
                      ),
                      Icon(Icons.mic, color: AppColors.primaryTeal, size: 19),
                    ],
                  ),
                )

              else if (message.type == MessageType.file)
                GestureDetector(
                  onTap: () {
                    if (message.fileUrl != null) {
                      controller.openRemoteFile(message.fileUrl!, message.text);
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: (isDark ? AppColors.darkBorder : AppColors.lightBorder).withOpacity(0.05),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: (isDark ? AppColors.darkBorder : AppColors.lightBorder).withOpacity(0.2)),
                    ),
                    width: 220,
                    child: Row(
                      children: [
                        const Icon(Icons.insert_drive_file_rounded, color: Colors.redAccent, size: 30),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                message.text,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold, fontSize: 12),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                "انقر للتحميل والفتح",
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 9, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )

              else
                Text(
                  message.text,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 15),
                ),

              const SizedBox(height: 3),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // إشارة توضيحية خفيفة إذا كانت الرسالة معدلة سابقاً
                  if (message.text != 'تم حذف هذه الرسالة' && message.type == MessageType.text)
                    // نفترض هنا وجود حقل اختياري في الموديل لديك، إذا لم يتوفر لن تسبب خطأ بفضل معالجة التحديث
                    FutureBuilder(
                      future: Future.value(false), // مكان لحفظ حالة التعديل مستقبلاً لو أردت
                      builder: (context, snapshot) => const SizedBox.shrink()
                    ),
                  Text(
                    DateFormat('hh:mm a').format(message.timestamp),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 9, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                  ),
                  if (isMe) ...[
                    const SizedBox(width: 4),
                    _buildStatusIcon(message.status, isDark),
                  ]
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _printDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }


Widget _buildBrokenImagePlaceholder(bool isDark) {
  return Container(
    width: 220,
    height: 220,
    color: (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary).withOpacity(0.2),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.broken_image, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary, size: 40),
        const SizedBox(height: 6),
        Text(
          "تعذر تحميل الصورة",
          style: TextStyle(fontSize: 11, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
        ),
      ],
    ),
  );
}
Widget _buildInputArea(BuildContext context, ChatController controller, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      color: Colors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // شريط علوي يظهر فقط عند دخول وضع التعديل (WhatsApp Style)
          Obx(() {
            if (controller.editingMessageId.value.isNotEmpty) {
              return Container(
                margin: const EdgeInsets.only(bottom: 5, left: 4, right: 4),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurface : Colors.teal.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border(right: BorderSide(color: AppColors.primaryTeal, width: 4)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.edit, color: AppColors.primaryTeal, size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "تعديل الرسالة...",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.primaryTeal,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => controller.cancelEditing(),
                      child: const Icon(Icons.close, color: Colors.redAccent, size: 18),
                    ),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          }),
          
          // منطقة الإدخال الأساسية مجمعة داخل Obx واحد لمنع التداخل والتعليق
          Obx(() {
            bool recording = controller.isRecording.value;
            bool showSendButton = controller.isTextFieldNotEmpty.value;

            return Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(isDark ? 0.15 : 0.05),
                          blurRadius: 2,
                          offset: const Offset(0, 1),
                        )
                      ],
                    ),
                    child: Row(
                      children: [
                        // إخفاء أزرار المرفقات أثناء التسجيل لمنع الأخطاء
                        if (!recording) ...[
                          IconButton(
                            icon: Icon(Icons.attach_file, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                            onPressed: () => controller.pickAndSendGeneralFile(),
                          ),
                          IconButton(
                            icon: Icon(Icons.camera_alt, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                            onPressed: () => _showImageSourceDialog(context, controller, isDark),
                          ),
                        ],
                        
                        Expanded(
                          child: recording
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
                                  child: Row(
                                    children: [
                                      const SizedBox(
                                        width: 8,
                                        height: 8,
                                        child: CircularProgressIndicator(strokeWidth: 1.5, color: Colors.red),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        "جاري تسجيل الصوت الآن...",
                                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                          color: AppColors.error, 
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Cairo'
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : TextField(
                                  controller: controller.textController,
                                  onChanged: (text) => controller.updateTypedText(text),
                                  maxLines: null,
                                  style: Theme.of(context).textTheme.bodyLarge,
                                  decoration: InputDecoration(
                                    hintText: "اكتب رسالتك هنا...",
                                    hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                                      fontFamily: 'Cairo'
                                    ),
                                    border: InputBorder.none,
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                
                // زر الإرسال / التسجيل الموحد الحساس لتغير الحالة
                CircleAvatar(
                  radius: 23,
                  backgroundColor: recording ? AppColors.error : AppColors.primaryTeal,
                  child: IconButton(
                    icon: showSendButton && !recording
                        ? const Icon(Icons.send, color: Colors.white, size: 22)
                        : Icon(
                            recording ? Icons.stop : Icons.mic,
                            color: Colors.white,
                            size: 22,
                          ),
                    onPressed: () {
                      if (showSendButton && !recording) {
                        controller.sendMessage();
                      } else {
                        if (!recording) {
                          controller.startAudioRecording();
                        } else {
                          // هنا يتم الإيقاف والإرسال فوراً
                          controller.stopAndSendAudioRecording();
                        }
                      }
                    },
                  ),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }

  // Widget _buildInputArea(BuildContext context, ChatController controller, bool isDark) {
  //   return Container(
  //     padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
  //     color: Colors.transparent,
  //     child: Column(
  //       mainAxisSize: MainAxisSize.min,
  //       children: [
  //         // 🎯 شريط علوي يظهر فقط عند دخول وضع التعديل (WhatsApp Style)
  //         Obx(() {
  //           if (controller.editingMessageId.value.isNotEmpty) {
  //             return Container(
  //               margin: const EdgeInsets.only(bottom: 5, left: 4, right: 4),
  //               padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
  //               decoration: BoxDecoration(
  //                 color: isDark ? AppColors.darkSurface : Colors.teal.withOpacity(0.1),
  //                 borderRadius: BorderRadius.circular(10),
  //                 border: Border(right: BorderSide(color: AppColors.primaryTeal, width: 4)),
  //               ),
  //               child: Row(
  //                 children: [
  //                   Icon(Icons.edit, color: AppColors.primaryTeal, size: 16),
  //                   const SizedBox(width: 8),
  //                   Expanded(
  //                     child: Text(
  //                       "تعديل الرسالة...",
  //                       style: Theme.of(context).textTheme.bodyMedium?.copyWith(
  //                         color: AppColors.primaryTeal,
  //                         fontWeight: FontWeight.bold
  //                       ),
  //                     ),
  //                   ),
  //                   GestureDetector(
  //                     onTap: () => controller.cancelEditing(),
  //                     child: Icon(Icons.close, color: Colors.redAccent, size: 18),
  //                   ),
  //                 ],
  //               ),
  //             );
  //           }
  //           return const SizedBox.shrink();
  //         }),
  //         Row(
  //           children: [
  //             Expanded(
  //               child: Container(
  //                 decoration: BoxDecoration(
  //                   color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
  //                   borderRadius: BorderRadius.circular(25),
  //                   boxShadow: [
  //                     BoxShadow(
  //                       color: Colors.black.withOpacity(isDark ? 0.15 : 0.05),
  //                       blurRadius: 2,
  //                       offset: const Offset(0, 1),
  //                     )
  //                   ],
  //                 ),
  //                 child: Row(
  //                   children: [
  //                     IconButton(
  //                       icon: Icon(Icons.attach_file, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
  //                       onPressed: () => controller.pickAndSendGeneralFile(),
  //                     ),
  //                     IconButton(
  //                       icon: Icon(Icons.camera_alt, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
  //                       onPressed: () => _showImageSourceDialog(context, controller, isDark),
  //                     ),
  //                     Expanded(
  //                       child: Obx(() {
  //                         return controller.isRecording.value
  //                             ? Padding(
  //                                 padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
  //                                 child: Text(
  //                                   "🔴 جاري تسجيل الصوت الآن...",
  //                                   style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.error, fontWeight: FontWeight.bold),
  //                                 ),
  //                               )
  //                             : TextField(
  //                                 controller: controller.textController,
  //                                 onChanged: (text) => controller.updateTypedText(text),
  //                                 maxLines: null,
  //                                 style: Theme.of(context).textTheme.bodyLarge,
  //                                 decoration: InputDecoration(
  //                                   hintText: "اكتب رسالتك هنا...",
  //                                   hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
  //                                   border: InputBorder.none,
  //                                   contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
  //                                 ),
  //                               );
  //                       }),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ),
  //             const SizedBox(width: 6),
  //             Obx(() {
  //               bool showSendButton = controller.isTextFieldNotEmpty.value;
  //               bool recording = controller.isRecording.value;

  //               return CircleAvatar(
  //                 radius: 23,
  //                 backgroundColor: recording ? AppColors.error : AppColors.primaryTeal,
  //                 child: IconButton(
  //                   icon: showSendButton
  //                       ? Icon(Icons.send, color: Colors.white, size: 22)
  //                       : Icon(
  //                           recording ? Icons.stop : Icons.mic,
  //                           color: Colors.white,
  //                           size: 22,
  //                         ),
  //                   onPressed: () {
  //                     if (showSendButton) {
  //                       controller.sendMessage();
  //                     } else {
  //                       if (!recording) {
  //                         controller.startAudioRecording();
  //                       } else {
  //                         controller.stopAndSendAudioRecording();
  //                       }
  //                     }
  //                   },
  //                 ),
  //               );
  //             }),
  //           ],
  //         ),
  //       ],
  //     ),
  //   );
  // }

  void _showImageSourceDialog(BuildContext context, ChatController controller, bool isDark) {
    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Wrap(
          spacing: 20,
          children: [
            Center(
              child: Container(
                width: 40, height: 4,
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: CircleAvatar(
                backgroundColor: (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary).withOpacity(0.1),
                child: Icon(Icons.camera_alt, color: AppColors.primaryTeal),
              ),
              title: Text(
                'التقاط عبر الكاميرا',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                ),
              ),




               onTap: () { Get.back(); controller.uploadAndSendImage(ImageSource.camera); },

            ),
            ListTile(
              leading: CircleAvatar(
                backgroundColor: (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary).withOpacity(0.1),
                child: Icon(Icons.photo_library, color: AppColors.primaryTeal),
              ),
              title: Text(
                'اختيار من معرض الصور',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600,
                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,),
              ),
              onTap: () { Get.back(); controller.uploadAndSendImage(ImageSource.gallery); },
            ),
          ],
        ),
      ),
    );
  }

  // 🎯 قائمة خيارات التعديل والحذف للرسائل النصية
  void _showOptionsBottomSheet(BuildContext context, ChatController controller, MessageModel message, bool isDark) {
    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          borderRadius: const BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25)),
        ),
        child: SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.edit, color: Colors.blue),
                title: const Text('تعديل الرسالة'),
                onTap: () {
                  Get.back();
                  controller.startEditing(message);
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete_forever, color: Colors.redAccent),
                title: const Text('حذف الرسالة للجميع'),
                onTap: () {
                  Get.back();
                  if (message.messageId != null) {
                    controller.deleteMessage(message.messageId!);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 🎯 قائمة خيار الحذف فقط لرسائل الميديا (صوت، صور، ملفات)
  void _showDeleteOnlyBottomSheet(BuildContext context, ChatController controller, MessageModel message, bool isDark) {
    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          borderRadius: const BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25)),
        ),
        child: SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.delete_forever, color: Colors.redAccent),
                title: const Text('حذف الرسالة للجميع'),
                onTap: () {
                  Get.back();
                  if (message.messageId != null) {
                    controller.deleteMessage(message.messageId!);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

}


// class ChatView extends StatelessWidget {
  
//   const ChatView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final bool isDark = Theme.of(context).brightness == Brightness.dark;
//     final ChatController controller = Get.put(ChatController(chatRepository: Get.find()));

//     // استقبال معطيات المحادثة الممررة ديناميكياً
//     final Map<String, dynamic> args = Get.arguments ?? {};
//     final String chatName = args['chatName'] ?? "المحادثة الفورية";
//     final String avatarUrl = args['avatarUrl'] ?? "";
//     final bool isActive = args['isActive'] ?? false;

//     return Scaffold(
//       backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
// appBar: AppBar(
//   backgroundColor: AppColors.primaryTeal,
//   elevation: 0,
//   iconTheme: const IconThemeData(color: Colors.white),
//   automaticallyImplyLeading: false,
//   title: SizedBox(
//     width: double.infinity,
//     height: kToolbarHeight,
//     child: Stack(
//       alignment: Alignment.center,
//       children: [
//         // زر الرجوع
//         Positioned(
//           left: 0,
//           child: IconButton(
//             icon: const Icon(Icons.arrow_back),
//             onPressed: () => Get.back(),
//           ),
//         ),

//         // الصورة الشخصية مع مؤشر الحالة (التحسين: Obx واحد يغطي الحالة فقط)
//         Positioned(
//           right: 0,
//           child: Stack(
//             children: [
//               CircleAvatar(
//                 radius: 19,
//                 backgroundColor: Colors.white.withOpacity(0.2),
//                 backgroundImage: (avatarUrl.isNotEmpty && avatarUrl != "group_placeholder")
//                     ? NetworkImage(avatarUrl)
//                     : null,
//                 child: (avatarUrl == "group_placeholder")
//                     ? const Icon(Icons.groups, color: Colors.white, size: 20)
//                     : (avatarUrl.isEmpty ? const Icon(Icons.person, color: Colors.white, size: 20) : null),
//               ),
              
//               // استخدام Obx هنا سيجعل النقطة تظهر وتختفي لحظياً دون إعادة بناء كل الـ AppBar
//               Obx(() => controller.isPeerOnlineInApp.value 
//                 ? Positioned(
//                     bottom: 0,
//                     right: 0,
//                     child: Container(
//                       width: 12,
//                       height: 12,
//                       decoration: BoxDecoration(
//                         color: Colors.greenAccent,
//                         shape: BoxShape.circle,
//                         border: Border.all(color: AppColors.primaryTeal, width: 2),
//                       ),
//                     ),
//                   )
//                 : const SizedBox.shrink() // استخدام SizedBox.shrink بدلاً من لا شيء لتجنب مشاكل الـ Layout
//               ),
//             ],
//           ),
//         ),

//         // اسم الطرف الآخر وحالته
//         Positioned(
//           right: 48,
//           left: 48,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text(
//                 chatName,
//                 maxLines: 1,
//                 overflow: TextOverflow.ellipsis,
//                 textAlign: TextAlign.center,
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontWeight: FontWeight.bold,
//                   fontSize: 16,
//                   fontFamily: 'Cairo',
//                 ),
//               ),
//               // الـ Obx هنا يراقب نص الحالة واللون معاً
//               Obx(() => Text(
//                 controller.peerLastSeenStr.value, 
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   color: controller.isPeerOnlineInApp.value ? Colors.greenAccent : Colors.white70,
//                   fontSize: 10,
//                   fontFamily: 'Cairo',
//                 ),
//               )),
//             ],
//           ),
//         ),
//       ],
//     ),
//   ),
// ),

//       body: Column(
//         children: [
//           Expanded(
//             child: Obx(() {
//               if (controller.messages.isEmpty) {
//                 return Center(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(Icons.chat_bubble_outline, size: 44, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
//                       const SizedBox(height: 12),
//                       Text(
//                         "لا توجد رسائل سابقة. ابدأ المحادثة الآن",
//                         style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//                           color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
//                         ),
//                       ),
//                     ],
//                   ),
//                 );
//               }
//               return ListView.builder(
//                 controller: controller.scrollController,
//                 reverse: true,
//                 padding: const EdgeInsets.symmetric(vertical: 8),
//                 itemCount: controller.messages.length,
//                 itemBuilder: (context, index) {
//                   final message = controller.messages[index];
//                   bool isMe = message.senderId == controller.currentUserId;
//                   return _buildMessageBubble(context, controller, message, isMe, isDark);
//                 },
//               );
//             }),
//           ),
//           Obx(() => controller.isUploading.value
//               ? LinearProgressIndicator(color: AppColors.primaryTeal)
//               : const SizedBox.shrink()),
//           _buildInputArea(context, controller, isDark),
//         ],
//       ),
//     );
//   }

//   Widget _buildStatusIcon(MessageStatus status, bool isDark) {
//     switch (status) {
//       case MessageStatus.sending:
//         return Icon(Icons.access_time_rounded, size: 13, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary);
//       case MessageStatus.sent:
//         return Icon(Icons.done, size: 14, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary);
//       case MessageStatus.delivered:
//         return Icon(Icons.done_all, size: 14, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary);
//       case MessageStatus.read:
//         return Icon(Icons.done_all, size: 14, color: AppColors.accentOrange);
//     }
//   }

//   Widget _buildMessageBubble(BuildContext context, ChatController controller, MessageModel message, bool isMe, bool isDark) {
//     String originalUrl = message.fileUrl ?? "";
//     String safeUrl = originalUrl.replaceAll(RegExp(EndPoint.socketUrl), EndPoint.socketPath);

//     // التعامل مع الرسائل المحذوفة بشكل فوري في الواجهة لراحة الطبيب والمريض
//     if (message.type.toString().contains('deleted') || message.text == 'تم حذف هذه الرسالة') {
//       return Align(
//         alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
//         child: Container(
//           margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 3),
//           padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
//           decoration: BoxDecoration(
//             color: isDark ? Colors.grey.withOpacity(0.1) : Colors.grey.withOpacity(0.15),
//             borderRadius: BorderRadius.circular(12),
//           ),
//           child: Row(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Icon(Icons.block, size: 14, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
//               const SizedBox(width: 5),
//               Text(
//                 "تم حذف هذه الرسالة",
//                 style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//                   fontStyle: FontStyle.italic,
//                   color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       );
//     }

//     Color bubbleColor;
//     if (isMe) {
//       bubbleColor = isDark ? AppColors.darkSurface : AppColors.primaryTeal.withOpacity(0.15);
//     } else {
//       bubbleColor = isDark ? AppColors.darkSurface : AppColors.lightSurface;
//     }

//     return Align(
//       alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
//       child: GestureDetector(
//         // 🎯 تفعيل الضغط المطول لإظهار خيارات الحذف والتعديل للرسائل الخاصة بالمستخدم فقط
//         onLongPress: () {
//           if (isMe && message.type == MessageType.text) {
//             _showOptionsBottomSheet(context, controller, message, isDark);
//           } else if (isMe) {
//             // خيار الحذف فقط لرسائل الميديا والصوتيات
//             _showDeleteOnlyBottomSheet(context, controller, message, isDark);
//           }
//         },
//         child: Container(
//           margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 3),
//           padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
//           constraints: BoxConstraints(maxWidth: Get.width * 0.78),
//           decoration: BoxDecoration(
//             color: bubbleColor,
//             borderRadius: BorderRadius.only(
//               topLeft: const Radius.circular(12),
//               topRight: const Radius.circular(12),
//               bottomLeft: Radius.circular(isMe ? 12 : 2),
//               bottomRight: Radius.circular(isMe ? 2 : 12),
//             ),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(isDark ? 0.15 : 0.04),
//                 blurRadius: 1.5,
//                 offset: const Offset(0, 1),
//               )
//             ],
//           ),
//           child: Column(
//             crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
//             mainAxisSize: MainAxisSize.min,
//             children: [
//              if (message.type == MessageType.image)
//   GestureDetector(
//     onTap: () {
//       // 🎯 جلب الرابط المضمون والكامل عند الضغط للتكبير
//       String finalUrl = message.fileUrl ?? '';
      
//       // إذا كان الرابط المخزن مجرد اسم ملف وليس رابط كامل، نصلحه تلقائياً
//       if (finalUrl.isNotEmpty && !finalUrl.startsWith('http')) {
//         // finalUrl = 'http://10.113.180.45:8000/storage/chat/$finalUrl';

//            finalUrl = '${EndPoint.socketPath}/storage/chat/$finalUrl';

//       }

//       if (finalUrl.isNotEmpty) {
//         Get.to(() => Scaffold(
//           appBar: AppBar(backgroundColor: Colors.black, iconTheme: const IconThemeData(color: Colors.white)),
//           backgroundColor: Colors.black,
//           body: Center(
//             child: Image.network(
//               finalUrl,
//               headers: const {"Connection": "Keep-Alive", "Accept": "image/*"},
//               errorBuilder: (context, error, stackTrace) => const Center(
//                 child: Icon(Icons.broken_image, color: Colors.white, size: 80),
//               ),
//             ),
//           ),
//         ));
//       }
//     },
//     child: ClipRRect(
//       borderRadius: BorderRadius.circular(8),
//       child: Builder(
//         builder: (context) {
//           // 🎯 التعديل الذهبي: القراءة مباشرة من message.fileUrl المطابق لكود الرفع الخاص بك
//           String imageUrl = message.fileUrl ?? '';
          
//           // تأمين الحالات التي يرجع فيها السيرفر اسم الملف فقط بدلاً من الرابط الكامل
//           if (imageUrl.isNotEmpty && !imageUrl.startsWith('http')) {
//             // imageUrl = 'http://10.113.180.45:8000/storage/chat/$imageUrl';

//               imageUrl = '${EndPoint.socketPath}/storage/chat/$imageUrl';
//           }

//           print("🖼️ [UI Render Check] الرابط الذي تحاول الواجهة عرضه الآن هو: $imageUrl");

//           if (imageUrl.isEmpty) {
//             return _buildBrokenImagePlaceholder(isDark);
//           }

//           return Image.network(
//             imageUrl, // 👈 استبدال safeUrl بـ imageUrl المضمونة
//             width: 220,
//             height: 220,
//             fit: BoxFit.cover,
//             headers: const {"Connection": "Keep-Alive", "Accept": "image/*"},
//             loadingBuilder: (context, child, loadingProgress) {
//               if (loadingProgress == null) return child;
//               return Container(
//                 width: 220,
//                 height: 220,
//                 color: (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary).withOpacity(0.1),
//                 child: Center(child: CircularProgressIndicator(color: AppColors.primaryTeal)),
//               );
//             },
//             errorBuilder: (context, error, stackTrace) {
//               print("❌ [UI errorBuilder] فشل تحميل الصورة من الرابط: $imageUrl. السبب: $error");
//               return _buildBrokenImagePlaceholder(isDark);
//             },
//           );
//         },
//       ),
//     ),
//   )

//               else if (message.type == MessageType.audio)
//                 Container(
//                   padding: const EdgeInsets.symmetric(vertical: 2),
//                   width: 235,
//                   child: Row(
//                     children: [
//                       GestureDetector(
//                         onTap: () {
//                           if (message.fileUrl != null) {
//                             controller.playOrPauseAudio(message.messageId ?? '', message.fileUrl!);
//                           }
//                         },
//                         child: Obx(() {
//                           bool isCurrentPlaying = controller.playingMessageId.value == message.messageId;
//                           return CircleAvatar(
//                             radius: 17,
//                             backgroundColor: AppColors.primaryTeal,
//                             child: Icon(
//                               isCurrentPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
//                               color: Colors.white,
//                               size: 20,
//                             ),
//                           );
//                         }),
//                       ),
//                       const SizedBox(width: 4),
//                       Expanded(
//                         child: Obx(() {
//                           bool isCurrentPlaying = controller.playingMessageId.value == message.messageId;
//                           double maxDuration = isCurrentPlaying ? controller.audioDuration.value.inMilliseconds.toDouble() : 1.0;
//                           double currentPos = isCurrentPlaying ? controller.audioPosition.value.inMilliseconds.toDouble() : 0.0;

//                           if (currentPos > maxDuration) currentPos = maxDuration;
//                           if (maxDuration <= 0) maxDuration = 1.0;

//                           return Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               SliderTheme(
//                                 data: SliderTheme.of(context).copyWith(
//                                   thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 5),
//                                   trackHeight: 2.5,
//                                   activeTrackColor: AppColors.primaryTeal,
//                                   inactiveTrackColor: (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary).withOpacity(0.3),
//                                   thumbColor: AppColors.primaryTeal,
//                                 ),
//                                 child: Slider(
//                                   min: 0.0,
//                                   max: maxDuration,
//                                   value: currentPos,
//                                   onChanged: (value) {
//                                     if (isCurrentPlaying) {
//                                       controller.seekAudio(Duration(milliseconds: value.toInt()));
//                                     }
//                                   },
//                                 ),
//                               ),
//                               Padding(
//                                 padding: const EdgeInsets.symmetric(horizontal: 8),
//                                 child: Text(
//                                   isCurrentPlaying
//                                       ? "${_printDuration(controller.audioPosition.value)} / ${_printDuration(controller.audioDuration.value)}"
//                                       : "00:00",
//                                   style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 10, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
//                                 ),
//                               )
//                             ],
//                           );
//                         }),
//                       ),
//                       Icon(Icons.mic, color: AppColors.primaryTeal, size: 19),
//                     ],
//                   ),
//                 )

//               else if (message.type == MessageType.file)
//                 GestureDetector(
//                   onTap: () {
//                     if (message.fileUrl != null) {
//                       controller.openRemoteFile(message.fileUrl!, message.text);
//                     }
//                   },
//                   child: Container(
//                     padding: const EdgeInsets.all(6),
//                     decoration: BoxDecoration(
//                       color: (isDark ? AppColors.darkBorder : AppColors.lightBorder).withOpacity(0.05),
//                       borderRadius: BorderRadius.circular(6),
//                       border: Border.all(color: (isDark ? AppColors.darkBorder : AppColors.lightBorder).withOpacity(0.2)),
//                     ),
//                     width: 220,
//                     child: Row(
//                       children: [
//                         const Icon(Icons.insert_drive_file_rounded, color: Colors.redAccent, size: 30),
//                         const SizedBox(width: 6),
//                         Expanded(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 message.text,
//                                 maxLines: 1,
//                                 overflow: TextOverflow.ellipsis,
//                                 style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold, fontSize: 12),
//                               ),
//                               const SizedBox(height: 2),
//                               Text(
//                                 "انقر للتحميل والفتح",
//                                 style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 9, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 )

//               else
//                 Text(
//                   message.text,
//                   style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 15),
//                 ),

//               const SizedBox(height: 3),

//               Row(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   // إشارة توضيحية خفيفة إذا كانت الرسالة معدلة سابقاً
//                   if (message.text != 'تم حذف هذه الرسالة' && message.type == MessageType.text)
//                     // نفترض هنا وجود حقل اختياري في الموديل لديك، إذا لم يتوفر لن تسبب خطأ بفضل معالجة التحديث
//                     FutureBuilder(
//                       future: Future.value(false), // مكان لحفظ حالة التعديل مستقبلاً لو أردت
//                       builder: (context, snapshot) => const SizedBox.shrink()
//                     ),
//                   Text(
//                     DateFormat('hh:mm a').format(message.timestamp),
//                     style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 9, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
//                   ),
//                   if (isMe) ...[
//                     const SizedBox(width: 4),
//                     _buildStatusIcon(message.status, isDark),
//                   ]
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   String _printDuration(Duration duration) {
//     String twoDigits(int n) => n.toString().padLeft(2, "0");
//     String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
//     String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
//     return "$twoDigitMinutes:$twoDigitSeconds";
//   }


// Widget _buildBrokenImagePlaceholder(bool isDark) {
//   return Container(
//     width: 220,
//     height: 220,
//     color: (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary).withOpacity(0.2),
//     child: Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Icon(Icons.broken_image, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary, size: 40),
//         const SizedBox(height: 6),
//         Text(
//           "تعذر تحميل الصورة",
//           style: TextStyle(fontSize: 11, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
//         ),
//       ],
//     ),
//   );
// }


//   Widget _buildInputArea(BuildContext context, ChatController controller, bool isDark) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
//       color: Colors.transparent,
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           // 🎯 شريط علوي يظهر فقط عند دخول وضع التعديل (WhatsApp Style)
//           Obx(() {
//             if (controller.editingMessageId.value.isNotEmpty) {
//               return Container(
//                 margin: const EdgeInsets.only(bottom: 5, left: 4, right: 4),
//                 padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                 decoration: BoxDecoration(
//                   color: isDark ? AppColors.darkSurface : Colors.teal.withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(10),
//                   border: Border(right: BorderSide(color: AppColors.primaryTeal, width: 4)),
//                 ),
//                 child: Row(
//                   children: [
//                     Icon(Icons.edit, color: AppColors.primaryTeal, size: 16),
//                     const SizedBox(width: 8),
//                     Expanded(
//                       child: Text(
//                         "تعديل الرسالة...",
//                         style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//                           color: AppColors.primaryTeal,
//                           fontWeight: FontWeight.bold
//                         ),
//                       ),
//                     ),
//                     GestureDetector(
//                       onTap: () => controller.cancelEditing(),
//                       child: Icon(Icons.close, color: Colors.redAccent, size: 18),
//                     ),
//                   ],
//                 ),
//               );
//             }
//             return const SizedBox.shrink();
//           }),
//           Row(
//             children: [
//               Expanded(
//                 child: Container(
//                   decoration: BoxDecoration(
//                     color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
//                     borderRadius: BorderRadius.circular(25),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black.withOpacity(isDark ? 0.15 : 0.05),
//                         blurRadius: 2,
//                         offset: const Offset(0, 1),
//                       )
//                     ],
//                   ),
//                   child: Row(
//                     children: [
//                       IconButton(
//                         icon: Icon(Icons.attach_file, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
//                         onPressed: () => controller.pickAndSendGeneralFile(),
//                       ),
//                       IconButton(
//                         icon: Icon(Icons.camera_alt, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
//                         onPressed: () => _showImageSourceDialog(context, controller, isDark),
//                       ),
//                       Expanded(
//                         child: Obx(() {
//                           return controller.isRecording.value
//                               ? Padding(
//                                   padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
//                                   child: Text(
//                                     "🔴 جاري تسجيل الصوت الآن...",
//                                     style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.error, fontWeight: FontWeight.bold),
//                                   ),
//                                 )
//                               : TextField(
//                                   controller: controller.textController,
//                                   onChanged: (text) => controller.updateTypedText(text),
//                                   maxLines: null,
//                                   style: Theme.of(context).textTheme.bodyLarge,
//                                   decoration: InputDecoration(
//                                     hintText: "اكتب رسالتك هنا...",
//                                     hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
//                                     border: InputBorder.none,
//                                     contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
//                                   ),
//                                 );
//                         }),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 6),
//               Obx(() {
//                 bool showSendButton = controller.isTextFieldNotEmpty.value;
//                 bool recording = controller.isRecording.value;

//                 return CircleAvatar(
//                   radius: 23,
//                   backgroundColor: recording ? AppColors.error : AppColors.primaryTeal,
//                   child: IconButton(
//                     icon: showSendButton
//                         ? Icon(Icons.send, color: Colors.white, size: 22)
//                         : Icon(
//                             recording ? Icons.stop : Icons.mic,
//                             color: Colors.white,
//                             size: 22,
//                           ),
//                     onPressed: () {
//                       if (showSendButton) {
//                         controller.sendMessage();
//                       } else {
//                         if (!recording) {
//                           controller.startAudioRecording();
//                         } else {
//                           controller.stopAndSendAudioRecording();
//                         }
//                       }
//                     },
//                   ),
//                 );
//               }),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   void _showImageSourceDialog(BuildContext context, ChatController controller, bool isDark) {
//     Get.bottomSheet(
//       Container(
//         decoration: BoxDecoration(
//           color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
//           borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
//         ),
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
//         child: Wrap(
//           spacing: 20,
//           children: [
//             Center(
//               child: Container(
//                 width: 40, height: 4,
//                 decoration: BoxDecoration(
//                   color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
//                   borderRadius: const BorderRadius.all(Radius.circular(10)),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20),
//             ListTile(
//               leading: CircleAvatar(
//                 backgroundColor: (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary).withOpacity(0.1),
//                 child: Icon(Icons.camera_alt, color: AppColors.primaryTeal),
//               ),
//               title: Text(
//                 'التقاط عبر الكاميرا',
//                 style: Theme.of(context).textTheme.titleSmall?.copyWith(
//                   fontWeight: FontWeight.w600,
//                   color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
//                 ),
//               ),




//                onTap: () { Get.back(); controller.uploadAndSendImage(ImageSource.camera); },

//             ),
//             ListTile(
//               leading: CircleAvatar(
//                 backgroundColor: (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary).withOpacity(0.1),
//                 child: Icon(Icons.photo_library, color: AppColors.primaryTeal),
//               ),
//               title: Text(
//                 'اختيار من معرض الصور',
//                 style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600,
//                 color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,),
//               ),
//               onTap: () { Get.back(); controller.uploadAndSendImage(ImageSource.gallery); },
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // 🎯 قائمة خيارات التعديل والحذف للرسائل النصية
//   void _showOptionsBottomSheet(BuildContext context, ChatController controller, MessageModel message, bool isDark) {
//     Get.bottomSheet(
//       Container(
//         decoration: BoxDecoration(
//           color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
//           borderRadius: const BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25)),
//         ),
//         child: SafeArea(
//           child: Wrap(
//             children: [
//               ListTile(
//                 leading: const Icon(Icons.edit, color: Colors.blue),
//                 title: const Text('تعديل الرسالة'),
//                 onTap: () {
//                   Get.back();
//                   controller.startEditing(message);
//                 },
//               ),
//               ListTile(
//                 leading: const Icon(Icons.delete_forever, color: Colors.redAccent),
//                 title: const Text('حذف الرسالة للجميع'),
//                 onTap: () {
//                   Get.back();
//                   if (message.messageId != null) {
//                     controller.deleteMessage(message.messageId!);
//                   }
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   // 🎯 قائمة خيار الحذف فقط لرسائل الميديا (صوت، صور، ملفات)
//   void _showDeleteOnlyBottomSheet(BuildContext context, ChatController controller, MessageModel message, bool isDark) {
//     Get.bottomSheet(
//       Container(
//         decoration: BoxDecoration(
//           color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
//           borderRadius: const BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25)),
//         ),
//         child: SafeArea(
//           child: Wrap(
//             children: [
//               ListTile(
//                 leading: const Icon(Icons.delete_forever, color: Colors.redAccent),
//                 title: const Text('حذف الرسالة للجميع'),
//                 onTap: () {
//                   Get.back();
//                   if (message.messageId != null) {
//                     controller.deleteMessage(message.messageId!);
//                   }
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

// }

