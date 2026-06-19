import 'package:get/get.dart';
import 'package:raghad_pro/features/chat/view/screen/chatList_screen.dart';
import 'package:raghad_pro/features/home/view/screen/appoinment_screen.dart';
import 'package:raghad_pro/features/home/view/screen/home_screen.dart';
import 'package:raghad_pro/features/profile/presentation/screen/profile_screen.dart';

class HomeNavigationController extends GetxController {
  final RxInt currentIndex = 0.obs;

  final List screens = [
    const HomeScreen(),
    const ClinicalChatWidget(isDark: false),
    const AppoinmentScreen(),
    const ProfileScreen(),
  ];

  void changeIndex(int index) {
    currentIndex.value = index;
  }
}