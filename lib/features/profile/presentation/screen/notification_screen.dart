import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:raghad_pro/core/constanse/string_manager.dart';
import 'package:raghad_pro/core/theme/app_colors.dart';
import 'package:raghad_pro/core/widget/dialoge_action.dart';
import 'package:raghad_pro/features/chat/controller/notification_controller.dart';

class NotificationsScreen extends GetView<NotificationLogic> {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    controller.loadNotificationsFromServer();

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title:  Text(
         StringManager.notificationCenter.tr,
         
        ),
        centerTitle: true,
        backgroundColor: theme.appBarTheme.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded,
              color: theme.iconTheme.color ?? theme.colorScheme.onBackground),
          onPressed: () => Get.back(),
        ),
        actions: [
          Obx(() => controller.serverNotifications.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.delete_sweep_rounded,
                      color: Colors.redAccent),
                  onPressed: () {
                  
                    CustomActionDialog.show(
                      context: context,
                      icon: Icons.delete_forever_rounded,
                      iconColor: AppColors.error,
                      iconBackgroundColor: AppColors.error.withOpacity(0.1),
                      title: StringManager.deletTotle,
                      subtitle: StringManager.deletConfirm,
                      confirmButtonText: StringManager.confirm,
                      onConfirm: () {
                        controller.clearAllNotificationsFromServer();
                      },
                      isSecondaryButtonVisible: true,
                      secondaryButtonText: StringManager.cancel,
                    );
                  },
                )
              : const SizedBox.shrink()),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Obx(() => Text(
                      "لديك ${controller.unreadCount.value} إشعارات غير مقروءة",
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.hintColor,
                        fontWeight: FontWeight.w500,
                      ),
                    )),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Divider(
                thickness: 0.7,
                height: 1,
                color: theme.dividerColor.withOpacity(0.4)),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return Center(
                  child: CircularProgressIndicator(
                      color: theme.colorScheme.primary),
                );
              }

              if (controller.serverNotifications.isEmpty) {
                return _buildEmptyState(context, theme);
              }

              return ListView.builder(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
                physics: const BouncingScrollPhysics(),
                itemCount: controller.serverNotifications.length,
                itemBuilder: (context, index) {
                  var notif = controller.serverNotifications[index];

                  bool isShiftSwap = notif.type == 'shift_swap';
                  Color dynamicColor = isShiftSwap
                      ? AppColors.warning
                      : theme.colorScheme.primary;

                  return Dismissible(
                    key: Key(notif.uuid),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      margin: const EdgeInsets.only(bottom: 14),
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(left: 24),
                      decoration: BoxDecoration(
                        color: AppColors.error.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(StringManager.deletTotle,
                              style: TextStyle(
                                  color: AppColors.lightSurface,
                                  fontWeight: FontWeight.bold)),
                          Spacer(),
                          Icon(Icons.delete_forever_rounded,
                              color: AppColors.lightSurface, size: 28),
                        ],
                      ),
                    ),
                    onDismissed: (direction) {
                      controller.removeSingleNotification(notif.uuid);
                    },
                    child: GestureDetector(
                      onTap: () {
                        if (!notif.isRead) {
                          controller.markNotificationAsRead(notif.uuid);
                        }
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 14),
                        decoration: BoxDecoration(
                          color: notif.isRead
                              ? theme.cardColor
                              : dynamicColor.withOpacity(
                                  0.06), // خلفية خفيفة جداً للإشعارات غير المقروءة
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: notif.isRead
                                ? theme.dividerColor.withOpacity(0.2)
                                : dynamicColor.withOpacity(0.4),
                            width: 1,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Stack(
                            children: [
                              Positioned(
                                top: 0,
                                right: 0,
                                bottom: 0,
                                width: 5,
                                child: Container(color: dynamicColor),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(14),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      notif.createdAt,
                                      style: theme.textTheme.bodyMedium
                                          ?.copyWith(
                                              fontSize: 11,
                                              fontWeight: FontWeight.bold,
                                              ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            notif.title,
                                            style: theme.textTheme.bodyMedium
                                                ?.copyWith(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),
                                            textAlign: TextAlign.right,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            notif.body,
                                            style: theme.textTheme.bodyMedium
                                                ?.copyWith(
                                              fontSize: 12,
                                              color: theme
                                                  .textTheme.bodyMedium?.color
                                                  ?.withOpacity(0.8),
                                            ),
                                            textAlign: TextAlign.right,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 14),
                                    Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: dynamicColor.withOpacity(0.12),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                          isShiftSwap
                                              ? Icons.swap_horiz_rounded
                                              : Icons
                                                  .notifications_none_rounded,
                                          color: dynamicColor,
                                          size: 22),
                                    ),
                                  ],
                                ),
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
    );
  }

  Widget _buildEmptyState(BuildContext context, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 40),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                  width: 110,
                  height: 110,
                  decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withOpacity(0.06),
                      shape: BoxShape.circle)),
              Container(
                  width: 85,
                  height: 85,
                  decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withOpacity(0.12),
                      shape: BoxShape.circle)),
              Icon(Icons.notifications_none_rounded,
                  size: 52, color: theme.colorScheme.primary),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            StringManager.inbox,
            style: theme.textTheme.titleLarge
                ?.copyWith(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 8),
          Text(
            StringManager.noNotifications,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium
                ?.copyWith(color: theme.hintColor, fontSize: 13, height: 1.4),
          ),
        ],
      ),
    );
  }
}
