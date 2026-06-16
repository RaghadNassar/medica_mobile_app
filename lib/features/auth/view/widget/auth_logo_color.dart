import 'package:flutter/material.dart';
import 'package:raghad_pro/core/constanse/app_assets.dart';
import 'package:raghad_pro/core/theme/app_colors.dart';
import 'package:raghad_pro/features/splash/view/widget/app_logo.dart';

class AuthLogoColorWidget extends StatelessWidget {
  const AuthLogoColorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
                  child: AppLogoWithText(
                    imageLogo: Appassets.logoSecondry,
                    colorImage: AppColors.primaryTeal,
                    style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryTeal,
                        ),
                  ),
                );
  }
}