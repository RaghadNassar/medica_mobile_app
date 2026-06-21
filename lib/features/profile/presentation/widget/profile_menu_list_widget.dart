import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:raghad_pro/core/constanse/app_route.dart';
import 'package:raghad_pro/core/constanse/string_manager.dart';
import 'package:raghad_pro/core/theme/app_colors.dart';
import 'package:raghad_pro/core/widget/custom_menu_container.dart';
import 'package:raghad_pro/features/chat/controller/notification_controller.dart';
import 'package:raghad_pro/features/chat/data/model/notification_model.dart';
import 'package:raghad_pro/features/profile/controller/profile_controller.dart';
import 'package:raghad_pro/features/profile/presentation/widget/profile_menu_item.dart';

class ProfileMenuList extends StatelessWidget {
  const ProfileMenuList({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final NotificationLogic _notificationService =
        Get.find<NotificationLogic>();

    final List<Map<String, dynamic>> menuItems = [
      {
        'icon': Icons.person_outline,
        'title': StringManager.editProfile.tr,
        'route': AppRoutes.editProfile
      },
      {
        'icon': Icons.medical_services_outlined,
        'title': StringManager.medicalRecord.tr,
        'route': AppRoutes.medicalHistory
      },
      {
        'icon': Icons.settings_outlined,
        'title': StringManager.settings.tr,
        'route': AppRoutes.settings
      },
      {
        'icon': Icons.notifications,
        'title': StringManager.notification.tr,
        'isNotification': true,
        'route': AppRoutes.notifications
      },
    ];

    return CustomMenuContainer(
      children: List.generate(menuItems.length, (index) {
        final item = menuItems[index];
        final bool isNotificationItem = item['isNotification'] == true;

        Widget buildNormalMenuItem() {
          return ProfileMenuItem(
            icon: item['icon'],
            title: item['title'],
            onTap: () async {
              if (item.containsKey('route')) {
                if (item['route'] == AppRoutes.editProfile) {
                  Get.find<ProfileController>()
                      .fillControllersWithCurrentData();
                }

                Get.toNamed(item['route']);
              }
            },
          );
        }

        return Column(
          children: [
            if (isNotificationItem)
              Obx(() {
                final int count = _notificationService.unreadCount.value;

                if (count > 0) {
                  return Stack(
                    clipBehavior: Clip.none,
                    children: [
                      buildNormalMenuItem(),
                      Positioned(
                        left: 24,
                        top: 18,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: AppColors.error,
                            shape: BoxShape.circle,
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 18,
                            minHeight: 18,
                          ),
                          child: Text(
                            count > 9 ? '+9' : '$count',
                            style: const TextStyle(
                              color: AppColors.lightSurface,
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  );
                } else {
                  return buildNormalMenuItem();
                }
              })
            else
              buildNormalMenuItem(),
            if (index != menuItems.length - 1) _CustomDivider(theme: theme),
          ],
        );
      }),
    );
  }
}

class _CustomDivider extends StatelessWidget {
  final ThemeData theme;
  const _CustomDivider({required this.theme});

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      indent: 60,
      endIndent: 16,
      color: theme.colorScheme.primaryContainer.withOpacity(0.3),
    );
  }

  void _showNotificationsBottomSheet(BuildContext context, bool isDark,
      NotificationLogic _notificationService) {
    Get.bottomSheet(
      Container(
        constraints:
            BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.8),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkBackground : const Color(0xFFF8FAFC),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
              width: 50,
              height: 5,
              decoration: BoxDecoration(
                color: isDark ? Colors.white24 : Colors.black12,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Obx(() => _notificationService.serverNotifications.isNotEmpty
                      ? TextButton.icon(
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.redAccent,
                            backgroundColor: Colors.redAccent.withOpacity(0.08),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                          icon:
                              const Icon(Icons.delete_sweep_rounded, size: 18),
                          onPressed: () {
                            Get.defaultDialog(
                              title: 'تأكيد المسح كلياً',
                              middleText: 'هل تريد حذف كافة الإشعارات نهائياً؟',
                              textConfirm: 'مسح الكل',
                              textCancel: 'تراجع',
                              confirmTextColor: Colors.white,
                              buttonColor: Colors.redAccent,
                              onConfirm: () {
                                _notificationService
                                    .clearAllNotificationsFromServer();
                                Get.back();
                              },
                            );
                          },
                          label: const Text("مسح الكل",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 13)),
                        )
                      : const SizedBox.shrink()),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "مركز التنبيهات",
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color:
                                  isDark ? Colors.white : AppColors.darkAppBar,
                            ),
                      ),
                      const SizedBox(height: 2),
                      Obx(() => Text(
                            "لديك ${_notificationService.unreadCount.value} إشعارات غير مقروءة",
                            style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 11,
                                fontWeight: FontWeight.w500),
                          )),
                    ],
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Divider(thickness: 0.7, height: 20),
            ),
            Flexible(
              child: Obx(() {
                if (_notificationService.isLoading.value) {
                  return const Center(
                      child: Padding(
                    padding: EdgeInsets.all(40.0),
                    child:
                        CircularProgressIndicator(color: AppColors.primaryTeal),
                  ));
                }

                if (_notificationService.serverNotifications.isEmpty) {
                  return _buildEmptyState(isDark);
                }

                return ListView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
                  physics: const BouncingScrollPhysics(),
                  itemCount: _notificationService.serverNotifications.length,
                  itemBuilder: (context, index) {
                    AppNotification notif =
                        _notificationService.serverNotifications[index];

                    bool isShiftSwap = notif.type == 'shift_swap';
                    Color dynamicColor = isShiftSwap
                        ? Colors.orangeAccent
                        : AppColors.primaryTeal;

                    return Dismissible(
                      key: Key(notif.uuid),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        margin: const EdgeInsets.only(bottom: 14),
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(left: 24),
                        decoration: BoxDecoration(
                          color: Colors.redAccent.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text("حذف التنبيه",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                            Spacer(),
                            Icon(Icons.delete_forever_rounded,
                                color: Colors.white, size: 28),
                          ],
                        ),
                      ),
                      onDismissed: (direction) {
                        _notificationService
                            .removeSingleNotification(notif.uuid);
                      },
                      child: GestureDetector(
                        onTap: () {
                          if (!notif.isRead) {
                            _notificationService
                                .markNotificationAsRead(notif.uuid);
                          }
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 14),
                          decoration: BoxDecoration(
                            color: notif.isRead
                                ? (isDark
                                    ? AppColors.darkSurface
                                    : Colors.white)
                                : (isDark
                                    ? const Color(0xFF1E293B)
                                    : const Color(0xFFF0FDF4)),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: notif.isRead
                                  ? (isDark
                                      ? AppColors.darkBorder
                                      : AppColors.lightBorder)
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        notif.createdAt,
                                        style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                            color: isDark
                                                ? Colors.white38
                                                : Colors.black38),
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
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                                color: isDark
                                                    ? Colors.white
                                                    : AppColors.darkAppBar,
                                              ),
                                              textAlign: TextAlign.right,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              notif.body,
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: isDark
                                                    ? Colors.white70
                                                    : Colors.black87,
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
      ),
      isScrollControlled: true,
      ignoreSafeArea: false,
    );
  }

  Widget _buildEmptyState(bool isDark) {
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
                      color: AppColors.primaryTeal.withOpacity(0.06),
                      shape: BoxShape.circle)),
              Container(
                  width: 85,
                  height: 85,
                  decoration: BoxDecoration(
                      color: AppColors.primaryTeal.withOpacity(0.12),
                      shape: BoxShape.circle)),
              const Icon(Icons.notifications_none_rounded,
                  size: 52, color: AppColors.primaryTeal),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            "صندوق الوارد فارغ!",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : AppColors.darkAppBar),
          ),
          const SizedBox(height: 8),
          const Text(
            "عيادتك تسير بانتظام تام، لا توجد إشعارات حالياً.",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey, fontSize: 13, height: 1.4),
          ),
        ],
      ),
    );
  }
}



































// class ProfileMenuList extends StatelessWidget {
//   const ProfileMenuList({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final bool isDark = context.isDarkMode;
    
//     // استدعاء الكنترولر
//     final NotificationLogic _notificationService = Get.find<NotificationLogic>();

//     final List<Map<String, dynamic>> menuItems = [
//       {'icon': Icons.person_outline, 'title': StringManager.editProfile},
//       {'icon': Icons.medical_services_outlined, 'title': StringManager.medicalRecord, 'route': AppRoutes.medicalHistory},
//       {'icon': Icons.settings_outlined, 'title': StringManager.settings, 'route': AppRoutes.settings},
//       {'icon': Icons.notifications, 'title': StringManager.notification, 'isNotification': true},
//     ];

//     return CustomMenuContainer(
//       children: List.generate(menuItems.length, (index) {
//         final item = menuItems[index];
//         final bool isNotificationItem = item['isNotification'] == true;

//         // دالة مسبقة لبناء الزر العادي للتطبيق (يستقبل IconData بشكل طبيعي)
//         Widget buildNormalMenuItem() {
//           return ProfileMenuItem(
//             icon: item['icon'], // هنا يمرر IconData مثل Icons.notifications
//             title: item['title'],
//             onTap: () async {
//               if (isNotificationItem) {
//                 print("🔔 جاري تحديث الإشعارات من السيرفر وعرض المركز...");
//                 _notificationService.loadNotificationsFromServer();
//                 _showNotificationsBottomSheet(context, isDark, _notificationService);
//                 return; 
//               }

//               if (item.containsKey('route')) {
//                 Get.toNamed(item['route']);
//               }
//             },
//           );
//         }

//         return Column(
//           children: [
//             // 💡 الحل الذكي: إذا كان العنصر هو الإشعارات، نضع الـ Badge فوق الـ MenuItem بالكامل باستخدام Stack
//             if (isNotificationItem)
//               Obx(() {
//                 final int count = _notificationService.unreadCount.value;
                
//                 if (count > 0) {
//                   // إذا كان هناك إشعارات، نغلف الزر بـ Stack ونضع الدائرة الحمراء في جهة اليسار (أو اليمين حسب اتجاه التطبيق)
//                   return Stack(
//                     clipBehavior: Clip.none,
//                     children: [
//                       buildNormalMenuItem(),
//                       // وضع الدائرة الحمراء فوق الصف (تم ضبط المحاذاة لتناسب التصميم العربي)
//                       Positioned(
//                         left: 24, // يوضع جهة اليسار لأن الأيقونة عادة تكون في اليمين باللغة العربية
//                         top: 18,  // محاذاة في المنتصف عمودياً بجانب النص أو الأيقونة
//                         child: Container(
//                           padding: const EdgeInsets.all(4),
//                           decoration: const BoxDecoration(
//                             color: Colors.redAccent,
//                             shape: BoxShape.circle,
//                           ),
//                           constraints: const BoxConstraints(
//                             minWidth: 18,
//                             minHeight: 18,
//                           ),
//                           child: Text(
//                             count > 9 ? '+9' : '$count',
//                             style: const TextStyle(
//                               color: Colors.white,
//                               fontSize: 9,
//                               fontWeight: FontWeight.bold,
//                             ),
//                             textAlign: TextAlign.center,
//                           ),
//                         ),
//                       ),
//                     ],
//                   );
//                 } else {
//                   return buildNormalMenuItem(); // لا توجد إشعارات غير مقروءة، يعود الزر طبيعي
//                 }
//               })
//             else
//               buildNormalMenuItem(), // العناصر الأخرى (الملف الشخصي، السجل، الإعدادات) تمر طبيعية جداً

//             if (index != menuItems.length - 1) _CustomDivider(theme: theme),
//           ],
//         );
//       }),
//     );
//   }
// }
























// import 'package:flutter/material.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:get/get_navigation/get_navigation.dart';
// import 'package:raghad_pro/core/constanse/app_route.dart';
// import 'package:raghad_pro/core/constanse/app_spacing.dart';
// import 'package:raghad_pro/core/constanse/string_manager.dart';
// import 'package:raghad_pro/features/profile/presentation/widget/profile_menu_item.dart';

// class ProfileMenuList extends StatelessWidget {
//   const ProfileMenuList({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);

//     final List<Map<String, dynamic>> menuItems = [
//       {'icon': Icons.person_outline, 'title': StringManager.editProfile},
//       {'icon': Icons.medical_services_outlined, 'title':StringManager.medicalRecord },
//       {'icon': Icons.settings_outlined, 'title':StringManager.settings ,'route': AppRoutes.settings},
//       {'icon': Icons.notifications, 'title': StringManager.notification},
//     ];

//     return Container(
//       padding: AppSpacing.screenPadding3,
//       decoration: _buildBoxDecoration(theme),
//       child: Column(
//         children: List.generate(menuItems.length, (index) {
//           return Column(
//             children: [
//               ProfileMenuItem(
//                 icon: menuItems[index]['icon'],
//                 title: menuItems[index]['title'],
//                 onTap: () {
//                   if (menuItems[index].containsKey('route')) {
//                     Get.toNamed(menuItems[index]['route']);
//                   }
//                 },
//               ),
//               if (index != menuItems.length - 1) _CustomDivider(theme: theme),
//             ],
//           );
//         }),
//       ),
//     );
//   }

//   BoxDecoration _buildBoxDecoration(ThemeData theme) {
//     return BoxDecoration(
//       color: theme.colorScheme.surface,
//       borderRadius: BorderRadius.circular(24),
//       boxShadow: [
//         BoxShadow(
//           color: Colors.black.withOpacity(0.05),
//           blurRadius: 20,
//           offset: const Offset(0, 10),
//         ),
//       ],
//     );
//   }
// }

// class _CustomDivider extends StatelessWidget {
//   final ThemeData theme;
//   const _CustomDivider({required this.theme});

//   @override
//   Widget build(BuildContext context) {
//     return Divider(
//       height: 1,
//       indent: 60,
//       endIndent: 16,
//       color: theme.colorScheme.primaryContainer.withOpacity(0.3),
//     );
//   }
// }