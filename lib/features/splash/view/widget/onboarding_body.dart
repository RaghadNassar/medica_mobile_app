import 'package:flutter/material.dart';
import 'package:raghad_pro/core/utilis/size_config.dart';
import 'package:raghad_pro/features/splash/model/splash_model.dart';
/*
class OnboardingBody extends StatelessWidget {
  final OnboardingModel model;
  const OnboardingBody({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(model.image, height: context.heightPct(0.4)), // استخدام الصورة من الموديل
        SizedBox(height:context.heightPct(0.01)),
        Text(
          model.title,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 24,fontWeight: FontWeight.bold),
        ),
         SizedBox(height: context.heightPct(0.02)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            model.description,
            textAlign: TextAlign.center,
            style:  Theme.of(context).textTheme.bodyLarge,
          ),
        ),
      ],
    );
  }
}*/
class OnboardingBody extends StatelessWidget {
  final OnboardingModel model;
  const OnboardingBody({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (model.image != null && model.image!.isNotEmpty) ...[
          Image.asset(
            model.image!, 
            height: context.heightPct(0.4),
          ),
          SizedBox(height: context.heightPct(0.04)),
        ],
        
        // العنوان يظهر دائماً
        Text(
          model.title,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
        ),
        
        SizedBox(height: context.heightPct(0.02)),
        
        // الوصف يظهر دائماً
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            model.description,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
      ],
    );
  }
}