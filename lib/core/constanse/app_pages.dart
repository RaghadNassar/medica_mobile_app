import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:raghad_pro/core/constanse/app_route.dart';
import 'package:raghad_pro/features/auth/controler/auth_logic.dart';
import 'package:raghad_pro/features/auth/view/screen/forget_pasword_screen.dart';
import 'package:raghad_pro/features/auth/view/screen/log_in_screen.dart';
import 'package:raghad_pro/features/auth/view/screen/regester_screen.dart';
import 'package:raghad_pro/features/auth/view/screen/reset_password_screen.dart';
import 'package:raghad_pro/features/auth/view/screen/verfiey_code_screen.dart';
import 'package:raghad_pro/features/chat/controller/chatList_controller.dart';
import 'package:raghad_pro/features/chat/view/screen/chatList_screen.dart';
import 'package:raghad_pro/features/chat/view/screen/chat_view.dart';
import 'package:raghad_pro/features/home/controller/home_controller.dart';
import 'package:raghad_pro/features/home/controller/search_controller.dart';
import 'package:raghad_pro/features/home/data/repositry/repostry_home.dart';
import 'package:raghad_pro/features/home/view/screen/appoinment_screen.dart';
import 'package:raghad_pro/features/home/view/screen/detail_screen.dart';
import 'package:raghad_pro/features/home/view/screen/search_screen.dart';
import 'package:raghad_pro/features/profile/controller/profile_controller.dart';
import 'package:raghad_pro/features/profile/presentation/screen/edite_profile.dart';
import 'package:raghad_pro/features/profile/presentation/screen/medecal_hestory.dart';
import 'package:raghad_pro/features/profile/controller/medical_hestory.dart';
import 'package:raghad_pro/features/profile/presentation/screen/notification_screen.dart';
import 'package:raghad_pro/features/profile/presentation/screen/profile_screen.dart';
import 'package:raghad_pro/features/home/view/widget/bottom_bar_widget.dart';
import 'package:raghad_pro/features/profile/presentation/screen/setting_screen.dart';
import 'package:raghad_pro/features/splash/binding/splash_binding.dart';
import 'package:raghad_pro/features/splash/view/screen/go_auth_screen.dart';
import 'package:raghad_pro/features/splash/view/screen/on_bording_splash.dart';
import 'package:raghad_pro/features/splash/view/screen/splash_screen.dart';

class AppPages {
  // المسار الابتدائي
  static const INITIAL = AppRoutes.splash;

  static final routes = [
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: AppRoutes.onboarding,
      page: () => const OnboardingView(),
    ),
    GetPage(
      name: AppRoutes.goAuth,
      page: () => const GoAuthScreen(),
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => const SignInScreen(),
      binding: AuthBinding(), // حقن الـ AuthController
    ),
    GetPage(
      name: AppRoutes.signUp,
      page: () => const RegesterScreen(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.forgotPassword,
      page: () => const ForgetPaswordScreen(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.verficationCode,
      page: () => const VerificationCodeScreen(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.resetPassword,
      page: () => const ResetPasswordScreen(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => const MainNavigationScreen(),
      binding: MainNavigationBinding(), // مستقبلاً عند عمل شاشة الهوم
    ),
    GetPage(
      name: AppRoutes.profile,
      page: () => const ProfileScreen(),
      binding: ProfileBinding(), // مستقبلاً عند عمل شاشة الهوم
    ),
     GetPage(
      name: AppRoutes.editProfile,
      page: () => const UpdateProfile(),
      binding: ProfileBinding(), // مستقبلاً عند عمل شاشة الهوم
    ),
    GetPage(
      name: AppRoutes.appoinment,
      page: () => const AppoinmentScreen(),
      // binding: MainNavigationBinding(), // مستقبلاً عند عمل شاشة الهوم
    ),
    GetPage(
      name: AppRoutes.settings,
      page: () => const SettingsScreen(),
      // binding: MainNavigationBinding(), // مستقبلاً عند عمل شاشة الهوم
    ),
    GetPage(
      name: AppRoutes.medicalHistory,
      page: () => const MedicalHistoryScreen(),
      binding: MedicalHistoryBinding(),
    ),
    GetPage(
      name: AppRoutes.detail,
      page: () => const DoctorDetailsScreen(),
      // binding: MainNavigationBinding(), // مستقبلاً عند عمل شاشة الهوم
    ),
    GetPage(
      name: AppRoutes
          .search, // تأكدي من تعريف هذا الاسم داخل كلاس AppRoutes الخاص بكِ (مثلاً: static const search = '/search';)
      page: () => PatientSearchScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut<PatientSearchController>(
          () => PatientSearchController(Get.find<RepostryHome>()),
        );
      }),
    ),
    GetPage(
      name: AppRoutes.chatList,
      page: () => const ClinicalChatWidget(
        isDark: false,
      ), // واجهة قائمة المحادثات
      // binding: ChatBinding(),
    ),
    GetPage(
      name: AppRoutes.chatView,
      page: () => const ChatView(), // واجهة غرفة المحادثة اللحظية
      // binding: ChatBinding(),
    ),
    GetPage(
      name: AppRoutes.notifications,
      page: () => const NotificationsScreen(), // واجهة إشعارات المستخدم
      // binding: NotificationsBinding(),
    ),
  ];
}
