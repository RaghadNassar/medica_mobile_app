import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:raghad_pro/features/splash/controller/splash_logic.dart';
/*
class OnboardingHeader extends StatelessWidget {
  final int currentIndex;
  final int total;
  final PageController pageController;

  const OnboardingHeader({super.key, required this.currentIndex, required this.total, required this.pageController});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("${currentIndex + 1}/$total", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          GestureDetector(
            onTap: () {
              // الانتقال لصفحة الـ Login مباشرة
              context.go(AppRoutes.login);
            },
            child: const Text("Skip", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}*/
class OnboardingHeader extends GetView<SplashController> {

  final int currentIndex;
  final int total;

  const OnboardingHeader({
    super.key,
    required this.currentIndex,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {

    return Padding(

      padding: const EdgeInsets.all(20),

      child: Row(

        mainAxisAlignment: MainAxisAlignment.spaceBetween,

        children: [

          Text(
            "${currentIndex + 1}/$total",
            style: Theme.of(context).textTheme.titleLarge
          ),

          GestureDetector(

            onTap: controller.skip,

            child:  Text("Skip",style: Theme.of(context).textTheme.titleLarge,),
          ),
        ],
      ),
    );
  }
}