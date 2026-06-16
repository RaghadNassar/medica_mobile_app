import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:raghad_pro/core/constanse/app_assets.dart';
import 'package:raghad_pro/core/constanse/string_manager.dart';
import 'package:raghad_pro/core/utilis/size_config.dart';
import 'package:raghad_pro/features/home/controller/home_controller.dart';
import 'package:raghad_pro/features/chat/controller/chatList_controller.dart';

class MainNavigationScreen extends GetView<HomeController> {
  const MainNavigationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => controller.screens[controller.currentIndex.value]),
      
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          currentIndex: controller.currentIndex.value,
          onTap: controller.changeIndex,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Theme.of(context).primaryColor,
          unselectedItemColor:Theme.of(context).colorScheme.primaryContainer ,
          showUnselectedLabels: true,
          items: [
            _buildNavItem(
              context,
              icon: Appassets.homeIcon,
              label: StringManager.home,
            ),
            _buildNavItem(
              context,
              icon: Appassets.messageIcon,
              label: StringManager.message,
              showBadge: true,
            ),
            _buildNavItem(
              context,
              icon: Appassets.appoIcon,
              label: StringManager.appointment,
            ),
            _buildNavItem(
              context,
              icon: Appassets.profileIcon,
              label: StringManager.profile,
            ),
          ],
        ),
      ),
    );
  }


  BottomNavigationBarItem _buildNavItem(
    BuildContext context, {
    required String icon,
    required String label,
    bool showBadge = false,
  }) {
    Widget baseIcon(bool active) => SvgPicture.asset(
          icon,
          width: context.widthPct(0.05),
          colorFilter: ColorFilter.mode(
            active ? Theme.of(context).primaryColor : Theme.of(context).colorScheme.primaryContainer,
            BlendMode.srcIn,
          ),
        );

    Widget buildWithBadge(Widget child) {
      if (!showBadge) return child;

      // If ChatListController is registered, show badge count; otherwise no badge
      if (!Get.isRegistered<ChatListController>()) return child;

      final ChatListController chatCtrl = Get.find<ChatListController>();

      return Obx(() {
        final totalUnread = chatCtrl.allChats.fold<int>(0, (prev, e) => prev + e.unreadCount);
        if (totalUnread <= 0) return child;

        return Stack(
          clipBehavior: Clip.none,
          children: [
            child,
            Positioned(
              right: -6,
              top: -6,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(color: Colors.redAccent, shape: BoxShape.circle),
                constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                child: Center(
                  child: Text(
                    totalUnread > 99 ? '99+' : '$totalUnread',
                    style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        );
      });
    }

    return BottomNavigationBarItem(
      icon: buildWithBadge(baseIcon(false)),
      activeIcon: buildWithBadge(baseIcon(true)),
      label: label,
    );
  }
}