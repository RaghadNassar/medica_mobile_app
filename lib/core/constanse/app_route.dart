// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:go_router/go_router.dart';
// import 'package:raghad_pro/features/auth/cubit/auth_cubit.dart';
// import 'package:raghad_pro/features/auth/view/screen/forget_pasword_screen.dart';
// import 'package:raghad_pro/features/auth/view/screen/log_in_screen.dart';
// import 'package:raghad_pro/features/auth/view/screen/regester_screen.dart';
// import 'package:raghad_pro/features/home/view/screen/home_screen.dart';
// import 'package:raghad_pro/features/splash/cubit/splash_cubit.dart';
// import 'package:raghad_pro/features/splash/view/screen/on_bording_splash.dart';
// import 'package:raghad_pro/features/splash/view/screen/splash_screen.dart';
// //import 'package:raghad_pro/features/auth/presentation/view/splach_screen.dart';

// class AppRoutes {
//   static const splash = '/';
//   static const onboarding = '/onboarding';
//   static const login = '/login';
//   static const signUp = '/signup';
//   static const forgotPassword = '/forgot-password';
//   static const home = '/home';
// }

// class AppRouter {
//   static final router = GoRouter(
//     initialLocation: AppRoutes.splash,
//     routes: [
//       GoRoute(
//         path: AppRoutes.splash,
//         builder: (context, state) => const SplashScreen(),
//       ),
//       GoRoute(
//         path: AppRoutes.onboarding,
//         builder: (context, state) => BlocProvider(
//           create: (context) => SplashCubit(),
//           child: const OnboardingView(),
//         ),
//       ),
//         GoRoute(
//   path: AppRoutes.login,
//   builder: (context, state) => BlocProvider(
//     create: (context) => AuthCubit(),
//     child: const SignInScreen(),
//   ),
// ),
// GoRoute(
//   path: AppRoutes.signUp,
//   builder: (context, state) => BlocProvider(
//     create: (context) => AuthCubit(),
//     child: const RegesterScreen(),
//   ),
// ),
//       GoRoute(
//         path: AppRoutes.forgotPassword,
//         builder: (context, state) => const ForgetPaswordScreen(),
//       ),
//        GoRoute(
//         path: AppRoutes.home,
//         builder: (context, state) => const HomeScreen(),
//       ),
//     ],
//   );
// }

class AppRoutes {
  static const splash = '/';
  static const onboarding = '/onboarding';
  static const goAuth = '/go_auth';
  static const login = '/login';
  static const signUp = '/signup';
  static const forgotPassword = '/forgot-password';
  static const verficationCode = '/verfiey-code';
  static const resetPassword = '/reset_password';
  static const profile = '/profile';
  static const editProfile = '/edit-profile';
  static const appoinment = '/appoinment';
  static const medicalRecord = '/medical-record';
  static const settings = '/settings';
  static const medicalHistory = '/medical_history';
  static const notifications = '/notifications';

  static const detail = '/detail';

  static const home = '/home';
  static const search = '/search';
   static const chatList = '/chat-list';
    static const chatView = '/chat-view';
   static const alldoctor= '/AllDoctorSpecializeScreen';
  static const changepassword = '/changePassword';

}
